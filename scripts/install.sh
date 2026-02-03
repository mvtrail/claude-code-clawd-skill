#!/bin/bash
# Claude Code Installation Script for Moltbot Skill

set -e

echo "📦 Installing Claude Code CLI..."

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"

# Function to install on macOS/Linux/WSL
install_unix() {
    if command -v curl >/dev/null 2>&1; then
        echo "📥 Downloading Claude Code installer..."
        curl -fsSL https://claude.ai/install.sh | bash
    elif command -v wget >/dev/null 2>&1; then
        echo "📥 Downloading Claude Code installer with wget..."
        wget -qO- https://claude.ai/install.sh | bash
    else
        echo "❌ Error: Neither curl nor wget found. Please install one of them first."
        exit 1
    fi
}

# Function to install on Windows (PowerShell)
install_windows_powershell() {
    echo "📥 Installing Claude Code via PowerShell..."
    powershell -Command "irm https://claude.ai/install.ps1 | iex"
}

# Function to install on Windows (CMD)
install_windows_cmd() {
    echo "📥 Installing Claude Code via CMD..."
    curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
}

# Function to install via Homebrew (macOS/Linux)
install_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        echo "📥 Installing Claude Code via Homebrew..."
        brew install --cask claude-code
    else
        echo "❌ Homebrew not found. Installing via direct method..."
        install_unix
    fi
}

# Function to install via WinGet (Windows)
install_winget() {
    if command -v winget >/dev/null 2>&1; then
        echo "📥 Installing Claude Code via WinGet..."
        winget install Anthropic.ClaudeCode
    else
        echo "❌ WinGet not found. Installing via PowerShell..."
        install_windows_powershell
    fi
}

# Main installation logic
case "${OS}" in
    Darwin*)
        echo "🍎 Detected macOS"
        if command -v brew >/dev/null 2>&1; then
            install_homebrew
        else
            install_unix
        fi
        ;;
    Linux*)
        echo "🐧 Detected Linux/WSL"
        if [[ "$OSTYPE" == "linux-gnu"* ]] && command -v apt >/dev/null 2>&1; then
            install_unix
        elif command -v brew >/dev/null 2>&1; then
            install_homebrew
        else
            install_unix
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        echo "🪟 Detected Windows"
        if command -v winget >/dev/null 2>&1; then
            install_winget
        elif command -v powershell >/dev/null 2>&1; then
            install_windows_powershell
        else
            install_windows_cmd
        fi
        ;;
    *)
        echo "❓ Unknown OS: ${OS}. Attempting Unix installation..."
        install_unix
        ;;
esac

echo "✅ Claude Code installation completed!"
echo "🔑 Next steps:"
echo "   1. Run 'claude' to log in to your Claude account"
echo "   2. Test with 'claude -p \"what can you do?\"'"
echo "   3. Use the Moltbot skill with '/claude-code' commands"

# Verify installation
if command -v claude >/dev/null 2>&1; then
    echo "🔍 Verifying installation..."
    claude --version
else
    echo "⚠️  Warning: 'claude' command not found in PATH"
    echo "   You may need to restart your terminal or add it to PATH manually"
fi