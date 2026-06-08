import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final int totalTasks;
  final int completedTasks;
  final String color; // hex color
  final DateTime deadline;

  const ProjectModel({
    required this.id, required this.name, required this.description,
    required this.totalTasks, required this.completedTasks,
    required this.color, required this.deadline,
  });

  double get progress => totalTasks == 0 ? 0 : completedTasks / totalTasks;
}

final projectsProvider = StateNotifierProvider<ProjectsNotifier, List<ProjectModel>>((ref) {
  return ProjectsNotifier();
});

class ProjectsNotifier extends StateNotifier<List<ProjectModel>> {
  ProjectsNotifier() : super([
    ProjectModel(id: 'p1', name: 'Nexus Mobile App', description: 'Complete Flutter rebuild with premium UI', totalTasks: 24, completedTasks: 18, color: '0xFF9B5DE5', deadline: DateTime.now().add(const Duration(days: 14))),
    ProjectModel(id: 'p2', name: 'API Integration', description: 'Backend REST API endpoints and auth', totalTasks: 12, completedTasks: 5, color: '0xFF00D9F5', deadline: DateTime.now().add(const Duration(days: 21))),
    ProjectModel(id: 'p3', name: 'Design System', description: 'Glassmorphism components and Lottie animations', totalTasks: 8, completedTasks: 8, color: '0xFF10B981', deadline: DateTime.now().add(const Duration(days: 7))),
    ProjectModel(id: 'p4', name: 'Team Dashboard', description: 'Analytics and team performance tracking', totalTasks: 16, completedTasks: 3, color: '0xFFFFB84C', deadline: DateTime.now().add(const Duration(days: 30))),
  ]);

  void addProject(String name, String description, DateTime deadline, String color) {
    state = [
      ProjectModel(
        id: 'p_${DateTime.now().millisecondsSinceEpoch}',
        name: name, description: description,
        totalTasks: 0, completedTasks: 0,
        color: color, deadline: deadline,
      ),
      ...state,
    ];
  }

  void deleteProject(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}
