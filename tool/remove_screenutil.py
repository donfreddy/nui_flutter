"""Remove flutter_screenutil dependency from all Dart files.

Replaces ScreenUtil extension calls (.sp, .w, .h, .r, .dg) with raw values,
and removes the corresponding import statements.
"""
import re
import os

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

EXT_PATTERNS = [
    # value.w / value.h / value.dg (n_spacing.dart parameter)
    (re.compile(r'\b(value)\.(w|h|dg)\b'), r'\1'),
    # NSpacing.X.w / NSpacing.X.h / NSpacing.X.r
    (re.compile(r'\b((?:NSpacing|NTokens)\.\w+)\.(w|h|r)\b'), r'\1'),
    # theme.X.w / theme.X.h / theme.X.r (e.g. theme.radius.r)
    (re.compile(r'\b(theme\.\w+)\.(w|h|r)\b'), r'\1'),
    # NTokens.X.w / NTokens.X.h / NTokens.X.r
    (re.compile(r'\b((?:NTokens)\.\w+)\.(w|h|r)\b'), r'\1'),
    # Integer literals: 14.w, 8.h, 6.r, etc.
    (re.compile(r'(\d+)\.(w|h|r|dg)\b'), r'\1'),
]

def transform_file(filepath: str) -> bool:
    with open(filepath, 'r') as f:
        content = f.read()
    original = content

    # 1. Remove import line
    content = content.replace(
        "import 'package:flutter_screenutil/flutter_screenutil.dart';\n", ''
    )
    content = content.replace(
        "import 'package:flutter_screenutil/flutter_screenutil.dart';", ''
    )

    # 2. Replace .sp (completely safe — no false positives in Dart)
    content = content.replace('.sp', '')

    # 3. Replace .w, .h, .r, .dg with controlled patterns
    for pattern, replacement in EXT_PATTERNS:
        content = pattern.sub(replacement, content)

    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        return True
    return False


def main():
    modified = []
    for root, dirs, files in os.walk(os.path.join(BASE, 'lib')):
        # Skip build cache
        dirs[:] = [d for d in dirs if not d.startswith('.')]
        for f in files:
            if f.endswith('.dart'):
                path = os.path.join(root, f)
                if transform_file(path):
                    modified.append(os.path.relpath(path, BASE))

    for root, dirs, files in os.walk(os.path.join(BASE, 'test')):
        dirs[:] = [d for d in dirs if not d.startswith('.')]
        for f in files:
            if f.endswith('.dart'):
                path = os.path.join(root, f)
                if transform_file(path):
                    modified.append(os.path.relpath(path, BASE))

    if modified:
        print('Modified files:')
        for m in modified:
            print(f'  {m}')
    else:
        print('No files modified.')

    print(f'\nDone. {len(modified)} files changed.')


if __name__ == '__main__':
    main()
