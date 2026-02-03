#!/bin/bash
# MCP Configuration Support for Claude Code Skill
# This script helps manage MCP (Model Context Protocol) server configurations

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[MCP]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if Claude Code is installed
check_claude_installed() {
    if ! command -v claude &> /dev/null; then
        error "Claude Code is not installed. Please install it first using the install.sh script."
        return 1
    fi
    return 0
}

# Add MCP server
add_mcp_server() {
    local name="$1"
    local transport="$2"
    local url_or_command="$3"
    shift 3
    local args=("$@")
    
    if ! check_claude_installed; then
        return 1
    fi
    
    log "Adding MCP server: $name ($transport)"
    
    case "$transport" in
        "http"|"https")
            if [[ ${#args[@]} -eq 0 ]]; then
                claude mcp add --transport http "$name" "$url_or_command"
            else
                # Handle headers and other options
                claude mcp add --transport http "$name" "$url_or_command" "${args[@]}"
            fi
            ;;
        "sse")
            if [[ ${#args[@]} -eq 0 ]]; then
                claude mcp add --transport sse "$name" "$url_or_command"
            else
                claude mcp add --transport sse "$name" "$url_or_command" "${args[@]}"
            fi
            ;;
        "stdio")
            # For stdio, url_or_command is the command
            claude mcp add "$name" -- "$url_or_command" "${args[@]}"
            ;;
        *)
            error "Unsupported transport: $transport"
            return 1
            ;;
    esac
    
    success "MCP server '$name' added successfully"
}

# List MCP servers
list_mcp_servers() {
    if ! check_claude_installed; then
        return 1
    fi
    
    log "Listing configured MCP servers..."
    claude mcp list
}

# Get MCP server details
get_mcp_server() {
    local name="$1"
    
    if ! check_claude_installed; then
        return 1
    fi
    
    log "Getting details for MCP server: $name"
    claude mcp get "$name"
}

# Remove MCP server
remove_mcp_server() {
    local name="$1"
    
    if ! check_claude_installed; then
        return 1
    fi
    
    log "Removing MCP server: $name"
    claude mcp remove "$name"
    success "MCP server '$name' removed"
}

# Import MCP configuration from JSON
import_mcp_config() {
    local config_file="$1"
    
    if ! check_claude_installed; then
        return 1
    fi
    
    if [[ ! -f "$config_file" ]]; then
        error "Config file not found: $config_file"
        return 1
    fi
    
    log "Importing MCP configuration from: $config_file"
    
    # Parse JSON and add servers
    if command -v jq &> /dev/null; then
        # Extract MCP servers from JSON
        if jq -e '.mcpServers // .mcp_servers // empty' "$config_file" > /dev/null; then
            # Handle standard .mcp.json format
            local servers
            servers=$(jq -r '(.mcpServers // .mcp_servers) | to_entries[] | "\(.key)|\(.value.type // "stdio")|\(.value.url // .value.command)"' "$config_file")
            
            while IFS='|' read -r name type endpoint; do
                if [[ -n "$name" && -n "$endpoint" ]]; then
                    log "Adding server: $name ($type)"
                    case "$type" in
                        "http"|"https")
                            add_mcp_server "$name" "$type" "$endpoint"
                            ;;
                        "stdio")
                            add_mcp_server "$name" "stdio" "$endpoint"
                            ;;
                        *)
                            warning "Skipping unsupported server type: $type"
                            ;;
                    esac
                fi
            done <<< "$servers"
        else
            error "No MCP servers found in config file"
            return 1
        fi
    else
        warning "jq not available, cannot parse JSON config file"
        return 1
    fi
    
    success "MCP configuration imported successfully"
}

# Export current MCP configuration
export_mcp_config() {
    local output_file="$1"
    
    if ! check_claude_installed; then
        return 1
    fi
    
    log "Exporting MCP configuration to: $output_file"
    
    # Create a basic .mcp.json structure
    cat > "$output_file" << EOF
{
  "mcpServers": {
    // Add your MCP servers here
    // Example:
    // "github": {
    //   "type": "http",
    //   "url": "https://api.githubcopilot.com/mcp/"
    // },
    // "sentry": {
    //   "type": "http", 
    //   "url": "https://mcp.sentry.dev/mcp"
    // }
  }
}
EOF
    
    success "MCP configuration template created at: $output_file"
    log "Edit the file to add your MCP server configurations"
}

# Main function
main() {
    if [[ $# -eq 0 ]]; then
        cat << EOF
MCP Configuration Tool for Claude Code

Usage:
  $0 add <name> <transport> <url/command> [options...]    # Add MCP server
  $0 list                                                # List all MCP servers
  $0 get <name>                                          # Get server details
  $0 remove <name>                                       # Remove MCP server
  $0 import <config-file>                                # Import from JSON config
  $0 export <output-file>                                # Export config template

Transports: http, https, sse, stdio

Examples:
  $0 add github http https://api.githubcopilot.com/mcp/
  $0 add db stdio npx -y @bytebase/dbhub --dsn "postgresql://..."
  $0 import ./my-mcp-config.json
EOF
        return 0
    fi
    
    case "$1" in
        "add")
            if [[ $# -lt 4 ]]; then
                error "Usage: $0 add <name> <transport> <url/command> [options...]"
                return 1
            fi
            add_mcp_server "$2" "$3" "$4" "${@:5}"
            ;;
        "list")
            list_mcp_servers
            ;;
        "get")
            if [[ $# -ne 2 ]]; then
                error "Usage: $0 get <name>"
                return 1
            fi
            get_mcp_server "$2"
            ;;
        "remove")
            if [[ $# -ne 2 ]]; then
                error "Usage: $0 remove <name>"
                return 1
            fi
            remove_mcp_server "$2"
            ;;
        "import")
            if [[ $# -ne 2 ]]; then
                error "Usage: $0 import <config-file>"
                return 1
            fi
            import_mcp_config "$2"
            ;;
        "export")
            if [[ $# -ne 2 ]]; then
                error "Usage: $0 export <output-file>"
                return 1
            fi
            export_mcp_config "$2"
            ;;
        *)
            error "Unknown command: $1"
            return 1
            ;;
    esac
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi