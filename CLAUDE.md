# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Doom Emacs configuration directory containing the three core configuration files that define a complete Doom setup:

- `init.el` - Module selection and feature flags
- `config.el` - Personal configuration and customizations
- `packages.el` - Package declarations and external dependencies

## Essential Commands

### Syncing Configuration Changes

After modifying `init.el` or `packages.el`, you MUST run:
```bash
~/.config/emacs/bin/doom sync
```

This synchronizes the Doom configuration, installs/removes packages, and rebuilds the environment.

### Git Sync Workflow

This configuration uses git for multi-machine synchronization. Use the provided script:
```bash
./sync.sh
```

The script automatically:
- Commits local changes with timestamped messages
- Pulls remote changes with rebase
- Pushes local commits
- Warns if `doom sync` is needed after init.el/packages.el changes

### Other Doom Commands

```bash
~/.config/emacs/bin/doom upgrade    # Upgrade Doom and packages
~/.config/emacs/bin/doom doctor     # Diagnose configuration issues
~/.config/emacs/bin/doom env        # Regenerate environment variables
```

## Configuration Architecture

### Module System (init.el)

Doom uses a declarative module system via the `doom!` macro. Modules are organized into categories:
- `:completion` - Completion frameworks (using corfu + vertico)
- `:ui` - Visual/interface modules
- `:editor` - Editing behavior (evil mode enabled everywhere)
- `:emacs` - Core Emacs features
- `:tools` - Development tools (magit for git, eval with overlays)
- `:lang` - Language support (minimal: emacs-lisp, markdown, org, sh)
- `:config` - Meta-configuration (using default with bindings and smartparens)

Module flags use the `+flag` syntax to enable optional features (e.g., `(corfu +orderless)`).

### Personal Configuration (config.el)

User-specific settings follow the `after!` pattern to ensure packages are loaded before configuration:

```elisp
(after! package-name
  (setq variable value))
```

Critical configuration points:
- Always use `after!` when configuring package-specific variables
- File/directory variables (like `org-directory`) can be set directly
- Doom variables (starting with `doom-` or `+`) can be set directly

### GTD/Org-mode Setup

This configuration implements Getting Things Done (GTD) methodology:

**Org Directory**: `~/gtd/`

**Agenda Files**:
- `~/gtd/inbox.org` - Capture inbox
- `~/gtd/projects.org` - Multi-step projects
- `~/gtd/areas.org` - Areas of responsibility

**Workflow States**: `TODO` → `NEXT` → `WAITING` → `DONE`/`CANCELLED`

**Context Tags**: `@work`, `@home`, `@computer`, `@phone`, `@errands`

**Capture Templates**:
- `t` - Todo item
- `n` - Note
- `m` - Meeting

**Custom Agenda Views**:
- `w` - Work tasks (`@work` tags)
- `h` - Home tasks (`@home` tags)
- `n` - Next actions (`NEXT` state)
- `W` - Waiting items (`WAITING` state)

**Auto-save/Auto-revert**: Configured with short intervals (20 saves, 5s revert) to support multi-machine sync workflow.

## File Modification Guidelines

### When Editing init.el

- Enable/disable modules by uncommenting/commenting lines
- Add module flags with `+flag` syntax
- Always run `doom sync` after changes
- Restart Emacs after sync completes

### When Editing config.el

- Use `after!` for package-specific configuration
- Follow existing patterns for consistency
- GTD-related changes should maintain the three-file structure (inbox/projects/areas)

### When Editing packages.el

- Use `package!` macro for declarations
- Add `:recipe` for non-standard sources
- Use `:disable t` to disable built-in packages
- Always run `doom sync` after changes
