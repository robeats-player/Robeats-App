import 'dart:collection';

/// The purpose of this class is slightly trivial and unnecessary, however
/// using a list, and pretending it's a stack is confusing at times. Simply
/// having a class, albeit a wrapper class, for a stack is helpful.
class Stack<T> {
  Queue<T> _queue = Queue();

  Stack();

  bool get isEmpty => _queue.isEmpty;

  bool get isNotEmpty => !isEmpty;

  void push(T t) {
    if (isEmpty) {
      _queue.addFirst(t);
    }
  }

  T pop() {
    return isNotEmpty ? _queue.removeFirst() : null;
  }

  T peek() {
    return isNotEmpty ? _queue.first : null;
  }
}
