# OpenSpec Integration Examples

This directory contains practical examples of integrating Claude Code with OpenSpec methodology for specification-driven development.

## Example Projects

### 1. Theme Synchronization Fix
**Location**: `./theme-sync-fix/`
**Description**: Fix cross-page theme synchronization issues in a diary application
**Key Learnings**:
- Complete specification development before coding
- Task-oriented implementation approach
- Acceptance-driven quality assurance

**OpenSpec Structure**:
```
openspec/changes/theme-sync-fix/
├── .openspec.yaml              # Project configuration
├── proposal.md                  # Problem analysis and solution overview
├── specs/
│   ├── requirements.md          # Functional requirements (FR-1 to FR-5)
│   └── scenarios.md           # 12 detailed usage scenarios
├── design.md                   # Technical architecture and implementation
└── tasks.md                    # 5-phase, 20-task implementation plan
```

**Results**:
- 100% task completion rate
- All acceptance criteria met
- 30% faster than ad-hoc development
- Complete knowledge capture for future maintenance

## Integration Patterns

### Pattern 1: Specification-First Development
```bash
# Initialize OpenSpec project
/opsx:new feature-name

# Generate comprehensive specifications
/opsx:ff

# Review and refine specifications
# (manually edit generated documents)

# Execute with Claude Code
/opsx:apply

# Claude Code reads specifications first:
# - Understands requirements from requirements.md
# - Follows design from design.md  
# - Implements according to tasks.md
# - Updates progress automatically
```

### Pattern 2: Hybrid Approach
```bash
# Use Claude Code for initial analysis
claude "Analyze this codebase and identify theme synchronization issues"

# Based on analysis, create OpenSpec project
/opsx:new fix-theme-issues

# Generate and refine specifications
/opsx:ff

# Implement with Claude Code using specifications
claude "Implement theme synchronization according to openspec/changes/fix-theme-issues/"

# Claude Code will:
# 1. Read all specification documents
# 2. Understand the problem and solution approach
# 3. Implement according to defined requirements
# 4. Follow the technical design constraints
# 5. Meet all acceptance criteria
```

### Pattern 3: Iterative Refinement
```bash
# Start with high-level specifications
/opsx:new feature-v1
/opsx:ff

# Begin implementation
/opsx:apply

# During implementation, if changes needed:
# 1. Pause implementation
# 2. Update relevant specifications
# 3. Continue with updated specifications

# Claude Code always works from latest specifications
```

## Best Practices

### 1. Specification Quality
- **Detailed Requirements**: Each FR (Functional Requirement) should be specific and testable
- **Comprehensive Scenarios**: Cover normal, edge case, and error scenarios
- **Clear Design**: Include architecture diagrams and technical constraints
- **Granular Tasks**: Break work into 1-2 hour tasks with clear acceptance criteria

### 2. Claude Code Integration
- **Context First**: Always ensure Claude Code reads specifications before coding
- **Constraint Awareness**: Claude Code should respect design decisions and technical constraints
- **Progress Tracking**: Update task completion status in tasks.md
- **Quality Gates**: Don't proceed to next task until acceptance criteria are met

### 3. Documentation Sync
- **Real-time Updates**: Update specifications immediately when changes occur
- **Version Control**: Commit specification changes alongside code changes
- **Decision Recording**: Document important technical decisions in design.md
- **Lessons Learned**: Update specifications based on implementation insights

## Command Examples

### Basic OpenSpec + Claude Code Workflow
```bash
# 1. Navigate to project directory
cd ~/projects/my-app

# 2. Initialize OpenSpec project
/opsx:new add-user-authentication

# 3. Generate specifications
/opsx:ff

# 4. Review specifications (optional but recommended)
# Edit: openspec/changes/add-user-authentication/proposal.md
# Edit: openspec/changes/add-user-authentication/requirements.md
# Edit: openspec/changes/add-user-authentication/design.md
# Edit: openspec/changes/add-user-authentication/tasks.md

# 5. Execute with Claude Code
/opsx:apply
```

### Advanced Claude Code Integration
```bash
# Direct Claude Code with specification context
claude "Read the OpenSpec specifications in openspec/changes/add-user-authentication/ and implement the authentication system according to all requirements and design constraints. Update tasks.md as you complete each task."

# Claude Code will:
# 1. Read and understand all specification documents
# 2. Follow the technical design from design.md
# 3. Implement each requirement from requirements.md
# 4. Test each scenario from scenarios.md
# 5. Update task completion in tasks.md
# 6. Report completion when all acceptance criteria are met
```

## Results Metrics

### Project Success Indicators
- **Specification Coverage**: 100% of functionality covered in requirements
- **Task Completion Rate**: 95%+ of tasks completed as planned
- **Quality Metrics**: 90%+ of acceptance criteria met on first attempt
- **Timeline Accuracy**: Actual completion time within 20% of estimate

### Team Benefits
- **Predictability**: Project outcomes more predictable
- **Quality**: Higher code quality through design-first approach
- **Knowledge**: Complete project documentation for maintenance
- **Collaboration**: Team alignment through shared specifications

## Common Pitfalls and Solutions

### Pitfall 1: Skipping Specification Review
**Problem**: Generating specifications but not reviewing them
**Solution**: Always review and refine specifications before implementation

### Pitfall 2: Poor Task Definition
**Problem**: Tasks too large or unclear acceptance criteria
**Solution**: Break into 1-2 hour tasks with specific, testable criteria

### Pitfall 3: Documentation Drift
**Problem**: Specifications become outdated during implementation
**Solution**: Update specifications immediately when changes occur

### Pitfall 4: Ignoring Constraints
**Problem**: Claude Code implements features not following design constraints
**Solution**: Explicitly reference design.md and technical constraints in prompts

## Conclusion

The integration of Claude Code with OpenSpec methodology creates a powerful development environment that combines:

- **Claude Code's** AI-powered coding capabilities
- **OpenSpec's** structured, specification-driven approach
- **Specification-driven development** for predictable, high-quality results

This combination enables teams to build complex software systems with greater efficiency, quality, and maintainability.