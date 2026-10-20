# kiwi-mods

Claude Code mods by David Wells.

- **predator-free**: Predator Free Aotearoa, a pest-trapping arcade game that sits above the prompt while Claude works. Type `/kiwi`. See [plugins/predator-free](plugins/predator-free/README.md).

Install: `/plugin install predator-free --marketplace DWellsBCN/kiwi-mods`, or in the desktop app + → Plugins → Add marketplace `DWellsBCN/kiwi-mods`.

## Hooks

`hooks/` holds David's session hooks: a Stop hook that asks for code review before finishing with uncommitted changes, a handoff nudge past 66% context, a guard that blocks a manual `/compact` until `docs/dave/handoff.md` is fresh, and a status line (model, repo:branch, Jira key, context %, cost).

## Cloud sessions

Cloud sessions don't load plugins or user settings from your own machine. To get everything above in every cloud session, open the environment's settings (environment selector, then the gear) and set its setup script to:

```bash
curl -fsSL https://raw.githubusercontent.com/DWellsBCN/kiwi-mods/main/cloud-setup.sh | bash
```

It clones this repo into the VM's `~/.claude/kiwi-mods`, copies the hooks into `~/.claude/hooks`, and merges the hooks, status line and the predator-free plugin folder into the VM's `~/.claude/settings.json`.
