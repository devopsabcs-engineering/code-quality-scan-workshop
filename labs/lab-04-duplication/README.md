---
permalink: /labs/lab-04-duplication/
title: "Lab 04: Duplication Detection"
description: "Detect code duplication across the codebase using jscpd and configure detection thresholds."
---

# Lab 04: Duplication Detection

| Duration | Level | Prerequisites |
|----------|-------|---------------|
| 30 min | Intermediate | Lab 03 |

## Learning Objectives

- Run jscpd to detect code duplication across multiple languages
- Interpret duplication reports and understand clone types
- Configure jscpd thresholds using `.jscpd.json`
- Understand the relationship between duplication and maintainability
- Review SARIF output from jscpd

## Prerequisites

- Completed [Lab 03: Complexity Analysis](../lab-03-complexity/)
- jscpd installed (`npm install -g jscpd`)

## Exercises

### Exercise 1: Run jscpd Across the Codebase

> **Working Directory**: Run the following commands from the `code-quality-scan-demo-app` repository root.

Run jscpd across all 5 demo apps:

```powershell
jscpd cq-demo-app-001/src cq-demo-app-002/src cq-demo-app-003/src cq-demo-app-004/src cq-demo-app-005/
```

jscpd scans for blocks of duplicated code (clones) across files and languages. The output shows:

- **Source** and **target** file locations
- **Lines** of duplicated code
- **Percentage** of duplication in the codebase

![jscpd output showing duplicates](../images/lab-04/lab-04-jscpd-output.png)

### Exercise 2: Generate an HTML Report

Generate a detailed HTML report for visual inspection:

```powershell
jscpd cq-demo-app-001/src cq-demo-app-002/src cq-demo-app-003/src cq-demo-app-004/src cq-demo-app-005/ --reporters html --output jscpd-report
```

Open the report:

```powershell
# In a Codespace, use the built-in preview or port forwarding
# Locally, open the file directly:
Start-Process jscpd-report/html/index.html
```

The HTML report provides:

- A summary table showing duplication percentage per file
- Side-by-side comparison of duplicated blocks
- File-level and project-level duplication metrics

![jscpd HTML report](../images/lab-04/lab-04-duplication-report.png)

### Exercise 3: Understand Clone Types

jscpd detects different types of code clones:

| Type | Name | Description | Example |
|------|------|-------------|---------|
| Type 1 | Exact | Identical code blocks (whitespace/comments may differ) | Copy-pasted function |
| Type 2 | Renamed | Structurally identical but with renamed identifiers | Same logic with different variable names |
| Type 3 | Near-miss | Similar code with minor modifications | Same algorithm with a few extra lines |

Review a detected clone in detail:

```powershell
jscpd cq-demo-app-001/src cq-demo-app-002/src --min-lines 5 --reporters consoleFull
```

![Clone detail view](../images/lab-04/lab-04-clone-details.png)

### Exercise 4: Configure Detection Thresholds

jscpd can be configured with a `.jscpd.json` file at the repository root. Examine the existing configuration:

```powershell
Get-Content src/config/.jscpd.json
```

A typical configuration looks like:

```json
{
  "threshold": 5,
  "reporters": ["json", "consoleFull"],
  "ignore": [
    "**/node_modules/**",
    "**/*.test.*",
    "**/*_test.go",
    "**/bin/**",
    "**/obj/**",
    "**/target/**"
  ],
  "minLines": 10,
  "minTokens": 50,
  "output": "jscpd-report"
}
```

Key configuration options:

| Option | Default | Description |
|--------|---------|-------------|
| `threshold` | 0 | Maximum allowed duplication percentage (0 = no limit) |
| `minLines` | 5 | Minimum lines for a block to be considered a clone |
| `minTokens` | 50 | Minimum tokens for a block to be considered a clone |
| `ignore` | `[]` | Glob patterns for files/directories to exclude |
| `reporters` | `["consoleFull"]` | Output formats: `console`, `consoleFull`, `json`, `html`, `sarif` |

![.jscpd.json configuration](../images/lab-04/lab-04-jscpd-config.png)

### Exercise 5: Generate SARIF Output

Run jscpd with SARIF output for integration with GitHub Security tab:

```powershell
jscpd cq-demo-app-001/src cq-demo-app-002/src cq-demo-app-003/src cq-demo-app-004/src cq-demo-app-005/ --reporters sarif --output jscpd-report
```

Examine the SARIF output:

```powershell
Get-Content jscpd-report/sarif/jscpd-report.sarif | ConvertFrom-Json | Select-Object -ExpandProperty runs | Select-Object -ExpandProperty results | Measure-Object
```

Each SARIF result from jscpd includes:

- `ruleId`: `jscpd:duplication`
- `level`: `warning`
- `message`: Description of the duplicated block with source and target locations
- `locations`: File paths and line ranges

### Exercise 6: Experiment with Thresholds

Try different threshold values to see their effect:

**Strict (catch small clones):**

```powershell
jscpd cq-demo-app-001/src --min-lines 5 --min-tokens 25
```

**Relaxed (only large blocks):**

```powershell
jscpd cq-demo-app-001/src --min-lines 20 --min-tokens 100
```

Observe how the number of detected clones changes with different thresholds. The workshop default of 10 lines / 50 tokens provides a good balance between noise and detection coverage.

## Verification Checkpoint

Verify your work before continuing:

- [ ] jscpd ran successfully across all 5 demo apps
- [ ] You generated an HTML report showing duplication locations
- [ ] You can explain the difference between Type 1, Type 2, and Type 3 clones
- [ ] You understand the `.jscpd.json` configuration options
- [ ] You generated SARIF output from jscpd

## Summary

Code duplication is a maintainability risk — when duplicated code needs to change, every copy must be updated. jscpd detects duplicated blocks across files and languages, making it ideal for multi-language repositories. By configuring appropriate thresholds and generating SARIF output, duplication findings integrate with the same triage workflow as lint and complexity findings.

**Remediation strategies** for duplication:
- Extract shared logic into utility functions or modules
- Use base classes or traits for repeated patterns
- Apply the DRY (Don't Repeat Yourself) principle

## Next Steps

Proceed to [Lab 05: Coverage Analysis](../lab-05-coverage/).
