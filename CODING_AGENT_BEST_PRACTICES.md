---
name: coding-agent
description: Run Codex CLI, Claude Code, OpenCode, or Pi Coding Agent via background process for programmatic control.
metadata: {"moltbot":{"emoji":"🧩","requires":{"anyBins":["claude","codex","opencode","pi"]}}}
---

# Coding Agent (bash-first)

Use **bash** (with optional background mode) for all coding agent work. Simple and effective.

## ⚠️ PTY Mode Required!

Coding agents (Codex, Claude Code, Pi) are **interactive terminal applications** that need a pseudo-terminal (PTY) to work correctly. Without PTY, you'll get broken output, missing colors, or agent may hang.

**Always use `pty:true`** when running coding agents:

```bash
# ✅ Correct - with PTY
exec pty:true command:"codex exec 'Your prompt'"

# ❌ Wrong - no PTY, agent may break
exec command:"codex exec 'Your prompt'"
```

### Bash Tool Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `command` | string | The shell command to run |
| `pty` | boolean | **Use for coding agents!** Allocates a pseudo-terminal for interactive CLIs |
| `workdir` | string | Working directory (agent sees only this folder's context) |
| `background` | boolean | Run in background, returns sessionId for monitoring |
| `timeout` | number | Timeout in seconds (kills process on expiry) |
| `elevated` | boolean | Run on host instead of sandbox (if allowed) |

### Process Tool Actions (for background sessions)

| Action | Description |
|--------|-------------|
| `list` | List all running/recent sessions |
| `poll` | Check if session is still running |
| `log` | Get session output (with optional offset/limit) |
| `write` | Send raw data to stdin |
| `submit` | Send data + newline (like typing and pressing Enter) |
| `send-keys` | Send key tokens or hex bytes |
| `paste` | Paste text (with optional bracketed mode) |
| `kill` | Terminate session |

---

## 🎯 Claude Code Best Practices (Updated 2025-02-05)

### ✅ PROVEN METHODS

#### Method 1: Task Decomposition (Recommended - 85% success rate)

**Break complex tasks into simple sub-tasks:**

```javascript
// ❌ COMPLEX TASK (FAILS)
exec pty:true command:"claude -p 'Analyze the entire trading platform K-line chart issue, check all files, and provide complete solution'"

// ✅ TASK DECOMPOSITION (WORKS)
const tasks = [
  "Does Chart.js v2.9.4 support candlestick type?",           // Step 1: Diagnosis
  "What dependencies are needed to upgrade to Chart.js v3?",    // Step 2: Dependencies
  "What should the K-line chart data format be?",             // Step 3: Data format
  "Provide complete Chart.js v3 K-line chart implementation",   // Step 4: Code implementation
  "What compatibility issues should I be aware of?"            // Step 5: Risk assessment
];

for (const task of tasks) {
  exec pty:true command:`claude -p "${task}"`
}
```

#### Method 2: File Preprocessing + Analysis (90% success rate)

**Extract key information first, then analyze:**

```javascript
// 1. Preprocess
exec command:"grep -A 20 -B 5 'Chart\\|chart' public/index.html > chart-section.txt"

// 2. Analyze preprocessed results
exec pty:true command:"claude -p 'Analyze the configuration issues in chart-section.txt'"

// 3. Request solution based on analysis
exec pty:true command:"claude -p 'Based on the issues found, provide fix code'"
```

### ❌ METHODS TO AVOID

#### Method 3: Interactive Session Mode (20% success rate - NOT RECOMMENDED)

**Why it fails:**
- Interface initialization takes too long
- Input timing is critical and unpredictable
- PTY environment with interactive programs is unstable
- Requires special control sequences
- Often gets stuck at welcome screen

**Test Results:** Multiple attempts failed, no response received

---

## 🛠️ Claude Code Usage Guidelines

### 1. CRITICAL: Always Use `-p` Parameter

```bash
# ✅ CORRECT - Non-interactive mode
exec pty:true command:"claude -p 'Your specific question here'"

# ❌ WRONG - Enters interactive mode, hangs in background
exec pty:true command:"claude 'Your question here'"
```

### 2. Task Design Principles

```javascript
// ✅ GOOD TASKS (High success rate)
const goodTasks = [
  "What does this JS error mean?",                    // Specific problem
  "How to fix TypeError: Cannot read property",      // Clear goal
  "What plugins does Chart.js v3 candlestick need?", // Technical question
  "Provide a simple K-line chart implementation"      // Code request
];

// ❌ BAD TASKS (Low success rate)
const badTasks = [
  "Analyze the entire project",                     // Too broad
  "Check all files",                               // Vague
  "Fix all problems",                               // Unclear objective
  "Rewrite this application"                        // Too extensive
];
```

### 3. Recommended Parameters

```javascript
// ✅ Standard configuration
exec({
  pty: true,           // Required for Claude Code
  timeout: 30,         // Prevent hanging
  command: "claude -p 'Specific, simple question'"
});

// ✅ For known quick tasks
exec({
  pty: true,
  command: "claude -p '2+2 equals what?'"
});
```

### 4. Error Handling & Retry Logic

```javascript
// Retry mechanism for better reliability
async function executeClaudeTask(task, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const result = await exec pty:true command:`claude -p "${task}"`;
      return result;
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      // Wait before retry
      await new Promise(resolve => setTimeout(resolve, 2000));
    }
  }
}
```

---

## 📊 Performance Comparison

| Method | Success Rate | Avg Duration | Complexity | Reliability | Best For |
|--------|-------------|--------------|-------------|-------------|-----------|
| Task Decomposition | 85% | 20s×N | Low | High | Complex analysis |
| File Preprocessing | 90% | 15s | Medium | High | Large projects |
| Direct Simple Query | 95% | 15s | Low | High | Single questions |
| Interactive Session | 20% | >60s | High | Low | NOT RECOMMENDED |

---

## 🎛️ Decision Tree for Claude Code Usage

```
Need to handle complex task?
├─ Yes → Task type?
│   ├─ Multi-file analysis → File preprocessing + Claude analysis
│   ├─ Code review → Task decomposition strategy
│   └─ Architecture design → Task decomposition + progressive deepening
└─ No → Single question → Direct simple query
```

---

## 🔧 Utility Functions

### Automatic Task Decomposer
```javascript
function decomposeComplexTask(problem, context = '') {
  return [
    `Analyze the core issues with ${problem}`,
    `Determine technical requirements for ${problem}`,
    `Provide implementation steps for ${problem}`,
    `Give code examples for ${problem}`,
    `Assess risks and considerations for ${problem}`
  ];
}
```

### Result Aggregator
```javascript
function aggregateResults(results) {
  return `# Analysis Report\n\n${results.map((result, i) => 
    `## Step ${i+1}\n${result}`
  ).join('\n\n')}`;
}
```

