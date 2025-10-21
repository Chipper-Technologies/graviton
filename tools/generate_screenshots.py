#!/usr/bin/env python3
"""
Screenshot Generator for Graviton App

This script processes raw screenshots from Android and iOS devices to generate:
1. Low-resolution images suitable for README display
2. Platform-specific feature images for app stores
3. Organized folder structure for different use cases

Requirements:
- Pillow (PIL): pip install Pillow

Usage:
    # Default: Generate highest resolution feature images + README images
    python3 tools/generate_screenshots.py
    
    # Generate all available sizes for both platforms
    python3 tools/generate_screenshots.py --all-sizes
    
    # Custom Android sizes only
    python3 tools/generate_screenshots.py --android-sizes 2560x1440 1920x1080
    
    # Custom iOS sizes only  
    python3 tools/generate_screenshots.py --ios-sizes 2778x1284 2688x1242
    
    # Generate only README images
    python3 tools/generate_screenshots.py --readme-only
    
    # Generate only feature images with custom width
    python3 tools/generate_screenshots.py --feature-only --max-width 400
"""

import os
import sys
from pathlib import Path
from PIL import Image, ImageEnhance, ImageFilter
import argparse
import json
from typing import Dict, List, Tuple, Optional

class ScreenshotProcessor:
    """Handles processing of screenshots for different platforms and use cases."""
    
    def __init__(self, project_root: Path, android_sizes: Optional[List[Tuple[int, int]]] = None, 
                 ios_sizes: Optional[List[Tuple[int, int]]] = None):
        self.project_root = project_root
        self.assets_path = project_root / "assets" / "screenshots"
        self.output_path = project_root / "assets" / "screenshots"
        
        # README display settings
        self.readme_max_width = 300
        self.readme_quality = 85
        
        # All available feature image dimensions
        self.all_android_sizes = [
            (1920, 1080),  # 16:9 landscape
            (1080, 1920),  # 9:16 portrait
            (2560, 1440),  # QHD 16:9
            (1440, 2560),  # QHD 9:16
        ]
        
        self.all_ios_sizes = [
            (1242, 2688),  # iPhone 11 Pro Max, 12 Pro Max portrait
            (2688, 1242),  # iPhone 11 Pro Max, 12 Pro Max landscape
            (1284, 2778),  # iPhone 12 Pro, 13 Pro portrait
            (2778, 1284),  # iPhone 12 Pro, 13 Pro landscape
        ]
        
        # Use provided sizes or Apple/Google required dimensions
        self.android_feature_sizes = android_sizes or [(1080, 2400)]  # Android original size is fine
        self.ios_feature_sizes = ios_sizes or [(1284, 2778)]  # Apple required iPhone size
        
        # Quality settings
        self.feature_quality = 95
        self.readme_quality = 85

    def setup_directories(self):
        """Create necessary output directories."""
        directories = [
            self.output_path / "android" / "readme",
            self.output_path / "android" / "feature",
            self.output_path / "ios" / "readme",
            self.output_path / "ios" / "feature",
        ]
        
        for directory in directories:
            directory.mkdir(parents=True, exist_ok=True)
            print(f"📁 Created directory: {directory}")

    def get_raw_screenshots(self, platform: str) -> List[Path]:
        """Get list of raw screenshot files for a platform."""
        platform_path = self.assets_path / platform
        if not platform_path.exists():
            print(f"❌ Platform directory not found: {platform_path}")
            return []
        
        # Get all PNG files, sorted naturally
        screenshots = sorted([
            f for f in platform_path.glob("*.png") 
            if not f.name.startswith(".")
        ])
        
        print(f"📱 Found {len(screenshots)} {platform} screenshots")
        return screenshots

    def calculate_resize_dimensions(self, original_size: Tuple[int, int], target_width: int) -> Tuple[int, int]:
        """Calculate new dimensions maintaining aspect ratio."""
        orig_width, orig_height = original_size
        if orig_width <= target_width:
            return original_size
        
        ratio = target_width / orig_width
        new_height = int(orig_height * ratio)
        return (target_width, new_height)

    def enhance_image_for_readme(self, image: Image.Image) -> Image.Image:
        """Apply subtle enhancements for README display."""
        # Slight sharpening for better clarity at small sizes
        enhanced = image.filter(ImageFilter.UnsharpMask(radius=0.5, percent=120, threshold=3))
        
        # Slight contrast boost for better visibility
        enhancer = ImageEnhance.Contrast(enhanced)
        enhanced = enhancer.enhance(1.1)
        
        return enhanced

    def create_feature_image(self, source_image: Image.Image, target_size: Tuple[int, int], 
                           background_color: Tuple[int, int, int] = (26, 26, 46)) -> Image.Image:
        """Create a feature image with exact target dimensions for app store requirements."""
        source_width, source_height = source_image.size
        target_width, target_height = target_size
        
        # For Android, if source is already the right size, keep it
        if (source_width, source_height) == (target_width, target_height):
            return source_image
            
        # For iOS or other cases, resize to exact target dimensions while maintaining aspect ratio
        # Calculate scale to fit within target while maintaining proportions
        scale_width = target_width / source_width
        scale_height = target_height / source_height
        scale = min(scale_width, scale_height)  # Fit within bounds
        
        # Calculate new dimensions
        new_width = int(source_width * scale)
        new_height = int(source_height * scale)
        
        # Resize the image
        resized_image = source_image.resize((new_width, new_height), Image.Resampling.LANCZOS)
        
        # If resized image doesn't exactly match target, center it on black background
        if (new_width, new_height) != (target_width, target_height):
            final_image = Image.new('RGB', (target_width, target_height), (0, 0, 0))
            x_offset = (target_width - new_width) // 2
            y_offset = (target_height - new_height) // 2
            final_image.paste(resized_image, (x_offset, y_offset))
            return final_image
        else:
            return resized_image

    def process_readme_images(self):
        """Generate low-resolution images for README."""
        print("\n🔄 Processing README images...")
        
        for platform in ["android", "ios"]:
            screenshots = self.get_raw_screenshots(platform)
            if not screenshots:
                continue
                
            platform_readme_path = self.output_path / platform / "readme"
            platform_readme_path.mkdir(exist_ok=True)
            
            for screenshot_path in screenshots:
                try:
                    with Image.open(screenshot_path) as img:
                        # Calculate new dimensions
                        new_size = self.calculate_resize_dimensions(img.size, self.readme_max_width)
                        
                        # Resize and enhance
                        resized = img.resize(new_size, Image.Resampling.LANCZOS)
                        enhanced = self.enhance_image_for_readme(resized)
                        
                        # Save with optimized settings
                        output_path = platform_readme_path / screenshot_path.name
                        enhanced.save(
                            output_path, 
                            "PNG", 
                            optimize=True,
                            quality=self.readme_quality
                        )
                        
                        orig_size = f"{img.size[0]}×{img.size[1]}"
                        new_size_str = f"{new_size[0]}×{new_size[1]}"
                        print(f"  ✅ {screenshot_path.name}: {orig_size} → {new_size_str}")
                        
                except Exception as e:
                    print(f"  ❌ Failed to process {screenshot_path.name}: {e}")

    def process_feature_images(self):
        """Generate feature images for app stores."""
        print("\n🔄 Processing feature images...")
        
        # Process Android feature images
        android_screenshots = self.get_raw_screenshots("android")
        if android_screenshots:
            print(f"\n📱 Processing Android feature images...")
            android_feature_path = self.output_path / "android" / "feature"
            
            # Create feature images for all screenshots in all required sizes
            for screenshot_path in android_screenshots:
                screenshot_name = screenshot_path.stem  # e.g., "android-1"
                
                for size in self.android_feature_sizes:
                    try:
                        with Image.open(screenshot_path) as img:
                            feature_img = self.create_feature_image(img, size)
                            
                            output_name = f"{screenshot_name}_{size[0]}x{size[1]}.png"
                            output_path = android_feature_path / output_name
                            
                            feature_img.save(output_path, "PNG", quality=self.feature_quality)
                            print(f"  ✅ Android {size[0]}×{size[1]}: {output_name}")
                            
                    except Exception as e:
                        print(f"  ❌ Failed to create Android feature {size} for {screenshot_path.name}: {e}")
        
        # Process iOS feature images
        ios_screenshots = self.get_raw_screenshots("ios")
        if ios_screenshots:
            print(f"\n📱 Processing iOS feature images...")
            ios_feature_path = self.output_path / "ios" / "feature"
            
            # Create feature images for all screenshots in all required sizes
            for screenshot_path in ios_screenshots:
                screenshot_name = screenshot_path.stem  # e.g., "ios-1"
                
                for size in self.ios_feature_sizes:
                    try:
                        with Image.open(screenshot_path) as img:
                            feature_img = self.create_feature_image(img, size)
                            
                            output_name = f"{screenshot_name}_{size[0]}x{size[1]}.png"
                            output_path = ios_feature_path / output_name
                            
                            feature_img.save(output_path, "PNG", quality=self.feature_quality)
                            print(f"  ✅ iOS {size[0]}×{size[1]}: {output_name}")
                            
                    except Exception as e:
                        print(f"  ❌ Failed to create iOS feature {size} for {screenshot_path.name}: {e}")

    def print_summary(self):
        """Print processing summary."""
        print(f"\n📊 Processing Summary:")
        print(f"{'='*50}")
        
        # Count generated files
        readme_count = len(list((self.output_path / "readme").rglob("*.png")))
        android_feature_count = len(list((self.output_path / "feature" / "android").glob("*.png")))
        ios_feature_count = len(list((self.output_path / "feature" / "ios").glob("*.png")))
        
        print(f"📱 README images generated: {readme_count}")
        print(f"🤖 Android feature images: {android_feature_count}")
        print(f"🍎 iOS feature images: {ios_feature_count}")
        print(f"\n📁 Output structure:")
        print(f"  assets/screenshots/readme/     - Low-res for README")
        print(f"  assets/screenshots/feature/    - App store images")

