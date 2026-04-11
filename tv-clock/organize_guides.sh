#!/bin/bash

# 📁 Organize Documentation into Guides Folder
# Run this script to move all guide files into organized folders

echo "📁 Organizing documentation files..."
echo ""

# Create folder structure
echo "Creating folder structure..."
mkdir -p Guides/Migration
mkdir -p Guides/Outdated

# Move main guides
echo "Moving main guides..."
mv INDEX.md Guides/README.md 2>/dev/null && echo "  ✓ INDEX.md → Guides/README.md"
mv APPICON_GUIDE.md Guides/ 2>/dev/null && echo "  ✓ APPICON_GUIDE.md → Guides/"
mv QUICK_START.md Guides/ 2>/dev/null && echo "  ✓ QUICK_START.md → Guides/"

# Move migration docs
echo ""
echo "Moving migration docs to Guides/Migration/..."
mv MIGRATION_TO_APPICON.md Guides/Migration/ 2>/dev/null && echo "  ✓ MIGRATION_TO_APPICON.md"
mv MIGRATION_COMPLETE.md Guides/Migration/ 2>/dev/null && echo "  ✓ MIGRATION_COMPLETE.md"
mv DELETE_THESE_FILES.md Guides/Migration/ 2>/dev/null && echo "  ✓ DELETE_THESE_FILES.md"
mv FILES_REMOVED.md Guides/Migration/ 2>/dev/null && echo "  ✓ FILES_REMOVED.md"

# Move outdated docs
echo ""
echo "Moving outdated docs to Guides/Outdated/..."
mv INSTALL_ICONS_GUIDE.md Guides/Outdated/ 2>/dev/null && echo "  ✓ INSTALL_ICONS_GUIDE.md"
mv IMPORT_EXISTING_ICONS.md Guides/Outdated/ 2>/dev/null && echo "  ✓ IMPORT_EXISTING_ICONS.md"
mv ICON_EXPORT_README.md Guides/Outdated/ 2>/dev/null && echo "  ✓ ICON_EXPORT_README.md"

echo ""
echo "═══════════════════════════════════════════════"
echo "✨ Organization complete!"
echo ""
echo "📂 New structure:"
echo "   Guides/"
echo "   ├── README.md"
echo "   ├── APPICON_GUIDE.md"
echo "   ├── QUICK_START.md"
echo "   ├── Migration/"
echo "   │   ├── MIGRATION_COMPLETE.md"
echo "   │   ├── MIGRATION_TO_APPICON.md"
echo "   │   ├── DELETE_THESE_FILES.md"
echo "   │   └── FILES_REMOVED.md"
echo "   └── Outdated/"
echo "       ├── INSTALL_ICONS_GUIDE.md"
echo "       ├── IMPORT_EXISTING_ICONS.md"
echo "       └── ICON_EXPORT_README.md"
echo ""
echo "📋 Next steps:"
echo "   1. Open Guides/README.md"
echo "   2. Follow the migration guide"
echo "   3. Delete Guides/Outdated/ when ready"
echo "   4. Delete Guides/Migration/ after migration"
echo "   5. Delete this script (organize_guides.sh)"
echo "═══════════════════════════════════════════════"