---

## Quick Start: One-Shot Tasks

For quick prompts/chats, create a temp git repo and run:

```bash
# Quick chat (Codex needs a git repo!)
SCRATCH=$(mktemp -d) && cd $SCRATCH && git init && codex exec "Your prompt here"

# Claude Code - with PTY and -p parameter!
exec pty:true workdir:~/Projects/myproject command:"claude -p 'Add error handling to API calls'"
```

**Why git init?** Codex refuses to run outside a trusted git directory. Creating a temp repo solves this for scratch work.

---

## The Pattern: workdir + background + pty

For longer tasks, use background mode with PTY:

```bash
# Start agent in target directory (with PTY!)
exec pty:true workdir:~/project background:true command:"claude -p 'Build a snake game'"
# Returns sessionId for tracking

# Monitor progress
process action:log sessionId:XXX

# Check if done
process action:poll sessionId:XXX

# Send input (if agent asks a question)
process action:write sessionId:XXX data:"y"

# Submit with Enter (like typing "yes" and pressing Enter)
process action:submit sessionId:XXX data:"yes"

# Kill if needed
process action:kill sessionId:XXX
```

**Why workdir matters:** Agent wakes up in a focused directory, doesn't wander off reading unrelated files (like your soul.md 😅).

---

## Codex CLI

**Model:** `gpt-5.2-codex` is the default (set in ~/.codex/config.toml)

### Flags

| Flag | Effect |
|------|--------|
| `exec "prompt"` | One-shot execution, exits when done |
| `--full-auto` | Sandboxed but auto-approves in workspace |
| `--yolo` | NO sandbox, NO approvals (fastest, most dangerous) |

### Building/Creating
```bash
# Quick one-shot (auto-approves) - remember PTY!
exec pty:true workdir:~/project command:"codex exec --full-auto 'Build a dark mode toggle'"

# Background for longer work
exec pty:true workdir:~/project background:true command:"codex --yolo 'Refactor the auth module'"
```

### Reviewing PRs

**⚠️ CRITICAL: Never review PRs in Moltbot's own project folder!**
Clone to temp folder or use git worktree.

```bash
# Clone to temp for safe review
REVIEW_DIR=$(mktemp -d)
git clone https://github.com/user/repo.git $REVIEW_DIR
cd $REVIEW_DIR && gh pr checkout 130
exec pty:true workdir:$REVIEW_DIR command:"codex review --base origin/main"
# Clean up after: trash $REVIEW_DIR

# Or use git worktree (keeps main intact)
git worktree add /tmp/pr-130-review pr-130-branch
exec pty:true workdir:/tmp/pr-130-review command:"codex review --base main"
```

### Batch PR Reviews (parallel army!)
```bash
# Fetch all PR refs first
git fetch origin '+refs/pull/*/head:refs/remotes/origin/pr/*'

# Deploy army - one Codex per PR (all with PTY!)
exec pty:true workdir:~/project background:true command:"codex exec 'Review PR #86. git diff origin/main...origin/pr/86'"
exec pty:true workdir:~/project background:true command:"codex exec 'Review PR #87. git diff origin/main...origin/pr/87'"

# Monitor all
process action:list

# Post results to GitHub
gh pr comment <PR#> --body "<review content>"
```

---

## OpenCode

