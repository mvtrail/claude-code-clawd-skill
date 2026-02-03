# Claude Code Skill - Basic Usage Examples

## 1. Simple Code Explanation
```
/sessions_send sessionKey="main" message="/claude explain this function"
```

## 2. One-time Query
```
/sessions_send sessionKey="main" message="/claude -p \"What does this project do?\""
```

## 3. Debug with Error Message
```
/sessions_send sessionKey="main" message="/claude There's a bug where users can submit empty forms - fix it"
```

## 4. Feature Implementation
```
/sessions_send sessionKey="main" message="/claude add input validation to the user registration form"
```

## 5. Git Operations
```
/sessions_send sessionKey="main" message="/claude commit my changes with a descriptive message"
```

## 6. MCP Integration Example
```
/sessions_send sessionKey="main" message="/claude mcp add --transport http github https://api.githubcopilot.com/mcp/"
/sessions_send sessionKey="main" message="/claude Review PR #456 and suggest improvements"
```

## 7. Custom Agent with Skills
```
/sessions_send sessionKey="main" message="/claude --agents '{\"code-reviewer\":{\"description\":\"Expert code reviewer\",\"prompt\":\"You are a senior code reviewer focusing on security and best practices\"}}' Start code review"
```