---
permalink: /labs/lab-07-ado-remediation/
title: "Lab 07-ADO: ADO Remediation"
description: "Fix code quality violations in the ADO repository, re-run the ADO pipeline, and verify reduced findings in ADO Advanced Security."
---

# Lab 07-ADO: ADO Remediation

| Duration | Level | Prerequisites |
|----------|-------|---------------|
| 45 min | Advanced | Lab 06-ADO |

## Learning Objectives

- Apply code quality fixes to the Azure DevOps repository
- Push fixes and trigger an automated pipeline re-run
- Verify reduced findings in ADO Advanced Security
- Compare the remediation workflow between GitHub and ADO

## Prerequisites

- Completed [Lab 06-ADO: ADO Pipelines CI/CD](../lab-06-ado-pipelines/)
- Write access to the imported ADO repository
- ADO Advanced Security enabled

## Exercises

### Exercise 1: Clone the ADO Repository

If you haven't already cloned the ADO repository, do so now:

```powershell
git clone https://MngEnvMCAP675646@dev.azure.com/MngEnvMCAP675646/Agentic%20Accelerator%20Framework/_git/code-quality-scan-demo-app
cd code-quality-scan-demo-app
```

> **Note**: Replace the organization and project names if you are using a different ADO instance.

### Exercise 2: Fix Lint Violations

Apply the same lint fixes as in Lab 07 (GitHub). Start with auto-fix:

```powershell
cd cq-demo-app-001
npm install
npx eslint src/ --fix
```

Fix remaining violations manually:

```powershell
npx eslint src/
```

Apply fixes for the Python app:

```powershell
cd ../cq-demo-app-002
ruff check src/ --fix
ruff check src/
```

```powershell
cd ..
```

### Exercise 3: Reduce Complexity and Add Tests

Follow the same refactoring techniques from Lab 07:

1. **Extract helper functions** to reduce cyclomatic complexity below 10
2. **Add test files** for untested modules to improve coverage above 80%
3. **Extract duplicated code** into shared utility modules

Verify your changes:

```powershell
lizard cq-demo-app-001/src --CCN 10 --warnings_only
```

![Code fix applied in ADO](../images/lab-07-ado/lab-07-ado-code-fix.png)

### Exercise 4: Push Fixes to ADO

Commit and push your fixes:

```powershell
git add -A
git commit -m "fix: reduce lint violations, complexity, and duplication across demo apps"
git push origin main
```

The push to `main` automatically triggers the `code-quality-scan.yml` pipeline in ADO.

### Exercise 5: Monitor the Pipeline Re-Run

1. Navigate to **Pipelines → Recent runs** in ADO.
2. Find the triggered pipeline run.
3. Wait for all 5 matrix jobs to complete.

![ADO pipeline re-run](../images/lab-07-ado/lab-07-ado-pipeline-rerun.png)

### Exercise 6: Verify Reduced Findings

1. Navigate to **Repos → Advanced Security** in ADO.
2. Compare the findings count with the previous scan.
3. Verify that:
   - Lint findings are reduced (fixed violations no longer appear)
   - Complexity warnings are reduced (refactored functions pass the threshold)
   - Coverage findings are reduced (new tests improve file-level coverage)

![ADO Advanced Security showing reduced findings](../images/lab-07-ado/lab-07-ado-reduced-findings.png)

### Exercise 7: Compare GitHub and ADO Remediation Workflows

| Aspect | GitHub | Azure DevOps |
|--------|--------|-------------|
| Push trigger | `push` to `main` in `.github/workflows/` | `trigger.branches.include` in `.azuredevops/pipelines/` |
| SARIF upload | `codeql-action/upload-sarif@v4` | `AdvancedSecurity-Publish@1` |
| Results view | Security → Code scanning alerts | Repos → Advanced Security |
| Finding lifecycle | Open → Dismissed/Fixed | Active → Fixed |
| PR integration | Code scanning checks | Advanced Security annotations |
| Auto-fix | ESLint `--fix`, Ruff `--fix` | Same tools, same flags |

The remediation workflow is identical regardless of platform — fix the code, push, re-scan. Only the CI/CD configuration and results dashboard differ.

## Verification Checkpoint

Verify your work before continuing:

- [ ] You applied lint fixes to at least one demo app
- [ ] You pushed fixes to the ADO repository
- [ ] The pipeline re-ran automatically after the push
- [ ] ADO Advanced Security shows fewer findings than before
- [ ] You understand the differences between GitHub and ADO remediation workflows

## Summary

The remediation workflow in Azure DevOps mirrors the GitHub workflow: fix violations locally, push to the repository, and the CI pipeline automatically re-scans the code. ADO Advanced Security tracks findings over time, showing which issues have been resolved. The key advantage of both platforms is the **scan → fix → re-scan feedback loop**, which enables continuous quality improvement.

## Next Steps

Proceed to [Lab 08: Power BI Dashboard](../lab-08-dashboard/).
