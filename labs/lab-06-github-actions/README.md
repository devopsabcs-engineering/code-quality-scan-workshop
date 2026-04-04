---
permalink: /labs/lab-06-github-actions/
title: "Lab 06: GitHub Actions CI/CD"
description: "Explore the code-quality-scan.yml workflow, run it via GitHub Actions, and view SARIF results in GitHub Security tab."
---

# Lab 06: GitHub Actions CI/CD

| Duration | Level | Prerequisites |
|----------|-------|---------------|
| 30 min | Intermediate | Lab 05 |

## Learning Objectives

- Understand the `code-quality-scan.yml` GitHub Actions workflow structure
- Run the scan workflow manually via workflow dispatch
- View SARIF results in the GitHub Security tab
- Filter findings by severity, category, and tool
- Understand the matrix strategy for multi-app scanning

## Prerequisites

- Completed [Lab 05: Coverage Analysis](../lab-05-coverage/)
- Your fork of `code-quality-scan-demo-app` pushed to GitHub
- GitHub Advanced Security enabled on the repository (free for public repos)

## Exercises

### Exercise 1: Explore the Scan Workflow

> **Working Directory**: Run the following commands from the `code-quality-scan-demo-app` repository root.

Open the central scan workflow file:

```powershell
Get-Content .github/workflows/code-quality-scan.yml
```

Key workflow sections:

| Section | Purpose |
|---------|---------|
| `on:` | Triggers: `push` to main, `pull_request`, and `workflow_dispatch` (manual) |
| `strategy.matrix` | Scans all 5 apps: `app: [001, 002, 003, 004, 005]` |
| `steps` — Lint | Runs the per-language linter for the target app |
| `steps` — Complexity | Runs Lizard and converts to SARIF |
| `steps` — Duplication | Runs jscpd across the app |
| `steps` — Coverage | Runs tests with coverage and converts to SARIF |
| `steps` — Upload | Uploads all SARIF files to GitHub Security tab |

The workflow uses a **matrix strategy** to scan all 5 apps in parallel:

```yaml
strategy:
  matrix:
    app: [001, 002, 003, 004, 005]
  fail-fast: false
```

Each matrix job uploads SARIF with a unique category prefix: `code-quality-scan/${{ matrix.app }}`.

![code-quality-scan.yml workflow](../images/lab-06/lab-06-workflow-file.png)

### Exercise 2: Run the Workflow Manually

Trigger the scan workflow using the GitHub CLI:

```powershell
gh workflow run code-quality-scan.yml --ref main
```

Monitor the workflow run:

```powershell
gh run list --workflow=code-quality-scan.yml --limit 1
```

Wait for the run to complete (this takes 3–5 minutes depending on the runners):

```powershell
$runId = gh run list --workflow=code-quality-scan.yml --limit 1 --json databaseId --jq ".[0].databaseId"
gh run watch $runId
```

![GitHub Actions workflow run](../images/lab-06/lab-06-actions-run.png)

### Exercise 3: View Workflow Results

Once the workflow completes, check the status:

```powershell
gh run view $runId
```

View the logs for a specific matrix job:

```powershell
gh run view $runId --log | Select-Object -First 100
```

![Workflow run completed](../images/lab-06/lab-06-actions-complete.png)

### Exercise 4: Explore the GitHub Security Tab

Open the GitHub Security tab in your browser:

```powershell
$repoUrl = gh repo view --json url --jq ".url"
Start-Process "$repoUrl/security/code-scanning"
```

Or navigate manually: **Repository → Security → Code scanning alerts**.

The Security tab shows all SARIF findings uploaded by the workflow:

- **Code scanning alerts** — findings from linters, complexity, and duplication
- **Severity filtering** — filter by Error, Warning, or Note
- **Tool filtering** — filter by ESLint, Ruff, Lizard, jscpd, etc.
- **Category filtering** — filter by `code-quality-scan/001` through `code-quality-scan/005`

![GitHub Security tab with SARIF findings](../images/lab-06/lab-06-security-tab.png)

### Exercise 5: Filter Findings

In the GitHub Security tab, practice filtering:

**By severity:**
- Click **Error** to see only critical findings (CCN > 20, coverage < 50%)
- Click **Warning** to see moderate findings (CCN 11–20, coverage 50–79%)

**By tool:**
- Filter by tool name to see findings from a specific scanner

**By category:**
- Use the category filter to see findings for a specific demo app

![Filtering findings by severity](../images/lab-06/lab-06-security-filter.png)

### Exercise 6: Examine a Finding Detail

Click on any finding to see its detail view:

- **Rule description** — what the rule checks for
- **Location** — file path and line number
- **Remediation guidance** — how to fix the issue
- **Help documentation** — link to the rule's documentation

![Finding detail view](../images/lab-06/lab-06-finding-detail.png)

The SARIF `help.markdown` field is rendered here, providing context-specific remediation guidance. This is why SARIF enrichment (adding `help.markdown`, `properties.tags`, and `partialFingerprints`) is important — it makes the triage experience richer.

## Verification Checkpoint

Verify your work before continuing:

- [ ] You triggered the `code-quality-scan.yml` workflow successfully
- [ ] The workflow completed with all 5 matrix jobs
- [ ] You can view SARIF findings in the GitHub Security tab
- [ ] You filtered findings by severity, tool, and category
- [ ] You examined the detail view of at least one finding

## Summary

The `code-quality-scan.yml` workflow automates the entire 4-tool scanning architecture in GitHub Actions. Using a matrix strategy, it scans all 5 demo apps in parallel and uploads results to the GitHub Security tab via SARIF. This provides a centralized view of all code quality findings — lint errors, complexity warnings, duplication, and coverage gaps — in a single dashboard.

Key takeaways:
- **Matrix strategy** enables parallel scanning across multiple apps
- **SARIF upload** via `codeql-action/upload-sarif@v4` integrates with GitHub Security
- **Category prefixes** separate findings by app for easier triage
- **Enriched SARIF** (help.markdown, tags, fingerprints) improves the triage experience

## Next Steps

Proceed to [Lab 07: Remediation (GitHub)](../lab-07-remediation-github/) or go back to try [Lab 06-ADO: ADO Pipelines CI/CD](../lab-06-ado-pipelines/).
