import 'package:isar/isar.dart';

part 'model.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement; //
  String userId;
  String? title;
  String? subtitle;

  DateTime? datetime;
  User(
      {required this.subtitle,
      required this.datetime,
      required this.title,
      required this.userId});
}
