#!/usr/bin/env python3
"""
ARB File Auditor for Graviton

This tool audits the app_en.arb file for:
1. Duplicate values (same text with different keys)
2. Duplicate keys (should not happen but worth checking)
3. Reorganizes the file into logical sections
4. Validates JSON structure
"""

import json
import re
from pathlib import Path
from collections import defaultdict, OrderedDict
from typing import Dict, List, Tuple, Set


class ARBAuditor:
    """Audits and reorganizes ARB localization files."""
    
    def __init__(self, arb_path: Path):
        self.arb_path = arb_path
        self.data = {}
        self.load_arb()
        
    def load_arb(self):
        """Load the ARB file."""
        try:
            with open(self.arb_path, 'r', encoding='utf-8') as f:
                self.data = json.load(f)
        except Exception as e:
            print(f"Error loading ARB file: {e}")
            raise
    
    def find_duplicate_values(self) -> Dict[str, List[str]]:
        """Find keys that have identical values."""
        value_to_keys = defaultdict(list)
        
        for key, value in self.data.items():
            # Skip metadata keys
            if key.startswith('@') or key == '@@locale':
                continue
                
            # Only check string values
            if isinstance(value, str):
                # Normalize whitespace for comparison
                normalized_value = ' '.join(value.split())
                value_to_keys[normalized_value].append(key)
        
        # Return only duplicates
        return {value: keys for value, keys in value_to_keys.items() if len(keys) > 1}
    
    def find_duplicate_keys(self) -> List[str]:
        """Find any duplicate keys (shouldn't happen in valid JSON)."""
        seen_keys = set()
        duplicates = []
        
        for key in self.data.keys():
            if key in seen_keys:
                duplicates.append(key)
            seen_keys.add(key)
        
        return duplicates
    
    def categorize_keys(self) -> Dict[str, List[str]]:
        """Categorize keys by functionality/screen."""
        categories = {
            'Core App': [],
            'Navigation': [],
            'Simulation Controls': [],
            'Camera Controls': [],
            'Visual Settings': [],
            'Physics Settings': [],
            'Preset Scenarios': [],
            'Scenario Editor': [],
            'Custom Scenarios': [],
            'Settings Screen': [],
            'Statistics': [],
            'Tutorial': [],
            'Onboarding': [],
            'Debug': [],
            'Errors & Messages': [],
            'Time & Date': [],
            'Units': [],
            'Common UI': [],
            'Accessibility': [],
            'Uncategorized': []
        }
        
        # Define patterns for categorization
        patterns = {
            'Core App': [r'^app[A-Z]', r'^graviton'],
            'Navigation': [
                r'bottomNav', r'drawer', r'menu', r'tab[A-Z]', r'navigate',
                r'back[A-Z]', r'home[A-Z]', r'screen[A-Z]'
            ],
            'Simulation Controls': [
                r'play[A-Z]', r'pause[A-Z]', r'reset[A-Z]', r'speed[A-Z]',
                r'simulation[A-Z]', r'trails[A-Z]', r'^run[A-Z]', r'stop[A-Z]'
            ],
            'Camera Controls': [
                r'camera[A-Z]', r'zoom[A-Z]', r'rotate[A-Z]', r'view[A-Z]',
                r'perspective[A-Z]', r'angle[A-Z]', r'distance[A-Z]'
            ],
            'Visual Settings': [
                r'visuals[A-Z]', r'display[A-Z]', r'theme[A-Z]', r'color[A-Z]',
                r'brightness[A-Z]', r'contrast[A-Z]', r'opacity[A-Z]'
            ],
            'Physics Settings': [
                r'physics[A-Z]', r'gravity[A-Z]', r'mass[A-Z]', r'force[A-Z]',
                r'velocity[A-Z]', r'acceleration[A-Z]', r'collision[A-Z]',
                r'temperature[A-Z]', r'density[A-Z]'
            ],
            'Preset Scenarios': [
                r'preset[A-Z]', r'scenario[A-Z].*[Pp]reset', r'solarSystem[A-Z]',
                r'binaryStars[A-Z]', r'threeBody[A-Z]', r'galaxy[A-Z]'
            ],
            'Scenario Editor': [
                r'editor[A-Z]', r'.*Editor$', r'edit[A-Z]', r'create[A-Z]',
                r'add[A-Z]', r'remove[A-Z]', r'delete[A-Z]', r'modify[A-Z]'
            ],
            'Custom Scenarios': [
                r'custom[A-Z]', r'scenario[A-Z].*[Cc]ustom', r'save[A-Z]',
                r'load[A-Z]', r'import[A-Z]', r'export[A-Z]'
            ],
            'Settings Screen': [
                r'settings[A-Z]', r'preferences[A-Z]', r'options[A-Z]',
                r'config[A-Z]', r'toggle[A-Z]'
            ],
            'Statistics': [
                r'stats[A-Z]', r'statistics[A-Z]', r'data[A-Z]', r'info[A-Z]',
                r'metrics[A-Z]', r'analysis[A-Z]'
            ],
            'Tutorial': [
                r'tutorial[A-Z]', r'guide[A-Z]', r'help[A-Z]', r'instruction[A-Z]',
                r'tip[A-Z]', r'hint[A-Z]', r'learn[A-Z]'
            ],
            'Onboarding': [
                r'welcome[A-Z]', r'intro[A-Z]', r'onboard[A-Z]', r'first[A-Z]',
                r'getting[A-Z]', r'start[A-Z]'
            ],
            'Debug': [
                r'debug[A-Z]', r'test[A-Z]', r'dev[A-Z]', r'log[A-Z]',
                r'console[A-Z]'
            ],
            'Errors & Messages': [
                r'error[A-Z]', r'warning[A-Z]', r'alert[A-Z]', r'message[A-Z]',
                r'notification[A-Z]', r'toast[A-Z]', r'snackbar[A-Z]'
            ],
            'Time & Date': [
                r'time[A-Z]', r'date[A-Z]', r'year[A-Z]', r'month[A-Z]',
                r'day[A-Z]', r'hour[A-Z]', r'minute[A-Z]', r'second[A-Z]'
            ],
            'Units': [
                r'unit[A-Z]', r'meter[A-Z]', r'kilometer[A-Z]', r'kilogram[A-Z]',
                r'celsius[A-Z]', r'kelvin[A-Z]', r'degree[A-Z]'
            ],
            'Common UI': [
                r'^ok$', r'^cancel$', r'^yes$', r'^no$', r'^close$', r'^open$',
                r'^done$', r'^finish$', r'^next$', r'^previous$', r'^skip$',
                r'button[A-Z]', r'label[A-Z]', r'title[A-Z]', r'subtitle[A-Z]',
                r'description[A-Z]', r'text[A-Z]', r'placeholder[A-Z]'
            ],
            'Accessibility': [
                r'accessibility[A-Z]', r'semantics[A-Z]', r'screen[Rr]eader[A-Z]',
                r'voice[A-Z]', r'announce[A-Z]'
            ]
        }
        
        # Categorize each key
        for key in self.data.keys():
            if key.startswith('@') or key == '@@locale':
                continue
                
            categorized = False
            for category, category_patterns in patterns.items():
                for pattern in category_patterns:
                    if re.search(pattern, key):
                        categories[category].append(key)
                        categorized = True
                        break
                if categorized:
                    break
            
            if not categorized:
                categories['Uncategorized'].append(key)
        
        # Sort keys within each category
        for category in categories:
            categories[category].sort()
        
        return categories
    
    def reorganize_arb(self) -> Dict:
        """Reorganize the ARB file by categories."""
        categorized = self.categorize_keys()
        organized_data = OrderedDict()
        
        # Start with locale
        organized_data['@@locale'] = self.data['@@locale']
        
        # Add categories in logical order
        category_order = [
            'Core App',
            'Navigation', 
            'Simulation Controls',
            'Camera Controls',
            'Visual Settings',
            'Physics Settings',
            'Preset Scenarios',
            'Scenario Editor',
            'Custom Scenarios',
            'Settings Screen',
            'Statistics',
            'Tutorial',
            'Onboarding',
            'Common UI',
            'Time & Date',
            'Units',
            'Errors & Messages',
            'Accessibility',
            'Debug',
            'Uncategorized'
        ]
        
        for category in category_order:
            keys = categorized.get(category, [])
            if not keys:
                continue
                
            # Add section comment (as a key-value pair that will be removed later)
            comment_key = f"_SECTION_COMMENT_{category.upper().replace(' ', '_')}"
            organized_data[comment_key] = f"// {category} Section"
            
            # Add keys and their metadata
            for key in keys:
                organized_data[key] = self.data[key]
                metadata_key = f"@{key}"
                if metadata_key in self.data:
                    organized_data[metadata_key] = self.data[metadata_key]
        
        return organized_data
    
    def save_reorganized_arb(self, output_path: Path = None):
        """Save the reorganized ARB file."""
        if output_path is None:
            output_path = self.arb_path
            
        organized_data = self.reorganize_arb()
        
        # Remove the comment placeholders and create clean JSON
        clean_data = {k: v for k, v in organized_data.items() if not k.startswith('_SECTION_COMMENT_')}
        
        # Write clean JSON
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(clean_data, f, indent=2, ensure_ascii=False)
    
    def generate_report(self) -> str:
        """Generate a comprehensive audit report."""
        duplicate_values = self.find_duplicate_values()
        duplicate_keys = self.find_duplicate_keys()
        categorized = self.categorize_keys()
        
        report = ["ARB File Audit Report", "=" * 50, ""]
        
        # File info
        total_keys = len([k for k in self.data.keys() if not k.startswith('@') and k != '@@locale'])
        report.append(f"Total translation keys: {total_keys}")
        report.append(f"Total entries (including metadata): {len(self.data)}")
        report.append("")
        
        # Duplicate keys
        if duplicate_keys:
            report.append("⚠️  DUPLICATE KEYS FOUND:")
            for key in duplicate_keys:
                report.append(f"  - {key}")
            report.append("")
        else:
            report.append("✅ No duplicate keys found")
            report.append("")
        
        # Duplicate values
        if duplicate_values:
            report.append("⚠️  DUPLICATE VALUES FOUND:")
            for value, keys in duplicate_values.items():
                report.append(f"  '{value}' appears in keys:")
                for key in keys:
                    report.append(f"    - {key}")
                report.append("")
        else:
            report.append("✅ No duplicate values found")
            report.append("")
        
        # Category breakdown
        report.append("📊 CATEGORIZATION BREAKDOWN:")
        for category, keys in categorized.items():
            if keys:
                report.append(f"  {category}: {len(keys)} keys")
        
        report.append("")
        
        # Uncategorized keys
        uncategorized = categorized.get('Uncategorized', [])
        if uncategorized:
            report.append("❓ UNCATEGORIZED KEYS:")
            for key in uncategorized[:20]:  # Show first 20
                report.append(f"  - {key}")
            if len(uncategorized) > 20:
                report.append(f"  ... and {len(uncategorized) - 20} more")
            report.append("")
        
        return "\n".join(report)


def main():
    """Main function."""
    project_root = Path.cwd()
    arb_path = project_root / "lib" / "l10n" / "app_en.arb"
    
    if not arb_path.exists():
        print(f"Error: ARB file not found at {arb_path}")
        return
    
    print("🔍 Auditing ARB file...")
    auditor = ARBAuditor(arb_path)
    
    # Generate and display report
    report = auditor.generate_report()
    print(report)
    
    # Ask for reorganization
    while True:
        response = input("\n📋 Would you like to reorganize the ARB file? (y/n): ").lower().strip()
        if response in ['y', 'yes']:
            backup_path = arb_path.with_suffix('.arb.backup')
            print(f"💾 Creating backup at {backup_path}")
            
            # Create backup
            with open(arb_path, 'r') as src, open(backup_path, 'w') as dst:
                dst.write(src.read())
            
            print("🔄 Reorganizing ARB file...")
            auditor.save_reorganized_arb()
            print("✅ ARB file reorganized successfully!")
            break
        elif response in ['n', 'no']:
            print("ℹ️  ARB file left unchanged.")
            break
        else:
            print("Please enter 'y' or 'n'")


if __name__ == "__main__":
    main()