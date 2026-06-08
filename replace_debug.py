import os, re
files_to_edit = [
  'lib/core/providers/avatar_provider.dart',
  'lib/main.dart',
  'lib/shared/widgets/custom/rive_refresh_indicator.dart',
  'lib/shared/widgets/custom/safe_lottie.dart'
]
for p in files_to_edit:
    path = os.path.join(*p.split('/'))
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if 'debugPrint(' in content:
        content = content.replace('debugPrint(', 'AppLogger.log(')
        import_stmt = "import 'package:nexus/core/utils/app_logger.dart';\n"
        if import_stmt not in content:
            content = import_stmt + content
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print('Updated ' + path)
