import 'dart:collection';

import 'package:rxdart/rxdart.dart';

/// Wrapper class for a [Queue]. This enables all changes to be registered with
/// a [BehaviorSubject].
class StreamQueue<E> extends ListQueue<E> {
  BehaviorSubject<Queue<E>> _behaviorSubject;

  StreamQueue(BehaviorSubject<Queue<E>> behaviorSubject) {
    this._behaviorSubject = behaviorSubject;
    _behaviorSubject.add(this);
  }

  @override
  void clear() {
    super.clear();
    _behaviorSubject.add(this);
  }

  @override
  bool remove(Object value) {
    super.remove(value);
    _behaviorSubject.add(this);
  }

  @override
  void add(E value) {
    super.add(value);
    _behaviorSubject.add(this);
  }

  @override
  E removeLast() {
    E e = super.removeLast();
    _behaviorSubject.add(this);

    return e;
  }

  @override
  E removeFirst() {
    E e = super.removeFirst();
    _behaviorSubject.add(this);

    return e;
  }

  @override
  void addFirst(E value) {
    super.add(value);
    _behaviorSubject.add(this);
  }

  @override
  void addLast(E value) {
    super.add(value);
    _behaviorSubject.add(this);
  }

  @override
  void retainWhere(bool test(E element)) {
    super.retainWhere(test);
    _behaviorSubject.add(this);
  }

  @override
  void removeWhere(bool test(E element)) {
    super.removeWhere(test);
    _behaviorSubject.add(this);
  }

  @override
  void addAll(Iterable<E> elements) {
    super.addAll(elements);
    _behaviorSubject.add(this);
  }
}