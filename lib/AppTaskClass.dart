import 'package:cloud_firestore/cloud_firestore.dart';

class AppTask {
  String id;
  final String taskName;
  final String taskDescription;
  final String taskEmail;
  final bool taskState;
  final DateTime taskDate;

  AppTask({
    this.id = '',
    required this.taskName,
    required this.taskDescription,
    required this.taskEmail,
    required this.taskState,
    required this.taskDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'Name': taskName,
        'Description': taskDescription,
        'Email': taskEmail,
        'State': taskState,
        'Date': taskDate,
      };

  static AppTask fromJson(Map<String, dynamic> json) => AppTask(
        id: json['id'] ?? '',
        taskName: json['Name'] ?? '',
        taskDescription: json['Description'] ?? '',
        taskEmail: json['Email'] ?? '',
        taskState: json['State'] ?? '',
        taskDate:
            (json['Date'] as Timestamp).toDate(), // ?? DateTime(2000, 1, 10),
      );
}

Future createAppTask(
    {required String id,
    required String taskName,
    required String taskDescription,
    required String taskEmail,
    required bool taskState,
    required DateTime taskDate}) async {
  final docUser = FirebaseFirestore.instance.collection('appTasks').doc();

  final _task = AppTask(
    id: docUser.id, //taskEmail,
    taskName: taskName,
    taskDescription: taskDescription,
    taskEmail: taskEmail,
    taskState: taskState,
    taskDate: taskDate,
  );

  final json = _task.toJson();

  await docUser.set(json);
}

Stream<List<AppTask>> readAppTasks() => FirebaseFirestore.instance
    .collection('appTasks')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => AppTask.fromJson(doc.data())).toList());

Future<AppTask?> readAppTask(String sID) async {
  final docUser = FirebaseFirestore.instance.collection('appTasks').doc(sID);
  final snapshot = await docUser.get();

  if (snapshot.exists) {
    return AppTask.fromJson(snapshot.data()!);
  }
}
