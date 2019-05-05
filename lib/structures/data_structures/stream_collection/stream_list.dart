import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Wrapper class for a [List]. This enables most changes to be registered with
 * a [BehaviorSubject].
 */
class StreamList<E> extends DelegatingList<E> {
  BehaviorSubject<List<E>> _behaviorSubject;

  StreamList() : super(List()) {
    this._behaviorSubject = BehaviorSubject();
    _behaviorSubject.add(this);
  }

  BehaviorSubject<List<E>> get behaviorSubject => _behaviorSubject;

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
