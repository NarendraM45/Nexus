import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String color; // hex color string

  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.color = '0xFF181D35',
  });

  NoteModel copyWith({String? title, String? content, String? color}) {
    return NoteModel(
      id: id, title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt, color: color ?? this.color,
    );
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<NoteModel>>((ref) {
  return NotesNotifier();
});

class NotesNotifier extends StateNotifier<List<NoteModel>> {
  NotesNotifier() : super([
    NoteModel(id: 'n1', title: 'Sprint Planning', content: 'Review backlog items and assign story points for next sprint.', createdAt: DateTime.now().subtract(const Duration(hours: 2)), color: '0xFF7C3AED'),
    NoteModel(id: 'n2', title: 'Design Review Notes', content: 'Updated color palette approved. New gradient system for Nexus brand.', createdAt: DateTime.now().subtract(const Duration(hours: 5)), color: '0xFF00D9F5'),
    NoteModel(id: 'n3', title: 'API Endpoints', content: '/api/v2/tasks\n/api/v2/users\n/api/v2/analytics\n/api/v2/projects', createdAt: DateTime.now().subtract(const Duration(days: 1)), color: '0xFF10B981'),
    NoteModel(id: 'n4', title: 'Meeting Agenda', content: '1. Q3 goals review\n2. Team capacity planning\n3. Tech debt priorities', createdAt: DateTime.now().subtract(const Duration(days: 2)), color: '0xFFFFB84C'),
  ]);

  void addNote(String title, String content, [String? color]) {
    state = [
      NoteModel(
        id: 'n_${DateTime.now().millisecondsSinceEpoch}',
        title: title, content: content,
        createdAt: DateTime.now(),
        color: color ?? '0xFF181D35',
      ),
      ...state,
    ];
  }

  void updateNote(String id, String title, String content) {
    state = state.map((n) => n.id == id ? n.copyWith(title: title, content: content) : n).toList();
  }

  void deleteNote(String id) {
    state = state.where((n) => n.id != id).toList();
  }
}
