import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

/**
 * Wrapper class for a [Set]. This enables most changes to be registered with
 * a [BehaviorSubject].
 */
class StreamSet<E> extends DelegatingSet<E> {
  BehaviorSubject<Set<E>> _behaviorSubject;

  StreamSet() : super(Set()) {
    this._behaviorSubject = BehaviorSubject();
    _behaviorSubject.add(this);
  }

  BehaviorSubject<Set<E>> get behaviorSubject => _behaviorSubject;

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
  bool add(E value) {
    bool b = super.add(value);
    _behaviorSubject.add(this);

    return b;
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
