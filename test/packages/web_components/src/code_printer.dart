// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library code_printer;

/** Helper class that auto-formats generated code. */
class CodePrinter {
  List _items = [];

  /**
   * Adds [object] to this printer and appends a new-line after it. Returns this
   * printer.
   */
  CodePrinter add(object) {
    _items.add(object);
    _items.add('\n');
    return this;
  }

  /** Returns everything on this printer without any fixes on indentation. */
  String toString() => new StringBuffer().addAll(_items).toString();

  /**
   * Returns a formatted code block, with indentation appropriate to code
   * blocks' nesting level.
   */
  String formatString([int indent = 0]) {
    bool lastEmpty = false;
    var buff = new StringBuffer();
    for (var item in _items) {
      for (var line in item.toString().split('\n')) {
        line = line.trim();
        if (line == '') {
          if (lastEmpty) continue;
          lastEmpty = true;
        } else {
          lastEmpty = false;
        }
        bool decIndent = line.startsWith("}");
        bool incIndent = line.endsWith("{");
        if (decIndent) indent--;
        for (int i = 0; i < indent; i++) buff.add('  ');
        buff.add(line);
        buff.add('\n');
        if (incIndent) indent++;
      }
    }
    return buff.toString();
  }
}
