import os

screens = [
    'activity_screen.dart',
    'analytics_screen.dart',
    'calendar_screen.dart',
    'explore_screen.dart',
    'notes_screen.dart',
    'profile_screen.dart',
    'projects_screen.dart',
    'tasks_screen.dart',
    'team_screen.dart'
]

for root, _, files in os.walk('lib/features'):
    for file in files:
        if file in screens:
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            modified = False
            # Add import if not there
            if 'lottie_hamburger.dart' not in content:
                lines = content.split('\n')
                last_import_idx = -1
                for i, line in enumerate(lines):
                    if line.startswith('import '):
                        last_import_idx = i
                if last_import_idx != -1:
                    lines.insert(last_import_idx + 1, "import '../../shared/widgets/lottie_hamburger.dart';")
                content = '\n'.join(lines)
                modified = True
            
            # Add leading if not there
            if 'leading: const LottieHamburger()' not in content:
                content = content.replace("appBar: AppBar(", "appBar: AppBar(\n        leading: const LottieHamburger(),")
                modified = True
            
            if modified:
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f'Updated {file}')
