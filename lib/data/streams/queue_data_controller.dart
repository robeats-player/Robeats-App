import 'package:Robeats/structures/data_structures/stream_queue.dart';
import 'package:Robeats/structures/media.dart';
import 'package:rxdart/rxdart.dart';

class QueueDataController {
  BehaviorSubject<StreamQueue<Song>> queueStreamController = BehaviorSubject();

  QueueDataController();

  /// Close all resources to reduce memory leaks.
  void dispose() {
    queueStreamController.close();
  }
}