---
permalink: /labs/lab-03-complexity/
title: "Lab 03: Complexity Analysis"
description: "Analyze cyclomatic complexity across all 5 demo apps using Lizard and convert results to SARIF format."
---

# Lab 03: Complexity Analysis

| Duration | Level | Prerequisites |
|----------|-------|---------------|
| 30 min | Intermediate | Lab 02 |

## Learning Objectives

- Understand cyclomatic complexity (CCN) and why it matters
- Run Lizard to measure function-level complexity
- Interpret CCN scores, function length, and parameter counts
- Convert Lizard output to SARIF format using `lizard-to-sarif.py`
- Identify functions that exceed complexity thresholds

## Prerequisites

- Completed [Lab 02: Linting](../lab-02-linting/)
- Lizard installed (`pip install lizard`)

## Exercises

### Exercise 1: Understand Cyclomatic Complexity

Cyclomatic complexity (CCN) measures the number of independent execution paths through a function. Higher CCN means more paths to test, harder-to-understand code, and higher defect probability.

| CCN Range | Risk Level | Action |
|-----------|-----------|--------|
| 1–5 | Low | Simple, easy to test |
| 6–10 | Moderate | Acceptable, consider refactoring |
| 11–20 | High | Should be refactored — CI warning |
| 21+ | Very High | Must be refactored — CI error |

The workshop uses a **threshold of 10** for the CI quality gate.

### Exercise 2: Run Lizard Across All Apps

> **Working Directory**: Run the following commands from the `code-quality-scan-demo-app` repository root.

Run Lizard across all demo apps to get a summary:

```powershell
lizard cq-demo-app-001/src cq-demo-app-002/src cq-demo-app-003/src cq-demo-app-004/src cq-demo-app-005/ --CCN 10
```

Lizard outputs a table with these columns:

| Column | Description |
|--------|-------------|
| NLOC | Non-comment Lines of Code |
| CCN | Cyclomatic Complexity Number |
| Token | Token count |
| PARAM | Number of parameters |
| Length | Total function length in lines |
| Location | File path and function name |

![Lizard output showing complexity metrics](../images/lab-03/lab-03-lizard-output.png)

### Exercise 3: Generate CSV Output

Generate CSV output for programmatic processing:

```powershell
lizard cq-demo-app-001/src cq-demo-app-002/src cq-demo-app-003/src cq-demo-app-004/src cq-demo-app-005/ --csv > lizard-output.csv
```

View the first few lines of the CSV:

```powershell
Get-Content lizard-output.csv | Select-Object -First 15
```

The CSV contains one row per function with columns: NLOC, CCN, Token, PARAM, Length, Location, File, Function, Start, End.

![Lizard CSV output](../images/lab-03/lab-03-lizard-csv.png)

### Exercise 4: Convert to SARIF Format

Use the `lizard-to-sarif.py` converter to transform Lizard CSV output into SARIF:

```powershell
python src/converters/lizard-to-sarif.py --input lizard-output.csv --output complexity.sarif --ccn-threshold 10 --length-threshold 50
```

The converter creates a SARIF result for each function that exceeds either threshold:

- **CCN > 10**: Flagged as a complexity violation
- **Length > 50 lines**: Flagged as a function length violation

Examine the generated SARIF:

```powershell
Get-Content complexity.sarif | ConvertFrom-Json | Select-Object -ExpandProperty runs | Select-Object -ExpandProperty results | Select-Object ruleId, level, @{N='function';E={$_.locations[0].physicalLocation.artifactLocation.uri}} | Format-Table
```

![lizard-to-sarif.py conversion output](../images/lab-03/lab-03-sarif-conversion.png)

### Exercise 5: Identify High-Complexity Functions

Filter for functions that exceed the CCN threshold:

```powershell
lizard cq-demo-app-001/src cq-demo-app-002/src cq-demo-app-003/src cq-demo-app-004/src cq-demo-app-005/ --CCN 10 --warnings_only
```

For each flagged function, note:

1. **Which function** has high complexity
2. **What causes it** — nested `if/else`, `switch` statements, loops within loops
3. **How to fix it** — extract helper functions, use early returns, replace conditionals with lookup tables

![Functions exceeding CCN threshold](../images/lab-03/lab-03-high-ccn-functions.png)

### Exercise 6: Analyze Nesting Depth

Look at the highest-complexity functions and identify nesting patterns:

```powershell
lizard cq-demo-app-001/src cq-demo-app-002/src --CCN 15 --warnings_only -L 100
```

Common causes of high complexity:

| Pattern | CCN Impact | Refactoring Strategy |
|---------|-----------|---------------------|
| Nested `if/else` chains | +1 per branch | Extract to guard clauses with early returns |
| `switch` with many cases | +1 per case | Use lookup table / dictionary |
| Loop + conditional | Multiplicative | Extract inner logic to a function |
| Try/catch with retry | +2–3 | Extract retry logic to utility |

## Verification Checkpoint

Verify your work before continuing:

- [ ] Lizard ran successfully across all 5 demo apps
- [ ] You generated `lizard-output.csv` with function-level metrics
- [ ] You converted the CSV to `complexity.sarif` using `lizard-to-sarif.py`
- [ ] You identified at least 3 functions with CCN > 10
- [ ] You understand the difference between CCN and function length

## Summary

Cyclomatic complexity analysis with Lizard provides function-level quality metrics that complement lint findings. High-CCN functions are harder to test, more error-prone, and difficult to maintain. By converting Lizard output to SARIF, you can track complexity trends alongside lint and coverage findings in a unified dashboard.

The workshop threshold of CCN ≤ 10 aligns with industry best practices. Functions exceeding this threshold should be refactored by extracting helper functions, using early returns, and replacing complex conditionals with lookup patterns.

## Next Steps

Proceed to [Lab 04: Duplication Detection](../lab-04-duplication/).
