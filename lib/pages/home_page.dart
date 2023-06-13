import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note/db/database_service.dart';
import 'package:note/extensions/format_date.dart';
import 'package:note/models/note.dart';
import 'package:note/utils/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabasesService dbService = DatabasesService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Simple Notes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).pushNamed('add-note');
        },
        child: const Icon(
          Icons.note_add_rounded,
          color: Colors.blue,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(DatabasesService.boxName).listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Tidak ada data'),
            );
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final note = box.getAt(index);
                return NoteCard(
                  note: note,
                  databasesService: dbService,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.databasesService,
  });

  final Note note;
  final DatabasesService databasesService;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.key.toString()),
      background: const Text(''),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          databasesService.deleteNote(note).then((value) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.blue,
                    content: Text('Catatan Berhasil Dihapus'),
                  ),
                )
              });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue[50],
        ),
        child: ListTile(
          onTap: () {
            GoRouter.of(context).pushNamed(AppRoutes.editNote, extra: note);
          },
          title: Text(
            note.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(note.desc),
          trailing: Text('Dibuat pada : \n ${note.createdAt.formatDate()}'),
        ),
      ),
    );
  }
}
