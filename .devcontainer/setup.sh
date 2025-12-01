#!/bin/bash

echo "🔧 Installeren systeemafhankelijkheden..."
sudo apt-get update && sudo apt-get install -y jq
echo "  ✓ jq geïnstalleerd voor hook scripts"

echo "📦 Installeren lokale dependencies..."
npm install

echo "🌐 Installeren Claude Code SDK globaal..."
npm install -g @anthropic-ai/claude-code

echo "⚙️ Configureren Claude instellingen..."
mkdir -p ~/.claude

if [ -f .claude/settings.json ]; then
    cp .claude/settings.json ~/.claude/settings.json
    echo "  ✓ settings.json gekopieerd"
fi

if [ -f .claude/settings.local.json ]; then
    cp .claude/settings.local.json ~/.claude/settings.local.json
    echo "  ✓ settings.local.json gekopieerd"
fi

echo "✅ Setup klaar."

