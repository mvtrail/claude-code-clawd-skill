#!/bin/bash
# Test script for Claude Code Moltbot skill
# This script verifies that the skill is properly installed and configured

set -e

echo "🧪 Testing Claude Code Moltbot Skill..."

# Check if required directories exist
if [ ! -d "/opt/moltbot/skills/claude-code" ]; then
    echo "❌ Error: Skill directory not found"
    exit 1
fi

# Check if SKILL.md exists
if [ ! -f "/opt/moltbot/skills/claude-code/SKILL.md" ]; then
    echo "❌ Error: SKILL.md not found"
    exit 1
fi

# Check if scripts directory exists
if [ ! -d "/opt/moltbot/skills/claude-code/scripts" ]; then
    echo "❌ Error: scripts directory not found"
    exit 1
fi

# Check if required scripts exist and are executable
SCRIPTS=("install.sh" "claude-cli.sh" "mcp-config.sh" "security.sh")
for script in "${SCRIPTS[@]}"; do
    if [ ! -f "/opt/moltbot/skills/claude-code/scripts/$script" ]; then
        echo "❌ Error: $script not found"
        exit 1
    fi
    if [ ! -x "/opt/moltbot/skills/claude-code/scripts/$script" ]; then
        chmod +x "/opt/moltbot/skills/claude-code/scripts/$script"
        echo "🔧 Made $script executable"
    fi
done

# Check if examples directory exists
if [ ! -d "/opt/moltbot/skills/claude-code/examples" ]; then
    echo "❌ Error: examples directory not found"
    exit 1
fi

# Test Claude CLI availability (without actually running it)
if command -v curl >/dev/null 2>&1 || command -v irm >/dev/null 2>&1; then
    echo "✅ System has required tools for Claude installation"
else
    echo "⚠️  Warning: System may not have required tools for Claude installation"
    echo "   Please ensure curl (Linux/macOS) or PowerShell (Windows) is available"
fi

# Test MCP configuration script syntax
if bash -n "/opt/moltbot/skills/claude-code/scripts/mcp-config.sh"; then
    echo "✅ MCP config script syntax is valid"
else
    echo "❌ Error: MCP config script has syntax errors"
    exit 1
fi

# Test security script syntax
if bash -n "/opt/moltbot/skills/claude-code/scripts/security.sh"; then
    echo "✅ Security script syntax is valid"
else
    echo "❌ Error: Security script has syntax errors"
    exit 1
fi

echo "✅ All tests passed! Claude Code skill is ready to use."
echo ""
echo "Next steps:"
echo "1. Run 'moltbot gateway restart' to load the new skill"
echo "2. Use the skill with: /claude-code <command>"
echo "3. Check examples in /opt/moltbot/skills/claude-code/examples/"