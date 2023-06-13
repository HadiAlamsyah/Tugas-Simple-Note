import 'package:hive/hive.dart';
import 'package:note/models/note.dart';

class DatabasesService {
  static const String boxName = 'notes';

  Future<void> addNote(Note note) async {
    final box = await Hive.openBox(boxName);
    await box.add(note);
  }

  Future<void> getNote(Note note) async {
    final box = await Hive.openBox(boxName);
    return await box.get(note.key).toList().cast<Note>();
  }

  Future<void> editNote(int key, Note note) async {
    final box = await Hive.openBox(boxName);
    await box.put(key, note);
  }

  Future<void> deleteNote(Note note) async {
    final box = await Hive.openBox(boxName);
    box.delete(note.key);
  }
}
