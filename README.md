# thimslugga-cc-plugins

A curated collection of Claude Code plugins covering development tooling, infrastructure, documentation, and language expertise.

## Plugins

| Plugin | Description | Version |
|--------|-------------|---------|
| [bash-expert](plugins/bash-expert) | Bash 5.3 scripting, ShellCheck, security-first patterns, cross-platform | 1.0.0 |
| [database-expert](plugins/database-expert) | SQL, PostgreSQL, Redshift | 1.0.0 |
| [developer](plugins/developer) | General development workflows and tooling | 1.0.0 |
| [doc-expert](plugins/doc-expert) | ADR authoring, Markdown lint, documentation diagnostics | 1.0.0 |
| [docker-expert](plugins/docker-expert) | Docker 2025 features, multi-stage builds, security hardening | 1.5.8 |
| [git-expert](plugins/git-expert) | Git 2.49+, GitHub CLI, signed commits, safety guardrails | 1.5.6 |
| [plugin-expert](plugins/plugin-expert) | Claude Code plugin development, validation, and publishing | 1.0.0 |
| [powershell-expert](plugins/powershell-expert) | PowerShell 7.5+, Az/Graph/PnP modules, cross-platform | 2.0.6 |
| [python-development](plugins/python-development) | Django, FastAPI, async patterns, uv | 1.0.0 |
| [python-expert](plugins/python-expert) | Python 3.13+, asyncio, type hints, FastAPI, pytest, Ruff | 2.3.6 |
| [terraform-expert](plugins/terraform-expert) | Terraform/OpenTofu, Azure/AWS/GCP, state management, CI/CD | 1.0.0 |
| [windows-path-expert](plugins/windows-path-expert) | Windows path resolution, Git Bash/MINGW compatibility | 1.0.0 |

## Installation

```bash
# Add this marketplace to Claude Code
/plugin marketplace add thimslugga https://github.com/thimslugga/thimslugga-cc-plugins

# Install a specific plugin
/plugin install bash-expert@thimslugga
/plugin install docker-expert@thimslugga
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

MIT — see [LICENSE](LICENSE)
