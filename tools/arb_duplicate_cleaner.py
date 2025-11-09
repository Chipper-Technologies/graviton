#!/usr/bin/env python3
"""
ARB Duplicate Cleaner for Graviton

This tool intelligently removes duplicate values from the ARB file by:
1. Analyzing usage patterns
2. Keeping the most appropriate key for each value
3. Generating a list of keys that should be updated in the codebase
"""

import json
import re
from pathlib import Path
from typing import Dict, List, Tuple, Set


class ARBDuplicateCleaner:
    """Cleans up duplicate values in ARB files."""
    
    def __init__(self, arb_path: Path):
        self.arb_path = arb_path
        self.data = {}
        self.load_arb()
        
    def load_arb(self):
        """Load the ARB file."""
        with open(self.arb_path, 'r', encoding='utf-8') as f:
            self.data = json.load(f)
    
    def find_duplicate_values(self) -> Dict[str, List[str]]:
        """Find keys that have identical values."""
        from collections import defaultdict
        value_to_keys = defaultdict(list)
        
        for key, value in self.data.items():
            if key.startswith('@') or key == '@@locale':
                continue
            if isinstance(value, str):
                normalized_value = ' '.join(value.split())
                value_to_keys[normalized_value].append(key)
        
        return {value: keys for value, keys in value_to_keys.items() if len(keys) > 1}
    
    def analyze_key_quality(self, key: str) -> int:
        """Score a key's quality/appropriateness (higher = better)."""
        score = 0
        
        # Prefer shorter, cleaner keys
        score += max(0, 50 - len(key))
        
        # Prefer keys without suffixes like "Customscenario", "Hometitle"
        bad_patterns = [
            r'[a-z][A-Z].*[a-z][A-Z]',  # Multiple camelCase transitions
            r'[a-z]title$',  # Weird title suffixes
            r'customscenario$',  # Specific bad patterns
            r'hometooltip$',
            r'debugtitle$',
            r'editortitle$',
            r'editor[a-z]+$',  # Bad editor patterns
            r'label$',  # Generic label suffix
        ]
        
        for pattern in bad_patterns:
            if re.search(pattern, key, re.IGNORECASE):
                score -= 20
        
        # Prefer generic/reusable keys
        good_patterns = [
            r'^(play|pause|reset|close|cancel|delete|save)Button$',
            r'^[a-z]+Label$',
            r'^[a-z]+Title$',
            r'^[a-z]+Tooltip$',
        ]
        
        for pattern in good_patterns:
            if re.search(pattern, key):
                score += 10
        
        # Penalty for overly specific keys
        if 'Editor' in key and 'title' in key.lower():
            score -= 15
        if 'Home' in key and 'tooltip' in key.lower():
            score -= 10
        
        return score
    
    def select_best_key(self, keys: List[str], value: str) -> Tuple[str, List[str]]:
        """Select the best key to keep and return others to remove."""
        if len(keys) <= 1:
            return keys[0] if keys else "", []
        
        # Score all keys
        scored_keys = [(key, self.analyze_key_quality(key)) for key in keys]
        scored_keys.sort(key=lambda x: x[1], reverse=True)
        
        # Special cases for specific values
        if value == "Graviton":
            # Keep appTitle over appNameGraviton
            if "appTitle" in keys:
                return "appTitle", [k for k in keys if k != "appTitle"]
        
        if value in ["Reset", "Speed", "Trails", "Camera", "Physics", "Bodies"]:
            # Prefer simple labels over complex ones
            simple_keys = [k for k in keys if k.endswith('Label') and not any(x in k for x in ['Stats', 'Nav', 'Editor'])]
            if simple_keys:
                return simple_keys[0], [k for k in keys if k != simple_keys[0]]
        
        if "Button" in value or value in ["Close", "Cancel", "Delete"]:
            # Prefer generic button keys
            button_keys = [k for k in keys if k.endswith('Button') and 'Custom' not in k and 'Tutorial' not in k]
            if button_keys:
                return button_keys[0], [k for k in keys if k != button_keys[0]]
        
        # For accessibility strings, prefer the cleaner key
        if any("accessibility" in k.lower() for k in keys):
            accessibility_keys = [k for k in keys if "accessibility" in k.lower()]
            other_keys = [k for k in keys if "accessibility" not in k.lower()]
            if accessibility_keys and other_keys:
                # Keep the accessibility one
                return accessibility_keys[0], other_keys
        
        # Default: use scoring
        best_key = scored_keys[0][0]
        others = [k for k in keys if k != best_key]
        
        return best_key, others
    
    def generate_cleanup_plan(self) -> Tuple[Dict[str, str], List[str], Dict[str, List[str]]]:
        """Generate a plan for cleaning up duplicates."""
        duplicates = self.find_duplicate_values()
        
        # Map: old_key -> new_key
        key_replacements = {}
        
        # Keys to remove from ARB
        keys_to_remove = []
        
        # Summary of changes
        changes = {}
        
        for value, keys in duplicates.items():
            best_key, remove_keys = self.select_best_key(keys, value)
            
            if remove_keys:
                changes[value] = {
                    'keep': best_key,
                    'remove': remove_keys
                }
                
                for remove_key in remove_keys:
                    key_replacements[remove_key] = best_key
                    keys_to_remove.append(remove_key)
                    # Also remove the metadata key
                    keys_to_remove.append(f"@{remove_key}")
        
        return key_replacements, keys_to_remove, changes
    
    def apply_cleanup(self, dry_run: bool = True) -> str:
        """Apply the cleanup plan."""
        key_replacements, keys_to_remove, changes = self.generate_cleanup_plan()
        
        report = ["ARB Cleanup Plan", "=" * 40, ""]
        
        if not changes:
            report.append("✅ No duplicates to clean up!")
            return "\n".join(report)
        
        report.append(f"📊 Found {len(changes)} sets of duplicates to clean")
        report.append(f"🗑️  Will remove {len(keys_to_remove)} keys")
        report.append("")
        
        for value, change_info in changes.items():
            report.append(f"'{value}':")
            report.append(f"  ✅ Keep: {change_info['keep']}")
            for remove_key in change_info['remove']:
                report.append(f"  ❌ Remove: {remove_key}")
            report.append("")
        
        if not dry_run:
            # Create cleaned data
            cleaned_data = {k: v for k, v in self.data.items() if k not in keys_to_remove}
            
            # Save cleaned file
            with open(self.arb_path, 'w', encoding='utf-8') as f:
                json.dump(cleaned_data, f, indent=2, ensure_ascii=False)
            
            report.append("✅ Cleanup applied to ARB file!")
        else:
            report.append("ℹ️  This is a dry run. Use apply_cleanup(dry_run=False) to actually modify the file.")
        
        report.append("")
        report.append("🔄 Code changes needed:")
        report.append("The following keys need to be updated in your Dart files:")
        report.append("")
        
        for old_key, new_key in key_replacements.items():
            report.append(f"  l10n.{old_key} → l10n.{new_key}")
        
        return "\n".join(report)


def main():
    """Main function."""
    project_root = Path.cwd()
    arb_path = project_root / "lib" / "l10n" / "app_en.arb"
    
    if not arb_path.exists():
        print(f"Error: ARB file not found at {arb_path}")
        return
    
    cleaner = ARBDuplicateCleaner(arb_path)
    
    print("🔍 Analyzing duplicates...")
    report = cleaner.apply_cleanup(dry_run=True)
    print(report)
    
    while True:
        response = input("\\n🧹 Apply cleanup? (y/n): ").lower().strip()
        if response in ['y', 'yes']:
            # Create another backup before cleanup
            backup_path = arb_path.with_suffix('.arb.pre_cleanup_backup')
            print(f"💾 Creating backup at {backup_path}")
            
            with open(arb_path, 'r') as src, open(backup_path, 'w') as dst:
                dst.write(src.read())
            
            print("🧹 Applying cleanup...")
            cleaner.apply_cleanup(dry_run=False)
            print("✅ Cleanup completed!")
            break
        elif response in ['n', 'no']:
            print("ℹ️  No changes applied.")
            break
        else:
            print("Please enter 'y' or 'n'")


if __name__ == "__main__":
    main()