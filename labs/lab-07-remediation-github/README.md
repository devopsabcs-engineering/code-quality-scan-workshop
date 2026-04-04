---
permalink: /labs/lab-07-remediation-github/
title: "Lab 07: Remediation (GitHub)"
description: "Fix code quality violations, reduce complexity, add tests, extract duplicated code, and verify improvements with a re-scan."
---

# Lab 07: Remediation (GitHub)

| Duration | Level | Prerequisites |
|----------|-------|---------------|
| 45 min | Advanced | Lab 06 |

## Learning Objectives

- Fix lint violations identified by per-language linters
- Reduce cyclomatic complexity by extracting functions
- Add tests to improve coverage above the 80% threshold
- Extract duplicated code into shared utilities
- Re-run the scan workflow and verify reduced findings in GitHub Security tab

## Prerequisites

- Completed [Lab 06: GitHub Actions CI/CD](../lab-06-github-actions/)
- Your fork of `code-quality-scan-demo-app` pushed to GitHub
- Familiarity with at least one of the demo app languages

## Exercises

### Exercise 1: Fix Lint Violations (cq-demo-app-001)

> **Working Directory**: Run the following commands from the `code-quality-scan-demo-app` repository root.

Start by auto-fixing what ESLint can handle automatically:

```powershell
cd cq-demo-app-001
npx eslint src/ --fix
```

Check remaining violations that require manual fixes:

```powershell
npx eslint src/
```

Common manual fixes:

| Violation | Fix |
|-----------|-----|
| `@typescript-eslint/no-unused-vars` | Remove the unused variable or prefix with `_` |
| `@typescript-eslint/no-explicit-any` | Replace `any` with a specific type |
| `prefer-const` | Change `let` to `const` for never-reassigned variables |

![Code before fixes](../images/lab-07/lab-07-before-fix.png)

After fixing, verify zero lint violations:

```powershell
npx eslint src/
```

```powershell
cd ..
```

### Exercise 2: Reduce Complexity

Identify the highest-complexity functions:

```powershell
lizard cq-demo-app-001/src --CCN 10 --warnings_only
```

For each high-complexity function, apply these refactoring techniques:

**Technique 1: Extract Helper Functions**

Before (CCN = 15):
```typescript
function processOrder(order: Order): Result {
  if (order.type === 'standard') {
    if (order.items.length > 10) {
      // ... 20 lines of bulk processing
    } else {
      // ... 15 lines of small order processing
    }
  } else if (order.type === 'express') {
    // ... 15 lines of express processing
  } else if (order.type === 'international') {
    // ... 15 lines of international processing
  }
  // ... validation, logging, notification
}
```

After (CCN = 3):
```typescript
function processOrder(order: Order): Result {
  const processor = getProcessor(order.type);
  const result = processor(order);
  logResult(result);
  notifyCustomer(result);
  return result;
}
```

**Technique 2: Early Returns (Guard Clauses)**

Before:
```typescript
function validate(input: Input): boolean {
  if (input !== null) {
    if (input.name !== '') {
      if (input.age > 0) {
        return true;
      }
    }
  }
  return false;
}
```

After:
```typescript
function validate(input: Input): boolean {
  if (input === null) return false;
  if (input.name === '') return false;
  if (input.age <= 0) return false;
  return true;
}
```

![Refactored function with reduced complexity](../images/lab-07/lab-07-complexity-refactor.png)

Verify the complexity reduction:

```powershell
lizard cq-demo-app-001/src --CCN 10 --warnings_only
```

### Exercise 3: Add Tests to Improve Coverage

Identify files with low coverage:

```powershell
cd cq-demo-app-001
npm test -- --coverage --coverageReporters=text 2>&1 | Select-String "src/"
```

Create test files for uncovered modules. For example, if `src/utils/validators.ts` has low coverage:

```powershell
# Create a test file
New-Item -Path src/utils/validators.test.ts -ItemType File
```

Write tests following the AAA (Arrange-Act-Assert) pattern:

