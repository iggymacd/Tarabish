// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * A library to observe changes on Dart objects.
 *
 * Similar to the principle of watchers in AngularJS, this library provides the
 * mechanisms to observe and react to changes that happen in an application's
 * data model.
 *
 * Watchers have a simple lifetime:
 *
 *   * they are created calling [watch],
 *
 *   * they are fired whenever [dispatch] is called and the watched values
 *   changed since the last time [dispatch] was invoked, and
 *
 *   * they are unregistered using a function that was returned by [watch] when
 *   they were created.
 *
 * For example, you can create a watcher that observes changes to a variable by
 * calling [watch] as follows:
 *
 *     var x = 0;
 *     var stop = watch(() => x, (_) => print('hi'));
 *
 * Changes to the variable 'x' will be detected whenever we call [dispatch]:
 *
 *     x = 12;
 *     x = 13;
 *     dispatch(); // the watcher is invoked ('hi' will be printed once).
 *
 * After deregistering the watcher, events are no longer fired:
 *
 *     stop();
 *     x = 14;
 *     dispatch(); // nothing happens.
 *
 * You can watch several kinds of expressions, including lists. See [watch] for
 * more details.
 *
 * A common design pattern for MVC applications is to call [dispatch] at the end
 * of each event loop (e.g. after each UI event is fired). Our view library does
 * this automatically.
 */
library watcher;

/**
 * Watch for changes in [target].  The [callback] function will be called when
 * [dispatch] is called and the value represented by [target] had changed.  The
 * returned function can be used to unregister this watcher.
 *
 * There are several values you can use for [target]:
 *
 *   * A [Getter] function.
 *   Use this to watch expressions as they change. For instance, to watch
 *   whether `a.b.c` changes, wrap it in a getter and call [watch] as follows:
 *         watch(() => a.b.c, ...)
 *   These targets are tracked to check for equality. If calling `target()`
 *   returns the same result, then the [callback] will not be invoked. In the
 *   special case whe the getter returns a [List], we will treat the value in a
 *   special way, similar to passing [List] directly as [target].
 *   **Important**: this library assumes that [Getter] is a read-only function
 *   and that it will consistently return the same value if called multiple
 *   times in a row.
 *
 *   * A [List].
 *   Use this to watch whether a list object changes. For instance, to detect
 *   if an element is added or changed in a list can call [watch] as follows:
 *         watch(list, ...)
 *
 *   * A [Handle].
 *   This is syntactic sugar for using the getter portion of a [Handle].
 *         watch(handle, ...)  // equivalent to `watch(handle._getter, ...)`
 */
WatcherDisposer watch(var target, ValueWatcher callback, [String debugName]) {
  if (callback == null) return () {}; // no use in passing null as a callback.
  if (_watchers == null) _watchers = [];
  Function exp;
  if (target is Handle) {
    // TODO(sigmund): replace by 'as' operator when supported by dart2js
    Handle t = target;
    exp = t._getter;
  } else if (target is Function) {
    try {
      if (target() is List) {
        exp = new _ListWatcher.getter(target).watchValue;
      } else {
        exp = target;
      }
    } catch (e, trace) { // in case target() throws some error
      // TODO(sigmund): use logging instead of print when logger is in the SDK
      // and available via pub (see dartbug.com/4363)
      print('error: evaluating ${debugName != null ? debugName : "<unnamed>"} '
            'watcher threw error ($e, $trace)');
      exp = target;
    }
  } else if (target is List) {
    exp = new _ListWatcher(target).watchValue;
  }
  var watcher = new _Watcher(exp, callback, debugName);
  _watchers.add(watcher);
  return () => _unregister(watcher);
}

/**
 * Add a watcher for [exp] and immediatly invoke [callback]. The watch event
 * passed to [callback] will have `null` as the old value, and the current
 * evaluation of [exp] as the new value.
 */
WatcherDisposer watchAndInvoke(exp, callback, [debugName]) {
  var res = watch(exp, callback, debugName);
  // TODO(jmesserly): this should be "is Getter" once dart2js bug is fixed.
  if (exp is Function) {
    callback(new WatchEvent(null, exp()));
  } else {
    callback(new WatchEvent(null, exp));
  }
  return res;
}

/** Callback fired when an expression changes. */
typedef void ValueWatcher(WatchEvent e);

/** A function that unregisters a watcher. */
typedef void WatcherDisposer();

/** Event passed to [ValueMatcher] showing what changed. */
class WatchEvent {

  /** Previous value seen on the watched expression. */
  final oldValue;

  /** New value seen on the watched expression. */
  final newValue;

