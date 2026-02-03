#!/bin/bash
# Claude Code CLI wrapper for Moltbot
# This script provides a unified interface to Claude Code CLI commands

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print usage
print_usage() {
    cat << EOF
Usage: $0 [OPTIONS] [COMMAND] [ARGS...]

Claude Code CLI wrapper for Moltbot integration.

OPTIONS:
    --help, -h          Show this help message
    --version, -v       Show version information
    --debug             Enable debug mode
    --verbose           Enable verbose output

COMMANDS:
    install             Install Claude Code
    check               Check if Claude Code is installed and working
    run                 Run Claude Code with specified arguments
    query               Run a one-time query (non-interactive)
    continue            Continue the most recent conversation
    resume              Resume a specific session
    update              Update Claude Code to latest version
    mcp                 Manage MCP (Model Context Protocol) servers
    config              Show or manage configuration

EXAMPLES:
    $0 install                          # Install Claude Code
    $0 check                            # Check installation
    $0 run "explain this project"       # Start interactive session with prompt
    $0 query "what does this function do?"  # Run one-time query
    $0 continue                         # Continue last conversation
    $0 mcp list                         # List MCP servers
    $0 config                           # Show configuration

For more information, see: https://code.claude.com/docs/
EOF
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to get Claude Code path
get_claude_path() {
    if command_exists claude; then
        which claude
    elif [ -f "/usr/local/bin/claude" ]; then
        echo "/usr/local/bin/claude"
    elif [ -f "$HOME/.local/bin/claude" ]; then
        echo "$HOME/.local/bin/claude"
    else
        echo ""
    fi
}

# Function to check installation
check_installation() {
    local claude_path=$(get_claude_path)
    if [ -n "$claude_path" ]; then
        echo -e "${GREEN}✓ Claude Code is installed at: $claude_path${NC}"
        echo -e "${GREEN}✓ Version: $($claude_path --version)${NC}"
        return 0
    else
        echo -e "${RED}✗ Claude Code is not installed${NC}"
        return 1
    fi
}

# Function to install Claude Code
install_claude() {
    echo -e "${BLUE}Installing Claude Code...${NC}"
    
    # Detect OS
    case "$(uname -s)" in
        Darwin*)
            echo -e "${YELLOW}Detected macOS${NC}"
            if command_exists brew; then
                echo "Using Homebrew..."
                brew install --cask claude-code
            else
                echo "Using curl installer..."
                curl -fsSL https://claude.ai/install.sh | bash
            fi
            ;;
        Linux*)
            echo -e "${YELLOW}Detected Linux${NC}"
            if command_exists apt; then
                echo "Using apt (Debian/Ubuntu)..."
                # Check if we're in WSL
                if grep -q Microsoft /proc/version; then
                    echo "Detected WSL, using curl installer..."
                    curl -fsSL https://claude.ai/install.sh | bash
                else
                    curl -fsSL https://claude.ai/install.sh | bash
                fi
            elif command_exists yum; then
                echo "Using yum (RHEL/CentOS)..."
                curl -fsSL https://claude.ai/install.sh | bash
            elif command_exists dnf; then
                echo "Using dnf (Fedora)..."
                curl -fsSL https://claude.ai/install.sh | bash
            elif command_exists zypper; then
                echo "Using zypper (openSUSE)..."
                curl -fsSL https://claude.ai/install.sh | bash
            else
                echo "Using curl installer..."
                curl -fsSL https://claude.ai/install.sh | bash
            fi
            ;;
        CYGWIN*|MINGW32*|MSYS*|MINGW*)
            echo -e "${YELLOW}Detected Windows${NC}"
            if command_exists winget; then
                echo "Using WinGet..."
                winget install Anthropic.ClaudeCode
            else
                echo "Please install Claude Code manually from https://claude.ai/download"
                return 1
            fi
            ;;
        *)
            echo -e "${RED}Unsupported operating system${NC}"
            return 1
            ;;
    esac
    
    echo -e "${GREEN}Installation completed!${NC}"
    check_installation
}

# Function to run Claude Code
run_claude() {
    local claude_path=$(get_claude_path)
    if [ -z "$claude_path" ]; then
        echo -e "${RED}Error: Claude Code is not installed. Run '$0 install' first.${NC}"
        return 1
    fi
    
    if [ $# -eq 0 ]; then
        # Interactive mode
        "$claude_path"
    else
        # Pass all arguments to claude
        "$claude_path" "$@"
    fi
}

# Main function
main() {
    local debug=false
    local verbose=false
    
    # Parse global options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                print_usage
                exit 0
                ;;
            --version|-v)
                echo "Claude Code Moltbot Skill Wrapper v1.0.0"
                exit 0
                ;;
            --debug)
                debug=true
                shift
                ;;
            --verbose)
                verbose=true
                shift
                ;;
            *)
                break
                ;;
        esac
    done
    
    # Handle command
    case ${1:-} in
        install)
            install_claude
            ;;
        check)
            check_installation
            ;;
        run)
            shift
            run_claude "$@"
            ;;
        query)
            shift
            if [ $# -eq 0 ]; then
                echo -e "${RED}Error: Query command requires a prompt${NC}"
                echo "Usage: $0 query \"your prompt here\""
                exit 1
            fi
            run_claude -p "$@"
            ;;
        continue)
            run_claude -c
            ;;
        resume)
            shift
            if [ $# -eq 0 ]; then
                run_claude -r
            else
                run_claude -r "$@"
            fi
            ;;
        update)
            local claude_path=$(get_claude_path)
            if [ -n "$claude_path" ]; then
                "$claude_path" update
            else
                echo -e "${RED}Error: Claude Code is not installed${NC}"
                exit 1
            fi
            ;;
        mcp)
            shift
            local claude_path=$(get_claude_path)
            if [ -n "$claude_path" ]; then
                "$claude_path" mcp "$@"
            else
                echo -e "${RED}Error: Claude Code is not installed${NC}"
                exit 1
            fi
            ;;
        config)
            echo "Claude Code Configuration:"
            echo "========================="
            echo "Installation path: $(get_claude_path)"
            echo "Config file: ~/.claude.json"
            echo "Skills directory: ~/.claude/skills/"
            echo "Project skills: .claude/skills/"
            if [ -f "$HOME/.claude.json" ]; then
                echo "Current config exists: $HOME/.claude.json"
            else
                echo "No config file found (will be created on first run)"
            fi
            ;;
        "")
            print_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown command: $1${NC}"
            print_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"