```typescript
import { validateEmail, validateAge, validateName } from './validators';

describe('validateEmail', () => {
  it('should return true for valid email', () => {
    // Arrange
    const email = 'user@example.com';
    // Act
    const result = validateEmail(email);
    // Assert
    expect(result).toBe(true);
  });

  it('should return false for email without @', () => {
    expect(validateEmail('invalid')).toBe(false);
  });

  it('should return false for empty string', () => {
    expect(validateEmail('')).toBe(false);
  });
});
```

![New test file with added test cases](../images/lab-07/lab-07-added-tests.png)

Run coverage again to verify improvement:

```powershell
npm test -- --coverage --coverageReporters=text
```

Target: ≥ 80% line coverage. Continue adding tests until you reach the threshold.

```powershell
cd ..
```

### Exercise 4: Extract Duplicated Code

Identify duplicated blocks:

```powershell
jscpd cq-demo-app-001/src --min-lines 5 --reporters consoleFull
```

For each detected clone, extract the common logic into a shared utility:

**Before** (duplicated in `routeA.ts` and `routeB.ts`):
```typescript
// routeA.ts
const normalized = input.trim().toLowerCase().replace(/\s+/g, '-');
if (normalized.length === 0) throw new Error('Invalid input');
if (normalized.length > 100) throw new Error('Input too long');

// routeB.ts
const normalized = input.trim().toLowerCase().replace(/\s+/g, '-');
if (normalized.length === 0) throw new Error('Invalid input');
if (normalized.length > 100) throw new Error('Input too long');
```

**After** (extracted to `utils/normalizer.ts`):
```typescript
// utils/normalizer.ts
export function normalizeInput(input: string): string {
  const normalized = input.trim().toLowerCase().replace(/\s+/g, '-');
  if (normalized.length === 0) throw new Error('Invalid input');
  if (normalized.length > 100) throw new Error('Input too long');
  return normalized;
}
```

![Extracted shared utility](../images/lab-07/lab-07-dedup-utility.png)

Verify duplication is reduced:

```powershell
jscpd cq-demo-app-001/src --min-lines 5
```

### Exercise 5: Commit and Push Fixes

Stage, commit, and push your changes:

```powershell
git add -A
git commit -m "fix: reduce lint violations, complexity, and duplication in cq-demo-app-001"
git push origin main
```

### Exercise 6: Re-Run the Scan and Verify Improvements

Trigger the scan workflow again:

```powershell
gh workflow run code-quality-scan.yml --ref main
```

Wait for completion:

```powershell
$runId = gh run list --workflow=code-quality-scan.yml --limit 1 --json databaseId --jq ".[0].databaseId"
gh run watch $runId
```

![Re-scan results showing reduced findings](../images/lab-07/lab-07-rescan-results.png)

Check the GitHub Security tab for the updated findings count. You should see:

- Fewer lint violations (some auto-fixed, others manually resolved)
- Reduced complexity warnings (refactored functions now below CCN 10)
- Lower duplication percentage (extracted shared utilities)
- Improved coverage (new tests covering previously untested code)

![GitHub Security tab after remediation](../images/lab-07/lab-07-security-tab-after.png)

## Verification Checkpoint

Verify your work before continuing:

- [ ] You fixed at least 5 lint violations via ESLint auto-fix and manual fixes
- [ ] You reduced CCN to ≤ 10 on at least one high-complexity function
- [ ] You added tests to improve coverage above 80% for at least one module
- [ ] You extracted duplicated code into a shared utility
- [ ] The re-scan shows fewer findings in GitHub Security tab

## Summary

Remediation is the most valuable step in the code quality scanning workflow. Finding violations is useful; fixing them improves your codebase. The key remediation strategies are:

| Strategy | Tool | Technique |
|----------|------|-----------|
| **Fix lint violations** | ESLint/Ruff | Auto-fix where possible, manual fix for complex issues |
| **Reduce complexity** | Lizard | Extract helper functions, use early returns |
| **Improve coverage** | Jest/pytest | Write targeted tests for uncovered paths |
| **Remove duplication** | jscpd | Extract shared utilities and base functions |

The scan → fix → re-scan cycle is the core workflow for continuous quality improvement.

## Next Steps

Proceed to [Lab 08: Power BI Dashboard](../lab-08-dashboard/).
