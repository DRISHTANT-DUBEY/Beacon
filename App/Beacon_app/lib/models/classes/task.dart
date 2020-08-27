import 'dart:convert';

class Task {
  List<Task> tasks;
  String note;
  DateTime timeToComplete;
  bool completed;
  String repeats;
  String deadline;
  List<DateTime> reminders;
  int taskId;
  String title;

  Task(this.title, this.completed, this.taskId, this.note, this.deadline);

  factory Task.fromJson(Map<String, dynamic> parsedJson) {
    return Task(
      parsedJson['title'],
      parsedJson['completed'],
      parsedJson['id'],
      parsedJson['note'],
      parsedJson['deadline'],
    );
  }
}