def parse_size_argument(size_str: str) -> Tuple[int, int]:
    """Parse a size string like '2560x1440' into a tuple."""
    try:
        width, height = size_str.split('x')
        return (int(width), int(height))
    except ValueError:
        raise argparse.ArgumentTypeError(f"Size must be in format WIDTHxHEIGHT, got: {size_str}")

def main():
    """Main execution function."""
    parser = argparse.ArgumentParser(description="Generate screenshots for Graviton app")
    parser.add_argument("--readme-only", action="store_true", help="Generate only README images")
    parser.add_argument("--feature-only", action="store_true", help="Generate only feature images")
    parser.add_argument("--max-width", type=int, default=300, help="Max width for README images")
    
    # Feature image size configuration
    parser.add_argument("--android-sizes", nargs="+", type=parse_size_argument,
                       help="Android feature image sizes (e.g., 2560x1440 1920x1080). Defaults to highest resolution.")
    parser.add_argument("--ios-sizes", nargs="+", type=parse_size_argument,
                       help="iOS feature image sizes (e.g., 2778x1284 2688x1242). Defaults to highest resolution.")
    parser.add_argument("--all-sizes", action="store_true",
                       help="Generate all available sizes for both platforms")
    
    args = parser.parse_args()
    
    # Determine feature image sizes
    android_sizes = None
    ios_sizes = None
    
    if args.all_sizes:
        # Use all available sizes
        android_sizes = [(1920, 1080), (1080, 1920), (2560, 1440), (1440, 2560)]
        ios_sizes = [(1242, 2688), (2688, 1242), (1284, 2778), (2778, 1284)]
    else:
        # Use custom sizes if provided
        android_sizes = args.android_sizes
        ios_sizes = args.ios_sizes
    
    # Detect project root
    script_path = Path(__file__).parent
    project_root = script_path.parent
    
    print("🚀 Graviton Screenshot Processor")
    print(f"📂 Project root: {project_root}")
    
    # Check if Pillow is installed
    try:
        from PIL import Image
    except ImportError:
        print("❌ Pillow not installed. Run: pip install Pillow")
        sys.exit(1)
    
    # Initialize processor with custom sizes
    processor = ScreenshotProcessor(project_root, android_sizes, ios_sizes)
    
    # Print configuration
    print(f"📱 Android feature sizes: {processor.android_feature_sizes}")
    print(f"🍎 iOS feature sizes: {processor.ios_feature_sizes}")
    
    # Override max width if specified
    if args.max_width:
        processor.readme_max_width = args.max_width
    
    # Setup directories
    processor.setup_directories()
    
    # Process based on arguments
    if args.feature_only:
        processor.process_feature_images()
    elif args.readme_only:
        processor.process_readme_images()
    else:
        # Process everything
        processor.process_readme_images()
        processor.process_feature_images()
    
    # Print summary
    processor.print_summary()
    print(f"\n✅ Screenshot processing complete!")

if __name__ == "__main__":
    main()