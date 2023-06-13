import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String desc;

  @HiveField(2)
  late DateTime createdAt;

  Note(
    this.title,
    this.desc,
    this.createdAt,
  );
}
