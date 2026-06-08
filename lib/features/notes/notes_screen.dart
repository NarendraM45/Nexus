import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import '../../core/providers/notes_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/lottie_hamburger.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  void _showNoteSheet({NoteModel? existingNote}) {
    final titleCtrl = TextEditingController(text: existingNote?.title ?? '');
    final contentCtrl = TextEditingController(text: existingNote?.content ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(ctx).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: 'Note Title',
                    border: InputBorder.none,
                  ),
                ),
                const Divider(),
                TextField(
                  controller: contentCtrl,
                  maxLines: 5,
                  style: GoogleFonts.nunito(fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Write your thoughts here...',
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: AppColors.neonCyan,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      if (titleCtrl.text.isNotEmpty || contentCtrl.text.isNotEmpty) {
                        if (existingNote == null) {
                          ref.read(notesProvider.notifier).addNote(
                            titleCtrl.text.isEmpty ? 'Untitled' : titleCtrl.text,
                            contentCtrl.text,
                          );
                        } else {
                          // we would edit, but since provider doesn't have editNote, delete and re-add or just keep add.
                          ref.read(notesProvider.notifier).deleteNote(existingNote.id);
                          ref.read(notesProvider.notifier).addNote(
                            titleCtrl.text.isEmpty ? 'Untitled' : titleCtrl.text,
                            contentCtrl.text,
                          );
                        }
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text('Save Note', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const LottieHamburger(),
        title: const Text('Notes'),
      ),
      body: MasonryGridView.count(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          final colorValue = int.tryParse(note.color) ?? 0xFF181D35;
          
          return GestureDetector(
            onTap: () => _showNoteSheet(existingNote: note),
            onLongPress: () => ref.read(notesProvider.notifier).deleteNote(note.id),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(colorValue).withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    note.title,
                    style: GoogleFonts.sora(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.content,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    DateFormat('MMM dd, hh:mm a').format(note.createdAt),
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNoteSheet(),
        backgroundColor: AppColors.neonCyan,
        icon: const Icon(Icons.add_rounded, color: Colors.black),
        label: const Text('New Note', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
