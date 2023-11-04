class Task {
  String? id;
  String title;
  String description;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  Task(
      {this.id,
      required this.title,
      required this.description,
      required this.status,
      required this.createdAt,
      required this.updatedAt});
}
