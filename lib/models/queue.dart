import 'package:uuid/uuid.dart';

class Queue {
  List<Uuid> queue = [];

  void addToQueue(Uuid songID) {
    queue.add(songID);
  }

  void removeFromQueue(Uuid songID) {
    queue.remove(songID);
  }

  void removeAtIndex(int index) {
    queue.removeAt(index);
  }

  void clearQueue() {
    queue.clear();
  }
}
