#!/usr/bin/env python3
"""
i18n Management Tool for Graviton

This tool helps:
1. Detect hardcoded English strings in Dart files
2. Check for existing ARB keys to prevent duplicates  
3. Generate new i18n keys following conventions
4. Update translation files consistently
"""

import os
import re
import json
import argparse
from pathlib import Path
from typing import Dict, List, Set, Tuple, Optional


class I18nManager:
    """Manages internationalization for the Graviton app."""
    
    def __init__(self, project_root: Path):
        self.project_root = project_root
        self.l10n_dir = project_root / "lib" / "l10n"
        self.en_arb_path = self.l10n_dir / "app_en.arb"
        self.untranslated_path = project_root / "untranslated_messages.json"
        
        # Load existing ARB keys
        self.existing_keys = self._load_existing_keys()
        
        # Common patterns for hardcoded strings
        self.hardcoded_patterns = [
            # Text widgets - single line
            r'Text\s*\(\s*[\'"]([A-Z][^\'"\n]{2,})[\'"]',
            r'(?:const\s+)?Text\s*\(\s*[\'"]([A-Z][^\'"\n]{2,})[\'"]',
            
            # Text widgets - multi-line (Text on one line, string on another)
            r'Text\s*\(\s*\n\s*[\'"]([A-Z][^\'"\n]{2,})[\'"]',
            r'(?:const\s+)?Text\s*\(\s*\n\s*[\'"]([A-Z][^\'"\n]{2,})[\'"]',
            
            # Widget properties  
            r'tooltip\s*:\s*[\'"]([^\'"\n]+)[\'"]',
            r'hintText\s*:\s*[\'"]([^\'"\n]+)[\'"]',
            r'labelText\s*:\s*[\'"]([^\'"\n]+)[\'"]',
            r'title\s*:\s*[\'"]([^\'"\n]+)[\'"]',
            r'message\s*:\s*[\'"]([^\'"\n]+)[\'"]',
            
            # Nested patterns  
            r'title\s*:\s*Text\s*\(\s*[\'"]([^\'"\n]+)[\'"]',
            r'content\s*:\s*Text\s*\(\s*[\'"]([^\'"\n]+)[\'"]',
            r'child\s*:\s*(?:const\s+)?Text\s*\(\s*[\'"]([A-Z][^\'"\n]{2,})[\'"]',
            
            # Custom widgets with title parameter
            r'SectionTitle\s*\(\s*title\s*:\s*[\'"]([^\'"\n]+)[\'"]',
            
            # Common widget constructors
            r'AlertDialog\s*\([^)]*title\s*:\s*Text\s*\(\s*[\'"]([^\'"\n]+)[\'"]',
            r'AppBar\s*\([^)]*title\s*:\s*Text\s*\(\s*[\'"]([^\'"\n]+)[\'"]',
            r'SnackBar\s*\([^)]*content\s*:\s*Text\s*\(\s*[\'"]([^\'"\n]+)[\'"]',
            
            # Object constructor parameters
            r'name\s*:\s*[\'"]([A-Z][^\'"\n]{2,})[\'"]',
            r'description\s*:\s*[\'"]([A-Z][^\'"\n]{2,})[\'"]',
            r'educationalFocus\s*:\s*[\'"]([^\'"\n]+)[\'"]',
            r'difficulty\s*:\s*[\'"]([^\'"\n]+)[\'"]',
            r'author\s*:\s*[\'"]([A-Z][^\'"\n]{2,})[\'"]',
            r'category\s*:\s*[\'"]([^\'"\n]+)[\'"]',
            
            # Variable assignments and defaults
            r'=\s*[\'"]([A-Z][^\'"\n]{3,})[\'"]',
            r':\s*[\'"]([A-Z][^\'"\n]{3,})[\'"]',
            
            # List/Array elements
            r'\[\s*[\'"]([A-Z][^\'"\n]{2,})[\'"]',
            r',\s*[\'"]([A-Z][^\'"\n]{2,})[\'"]',
            
            # Common UI text patterns
            r'(?:final|const|var)\s+\w+\s*=\s*[\'"]([A-Z][^\'"\n]{3,})[\'"]',
            
            # Ternary operator patterns
            r'\?\s*[\'"]([A-Z][^\'"\n]{3,})[\'"]',
            r':\s*[\'"]([A-Z][^\'"\n]{3,})[\'"](?=\s*[,;)])',
            
            # Additional property patterns 
            r'difficulty\s*:\s*[\'"]([a-z]+)[\'"]',
            r'tags\s*:\s*\[[\'"]([^\'"\n]+)[\'"]',
            
            # Special cases for lowercase meaningful text
            r'difficulty\s*:\s*[\'"]([^\'"\n]+)[\'"]',
            r'level\s*:\s*[\'"]([^\'"\n]+)[\'"]',
            r'category\s*:\s*[\'"]([^\'"\n]+)[\'"]',
            
            # Method call parameters
            r'\(\s*[\'"]([A-Z][^\'"\n]{2,})[\'"]',
            r',\s*[\'"]([A-Z][^\'"\n]{2,})[\'"]',
        ]
    
    def _load_existing_keys(self) -> Set[str]:
        """Load existing ARB keys to prevent duplicates."""
        keys = set()
        if self.en_arb_path.exists():
            try:
                with open(self.en_arb_path, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    for key in data:
                        if not key.startswith('@') and key != '@@locale':
                            keys.add(key)
            except Exception as e:
                print(f"Warning: Could not load existing ARB keys: {e}")
        return keys
    
    def _generate_key_name(self, text: str, context: str = "") -> str:
        """Generate a consistent key name from English text."""
        # Remove common prefixes/suffixes
        text = text.strip()
        text = re.sub(r'^(The|A|An)\s+', '', text, flags=re.IGNORECASE)
        
        # Convert to camelCase
        # Split on spaces, punctuation, and case changes
        words = re.findall(r'[A-Z]*[a-z]+|[A-Z]+(?=[A-Z][a-z]|\b)|[0-9]+', text)
        
        if not words:
            return ""
            
        # First word lowercase, rest title case
        key = words[0].lower() + ''.join(word.capitalize() for word in words[1:])
        
        # Add context suffix if provided
        if context:
            context_suffix = ''.join(word.capitalize() for word in context.split('_'))
            key += context_suffix
        
        # Clean up
        key = re.sub(r'[^a-zA-Z0-9]', '', key)
        
        return key
    
    def _determine_context(self, file_path: Path, line_content: str) -> str:
        """Determine context based on file path and line content."""
        file_name = file_path.stem
        
        # Context mapping
        context_map = {
            'scenario_editor': 'Editor',
            'custom_scenarios': 'CustomScenario', 
            'home_screen': 'Home',
            'preset_scenarios': 'PresetScenario'
        }
        
        for pattern, context in context_map.items():
            if pattern in file_name:
                # Additional context from line content
                if 'tooltip' in line_content.lower():
                    return context + 'Tooltip'
                elif 'title' in line_content.lower():
                    return context + 'Title'
                elif 'hint' in line_content.lower():
                    return context + 'Hint'
                elif 'label' in line_content.lower():
                    return context + 'Label'
                elif 'button' in line_content.lower():
                    return context + 'Button'
                return context
        
        return ""
    
    def find_hardcoded_strings(self, file_path: Path) -> List[Tuple[int, str, str, str]]:
        """Find hardcoded strings in a Dart file."""
        results = []
        
        if not file_path.exists():
            return results
            
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                lines = content.splitlines()
        except Exception as e:
            print(f"Warning: Could not read {file_path}: {e}")
            return results
        
        # First, scan line by line for single-line patterns
        for line_num, line in enumerate(lines, 1):
            # Skip lines that already use l10n
            if 'l10n.' in line or 'AppLocalizations.of' in line:
                continue
                
            # Skip comments
            if line.strip().startswith('//'):
                continue
                
            # Skip debugPrint statements (developer debug messages)
            if 'debugPrint(' in line:
                continue
                
            # Skip Exception messages (internal error handling)
            if 'Exception(' in line or 'throw Exception(' in line:
                continue
                
            for pattern in self.hardcoded_patterns:
                matches = re.finditer(pattern, line)
                for match in matches:
                    text = match.group(1)
                    
                    # Filter out obvious non-translatable strings
                    if self._should_skip_text(text):
                        continue
                    
                    context = self._determine_context(file_path, line)
                    
                    # Generate a unique key 
                    key = self._generate_key_name(text, context)
                    
                    # Check if this key already exists
                    existing_key = self._check_existing_keys(text, key)
                    if existing_key:
                        status = f"exists: {existing_key}"
                    else:
                        status = "new"
                    
                    results.append((line_num, text, key, status))
        
        # Then, scan the entire file content for multi-line patterns
        # Focus on Text widgets that span multiple lines
        multiline_text_pattern = r'Text\s*\(\s*\n\s*[\'"]([A-Z][^\'"\n]{2,})[\'"]'
        matches = re.finditer(multiline_text_pattern, content, re.MULTILINE)
        for match in matches:
            text = match.group(1)
            
            # Filter out obvious non-translatable strings
            if self._should_skip_text(text):
                continue
                
            # Find which line this match is on
            start_pos = match.start()
            line_num = content[:start_pos].count('\n') + 1
            
            # Skip if already using l10n
            context_start = max(0, start_pos - 100)
            context_end = min(len(content), match.end() + 100)
            context_text = content[context_start:context_end]
            if 'l10n.' in context_text or 'AppLocalizations.of' in context_text:
                continue
                
            # Skip debugPrint statements (developer debug messages)
            if 'debugPrint(' in context_text:
                continue
                
            # Skip Exception messages (internal error handling)
            if 'Exception(' in context_text or 'throw Exception(' in context_text:
                continue
            
            context = self._determine_context(file_path, text)
            
            # Generate a unique key 
            key = self._generate_key_name(text, context)
            
            # Check if this key already exists
            existing_key = self._check_existing_keys(text, key)
            if existing_key:
                status = f"exists: {existing_key}"
            else:
                status = "new"
            
            # Only add if not already found in line-by-line scan
            if not any(result[1] == text and result[0] == line_num for result in results):
                results.append((line_num, text, key, status))
        
        return results
        
        return results
    
    def _should_skip_text(self, text: str) -> bool:
        """Determine if text should be skipped (not translatable)."""
        # Basic patterns that should definitely be skipped
        skip_patterns = [
            r'^[A-Z_]+$',  # All caps (likely constants like 'DEV')
            r'^\d+(\.\d+)?$',     # Numbers only
            r'^[a-z_]+$', # Likely variables/keys (lowercase only) - BUT EXCEPTIONS BELOW
            r'^\$',       # Template strings starting with $
            r'^https?://', # URLs
            r'^[^A-Za-z]', # Starts with non-letter
            r'^.{0,2}$',  # Too short (1-2 chars)
            r'^(true|false)$',  # Booleans
            r'^\w+\.\w+$', # Property access patterns
        ]
        
        # Allow certain meaningful lowercase words that should be translated
        meaningful_lowercase = ['beginner', 'intermediate', 'advanced', 'easy', 'medium', 'hard']
        if text.lower() in meaningful_lowercase:
            return False
        
        # Skip obvious non-user-facing text
        skip_keywords = ['import', 'export', 'extends', 'implements', 'class', 'enum', 'typedef']
        if any(keyword in text.lower() for keyword in skip_keywords):
            return True
        
        # Skip technical terms, IDs, and internal identifiers
        technical_terms = [
            'custom', 'dev', 'prod', 'debug', 'release', 'test', 'demo',
            # Names that are more like IDs
            'graviton', 'john doe', 'presets', 'earth',
            # Physics/technical terms that are universal
            'apoapsis', 'periapsis', 'central star', 'companion a', 'companion b',
            # Internal categories
            'center of mass',
            # Test/development strings
            'test preset', 'body index', 'color option',
            # Planet/celestial body names (universal)
            'sun', 'mercury', 'venus', 'moon', 'mars', 'jupiter', 'saturn', 'uranus', 'neptune', 'pluto',
            'alpha', 'beta', 'gamma', 'star a', 'star b', 'planet p', 'moon m',
            'supermassive black hole', 'asteroid', 'star', 'ring', 'fragment', 'planetoid',
            # Color names
            'blue', 'blue-white', 'white', 'yellow-white', 'yellow', 'orange', 'unknown',
            # Technical categories that are universal
            'inner', 'earth-like', 'super-earth',
            # Error/system messages (should not be user-facing in UI)
            'firebase', 'remote config', 'version service', 'maintenance', 'back',
        ]
        if text.lower() in technical_terms:
            return True
        
        # Skip strings that are clearly error messages or system logs
        error_patterns = [
            r'.*failed.*',
            r'.*error.*',
            r'.*initialization.*',
            r'.*loading.*',
            r'.*saving.*',
            r'.*skipping.*',
            r'.*not.*found.*',
            r'.*cannot.*',
            r'.*must.*',
            r'.*invalid.*',
            r'.*missing.*',
            r'.*requires.*',
            r'.*cleared.*',
            r'.*deleted.*',
            r'.*saved.*',
            r'.*loaded.*',
            r'.*launched.*',
            r'.*entering.*',
            r'.*exiting.*',
            r'.*applying.*',
        ]
        for pattern in error_patterns:
            if re.match(pattern, text, re.IGNORECASE):
                return True
            
        # Skip strings that look like identifiers or internal codes
        identifier_patterns = [
            r'^[A-Z][a-z]+\s+[A-Z][a-z]+$',  # "John Doe" pattern
            r'^\w+\s+\d+$',  # "Body 1", "Test 123" patterns
            r'^\w+\s+preset$',  # "Test preset" patterns
            r'color\s+option',  # Color option patterns
            r'body\s+\d+',  # Body numbering
        ]
        for pattern in identifier_patterns:
            if re.match(pattern, text, re.IGNORECASE):
                return True
        
        # Apply basic skip patterns
        for pattern in skip_patterns:
            if re.match(pattern, text):
                return True
                
        return False
    
    def _check_existing_keys(self, text: str, suggested_key: str) -> Optional[str]:
        """Check if a key already exists for this text or similar text."""
        # Direct key match
        if suggested_key in self.existing_keys:
            return suggested_key
            
        # Look for keys that might contain the same text
        text_lower = text.lower()
        
        # Check if any existing key seems to match this text semantically
        for existing_key in self.existing_keys:
            # Simple heuristic: if the text words appear in the key name
            text_words = re.findall(r'\w+', text_lower)
            key_lower = existing_key.lower()
            
            if len(text_words) >= 2:  # Only check for multi-word texts
                if all(word in key_lower for word in text_words):
                    return existing_key
        
        return None
    
    def scan_project(self, lib_only: bool = True) -> Dict[str, List[Tuple[int, str, str, str]]]:
        """Scan the entire project for hardcoded strings."""
        results = {}
        
        search_dir = self.project_root / "lib" if lib_only else self.project_root
        
        for dart_file in search_dir.rglob("*.dart"):
            # Skip generated files
            if any(skip in str(dart_file) for skip in ['.g.dart', 'generated', 'l10n']):
                continue
                
            hardcoded = self.find_hardcoded_strings(dart_file)
            if hardcoded:
                relative_path = dart_file.relative_to(self.project_root)
                results[str(relative_path)] = hardcoded
        
        return results
    
    def generate_arb_entries(self, text: str, key: str, description: str = "") -> Dict[str, str]:
        """Generate ARB entries for a new translation."""
        if not description:
            description = f"Text for {key}"
            
        return {
            key: text,
            f"@{key}": {
                "description": description
            }
        }
    
    def check_duplicate_keys(self, new_key: str) -> Optional[str]:
        """Check if a key already exists and return existing key if found."""
        if new_key in self.existing_keys:
            return new_key
        return None
    
    def suggest_replacement(self, text: str, suggested_key: str, context: str = "") -> str:
        """Suggest the Dart code replacement for hardcoded text."""
        # Check if key exists
        existing_key = self.check_duplicate_keys(suggested_key)
        final_key = existing_key if existing_key else suggested_key
        
        return f"l10n.{final_key}"


def main():
    """Main function to run the i18n management tool."""
    parser = argparse.ArgumentParser(description="Graviton i18n Management Tool")
    parser.add_argument("--scan", action="store_true", help="Scan for hardcoded strings")
    parser.add_argument("--file", type=str, help="Scan specific file")
    parser.add_argument("--generate-keys", action="store_true", help="Generate suggested keys")
    
    args = parser.parse_args()
    
    # Find project root
    current_dir = Path.cwd()
    project_root = current_dir
    
    # Look for pubspec.yaml to confirm Flutter project
    if not (project_root / "pubspec.yaml").exists():
        print("Error: Not in a Flutter project directory")
        return
    
    manager = I18nManager(project_root)
    
    if args.scan or not any([args.file, args.generate_keys]):
        print("🔍 Scanning for hardcoded strings...")
        results = manager.scan_project()
        
        if not results:
            print("✅ No hardcoded strings found!")
            return
        
        total_issues = sum(len(issues) for issues in results.values())
        print(f"📊 Found {total_issues} hardcoded strings in {len(results)} files:")
        print()
        
        for file_path, issues in results.items():
            print(f"📁 {file_path}:")
            for line_num, text, suggested_key, line_content in issues:
                existing = manager.check_duplicate_keys(suggested_key)
                status = f"(exists: {existing})" if existing else "(new)"
                print(f"  Line {line_num}: '{text}' → {suggested_key} {status}")
                if args.generate_keys:
                    replacement = manager.suggest_replacement(text, suggested_key)
                    print(f"    Replace with: {replacement}")
            print()
    
    if args.file:
        file_path = Path(args.file)
        if not file_path.exists():
            file_path = project_root / args.file
        
        if file_path.exists():
            issues = manager.find_hardcoded_strings(file_path)
            print(f"📁 {file_path}:")
            for line_num, text, suggested_key, line_content in issues:
                existing = manager.check_duplicate_keys(suggested_key)
                status = f"(exists: {existing})" if existing else "(new)" 
                print(f"  Line {line_num}: '{text}' → {suggested_key} {status}")
                if args.generate_keys:
                    replacement = manager.suggest_replacement(text, suggested_key)
                    print(f"    Replace with: {replacement}")
        else:
            print(f"Error: File {args.file} not found")


if __name__ == "__main__":
    main()