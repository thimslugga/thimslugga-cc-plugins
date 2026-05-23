# thimslugga-cc-plugins

A curated collection of Claude Code plugins covering development tooling, infrastructure, documentation and language expertise.

## Plugins

| Plugin | Description | Version |
|--------|-------------|---------|
| [developer](plugins/developer) | General development workflows and tooling | 1.0.0 |
| [git-expert](plugins/git-expert) | Git 2.49+, GitHub CLI, signed commits, safety guardrails | 1.0.0 |
| [plugin-expert](plugins/plugin-expert) | Claude Code plugin development, validation, and publishing | 1.0.0 |
| [bash-expert](plugins/bash-expert) | Bash 5.x+ scripting, ShellCheck | 1.0.0 |
| [powershell-expert](plugins/powershell-expert) | PowerShell 7.5+ | 1.0.0 |
| [windows-path-expert](plugins/windows-path-expert) | Windows path resolution, Git Bash compatibility | 1.0.0 |
| [doc-expert](plugins/doc-expert) | Documentation, Markdown, ADR authoring| 1.0.0 |
| [docker-expert](plugins/docker-expert) | Docker, Containers, OCI | 1.0.0 |
| [python-development](plugins/python-development) | Django, FastAPI, async patterns, uv, ruff, ty | 1.0.0 |
| [python-expert](plugins/python-expert) | Python 3.13+, asyncio, FastAPI, pytest, uv, ruff, ty | 1.0.0 |
| [terraform-expert](plugins/terraform-expert) | Terraform/OpenTofu, IaC, AWS/Azure/GCP | 1.0.0 |
| [database-expert](plugins/database-expert) | SQL, PostgreSQL, RedShift | 1.0.0 |

## Installation

Plugins can be installed directly from this repo via Claude Code's plugin system.

```bash
claude plugin marketplace add thimslugga/thimslugga-cc-plugins
claude plugin install <plugin-name>
```

OR

```bash
# Add this marketplace to Claude Code
/plugin marketplace add thimslugga/thimslugga-cc-plugins

# Install a specific plugin
/plugin install <plugin-name>@thimslugga-cc-plugins
```

For example:

```bash
# Install a specific plugin
/plugin install developer@thimslugga
/plugin install windows-path-expert@thimslugga
```

## Repository Structure

```text
thimslugga-cc-plugins/
├── .claude-plugin/
│   └── marketplace.json      # Central plugin registry
├── plugins/
│   └── <plugin-name>/
│       ├── .claude-plugin/
│       │   └── plugin.json   # Plugin config (version must match marketplace)
│       ├── agents/           # Agent definitions
│       ├── skills/           # Skill knowledge bases
│       ├── commands/         # Slash commands
│       └── hooks/            # Lifecycle hooks
└── scripts/
    ├── version_ops.py        # Version management
    └── validate_plugins.py   # Plugin structure validation
```

## Plugin Structure

Each plugin follows a standard structure:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json      # Plugin metadata (required)
├── .mcp.json            # MCP server configuration (optional)
├── commands/            # Slash commands (optional)
├── agents/              # Agent definitions (optional)
├── skills/              # Skill definitions (optional)
└── README.md            # Documentation
```

## Version Management

Versions are kept in sync between each plugin's `plugin.json` and the central `marketplace.json`. Always use the version script — never edit versions by hand.

```bash
# Bump a single plugin after making changes
python3 scripts/version_ops.py -b patch -p <plugin-name>

# Bump all plugins
python3 scripts/version_ops.py -b patch --all

# Validate versions are in sync
python3 scripts/version_ops.py --validate

# Sync if they drift
python3 scripts/version_ops.py --sync
```

Version bump guide:

- `patch` — bug fixes, docs, minor tweaks
- `minor` — new features, skills, or agents
- `major` — breaking changes

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `python3 scripts/validate_plugins.py` to check structure
5. Run `python3 scripts/version_ops.py --validate` to check version sync
6. Submit a pull request

## License

MIT - see [LICENSE](LICENSE)
