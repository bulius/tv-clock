# 🌅 App Icon Export Guide

Your Morning Routine app now has **three ways** to export the beautiful sunrise icon at all required tvOS sizes!

## 📋 Required Icon Sizes for tvOS

| Size | Resolution | Usage |
|------|------------|-------|
| App Icon Small (1x) | 400×240 | Home screen small icon |
| App Icon Small (2x) | 800×480 | Home screen small icon @2x |
| App Icon Large (1x) | 1280×768 | Home screen large icon |
| App Icon Large (2x) | 2560×1536 | Home screen large icon @2x |

---

## 🎨 Method 1: Using Xcode Previews (Easiest)

**Best for:** Quick previews and manual screenshots

### Steps:

1. **Open `AppIconGenerator.swift` in Xcode**

2. **Enable Canvas**
   - Press `⌥⌘↵` (Option-Command-Return)
   - Or click the Canvas button in the top-right

3. **View the previews**
   - You'll see three preview sizes automatically
   - The icon renders with full glass effect and sunrise gradient

4. **Take screenshots** (if needed)
   - Use `⌘⇧4` to capture specific areas
   - Save at exact pixel dimensions

---

## 🚀 Method 2: Run Swift Script (Automated)

**Best for:** Generating all sizes at once from Terminal

### Option A: Direct Execution

```bash
# Navigate to your project folder
cd /path/to/tv-clock

# Make executable
chmod +x ExportIcons.swift

# Run it!
./ExportIcons.swift
```

### Option B: Compile First

```bash
# Compile the script
swiftc -o ExportIcons ExportIcons.swift

# Run the compiled binary
./ExportIcons
```

### What it does:

- ✅ Generates all 4 required tvOS icon sizes
- ✅ Saves to `~/Desktop/AppIcons/`
- ✅ Creates properly named PNG files
- ✅ Uses exact pixel dimensions
- ✅ Includes glass effects and gradients

### Output:

```
☀️  Morning Routine App Icon Exporter
═══════════════════════════════════════════════

📁 Output directory: /Users/yourname/Desktop/AppIcons

🎨 Rendering AppIcon-Small (400×240)... ✅
🎨 Rendering AppIcon-Small@2x (800×480)... ✅
🎨 Rendering AppIcon-Large (1280×768)... ✅
🎨 Rendering AppIcon-Large@2x (2560×1536)... ✅

═══════════════════════════════════════════════
✨ Export Complete!
   Created: 4/4 icons
═══════════════════════════════════════════════
```

---

## 🛠️ Method 3: Add Xcode Target (Most Integrated)

**Best for:** Keeping export tools in your Xcode project

### Setup:

1. **In Xcode, add a new target:**
   - File → New → Target
   - Choose "macOS" → "Command Line Tool"
   - Name it "IconExport"
   - Language: Swift

2. **Replace the default main.swift with `IconExportTool.swift`:**
   - Delete the default `main.swift`
   - Add `IconExportTool.swift` to the target

3. **Run the target:**
   - Select "IconExport" scheme
   - Press `⌘R` to run
   - Icons export to Desktop!

### Advantages:

- ✅ Run directly from Xcode
- ✅ Part of your project
- ✅ Easy to modify
- ✅ No Terminal needed

---

## 📥 Installing Icons in Xcode

Once you've generated the PNG files:

### 1. **Locate Assets Catalog**
   - Open your project in Xcode
   - Find `Assets.xcassets` in the Project Navigator

### 2. **Find App Icon**
   - Look for "App Icon" or "AppIcon" in the asset list
   - Make sure it's set to tvOS

### 3. **Drag and Drop**
   Match files to slots:
   ```
   AppIcon-Small-1x.png      → App Icon - Small (1x)
   AppIcon-Small@2x.png      → App Icon - Small (2x)
   AppIcon-Large-1x.png      → App Icon - Large (1x)
   AppIcon-Large@2x.png      → App Icon - Large (2x)
   ```

### 4. **Verify**
   - Build your app (`⌘B`)
   - Run in tvOS Simulator (`⌘R`)
   - Press Home button to see your icon on the home screen

---

## 🎯 Recommended Workflow

**For most users:**
1. Use **Method 2** (Swift Script) to export all sizes
2. Drag files into Xcode Assets
3. Build and test
4. Use **Method 1** (Previews) for quick design tweaks

**For developers:**
1. Set up **Method 3** (Xcode Target) once
2. Run IconExport target whenever you update the design
3. Icons automatically export to Desktop

---

## 🎨 Icon Design Details

Your sunrise icon features:

- **🌅 Sunrise Gradient**
  - Bright yellow at top (morning sky)
  - Warm orange in middle
  - Deep sunrise orange at bottom

- **☀️ Glass Sun Symbol**
  - Uses SF Symbol `sun.min.fill`
  - Three-layer glass effect
  - Radiant glow with blur
  - Dual shadows (white + orange)
  - Overlay highlight for shine

- **✨ Premium Quality**
  - Multiple gradient layers
  - Proper alpha blending
  - Shadow depth
  - Professional finish

---

## 🔧 Customization

To modify the icon design, edit `AppIconGenerator.swift`:

```swift
// Change gradient colors
LinearGradient(
    colors: [
        Color(red: 1.0, green: 0.85, blue: 0.3),  // 👈 Top color
        Color(red: 1.0, green: 0.6, blue: 0.2),   // 👈 Middle color
        Color(red: 0.95, green: 0.4, blue: 0.25)  // 👈 Bottom color
    ],
    startPoint: .top,
    endPoint: .bottom
)

// Change the SF Symbol
Image(systemName: "sun.min.fill")  // 👈 Try: sun.max.fill, sunrise.fill, etc.

// Adjust size
.font(.system(size: 280, weight: .regular))  // 👈 Make bigger/smaller
```

After editing, re-export using any method above!

---

## 📝 Files Reference

| File | Purpose |
|------|---------|
| `AppIconGenerator.swift` | SwiftUI view definition with previews |
| `ExportIcons.swift` | Standalone Terminal script |
| `IconExportTool.swift` | Xcode Command Line Tool target |
| `GenerateAppIcons.swift` | Advanced script with Top Shelf images |

---

## 🎉 Tips

- **Preview First**: Always check the icon in Xcode Canvas before exporting
- **Test on Device**: Icons look different on actual tvOS vs simulator
- **Keep Originals**: Save your exported PNGs separately
- **Version Control**: Commit `AppIconGenerator.swift` to track design changes
- **Batch Export**: Re-run export script whenever you tweak the design

---

## ❓ Troubleshooting

**Script won't run?**
```bash
# Make sure it's executable
chmod +x ExportIcons.swift

# Check Swift version (requires Swift 5.9+)
swift --version
```

**Icons look blurry?**
- Make sure you're using exact pixel dimensions
- Check that `renderer.scale = 1.0` in the script
- Verify PNG files are correct resolution

**Can't find Assets.xcassets?**
- Look in your tvOS target
- May be named `Media.xcassets` or similar
- Create one if missing: File → New → Asset Catalog

**Icons not showing in Simulator?**
- Clean build folder (`⌘⇧K`)
- Delete app from Simulator
- Rebuild and reinstall

---

Built with ☀️ for your Morning Routine app!
