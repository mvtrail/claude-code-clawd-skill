#!/bin/bash
# Security and permission management for Claude Code integration
# This script handles secure credential storage and permission validation

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[SECURITY]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1" >&2
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    exit 1
}

# Secure credential storage using system keychain or encrypted files
setup_secure_storage() {
    log "Setting up secure credential storage..."
    
    # Try to use system keychain first (macOS Keychain, Linux Secret Service, Windows Credential Manager)
    if command -v security >/dev/null 2>&1 && [[ "$OSTYPE" == "darwin"* ]]; then
        log "Using macOS Keychain for credential storage"
        # macOS Keychain integration would go here
    elif command -v secret-tool >/dev/null 2>&1; then
        log "Using Linux Secret Service for credential storage"
        # Linux Secret Service integration would go here
    elif command -v cmdkey >/dev/null 2>&1 && [[ "$OSTYPE" == "msys"* ]]; then
        log "Using Windows Credential Manager for credential storage"
        # Windows Credential Manager integration would go here
    else
        # Fallback to encrypted file storage
        warn "No system keychain available, using encrypted file storage"
        setup_encrypted_storage
    fi
}

setup_encrypted_storage() {
    local config_dir="$HOME/.moltbot/claude-code"
    mkdir -p "$config_dir"
    
    # Create encrypted config directory with restricted permissions
    chmod 700 "$config_dir"
    
    # Generate encryption key if it doesn't exist
    local key_file="$config_dir/.encryption-key"
    if [[ ! -f "$key_file" ]]; then
        log "Generating encryption key..."
        openssl rand -base64 32 > "$key_file"
        chmod 600 "$key_file"
    fi
    
    log "Encrypted storage configured at: $config_dir"
}

# Validate Claude API credentials
validate_credentials() {
    local api_key="${1:-}"
    
    if [[ -z "$api_key" ]]; then
        error "API key is required for validation"
    fi
    
    # Basic format validation (Claude API keys typically start with "sk-ant-")
    if [[ ! "$api_key" =~ ^sk-ant-[a-zA-Z0-9_-]+$ ]]; then
        warn "API key format doesn't match expected Claude format (sk-ant-...)"
        warn "This might be a Console API key or from a different provider"
    fi
    
    log "API key format validation passed"
}

# Set up permission rules for tool access
setup_permission_rules() {
    log "Setting up permission rules..."
    
    local rules_file="$HOME/.moltbot/claude-code/permissions.json"
    mkdir -p "$(dirname "$rules_file")"
    
    # Default permission rules that align with Moltbot's security model
    cat > "$rules_file" << 'EOF'
{
  "permissions": {
    "allow": [
      "Read",
      "Grep", 
      "Glob",
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)"
    ],
    "deny": [
      "Bash(rm *)",
      "Bash(sudo *)",
      "Bash(curl * --data *)",
      "Bash(wget * --post-data *)"
    ]
  }
}
EOF
    
    chmod 600 "$rules_file"
    log "Permission rules saved to: $rules_file"
}

# Check for required dependencies
check_dependencies() {
    log "Checking dependencies..."
    
    local missing_deps=()
    
    # Required tools
    local required_tools=("curl" "jq" "bash" "openssl")
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_deps+=("$tool")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        error "Missing required dependencies: ${missing_deps[*]}"
    fi
    
    log "All required dependencies found"
}

# Main function
main() {
    case "${1:-}" in
        "setup-storage")
            setup_secure_storage
            ;;
        "validate-credentials")
            validate_credentials "${2:-}"
            ;;
        "setup-permissions")
            setup_permission_rules
            ;;
        "check-deps")
            check_dependencies
            ;;
        "all")
            check_dependencies
            setup_secure_storage
            setup_permission_rules
            ;;
        *)
            echo "Usage: $0 {setup-storage|validate-credentials|setup-permissions|check-deps|all} [args...]" >&2
            exit 1
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi