# 🎯 Quick Start: Copy Icons in 3 Steps

## Step 1: Generate Icons ⚡

Open Terminal and run:

```bash
cd /path/to/your/tv-clock-project
swift GenerateAppIcons.swift
```

**Result**: PNG files on Desktop in `AppIcons` folder ✅

---

## Step 2: Find Assets in Xcode 🔍

**Quick Way**: Press `⌘⇧O` and type "Assets.xcassets"

**Manual Way**: 
1. Open Xcode
2. Press `⌘1` (Project Navigator)
3. Look for `Assets.xcassets`

**If not found**: Create one
- File → New → File → Asset Catalog

---

## Step 3: Drag and Drop 📥

### Open Side-by-Side:

**Left Window**: Finder → Desktop → AppIcons folder  
**Right Window**: Xcode → Assets.xcassets → App Icon

### Drag These Files:

```
From Finder                        →  To Xcode Slot
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
AppIcon-Small-400x240.png         →  App Icon - Small (1x)
AppIcon-Small-800x480.png         →  App Icon - Small (2x)
AppIcon-Large-1280x768.png        →  App Icon - Large (1x)
AppIcon-Large-2560x1536.png       →  App Icon - Large (2x)
```

### Visual:

```
┌─────────────────────┐         ┌─────────────────────┐
│  Finder             │         │  Xcode              │
│  ~/Desktop/AppIcons │         │  Assets.xcassets    │
│                     │         │                     │
│  📄 AppIcon-Small-  │ ─────▶  │  ☐ Small (1x)      │
│     400x240.png     │         │  ☐ Small (2x)      │
│                     │         │  ☐ Large (1x)      │
│  📄 AppIcon-Small-  │ ─────▶  │  ☐ Large (2x)      │
│     800x480.png     │         │                     │
│                     │         └─────────────────────┘
│  📄 AppIcon-Large-  │
│     1280x768.png    │
│                     │
│  📄 AppIcon-Large-  │
│     2560x1536.png   │
└─────────────────────┘
```

---

## ✅ Done!

Test it:
1. Press `⌘R` to run in Simulator
2. Press Home button
3. See your sunrise icon! 🌅

---

## 🆘 Troubleshooting

**Can't run script?**
```bash
chmod +x GenerateAppIcons.swift
./GenerateAppIcons.swift
```

**No Assets.xcassets?**
- Create new: File → New → Asset Catalog

**Icons don't show?**
- Clean build: `⌘⇧K`
- Rebuild: `⌘B`
- Delete app from Simulator
- Run again: `⌘R`

---

**Need detailed help?** → See `INSTALL_ICONS_GUIDE.md`
