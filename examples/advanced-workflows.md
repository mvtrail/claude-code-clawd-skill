# Advanced Claude Code Workflows

## MCP Integration Examples

### GitHub Integration
```bash
# Add GitHub MCP server
moltbot skill claude-code mcp add github https://api.githubcopilot.com/mcp/

# Use in conversation
# "Review PR #123 and suggest improvements"
# "Create a new issue for the bug we just found"
```

### Database Query Integration
```bash
# Add PostgreSQL MCP server
moltbot skill claude-code mcp add db -- npx -y @bytebase/dbhub \
  --dsn "postgresql://readonly:user@host:5432/analytics"

# Use in conversation
# "What's our total revenue this month?"
# "Find customers who haven't made a purchase in 90 days"
```

## Custom Agent Workflows

### Code Review Agent
```yaml
# Create custom agent for code review
agents:
  code-reviewer:
    description: "Expert code reviewer. Use proactively after code changes."
    prompt: "You are a senior code reviewer. Focus on code quality, security, and best practices."
    tools: ["Read", "Grep", "Glob", "Bash"]
    model: "sonnet"
```

### Debugging Agent
```yaml
# Create debugging specialist
agents:
  debugger:
    description: "Debugging specialist for errors and test failures."
    prompt: "You are an expert debugger. Analyze errors, identify root causes, and provide fixes."
```

## Project-Specific Skills

### Create Project Skill
```bash
# Create project-specific skill directory
mkdir -p .moltbot/skills/api-conventions

# Create SKILL.md for API conventions
cat > .moltbot/skills/api-conventions/SKILL.md << 'EOF'
---
name: api-conventions
description: API design patterns for this codebase
---
When writing API endpoints:
- Use RESTful naming conventions
- Return consistent error formats  
- Include request validation
- Document all endpoints with OpenAPI
EOF
```

### Deployment Skill
```bash
# Create deployment skill (manual invocation only)
mkdir -p .moltbot/skills/deploy

cat > .moltbot/skills/deploy/SKILL.md << 'EOF'
---
name: deploy
description: Deploy the application to production
disable-model-invocation: true
allowed-tools: Bash, Read
---
Deploy $ARGUMENTS to production:

1. Run the test suite: `npm test`
2. Build the application: `npm run build`  
3. Push to deployment target: `git push production main`
4. Verify deployment succeeded
EOF
```

## Visual Output Generation

### Codebase Visualizer
```bash
# Generate interactive codebase visualization
moltbot skill claude-code visualize .

# Creates codebase-map.html and opens in browser
# Shows collapsible tree, file sizes, file type breakdown
```

### Dependency Graph
```bash
# Create dependency visualization (example script structure)
cat > scripts/dependency-graph.py << 'PYEOF'
#!/usr/bin/env python3
"""Generate dependency graph visualization"""
# Implementation would parse package.json, imports, etc.
# Output interactive HTML with D3.js or similar
PYEOF
```

## CI/CD Integration

### GitHub Actions
```yaml
# .github/workflows/claude-code.yml
name: Claude Code Review
on: [pull_request]

jobs:
  claude-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Claude Code
        run: curl -fsSL https://claude.ai/install.sh | bash
      - name: Run Claude Code Review
        run: |
          echo "Review this PR and suggest improvements" | claude -p
```

### GitLab CI/CD
```yaml
# .gitlab-ci.yml
claude-code-review:
  stage: test
  script:
    - curl -fsSL https://claude.ai/install.sh | bash
    - echo "Review merge request and suggest improvements" | claude -p
```

## Environment Variable Configuration

### Custom System Prompts
```bash
# Append to default system prompt
export CLAUDE_APPEND_SYSTEM_PROMPT="Always use TypeScript and include JSDoc comments"

# Replace entire system prompt  
export CLAUDE_SYSTEM_PROMPT="You are a Python expert who only writes type-annotated code"

# Set maximum budget
export CLAUDE_MAX_BUDGET_USD=5.00
```

### MCP Output Limits
```bash
# Increase MCP output token limit
export MAX_MCP_OUTPUT_TOKENS=50000

# Enable tool search at custom threshold
export ENABLE_TOOL_SEARCH=auto:5
```

## Security and Permissions

### Managed MCP Configuration
```json
// /etc/moltbot/managed-mcp.json (system-wide)
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "company-internal": {
      "type": "stdio",
      "command": "/usr/local/bin/company-mcp-server",
      "args": ["--config", "/etc/company/mcp-config.json"]
    }
  }
}
```

### Allowlist/Denylist Configuration
```json
// Managed settings with restrictions
{
  "allowedMcpServers": [
    { "serverName": "github" },
    { "serverUrl": "https://mcp.company.com/*" }
  ],
  "deniedMcpServers": [
    { "serverUrl": "https://*.untrusted.com/*" }
  ]
}
```

## Troubleshooting Common Issues

### Skill Not Triggering
- Check description includes relevant keywords
- Verify skill appears in available skills list
- Try direct invocation with `/skill-name`
- Increase character budget: `export SLASH_COMMAND_TOOL_CHAR_BUDGET=25000`

### Authentication Issues
```bash
# Reset MCP authentication
moltbot skill claude-code mcp reset-project-choices

# Re-authenticate with specific server
moltbot skill claude-code mcp auth github
```

### Performance Optimization
```bash
# Use lighter model for simple tasks
moltbot skill claude-code --model haiku "explain this function"

# Limit agentic turns for complex tasks
moltbot skill claude-code -p --max-turns 3 "refactor this module"
```

## Best Practices

### Prompt Engineering
- Be specific about desired outcomes
- Provide context about your codebase
- Specify coding standards and conventions
- Ask for step-by-step explanations when needed

### Tool Usage
- Use `--tools` to restrict available tools for safety
- Leverage `--allowedTools` in skills for controlled access
- Use `--disallowedTools` to block dangerous operations
- Combine with MCP for external data sources

### Session Management
- Use `--session-id` for reproducible sessions
- Leverage `--continue` to resume previous work
- Use `--fork-session` for experimental branches
- Clean up with `/clear` when starting fresh