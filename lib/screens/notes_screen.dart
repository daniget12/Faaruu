import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../db/note_database.dart';
import 'add_note_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    final notes = await NoteDatabase.instance.readAllNotes();
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  Future<void> _deleteNote(Note note) async {
    await NoteDatabase.instance.delete(note.id!);
    _loadNotes();
  }

  Future<void> _openAddNote({Note? note}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddNoteScreen(note: note)),
    );
    if (result == true) _loadNotes();
  }

  Future<bool> _confirmDelete(Note note) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Haqi?'),
        content: Text('"${note.title}" haquu barbaaddaa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Lakkii'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Haqi'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B2737),
        foregroundColor: Colors.white,
        title: const Text(
          'Yaadannoo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6B2737)),
            )
          : _notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.note_alt_outlined,
                          size: 72, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'Yaadannoon hin jiru.\n+ tuqi yaadannoo haaraa barreessi.',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.grey.shade500, fontSize: 15),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return Dismissible(
                      key: Key('note_${note.id}'),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) => _confirmDelete(note),
                      onDismissed: (_) => _deleteNote(note),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 1,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          title: Text(
                            note.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                note.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 13),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                DateFormat('MMM d, yyyy')
                                    .format(note.updatedAt),
                                style: TextStyle(
                                    color: Colors.grey.shade400, fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                color: Color(0xFF6B2737)),
                            onPressed: () => _openAddNote(note: note),
                          ),
                          onTap: () => _openAddNote(note: note),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddNote(),
        backgroundColor: const Color(0xFF6B2737),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
