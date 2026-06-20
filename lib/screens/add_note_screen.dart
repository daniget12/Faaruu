import 'package:flutter/material.dart';
import '../models/note.dart';
import '../db/note_database.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;

  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSaving = false;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mata duree fi qabiyyee guuti.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final now = DateTime.now();
    if (_isEditing) {
      final updated = widget.note!.copyWith(
        title: title,
        content: content,
        updatedAt: now,
      );
      await NoteDatabase.instance.update(updated);
    } else {
      final note = Note(
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
      );
      await NoteDatabase.instance.create(note);
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B2737),
        foregroundColor: Colors.white,
        title: Text(
          _isEditing ? 'Yaadannoo Gulaali' : 'Yaadannoo Haaraa',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.check),
                  tooltip: 'Kuusi',
                  onPressed: _save,
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Mata duree',
                labelStyle: const TextStyle(color: Color(0xFF6B2737)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFF6B2737), width: 2),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Yaadannoo kee',
                  labelStyle: const TextStyle(color: Color(0xFF6B2737)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFF6B2737), width: 2),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
