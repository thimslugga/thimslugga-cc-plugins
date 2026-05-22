---
description: Fully autonomous plugin improvement - agents discover, decide, and complete all improvements with minimal context usage
---

# Auto-Improve All Plugins

## Purpose

**Fully autonomous improvement** of every plugin in the repository. Each plugin's expert agent will:

1. **Self-determine** what needs improvement using web search
2. **Autonomously decide** what features/fixes to add
3. **Complete all improvements** themselves (no pausing, no asking)
4. **Minimize context usage** by doing all work within agent contexts

## Process

**DO NOT do the work yourself.** Launch agents and let them do ALL the work autonomously.

### Step 1: Launch All Plugin Expert Agents in Parallel

Use a **single message with multiple Task tool calls** to launch all agents simultaneously.

**Plugins to improve (12 total):**

- bash-expert → `bash-expert:bash-expert`
- database-expert → `general-purpose` agent
- developer → `general-purpose` agent
- doc-expert → `doc-expert:doc-expert`
- docker-expert → `docker-expert:docker-expert`
- git-expert → `git-expert:git-expert`
- plugin-expert → `plugin-expert:plugin-expert`
- powershell-expert → `powershell-expert:powershell-expert`
- python-development → `general-purpose` agent
- python-expert → `python-expert:python-expert`
- terraform-expert → `terraform-expert:terraform-expert`
- windows-path-expert → `windows-path-expert:windows-path-expert`

### Step 2: Provide Autonomous Improvement Instructions

Give each agent these instructions:

```text
You are the expert for the [PLUGIN_NAME] plugin in the thimslugga-cc-plugins repository.

Your task: AUTONOMOUSLY IMPROVE your plugin. You will:
1. Self-determine what needs improvement (no one will tell you what to do)
2. Decide what features/fixes to add (use your expert judgment)
3. Complete ALL improvements yourself (do not pause or ask for approval)
4. Work entirely within your own context (minimize main context usage)

AUTONOMOUS IMPROVEMENT PROCESS:

1. **SELF-ASSESS Your Plugin**
   - Read all files in plugins/[PLUGIN_NAME]/ directory
   - Use your expert knowledge to identify gaps
   - Look for outdated patterns, missing features, verbose content

2. **DISCOVER Current State-of-the-Art**
   - WebSearch: "[TECHNOLOGY] new features 2025"
   - WebSearch: "[TECHNOLOGY] breaking changes 2025"
   - WebSearch: "[TECHNOLOGY] best practices 2025"
   - YOU DECIDE what's worth adding based on findings

3. **AUTONOMOUSLY DECIDE Improvements to Make**
   Based on your assessment and research, decide:
   - Which features to add (pick the most valuable ones)
   - What bugs/issues to fix (prioritize critical ones)
   - What content to optimize (target 20-40% reduction)
   - What new files to create (if gaps are significant)
   - What version bump is appropriate

   DO NOT ask for approval. Use your expert judgment.

4. **COMPLETE ALL IMPROVEMENTS (No Pausing)**
   Execute your decisions:
   - CREATE new command/skill files for new capabilities
   - EDIT existing files to add features and fix issues
   - USE `scripts/version_ops.py` for version bumps (MANDATORY)
   - REMOVE duplicate content across files
   - REPLACE deprecated features with current alternatives
   - VALIDATE all examples work with current versions
   - **ENSURE PORTABILITY** - Remove all user-specific paths,
     machine names, personal info, and private project references

5. **REPORT Your Autonomous Improvements**
   After completing all improvements, provide:
   - **Decisions Made**: What you decided to improve and why
   - **New Features Added**: List of new features now documented
   - **Files Created**: New command/skill files created
   - **Files Enhanced**: Existing files updated
   - **Bugs Fixed**: Critical issues corrected
   - **Content Optimized**: Deduplication percentage achieved
   - **Version Bumped**: New version applied via `version_ops.py`
   - **Portability Verified**: No user-specific content remains

CRITICAL RULES:
✓ COMPLETE all improvements before reporting (no pausing)
✓ MAKE actual changes (do not just identify issues)
✓ USE your expert judgment to prioritize improvements
✓ ALWAYS bump versions with `python3 scripts/version_ops.py`
✗ DO NOT ask for approval or confirmation
✗ DO NOT pause mid-improvement to check in
✗ DO NOT create placeholder content
✗ DO NOT include hardcoded paths like C:\Users\name or /home/user
✗ DO NOT include personal email addresses or usernames in examples

BEGIN AUTONOMOUS IMPROVEMENT NOW.
```

### Step 3: Wait for Agent Results

After launching all agents in parallel:

1. Agents work autonomously in their own contexts
2. Each agent self-assesses, decides improvements, and completes them
3. Primary context usage remains minimal
4. Collect reports when all agents finish

### Step 4: Update README.md

After all agents complete, sync the main README.md:

1. Read current `marketplace.json` for latest descriptions and versions
2. Update plugin table in `README.md` to match
3. Verify all 12 plugins are listed with correct versions

### Step 5: Summarize Results

- **Total plugins improved**: Count (should be 12)
- **New features added**: Aggregate across all plugins
- **Files created/enhanced**: Totals
- **Versions bumped**: List all plugins with version updates
- **README.md updated**: Confirm descriptions synchronized

## Expected Outcomes

1. **New features added** across all plugins
2. **Files enhanced** with current best practices
3. **Bugs fixed** — outdated info and deprecated code corrected
4. **Content optimized** — redundant content removed
5. **Version bumps** applied through `scripts/version_ops.py`
6. **README.md synchronized** with current plugin state
7. **100% portable** — no user-specific paths or personal info

## Manual Steps After Completion

1. **Review improvements**: `git diff` to see all changes
2. **Verify versions**: `python3 scripts/version_ops.py --validate`
3. **Validate metadata**: `python3 scripts/version_ops.py --validate --metadata all`
4. **Check portability**: Search for `C:\Users`, `/home/`, personal emails
5. **Test new features**: Validate new commands and examples work
6. **Commit improvements**: Descriptive commit message

## Related Commands

- `/plugin-expert:validate-plugin` - Validate structure after improvements
- `/git-expert:git-cleanup` - Clean up after major updates
