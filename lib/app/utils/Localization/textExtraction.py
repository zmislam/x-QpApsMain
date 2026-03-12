#!/usr/bin/env python3
"""
Flutter Localization Converter
Automatically adds .tr extension to Text widgets and extracts translations
"""

import re
import os
import json
import shutil
from datetime import datetime
from pathlib import Path

class LocalizationConverter:
    def __init__(self, project_path):
        self.project_path = Path(project_path)
        self.lib_path = self.project_path / 'lib'
        self.backup_path = self.project_path / f'backup_{datetime.now().strftime("%Y%m%d_%H%M%S")}'
        self.translations = set()
        self.files_processed = []
        self.files_modified = []

    def create_backup(self):
        """Create backup of lib folder"""
        print(f"📦 Creating backup at: {self.backup_path}")
        shutil.copytree(self.lib_path, self.backup_path)
        print("✅ Backup created successfully\n")

    def should_skip_file(self, file_path):
        """Check if file should be skipped"""
        skip_patterns = [
            'generated',
            '.g.dart',
            '.freezed.dart',
            '.gr.dart',
            'app_translations.dart',
            'language_controller.dart',
        ]
        file_str = str(file_path)
        return any(pattern in file_str for pattern in skip_patterns)

    def extract_strings(self, content):
        """Extract translatable strings from Dart code"""
        patterns = {
            'text_widget': r"Text\s*\(\s*['\"]([^'\"]+)['\"]\s*[,\)]",
            'text_param': r"text:\s*['\"]([^'\"]+)['\"]",
            'title_param': r"title:\s*['\"]([^'\"]+)['\"]",
            'label_param': r"label:\s*['\"]([^'\"]+)['\"]",
            'hint_text': r"hintText:\s*['\"]([^'\"]+)['\"]",
            'label_text': r"labelText:\s*['\"]([^'\"]+)['\"]",
            'helper_text': r"helperText:\s*['\"]([^'\"]+)['\"]",
            'error_text': r"errorText:\s*['\"]([^'\"]+)['\"]",
            'button_text': r"child:\s*Text\s*\(\s*['\"]([^'\"]+)['\"]",
        }

        extracted = set()
        for pattern_name, pattern in patterns.items():
            matches = re.finditer(pattern, content)
            for match in matches:
                text = match.group(1).strip()
                # Skip if contains variables, numbers only, or is too short
                if (not text.startswith('$') and
                    '$' not in text and
                    not text.isdigit() and
                    len(text) > 1 and
                    not text.startswith('http')):
                    extracted.add(text)

        return extracted

    def add_tr_extension(self, content):
        """Add .tr extension to translatable strings"""
        modified = content
        changes_made = False

        # Check if GetX is already imported
        has_getx_import = 'package:get/get.dart' in content

        # Patterns to add .tr
        patterns = [
            # Text('string') -> Text('string'.tr)
            (r"Text\s*\(\s*(['\"])([^'\"]+)\1\s*\)", r"Text(\1\2\1.tr)"),
            # Text("string",) -> Text("string".tr,)
            (r"Text\s*\(\s*(['\"])([^'\"]+)\1\s*,", r"Text(\1\2\1.tr,"),
            # text: 'string' -> text: 'string'.tr
            (r"text:\s*(['\"])([^'\"]+)\1(?!\s*\.tr)", r"text: \1\2\1.tr"),
            # title: 'string' -> title: 'string'.tr
            (r"title:\s*(['\"])([^'\"]+)\1(?!\s*\.tr)", r"title: \1\2\1.tr"),
            # label: 'string' -> label: 'string'.tr
            (r"label:\s*(['\"])([^'\"]+)\1(?!\s*\.tr)", r"label: \1\2\1.tr"),
            # hintText: 'string' -> hintText: 'string'.tr
            (r"hintText:\s*(['\"])([^'\"]+)\1(?!\s*\.tr)", r"hintText: \1\2\1.tr"),
            # labelText: 'string' -> labelText: 'string'.tr
            (r"labelText:\s*(['\"])([^'\"]+)\1(?!\s*\.tr)", r"labelText: \1\2\1.tr"),
            # helperText: 'string' -> helperText: 'string'.tr
            (r"helperText:\s*(['\"])([^'\"]+)\1(?!\s*\.tr)", r"helperText: \1\2\1.tr"),
            # errorText: 'string' -> errorText: 'string'.tr
            (r"errorText:\s*(['\"])([^'\"]+)\1(?!\s*\.tr)", r"errorText: \1\2\1.tr"),
        ]

        for pattern, replacement in patterns:
            before = modified
            modified = re.sub(pattern, replacement, modified)
            if modified != before:
                changes_made = True

        # Add GetX import if changes were made and import doesn't exist
        if changes_made and not has_getx_import:
            # Find the position after the last import
            import_pattern = r"import\s+['\"].*['\"];?\n"
            imports = list(re.finditer(import_pattern, modified))
            if imports:
                last_import = imports[-1]
                insert_pos = last_import.end()
                modified = (modified[:insert_pos] +
                          "import 'package:get/get.dart';\n" +
                          modified[insert_pos:])
            else:
                # No imports found, add at the beginning
                modified = "import 'package:get/get.dart';\n\n" + modified

        return modified, changes_made

    def process_file(self, file_path, dry_run=True):
        """Process a single Dart file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()

            # Extract strings
            strings = self.extract_strings(content)
            self.translations.update(strings)

            # Add .tr extension
            modified_content, changes_made = self.add_tr_extension(content)

            if changes_made:
                self.files_modified.append(file_path)
                if not dry_run:
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(modified_content)

            self.files_processed.append(file_path)
            return True, changes_made

        except Exception as e:
            print(f"❌ Error processing {file_path}: {str(e)}")
            return False, False

    def scan_directory(self, dry_run=True):
        """Scan all Dart files in lib directory"""
        skip_dirs = {'.dart_tool', 'build', 'ios', 'android', 'windows',
                     'linux', 'macos', 'web', '.idea', '.git'}

        dart_files = []
        for root, dirs, files in os.walk(self.lib_path):
            # Remove skip directories
            dirs[:] = [d for d in dirs if d not in skip_dirs and not d.startswith('.')]

            for file in files:
                if file.endswith('.dart'):
                    file_path = Path(root) / file
                    if not self.should_skip_file(file_path):
                        dart_files.append(file_path)

        print(f"📝 Found {len(dart_files)} Dart files to process\n")

        for i, file_path in enumerate(dart_files, 1):
            relative_path = file_path.relative_to(self.project_path)
            print(f"[{i}/{len(dart_files)}] Processing: {relative_path}")
            self.process_file(file_path, dry_run)

        return len(dart_files)

    def generate_translation_file(self, output_path='translations_extracted.json'):
        """Generate JSON file with extracted translations"""
        output_file = self.project_path / output_path

        # Create translation dictionary
        translation_dict = {text: text for text in sorted(self.translations)}

        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(translation_dict, f, indent=2, ensure_ascii=False)

        print(f"\n📄 Translation file generated: {output_file}")
        print(f"   Total translations: {len(self.translations)}")

    def generate_report(self):
        """Generate conversion report"""
        print("\n" + "="*60)
        print("📊 CONVERSION REPORT")
        print("="*60)
        print(f"Files processed: {len(self.files_processed)}")
        print(f"Files modified: {len(self.files_modified)}")
        print(f"Translations extracted: {len(self.translations)}")
        print(f"Backup location: {self.backup_path}")
        print("="*60)

        if self.files_modified:
            print("\n📝 Modified files:")
            for file_path in self.files_modified[:10]:  # Show first 10
                relative_path = file_path.relative_to(self.project_path)
                print(f"   - {relative_path}")
            if len(self.files_modified) > 10:
                print(f"   ... and {len(self.files_modified) - 10} more")

def main():
    print("="*60)
    print("🌍 Flutter Localization Converter")
    print("="*60)
    print()

    # Get project path
    project_path = input("Enter your Flutter project path (or press Enter for current directory): ").strip()
    if not project_path:
        project_path = os.getcwd()
        # Try to find the root Flutter project
        while not os.path.exists(os.path.join(project_path, 'pubspec.yaml')):
            parent = os.path.dirname(project_path)
            if parent == project_path:
                print("❌ Could not find Flutter project root (pubspec.yaml)")
                return
            project_path = parent

    if not os.path.exists(os.path.join(project_path, 'pubspec.yaml')):
        print("❌ Not a valid Flutter project (pubspec.yaml not found)")
        return

    print(f"\n📁 Project path: {project_path}")

    # Initialize converter
    converter = LocalizationConverter(project_path)

    # Create backup
    response = input("\n⚠️  Create backup before processing? (yes/no): ").strip().lower()
    if response == 'yes':
        converter.create_backup()

    # Dry run first
    print("\n" + "="*60)
    print("🔍 DRY RUN - Analyzing files...")
    print("="*60)
    converter.scan_directory(dry_run=True)
    converter.generate_report()

    # Generate translations
    converter.generate_translation_file()

    # Ask to apply changes
    print("\n" + "="*60)
    response = input("\n✅ Apply changes to files? (yes/no): ").strip().lower()

    if response == 'yes':
        print("\n🔄 Applying changes...")
        # Reset and run again without dry_run
        converter.files_processed = []
        converter.files_modified = []
        converter.scan_directory(dry_run=False)
        print("\n✅ All changes applied successfully!")
        converter.generate_report()
    else:
        print("\n❌ No changes made. Run the script again when ready.")

    print("\n" + "="*60)
    print("🎉 Done!")
    print("="*60)

if __name__ == "__main__":
    main()