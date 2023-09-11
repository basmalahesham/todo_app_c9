import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/task_model.dart';

class FirestoreUtils {
  static CollectionReference getCollection() {
    return FirebaseFirestore.instance
        .collection(TaskModel.collectionName)
        .withConverter<TaskModel>(
          fromFirestore: (snapshot, _) =>
              TaskModel.fromFireStore(snapshot.data()!),
          toFirestore: (taskModel, _) => taskModel.toFireStore(),
        );
  }

  static Future<void> addTask(TaskModel taskModel) async {
    var collection = getCollection();
    var doc = collection.doc();
    taskModel.id = doc.id;
    doc.set(taskModel);
  }

// Future<void> updateTask(TaskModel taskModel) async {
//   await getCollection().doc(taskModel.id).update(taskModel.toFireStore());
// }
//
// Future<void> deleteTask(TaskModel taskModel) async {
//   await getCollection().doc(taskModel.id).delete();
// }
//
// Future<List<TaskModel>> getTasks() async {}
}
