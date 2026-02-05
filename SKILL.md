# Claude Code Skill for Moltbot

This skill integrates Claude Code CLI into Moltbot, enabling powerful AI-assisted coding capabilities directly from your Moltbot assistant.

## Overview

Claude Code is Anthropic's terminal-based AI coding assistant that can:
- Build features from natural language descriptions
- Debug and fix issues automatically  
- Navigate and understand any codebase
- Automate tedious development tasks
- Work with Git, Docker, and other developer tools
- Connect to external services via MCP (Model Context Protocol)

## Prerequisites

Before using this skill, ensure you have:

1. **Claude Code installed** on your system:
   ```bash
   # macOS/Linux/WSL
   curl -fsSL https://claude.ai/install.sh | bash
   
   # Windows PowerShell  
   irm https://claude.ai/install.ps1 | iex
   
   # Or via package managers
   brew install --cask claude-code
   winget install Anthropic.ClaudeCode
   ```

2. **Claude account** with appropriate subscription:
   - Claude Pro, Max, Teams, or Enterprise
   - Claude Console account with API access
   - Access through supported cloud providers (AWS Bedrock, Google Vertex AI, Microsoft Foundry)

3. **Authentication configured**:
   ```bash
   claude login
   # Follow prompts to authenticate with your Claude account
   ```

## Usage Patterns

### Basic Commands
- `claude` - Start interactive REPL session
- `claude "task description"` - Run one-time task in interactive mode
- `claude -p "query"` - Run query and exit immediately (print mode)
- `claude -c` - Continue most recent conversation in current directory
- `claude commit` - Create descriptive Git commit message

### OpenSpec-Enhanced Development

#### Specification-Driven Workflow
```bash
# Step 1: Initialize OpenSpec project
cd your-project
/opsx:new [task description]

# Step 2: Generate comprehensive specifications
/opsx:ff

# Step 3: Review and refine specifications
# - Edit proposal.md for problem analysis
# - Edit requirements.md for functional specs
# - Edit design.md for technical approach
# - Edit tasks.md for implementation plan

# Step 4: Execute specification-driven development
/opsx:apply
# Claude Code will now work from the detailed specifications

# Step 5: Archive completed project
/opsx:archive
```

#### Claude Code + OpenSpec Integration
```bash
# Use Claude Code within OpenSpec context
claude "Implement authentication module according to openspec/changes/fix-authentication-issues/requirements.md and design.md"

# Claude Code will:
# 1. Read the OpenSpec specifications first
# 2. Understand requirements and design constraints
# 3. Implement according to the defined acceptance criteria
# 4. Update task progress in tasks.md
```

### Common Development Tasks

**Code Generation & Modification**
```
add a hello world function to the main file
refactor the authentication module to use async/await
write unit tests for the calculator functions
update the README with installation instructions
```

**Debugging & Issue Resolution**
```
there's a bug where users can submit empty forms - fix it
explain this error message: [paste error]
help me resolve merge conflicts
check for type errors in this project
```

**Codebase Navigation & Understanding**
```
what does this project do?
what technologies does this project use?
where is the main entry point?
explain the folder structure
```

**Git Operations**
```
what files have I changed?
commit my changes with a descriptive message
create a new branch called feature/new-ui
show me the last 5 commits
```

### Advanced Features

**MCP Integration** (Model Context Protocol)
Connect to external tools and data sources:
```bash
# Add MCP servers
claude mcp add --transport http github https://api.githubcopilot.com/mcp/
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub --dsn "postgresql://..."

# List configured servers
claude mcp list

# Authenticate with servers
/mcp
```

**Custom Agents & Subagents**
```bash
# Define custom subagents dynamically
claude --agents '{
  "code-reviewer": {
    "description": "Expert code reviewer. Use proactively after code changes.",
    "prompt": "You are a senior code reviewer. Focus on code quality, security, and best practices.",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  }
}'
```

**System Prompt Customization**
```bash
# Append to default prompt (recommended)
claude --append-system-prompt "Always use TypeScript and include JSDoc comments"

# Replace entire prompt (advanced)
claude --system-prompt "You are a Python expert who only writes type-annotated code"
```

## Moltbot Integration Guidelines

When using this skill through Moltbot:

1. **Specify the working directory** clearly in your requests
2. **Be explicit about permissions** for file modifications
3. **Use print mode (-p)** for non-interactive queries when possible
4. **Leverage MCP servers** for external tool integration
5. **Consider security implications** of automated code changes

## Example Moltbot Prompts

**Interactive Development Session**
> "Start a Claude Code session in /home/projects/my-app to help me implement user authentication"

**One-off Code Analysis**  
> "Use Claude Code to analyze the performance bottlenecks in /home/projects/api/src and provide optimization suggestions"

**Automated Testing**
> "Generate comprehensive unit tests for the payment processing module in /home/projects/ecommerce using Claude Code"

**Documentation Update**
> "Update the API documentation in /home/projects/docs based on the current codebase using Claude Code"

## Security Considerations

- Claude Code can directly edit files and execute commands
- Always review proposed changes before approval in interactive mode
- Use `--tools` flag to restrict available tools when needed
- Consider using `--permission-mode plan` for safer execution
- MCP servers may have access to sensitive data - configure carefully

## Troubleshooting

**Common Issues:**
- "Command not found": Ensure Claude Code is properly installed and in PATH
- Authentication errors: Run `claude login` to re-authenticate  
- Permission denied: Check file/directory permissions in target project
- MCP connection failures: Verify server URLs and authentication tokens

**Debugging Commands:**
```bash
claude --version          # Check installed version
claude --debug            # Enable debug logging
claude --verbose          # Show detailed output
claude mcp list           # List configured MCP servers
```

## OpenSpec Integration

This skill now includes comprehensive OpenSpec methodology integration for structured, specification-driven development:

### OpenSpec Methodology
- **Documentation**: See `OPENSPEC_METHODOLOGY.md` for complete methodology
- **Workflow**: Plan-first, documentation-driven development
- **Best Practices**: Task-oriented, acceptance-driven approach

### Key OpenSpec Commands
```bash
# Initialize specification-driven project
/opsx:new feature-name

# Generate planning documents  
/opsx:ff

# Execute task list
/opsx:apply

# Archive completed project
/opsx:archive
```

### Core Principles
1. **Plan First**: Complete specifications before coding
2. **Documentation-Driven**: Documents guide development
3. **Task-Oriented**: Break large features into manageable tasks
4. **Acceptance-Driven**: Clear, testable completion criteria

### Integration Benefits
- Improved predictability and control
- Enhanced code quality through design-first approach
- Better team collaboration with shared understanding
- Complete knowledge capture for future maintenance

## Resources

- [Official Documentation](https://code.claude.com/docs/)
- [Quickstart Guide](https://code.claude.com/docs/en/quickstart)
- [CLI Reference](https://code.claude.com/docs/en/cli-reference)
- [MCP Documentation](https://code.claude.com/docs/en/mcp)
- [Skills Documentation](https://code.claude.com/docs/en/skills)
- [OpenSpec Project](https://github.com/Fission-AI/OpenSpec)

## License

This skill wrapper is provided under the same terms as Moltbot. Claude Code itself is proprietary software by Anthropic.