  WatchEvent(this.oldValue, this.newValue);
}

/** Internal set of active watchers. */
List<_Watcher> _watchers;

/**
 * An internal representation of a watcher. Contains the expression it watches,
 * the last value seen for it, and a callback to invoke when a change is
 * detected.
 */
class _Watcher {
  /** Name used to debug. */
  final String debugName;

  /** Function that retrieves the value being watched. */
  final Function _getter;

  /** Callback to invoke when the value changes. */
  final ValueWatcher _callback;

  /** Last value observed on the matched expression. */
  var _lastValue;

  _Watcher(this._getter, this._callback, this.debugName) {
    _lastValue = _getter();
  }

  String toString() => debugName == null ? '<unnamed>' : debugName;
}


/** Removes a watcher. */
void _unregister(_Watcher watcher) {
  var index = _watchers.indexOf(watcher);
  if (index != -1) _watchers.removeRange(index, 1);
}

/** Bound for the [dispatch] algorithm. */
final int _maxIter = 10;

/**
 * Scan all registered watchers and invoke their callbacks if the watched value
 * has changed. Because we allow listeners to modify other watched expressions,
 * [dispatch] will reiterate until no changes occur or until we reach a
 * particular limit (10) to ensure termination.
 */
void dispatch() {
  if (_watchers == null) return;
  bool dirty = false;
  int total = 0;
  do {
    dirty = false;
    for (var watcher in _watchers) {
        var oldValue = watcher._lastValue;
        var newValue;
        try {
          newValue = watcher._getter();
        } catch (e, trace) {
          print('error: evaluating $watcher watcher threw an exception '
              '($e, $trace)');
          newValue = oldValue;
        }
        if (oldValue != newValue) {
          watcher._lastValue = newValue;
          watcher._callback(new WatchEvent(oldValue, newValue));
          dirty = true;
        }
    }
  } while (dirty && total++ < _maxIter);
  if (total == _maxIter) {
    print('Possible loop in watchers propagation, stopped dispatch.');
  }
}

/**
 * An indirect getter. Basically a simple closure that returns a value, which is
 * the most common argument in [watch].
 */
typedef T Getter<T>();

/** An indirect setter. */
typedef void Setter<T>(T value);

/**
 * An indirect reference to a value. This is used to create two-way bindings in
 * MVC applications.
 *
 * The model can be a normal Dart class. You can then create a handle to a
 * particular reference so that the view has read/write access without
 * internally revealing your model abstraction. For example, consider a model
 * class containing whether or not an item is 'checked' on a list:
 *
 *     class Item {
 *       int id;
 *       ...
 *       bool checked;
 *
 * Then we can use a CheckBox view and only reveal the status of the checked
 * field as follows:
 *
 *     new CheckBoxView(new Handle<bool>(
 *         () => item.checked,
 *         (v) { item.checked = v}));
 *
 * A handle with no setter is a read-only handle.
 */
class Handle<T> {
  final Getter<T> _getter;
  final Setter<T> _setter;

  /** Create a handle, possibly read-only (if no setter is specified). */
  Handle(this._getter, [this._setter]);

  Handle.of(T value) : this(() => value);

  T get value => _getter();

  void set value(T value) {
    if (_setter != null) {
      _setter(value);
    } else {
      throw new Exception('Sorry - this handle has no setter.');
    }
  }
}

/** Internal helper to detect changes on list objects. */
class _ListWatcher<T> {

  /** Shallow copy of the list as it was when this watcher was created. */
  List<T> _last = <T>[];

  /**
   * The list reference (the current value of the list). If not null, then
   * [_getter] should be null.
   */
  final List<T> _value;

  /**
   * A getter to the list reference (the current value of the list). If not
   * null, then [_value] should be null.
   */
  final Getter<List<T>> _getter;


  _ListWatcher(this._value) : _getter = null {
    _last.addAll(_value);
  }

  _ListWatcher.getter(this._getter) : _value = null {
    _last.addAll(_getter());
  }

  /** [_lastResult] changes only when the list changes. */
  bool _lastResult = false;
  bool watchValue() {
    List<T> currentValue = (_value != null ? _value : _getter());
    if (_changed(currentValue)) {
      _lastResult = !_lastResult;
      _last.clear();
      _last.addAll(currentValue);
    }

    return _lastResult;
  }

  bool _changed(List<T> currentValue) {
    if (_last.length != currentValue.length) return true;

    for (int i = 0 ; i < _last.length; i++) {
      if (_last[i] != currentValue[i]) return true;
    }
    return false;
  }
}
