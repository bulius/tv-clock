# ☀️ Quick Start: App Icon for Morning Routine

## 🎯 3-Step Icon Setup

### Step 1: Create AppIcon.icon
```
Xcode → File → New → Resource → App Icon
Name: AppIcon.icon
```

### Step 2: Add Sunrise Design
```
SF Symbol: sun.min.fill
Background: Gradient
  - Top: #FFD94D
  - Bottom: #F26440
Symbol: White
```

### Step 3: Done!
```
Build → Run → See icon in Simulator
```

---

## 🎨 Design Specs

**Colors:**
- `#FFD94D` - Bright sunrise yellow
- `#FF9933` - Warm orange
- `#F26440` - Deep sunrise orange

**Symbol:**
- `sun.min.fill` (SF Symbol)
- White fill
- Gradient background

---

## 📁 File Reference

| File | Purpose |
|------|---------|
| `AppIcon.icon` | Your actual icon (create this) |
| `AppIconGenerator.swift` | Design reference & specs |
| `APPICON_GUIDE.md` | Full documentation |

---

## ⚡ Commands

```bash
# Clean build
⌘⇧K

# Build
⌘B

# Run
⌘R
```

---

**That's it!** Your sunrise icon is ready to greet users every morning! ☀️
