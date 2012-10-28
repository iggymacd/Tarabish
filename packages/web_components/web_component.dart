// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO(jmesserly): Remove this file when our version >= 0.2, and merge
// this with "web_components.dart". Leaving for now to keep 0.1.x compat.
/** Declares the [WebComponent] base class (eventually: mixin). */
library web_component;

import 'dart:html';

/**
 * The base class for all Dart web components. In addition to the [Element]
 * interface, it also provides lifecycle methods:
 * - [created]
 * - [inserted]
 * - [attributeChanged]
 * - [removed]
 */
abstract class WebComponent implements Element {
  /** The web component element wrapped by this class. */
  final Element _element;

  static bool _hasShadowRoot = true;

  /**
   * Default constructor for web components. This contructor is only provided
   * for tooling, and is *not* currently supported.
   * Use [WebComponent.forElement] instead.
   */
  WebComponent() : _element = null {
    throw new UnsupportedError(
        'Directly constructing web components is not currently supported. '
        'You need to use the WebComponent.forElement constructor to associate '
        'a component with its DOM element. If you run "bin/dwc.dart" on your '
        'component, the compiler will create the approriate construction '
        'logic.');
  }

  /**
   * Temporary constructor until components extend [Element]. Attaches this
   * component to the provided [element]. The element must not already have a
   * component associated with it.
   */
  WebComponent.forElement(Element element) : _element = element {
    if (element == null || _element.xtag != null) {
      throw new IllegalArgumentException(
          'element must be provided and not have its xtag property set');
    }
    _element.xtag = this;
  }

  /**
   * Creates the [ShadowRoot] backing this component. This is an implementation
   * helper and should not need to be called from your code.
   */
  createShadowRoot() {
    var shadowRoot;
    if (ShadowRoot.supported) {
      shadowRoot = new ShadowRoot(_element);
      // TODO(jmesserly): what's up with this flag? Why are we setting it?
      shadowRoot.resetStyleInheritance = false;
    } else {
      shadowRoot = new Element.html('<div class="shadowroot"></div>');
      nodes.add(shadowRoot);
    }
    return shadowRoot;
  }

  /**
   * Invoked when this component gets created.
   * Note that [root] will be a [ShadowRoot] if the browser supports Shadow DOM.
   */
  void created() {}

  /** Invoked when this component gets inserted in the DOM tree. */
  void inserted() {}

  /** Invoked when this component is removed from the DOM tree. */
  void removed() {}

  // TODO(jmesserly): how do we implement this efficiently?
  // See https://github.com/dart-lang/dart-web-components/issues/37
  /** Invoked when any attribute of the component is modified. */
  void attributeChanged(
      String name, String oldValue, String newValue) {}

  // TODO(jmesserly): this forwarding is temporary until Dart supports
  // subclassing Elements.

  NodeList get nodes => _element.nodes;

  set nodes(Collection<Node> value) { _element.nodes = value; }

  /**
   * Replaces this node with another node.
   */
  Node replaceWith(Node otherNode) { _element.replaceWith(otherNode); }

  /**
   * Removes this node from the DOM.
   */
  void remove() => _element.remove();

  Node get nextNode => _element.nextNode;

  Document get document => _element.document;

  Node get previousNode => _element.previousNode;

  String get text => _element.text;

  set text(String v) { _element.text = v; }

  bool contains(Node other) => _element.contains(other);

  bool hasChildNodes() => _element.hasChildNodes();

  Node insertBefore(Node newChild, Node refChild) =>
    _element.insertBefore(newChild, refChild);

  AttributeMap get attributes => _element.attributes;
  set attributes(Map<String, String> value) {
    _element.attributes = value;
  }

  List<Element> get elements => _element.elements;

  set elements(Collection<Element> value) {
    _element.elements = value;
  }

  Set<String> get classes => _element.classes;

  set classes(Collection<String> value) {
    _element.classes = value;
  }

  AttributeMap get dataAttributes => _element.dataAttributes;
  set dataAttributes(Map<String, String> value) {
    _element.dataAttributes = value;
  }

  Future<ElementRect> get rect => _element.rect;

  Future<CSSStyleDeclaration> get computedStyle => _element.computedStyle;

  Future<CSSStyleDeclaration> getComputedStyle(String pseudoElement)
    => _element.getComputedStyle(pseudoElement);

  Element clone(bool deep) => _element.clone(deep);

  Element get parent => _element.parent;

  ElementEvents get on => _element.on;

  String get contentEditable => _element.contentEditable;

  String get dir => _element.dir;

  bool get draggable => _element.draggable;

  bool get hidden => _element.hidden;

  String get id => _element.id;

  String get innerHTML => _element.innerHTML;

  bool get isContentEditable => _element.isContentEditable;

  String get lang => _element.lang;

  String get outerHTML => _element.outerHTML;

  bool get spellcheck => _element.spellcheck;

  int get tabIndex => _element.tabIndex;

  String get title => _element.title;

  bool get translate => _element.translate;

