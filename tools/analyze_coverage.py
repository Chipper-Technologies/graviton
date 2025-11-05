#!/usr/bin/env python3
"""
Enhanced coverage analysis script for Flutter projects.
Excludes auto-generated files and provides better insights.
"""

import re
import sys
import os

def analyze_coverage(lcov_file_path='coverage/lcov.info'):
    """Analyze coverage data and exclude auto-generated files."""
    
    # Files/patterns to exclude from coverage analysis
    EXCLUDED_PATTERNS = [
        '/test/',           # Test files
        '/build/',          # Build artifacts
        '.g.dart',          # Generated files (json_annotation, etc.)
        '.freezed.dart',    # Freezed generated files
        '.gr.dart',         # Auto Route generated files
        'app_localizations_', # Auto-generated localization files
        '.arb.dart',        # ARB generated files
        'generated_plugin_registrant.dart',  # Flutter generated files
    ]
    
    try:
        with open(lcov_file_path, 'r') as f:
            lcov_data = f.read()
    except FileNotFoundError:
        print(f"Coverage file not found: {lcov_file_path}")
        print("Run 'flutter test --coverage' first to generate coverage data.")
        return
    except Exception as e:
        print(f"Error reading coverage file: {e}")
        return

    # Extract all files and their coverage
    blocks = lcov_data.split('SF:')
    files = []
    excluded_files = []
    
    for block in blocks[1:]:  # Skip first empty block
        lines = block.strip().split('\n')
        file_path = lines[0]
        
        # Skip if not a Dart file
        if not file_path.endswith('.dart'):
            continue
        
        # Check if file should be excluded
        should_exclude = any(pattern in file_path for pattern in EXCLUDED_PATTERNS)
        
        found = 0
        hit = 0
        
        for line in lines:
            if line.startswith('LF:'):
                found = int(line.split(':')[1])
            elif line.startswith('LH:'):
                hit = int(line.split(':')[1])
        
        if found > 0:
            percentage = (hit / found) * 100
            file_data = (file_path, percentage, hit, found)
            
            if should_exclude:
                excluded_files.append(file_data)
            else:
                files.append(file_data)
    
    # Sort by coverage percentage
    files.sort(key=lambda x: x[1])
    excluded_files.sort(key=lambda x: x[1])
    
    # Calculate overall statistics
    total_lines = sum(found for _, _, _, found in files)
    total_hit = sum(hit for _, _, hit, _ in files)
    overall_percentage = (total_hit / total_lines * 100) if total_lines > 0 else 0
    
    # Display results
    print("Flutter Coverage Analysis (Excluding Generated Files)")
    print("=" * 60)
    print(f"Overall Coverage: {overall_percentage:.1f}% ({total_hit}/{total_lines} lines)")
    print(f"Files Analyzed: {len(files)}")
    print(f"Files Excluded: {len(excluded_files)}")
    print()
    
    print("Lowest Coverage Files (Targets for Improvement):")
    print("=" * 60)
    for i, (file_path, percentage, hit, found) in enumerate(files[:15]):
        file_name = file_path.split('/')[-1]
        # Add color coding for coverage levels
        if percentage < 30:
            status = "🔴"  # Red - Low coverage
        elif percentage < 60:
            status = "🟡"  # Yellow - Medium coverage  
        elif percentage < 80:
            status = "🟢"  # Green - Good coverage
        else:
            status = "✅"  # Check - Excellent coverage
            
        print(f"{i+1:2d}. {status} {file_name:<35} {percentage:5.1f}% ({hit:3d}/{found:3d} lines)")
    
    print()
    print("Highest Coverage Files (Well Tested):")
    print("=" * 60)
    high_coverage_files = sorted(files, key=lambda x: x[1], reverse=True)
    for i, (file_path, percentage, hit, found) in enumerate(high_coverage_files[:10]):
        file_name = file_path.split('/')[-1]
        if percentage >= 80:
            status = "✅"
        elif percentage >= 60:
            status = "🟢"
        else:
            break  # Stop if coverage drops below 60%
            
        print(f"{i+1:2d}. {status} {file_name:<35} {percentage:5.1f}% ({hit:3d}/{found:3d} lines)")
    
    if excluded_files:
        print()
        print("Excluded Generated Files:")
        print("=" * 60)
        for i, (file_path, percentage, hit, found) in enumerate(excluded_files[:10]):
            file_name = file_path.split('/')[-1]
            print(f"{i+1:2d}. 🚫 {file_name:<35} {percentage:5.1f}% ({hit:3d}/{found:3d} lines)")
    
    # Provide improvement recommendations
    low_coverage_files = [f for f in files if f[1] < 50]
    if low_coverage_files:
        print()
        print("🎯 Improvement Recommendations:")
        print("=" * 60)
        print(f"• {len(low_coverage_files)} files have <50% coverage")
        print("• Focus on files with moderate size (50-200 lines) for best ROI")
        print("• Consider these priorities:")
        
        # Recommend files based on size and current coverage
        recommendations = []
        for file_path, percentage, hit, found in low_coverage_files:
            if 20 <= found <= 200 and percentage < 40:  # Good size, low coverage
                improvement_potential = (found - hit) * (100 - percentage) / 100
                recommendations.append((file_path, percentage, found, improvement_potential))
        
        recommendations.sort(key=lambda x: x[3], reverse=True)  # Sort by improvement potential
        
        for i, (file_path, percentage, found, potential) in enumerate(recommendations[:5]):
            file_name = file_path.split('/')[-1]
            print(f"  {i+1}. {file_name} - {percentage:.1f}% coverage, {found} lines, high impact potential")

if __name__ == "__main__":
    lcov_path = sys.argv[1] if len(sys.argv) > 1 else 'coverage/lcov.info'
    analyze_coverage(lcov_path)