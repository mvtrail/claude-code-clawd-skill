# Claude Code Skill for Moltbot

This skill integrates Claude Code functionality into Moltbot, allowing you to leverage Claude's powerful AI coding capabilities directly from your Moltbot assistant.

## Features

- **Code Generation**: Generate code from natural language descriptions
- **Debugging**: Fix bugs and resolve errors automatically  
- **Codebase Navigation**: Understand and explore any codebase
- **Git Integration**: Work with Git repositories conversationally
- **MCP Support**: Connect to external tools and data sources via Model Context Protocol
- **Multi-language Support**: Works with any programming language
- **Terminal Integration**: Execute commands and interact with your development environment

## Prerequisites

1. **Claude Account**: You need a [Claude subscription](https://claude.com/pricing) (Pro, Max, Teams, or Enterprise) or [Claude Console](https://console.anthropic.com/) account
2. **Claude Code CLI**: Install the Claude Code CLI on your system
3. **Authentication**: Log in to your Claude account via the CLI

## Installation

### Install Claude Code CLI

**macOS, Linux, WSL:**
```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Windows PowerShell:**
```powershell
irm https://claude.ai/install.ps1 | iex
```

**Windows CMD:**
```cmd
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

**Homebrew (macOS):**
```bash
brew install --cask claude-code
```

**WinGet (Windows):**
```cmd
winget install Anthropic.ClaudeCode
```

### Authenticate Claude Code

After installation, authenticate your Claude account:

```bash
claude
# Follow the login prompts on first use
```

## Usage Examples

### Basic Code Generation
- "Generate a Python function that sorts a list of dictionaries by a specific key"
- "Create a React component for a todo list with add/remove functionality"

### Debugging and Fixing
- "There's a bug in my authentication code - users can't log in"
- "Fix the type errors in my TypeScript file"

### Codebase Understanding
- "What does this project do?"
- "Explain the folder structure of this repository"
- "Where is the main entry point?"

### Git Operations
- "Commit my changes with a descriptive message"
- "Create a new branch called feature/user-profile"
- "Help me resolve merge conflicts"

### Advanced Workflows
- "Add input validation to the user registration form"
- "Write unit tests for the calculator functions"
- "Refactor the authentication module to use async/await"

## MCP Integration

You can connect Claude Code to external tools via MCP (Model Context Protocol):

```bash
# Add GitHub integration
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# Add Sentry for error monitoring  
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# Add database access
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub --dsn "postgresql://..."
```

## Configuration

The skill supports various configuration options through Moltbot's standard skill interface. You can customize:

- **Model Selection**: Choose between different Claude models
- **Tool Permissions**: Control which tools Claude can use
- **Session Management**: Resume previous conversations or start fresh
- **Output Format**: Control how results are presented

## Security Considerations

- Claude Code requires proper authentication and will not work without valid credentials
- The skill respects Moltbot's security model and permission system
- External tool integrations (MCP) require explicit configuration and authentication
- All code changes are reviewed and approved before execution

## Troubleshooting

### Common Issues

1. **"Command not found: claude"**
   - Ensure Claude Code CLI is properly installed
   - Check your PATH environment variable

2. **Authentication errors**
   - Run `claude` and follow login prompts
   - Ensure your Claude subscription is active

3. **Permission denied for file operations**
   - Claude Code respects file system permissions
   - Ensure proper write permissions in your project directory

4. **MCP server connection issues**
   - Verify MCP server URLs and authentication tokens
   - Check network connectivity to external services

### Debugging Commands

```bash
# Check Claude Code version
claude --version

# List configured MCP servers
claude mcp list

# Get help with available commands
claude --help
```

## Advanced Usage

### Custom Prompts
You can customize Claude's behavior using system prompts:

```bash
# Replace entire system prompt
claude --system-prompt "You are a Python expert"

# Append to default system prompt  
claude --append-system-prompt "Always use TypeScript and include JSDoc comments"
```

### Subagents and Skills
Claude Code supports custom subagents for specialized tasks:

```bash
claude --agents '{
  "code-reviewer": {
    "description": "Expert code reviewer. Use proactively after code changes.",
    "prompt": "You are a senior code reviewer. Focus on code quality, security, and best practices.",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  }
}'
```

### Environment Variables
Control Claude Code behavior with environment variables:

```bash
# Increase MCP output limits
export MAX_MCP_OUTPUT_TOKENS=50000

# Enable verbose logging
export CLAUDE_VERBOSE=true
```

## License

This skill is provided under the same terms as Moltbot. Claude Code is a product of Anthropic.

## Support

For issues with this skill, please check:
- [Claude Code Documentation](https://code.claude.com/docs/)
- [Moltbot Documentation](https://docs.molt.bot)
- [Anthropic Discord Community](https://www.anthropic.com/discord)

For enterprise support, contact your Anthropic representative.