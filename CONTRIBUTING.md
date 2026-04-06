# Contributing to the Code Quality Scan Workshop

Thank you for your interest in improving this workshop! This guide explains how to contribute lab content, screenshots, and fixes.

## Getting Started

1. Fork this repository.
2. Clone your fork locally.
3. Create a feature branch: `git checkout -b feature/your-change`.
4. Make your changes following the standards below.
5. Submit a pull request against `main`.

## Lab Content Standards

### File Structure

Each lab is a directory under `labs/` with a single `README.md`:

```
labs/lab-NN-slug/
└── README.md
```

### Frontmatter

Every lab README MUST include YAML frontmatter:

```yaml
---
permalink: /labs/lab-NN-slug/
title: "Lab NN: Title"
description: "One-sentence description"
---
```

### Required Sections

Every lab README MUST include these sections in order:

1. **Title** (`# Lab NN: Title`)
2. **Metadata table** (Duration, Level, Prerequisites)
3. **Learning Objectives** (3–5 bullets)
4. **Prerequisites** (tools, prior labs)
5. **Exercises** (numbered steps with commands and screenshots)
6. **Verification Checkpoint** (checklist)
7. **Summary** (key takeaways)
8. **Next Steps** (link to next lab)

### Commands

- Use **PowerShell Core** syntax for all commands.
- Wrap commands in fenced code blocks with `powershell` language tag.
- Never use Unix-only commands (`head`, `tail`, `cat`, `2>/dev/null`).

### Working Directory Callouts

When a step requires running commands in the demo-app repository, include:

```markdown
> **Working Directory**: Run the following commands from the `code-quality-scan-demo-app` repository root.
```

## Screenshot Standards

### Naming Convention

```
lab-NN-description-slug.png
```

Examples:
- `lab-02-eslint-output.png`
- `lab-06-security-tab-results.png`

### Screenshot References

Place screenshot references after the step that produces visible output:

```markdown
![ESLint results showing 12 warnings](../../images/lab-02/lab-02-eslint-output.png)
```

### Adding New Screenshots

1. Add an entry to `scripts/screenshot-manifest.json`.
2. Run `scripts/capture-screenshots.ps1` to generate the screenshot.
3. Place the generated PNG in the appropriate `images/lab-NN/` directory.
4. Update the `images/lab-NN/README.md` inventory.

### Image Directory README

Each `images/lab-NN/` directory has a `README.md` listing all screenshots:

```markdown
# Lab NN Screenshots

| File | Description |
|------|-------------|
| `lab-NN-slug.png` | Description of what the screenshot shows |
```

## Delivery Guides

The `delivery/` directory contains facilitator guides:

- `half-day.md` — 3.5-hour delivery guide (Labs 00–05 + Lab 06)
- `full-day.md` — 7-hour delivery guide (all labs)

When adding labs, update both delivery guides with timing adjustments.

## Pull Request Process

1. Ensure your changes render correctly with Jekyll locally (`bundle exec jekyll serve`).
2. Verify all screenshot references resolve to existing files.
3. Test any commands in a GitHub Codespace.
4. Update the screenshot manifest if adding new screenshots.
5. Submit a PR with a clear description of changes.

## Code of Conduct

Be respectful, constructive, and inclusive. We follow the [Contributor Covenant](https://www.contributor-covenant.org/) Code of Conduct.