  String get webkitdropzone => _element.webkitdropzone;

  void click() { _element.click(); }

  Element insertAdjacentElement(String where, Element element) =>
    _element.insertAdjacentElement(where, element);

  void insertAdjacentHTML(String where, String html) {
    _element.insertAdjacentHTML(where, html);
  }

  void insertAdjacentText(String where, String text) {
    _element.insertAdjacentText(where, text);
  }

  Map<String, String> get dataset => _element.dataset;

  Element get nextElementSibling => _element.nextElementSibling;

  Element get offsetParent => _element.offsetParent;

  Element get previousElementSibling => _element.previousElementSibling;

  CSSStyleDeclaration get style => _element.style;

  String get tagName => _element.tagName;

  void blur() { _element.blur(); }

  void focus() { _element.focus(); }

  void scrollByLines(int lines) {
    _element.scrollByLines(lines);
  }

  void scrollByPages(int pages) {
    _element.scrollByPages(pages);
  }

  void scrollIntoView([bool centerIfNeeded]) {
    if (centerIfNeeded == null) {
      _element.scrollIntoView();
    } else {
      _element.scrollIntoView(centerIfNeeded);
    }
  }

  bool matchesSelector(String selectors) => _element.matchesSelector(selectors);

  void webkitRequestFullScreen(int flags) {
    _element.webkitRequestFullScreen(flags);
  }

  void webkitRequestFullscreen() { _element.webkitRequestFullscreen(); }

  void webkitRequestPointerLock() { _element.webkitRequestPointerLock(); }

  Element query(String selectors) => _element.query(selectors);

  List<Element> queryAll(String selectors) => _element.queryAll(selectors);

  HTMLCollection get $dom_children => _element.$dom_children;

  int get $dom_childElementCount => _element.$dom_childElementCount;

  String get $dom_className => _element.$dom_className;
  set $dom_className(String value) { _element.$dom_className = value; }

  int get clientHeight => _element.clientHeight;

  int get clientLeft => _element.clientLeft;

  int get clientTop => _element.clientTop;

  int get clientWidth => _element.clientWidth;

  Element get $dom_firstElementChild => _element.$dom_firstElementChild;

  Element get $dom_lastElementChild => _element.$dom_lastElementChild;

  int get offsetHeight => _element.offsetHeight;

  int get offsetLeft => _element.offsetLeft;

  int get offsetTop => _element.offsetTop;

  int get offsetWidth => _element.offsetWidth;

  int get scrollHeight => _element.scrollHeight;

  int get scrollLeft => _element.scrollLeft;

  int get scrollTop => _element.scrollTop;

  set scrollLeft(int value) { _element.scrollLeft = value; }

  set scrollTop(int value) { _element.scrollTop = value; }

  int get scrollWidth => _element.scrollWidth;

  String $dom_getAttribute(String name) =>
      _element.$dom_getAttribute(name);

  ClientRect getBoundingClientRect() => _element.getBoundingClientRect();

  List<ClientRect> getClientRects() => _element.getClientRects();

  NodeList $dom_getElementsByClassName(String name) =>
      _element.$dom_getElementsByClassName(name);

  NodeList $dom_getElementsByTagName(String name) =>
      _element.$dom_getElementsByTagName(name);

  bool $dom_hasAttribute(String name) =>
      _element.$dom_hasAttribute(name);

  Element $dom_querySelector(String selectors) =>
      _element.$dom_querySelector(selectors);

  NodeList $dom_querySelectorAll(String selectors) =>
      _element.$dom_querySelectorAll(selectors);

  void $dom_removeAttribute(String name) =>
      _element.$dom_removeAttribute(name);

  void $dom_setAttribute(String name, String value) =>
      _element.$dom_setAttribute(name, value);

  NamedNodeMap get $dom_attributes => _element.$dom_attributes;

  NodeList get $dom_childNodes => _element.$dom_childNodes;

  Node get $dom_firstChild => _element.$dom_firstChild;

  Node get $dom_lastChild => _element.$dom_lastChild;

  int get $dom_nodeType => _element.$dom_nodeType;

  void $dom_addEventListener(String type, EventListener listener,
                             [bool useCapture]) {
    _element.$dom_addEventListener(type, listener, useCapture);
  }

  Node $dom_appendChild(Node newChild) => _element.$dom_appendChild(newChild);

  bool $dom_dispatchEvent(Event event) => _element.$dom_dispatchEvent(event);

  Node $dom_removeChild(Node oldChild) => _element.$dom_removeChild(oldChild);

  void $dom_removeEventListener(String type, EventListener listener,
                                [bool useCapture]) {
    _element.$dom_removeEventListener(type, listener, useCapture);
  }

  Node $dom_replaceChild(Node newChild, Node oldChild) =>
      _element.$dom_replaceChild(newChild, oldChild);

  get xtag => _element.xtag;

  set xtag(value) { _element.xtag = value; }

  void addText(String text) => _element.addText(text);

  void addHTML(String html) => _element.addHTML(html);
}