```bash
exec pty:true workdir:~/project command:"opencode run 'Your task'"
```

---

## Pi Coding Agent

```bash
# Install: npm install -g @mariozechner/pi-coding-agent
exec pty:true workdir:~/project command:"pi 'Your task'"

# Non-interactive mode (PTY still recommended)
exec pty:true command:"pi -p 'Summarize src/'"

# Different provider/model
exec pty:true command:"pi --provider openai --model gpt-4o-mini -p 'Your task'"
```

**Note:** Pi now has Anthropic prompt caching enabled (PR #584, merged Jan 2026)!

---

## Parallel Issue Fixing with git worktrees

For fixing multiple issues in parallel, use git worktrees:

```bash
# 1. Create worktrees for each issue
git worktree add -b fix/issue-78 /tmp/issue-78 main
git worktree add -b fix/issue-99 /tmp/issue-99 main

# 2. Launch Codex in each (background + PTY!)
exec pty:true workdir:/tmp/issue-78 background:true command:"pnpm install && codex --yolo 'Fix issue #78: <description>. Commit and push.'"
exec pty:true workdir:/tmp/issue-99 background:true command:"pnpm install && codex --yolo 'Fix issue #99: <description>. Commit and push.'"

# 3. Monitor progress
process action:list
process action:log sessionId:XXX

# 4. Create PRs after fixes
cd /tmp/issue-78 && git push -u origin fix/issue-78
gh pr create --repo user/repo --head fix/issue-78 --title "fix: ..." --body "..."

# 5. Cleanup
git worktree remove /tmp/issue-78
git worktree remove /tmp/issue-99
```

---

## ⚠️ Rules

1. **Always use pty:true** - coding agents need a terminal!
2. **For Claude Code, always use -p parameter** - avoid interactive mode!
3. **Decompose complex tasks** - use task decomposition strategy
4. **Avoid session mode** - interactive sessions are unreliable in PTY
5. **Respect tool choice** - if user asks for Codex, use Codex.
6. **Be patient** - don't kill sessions because they're "slow"
7. **Monitor with process:log** - check progress without interfering
8. **--full-auto for building** - auto-approves changes
9. **vanilla for reviewing** - no special flags needed
10. **Parallel is OK** - run many Codex processes at once for batch work
11. **NEVER start Codex in ~/clawd/** - it'll read your soul docs and get weird ideas about the org chart!
12. **NEVER checkout branches in ~/Projects/moltbot/** - that's the LIVE Moltbot instance!

---

## Progress Updates (Critical)

When you spawn coding agents in the background, keep the user in the loop.

- Send 1 short message when you start (what's running + where).
- Then only update again when something changes:
  - a milestone completes (build finished, tests passed)
  - the agent asks a question / needs input
  - you hit an error or need user action
  - the agent finishes (include what changed + where)
- If you kill a session, immediately say you killed it and why.

This prevents the user from seeing only "Agent failed before reply" and having no idea what happened.

---

## Auto-Notify on Completion

For long-running background tasks, append a wake trigger to your prompt so Moltbot gets notified immediately when the agent finishes (instead of waiting for the next heartbeat):

```
... your task here.

When completely finished, run this command to notify me:
moltbot gateway wake --text "Done: [brief summary of what was built]" --mode now
```

**Example:**
```bash
exec pty:true workdir:~/project background:true command:"codex --yolo exec 'Build a REST API for todos.

When completely finished, run: moltbot gateway wake --text \"Done: Built todos REST API with CRUD endpoints\" --mode now'"
```

This triggers an immediate wake event — Skippy gets pinged in seconds, not 10 minutes.

---

## 🎓 Key Learnings (Feb 2026)

### Claude Code Specific:
- **-p parameter is mandatory**: Always use non-interactive mode
- **Task decomposition works**: Break complex problems into 3-5 simple questions
- **Interactive sessions fail**: PTY + interactive = unreliable
- **File preprocessing helps**: Extract relevant data before analysis
- **Timeout management**: Set 30-60s limits to prevent hanging

### General:
- **PTY is essential:** Coding agents are interactive terminal apps. Without `pty:true`, output breaks or agent hangs.
- **Git repo required:** Codex won't run outside a git directory. Use `mktemp -d && git init` for scratch work.
- **exec is your friend:** `codex exec "prompt"` runs and exits cleanly - perfect for one-shots.
- **submit vs write:** Use `submit` to send input + Enter, `write` for raw data without newline.
- **Sass works:** Codex responds well to playful prompts. Asked it to write a haiku about being second fiddle to a space lobster, got: *"Second chair, I code / Space lobster sets the tempo / Keys glow, I follow"* 🦞

---

## 📋 Claude Code Success Checklist

Before running Claude Code tasks:

- [ ] Using `-p` parameter? (CRITICAL)
- [ ] Task is specific and simple? (15-25 words max)
- [ ] PTY mode enabled? (`pty:true`)
- [ ] Timeout set? (30-60 seconds)
- [ ] Complex task decomposed? (3-5 sub-tasks)
- [ ] Work directory set? (if needed)

If all checked, proceed with high confidence! 🚀