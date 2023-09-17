import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/task_model.dart';

class FirestoreUtils {
  static CollectionReference<TaskModel> getCollection() {
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
    return doc.set(taskModel);
  }

  static Future<List<TaskModel>> getDataFromFirestore() async {
    var snapshots = await getCollection().get();
    // List <QuerySnapshot<TaskModel>>  ---> List<TaskModel>
    List<TaskModel> tasksList =
        snapshots.docs.map((element) => element.data()).toList();
    return tasksList;
  }

  static Stream<QuerySnapshot<TaskModel>> getRealTimeDataFromFirestore() {
    var querySnapshots = getCollection().snapshots();
    return querySnapshots;
  }

  static Future<void> deleteData(TaskModel model) {
    var collectionRef = getCollection().doc(model.id);
    return collectionRef.delete();
  }

// Future<void> updateTask(TaskModel taskModel) async {
//   await getCollection().doc(taskModel.id).update(taskModel.toFireStore());
// }
//

//
// Future<List<TaskModel>> getTasks() async {}
}
