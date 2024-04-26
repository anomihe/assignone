import 'package:assignment_one/database/model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class DatabaseServices {
  late Future<Isar> _db;

  DatabaseServices() {
    _db = openDatabase();
  }

  Future<Isar> openDatabase() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      final isar = await Isar.open([UserSchema], directory: dir.path);
      return isar;
    }
    return Future.value(Isar.getInstance());
  }

  Future<List<User>> loadAllMeetings() async {
    final Isar dbInstance = await _db;
    final users = await dbInstance.users
        .where()
        .sortByDatetimeDesc()
        .thenByDatetimeDesc()
        .findAll();
    return users;
  }

  Future<void> createNewMeeting(
      {required String title,
      required String subtitile,
      required DateTime time}) async {
    final Isar dbInstance = await _db;
    const uuid = Uuid();
    final user = User(
        userId: uuid.v4(), title: title, subtitle: subtitile, datetime: time);
    await dbInstance.writeTxn(() async {
      await dbInstance.users.put(user);
    });
  }

  Future<void> deleteMeeting({required String todoId}) async {
    final Isar dbInstance = await _db;
    final User? user =
        await dbInstance.users.filter().userIdEqualTo(todoId).findFirst();
    if (user != null) {
      await dbInstance.writeTxn(() async {
        await dbInstance.users.delete(user.id);
      });
    }
  }

  // Future<void> completeTodo({required String todoId}) async {
  //   final Isar dbInstance = await _db;
  //   final User? user = await dbInstance.users.filter().userIdEqualTo(todoId).findFirst();
  //   if(user != null){
  //     await dbInstance.writeTxn(() async {
  //       user. = true;
  //       await dbInstance.users.put(todo);
  //     });
  //   }
  // }
}
