import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class FirebaseService {
  static final FirebaseService instance = FirebaseService._init();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseService._init();

  Stream<List<Event>> getEvents() {
    return _firestore
        .collection('events')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList());
  }
}
