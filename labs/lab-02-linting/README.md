---
permalink: /labs/lab-02-linting/
title: "Lab 02: Linting"
description: "Run per-language linters on all 5 demo apps and understand SARIF output format for code quality findings."
---

# Lab 02: Linting

| Duration | Level | Prerequisites |
|----------|-------|---------------|
| 45 min | Intermediate | Lab 01 |

## Learning Objectives

- Run ESLint on TypeScript code and interpret lint results
- Run Ruff on Python code and understand rule categories
- Run .NET Analyzers on C# code
- Run Checkstyle on Java code
- Run golangci-lint on Go code
- Understand the SARIF output format for linter results

## Prerequisites

- Completed [Lab 01: Explore Demo Apps](../lab-01-explore-demo-apps/)
- All scanning tools installed (ESLint, Ruff, golangci-lint)

## Exercises

### Exercise 1: Run ESLint on TypeScript (cq-demo-app-001)

> **Working Directory**: Run the following commands from the `code-quality-scan-demo-app` repository root.

Navigate to the TypeScript demo app and install dependencies:

```powershell
cd cq-demo-app-001
npm install
```

Run ESLint with the default stylish formatter to see human-readable output:

```powershell
npx eslint src/ --format stylish
```

You should see violations such as:

- `prefer-const` — variables declared with `let` that are never reassigned
- `@typescript-eslint/no-unused-vars` — declared but unused variables
- `@typescript-eslint/no-explicit-any` — use of `any` type instead of specific types

![ESLint output showing TypeScript violations](../images/lab-02/lab-02-eslint-output.png)

Now run ESLint with SARIF output to see the machine-readable format:

```powershell
npx eslint src/ --format @microsoft/eslint-formatter-sarif --output-file eslint-results.sarif
```

> **Note**: If the SARIF formatter is not installed, install it first:
> ```powershell
> npm install -D @microsoft/eslint-formatter-sarif
> ```

Examine the SARIF output:

```powershell
Get-Content eslint-results.sarif | ConvertFrom-Json | ConvertTo-Json -Depth 10 | Select-Object -First 60
```

![ESLint SARIF output](../images/lab-02/lab-02-eslint-sarif.png)

```powershell
cd ..
```

### Exercise 2: Run Ruff on Python (cq-demo-app-002)

Navigate to the Python demo app and run Ruff:

```powershell
cd cq-demo-app-002
ruff check src/
```

Ruff organizes rules by category prefix:

| Prefix | Category | Example |
|--------|----------|---------|
| `F` | Pyflakes — logic errors | F401 (unused import), F841 (unused variable) |
| `E` | pycodestyle — style errors | E501 (line too long) |
| `W` | pycodestyle — warnings | W291 (trailing whitespace) |
| `I` | isort — import ordering | I001 (unsorted imports) |
| `N` | pep8-naming — naming conventions | N802 (function name should be lowercase) |

![Ruff output showing Python violations](../images/lab-02/lab-02-ruff-output.png)

Run Ruff with SARIF output:

```powershell
ruff check src/ --output-format sarif --output-file ruff-results.sarif
```

```powershell
cd ..
```

### Exercise 3: Run .NET Analyzers on C# (cq-demo-app-003)

Navigate to the C# demo app and build with analyzers enabled:

```powershell
cd cq-demo-app-003
dotnet build /p:TreatWarningsAsErrors=false -warnaserror- 2>&1 | Select-String "warning CA|error CA"
```

Common .NET Analyzer findings include:

| Rule | Description |
|------|-------------|
| CA1822 | Mark members as static |
| CA2007 | Consider calling ConfigureAwait |
| CA1062 | Validate arguments of public methods |
| CA1031 | Do not catch general exception types |
| IDE0060 | Remove unused parameter |

![.NET Analyzers output](../images/lab-02/lab-02-dotnet-analyzers.png)

To generate SARIF output from the .NET build:

```powershell
dotnet build /p:ErrorLog=dotnet-results.sarif,version=2.1
```

```powershell
cd ..
```

### Exercise 4: Run Checkstyle on Java (cq-demo-app-004)

Navigate to the Java demo app and run Checkstyle via Maven:

```powershell
cd cq-demo-app-004
.\mvnw.cmd checkstyle:check 2>&1 | Select-Object -Last 30
```

> **Note on cross-platform**: On Linux/macOS, use `./mvnw` instead of `.\mvnw.cmd`.

Common Checkstyle findings:

| Rule | Description |
|------|-------------|
| `NamingConvention` | Method/variable naming violations |
| `LineLength` | Lines exceeding 120 characters |
| `MagicNumber` | Hardcoded numeric literals |
| `JavadocMethod` | Missing Javadoc on public methods |
| `CyclomaticComplexity` | Methods with complexity > 10 |

![Checkstyle output for Java](../images/lab-02/lab-02-checkstyle-output.png)

```powershell
cd ..
```

### Exercise 5: Run golangci-lint on Go (cq-demo-app-005)

Navigate to the Go demo app and run golangci-lint:

```powershell
cd cq-demo-app-005
golangci-lint run ./...
```

Common golangci-lint findings:

| Linter | Description |
|--------|-------------|
| `errcheck` | Unchecked error return values |
| `ineffassign` | Assignments to variables that are never used afterward |
| `staticcheck` | Advanced static analysis |
| `govet` | Reports suspicious constructs |
| `unused` | Unused variables, functions, or types |

![golangci-lint output for Go](../images/lab-02/lab-02-golangci-lint-output.png)

Run with SARIF output (golangci-lint does not natively output SARIF, but you can use JSON and convert):

```powershell
golangci-lint run ./... --out-format json > golangci-lint-results.json
```

```powershell
cd ..
```

### Exercise 6: Understand the SARIF Format

Open any of the SARIF files generated in the previous exercises. A SARIF result looks like this:

```json
{
  "$schema": "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/main/sarif-2.1/schema/sarif-schema-2.1.0.json",
  "version": "2.1.0",
  "runs": [
    {
      "tool": {
        "driver": {
          "name": "ESLint",
          "rules": [
            {
              "id": "prefer-const",
              "shortDescription": { "text": "Require const for variables that are never reassigned" },
              "helpUri": "https://eslint.org/docs/rules/prefer-const"
            }
          ]
        }
      },
      "results": [
        {
          "ruleId": "prefer-const",
          "level": "warning",
          "message": { "text": "'x' is never reassigned. Use 'const' instead." },
          "locations": [
            {
              "physicalLocation": {
                "artifactLocation": { "uri": "src/utils/helpers.ts" },
                "region": { "startLine": 15, "startColumn": 7 }
              }
            }
          ]
        }
      ]
    }
  ]
}
```

Key SARIF concepts:

| Element | Purpose |
|---------|---------|
| `tool.driver.name` | Identifies the scanning tool |
| `tool.driver.rules` | Rule definitions with descriptions |
| `results[].ruleId` | Links finding to its rule definition |
| `results[].level` | Severity: `error`, `warning`, or `note` |
| `results[].locations` | File path, line number, and column |
| `results[].message` | Human-readable description of the finding |

![SARIF JSON structure](../images/lab-02/lab-02-sarif-structure.png)

## Verification Checkpoint

Verify your work before continuing:

- [ ] ESLint produced warnings/errors for `cq-demo-app-001`
- [ ] Ruff found violations in `cq-demo-app-002`
- [ ] .NET Analyzers reported findings for `cq-demo-app-003`
- [ ] Checkstyle identified violations in `cq-demo-app-004`
- [ ] golangci-lint found issues in `cq-demo-app-005`
- [ ] You generated at least one SARIF output file
- [ ] You can explain the key fields in a SARIF result

## Summary

Per-language linters are the first line of defense in code quality scanning. Each tool specializes in its language ecosystem — ESLint for TypeScript/JavaScript, Ruff for Python, .NET Analyzers for C#, Checkstyle for Java, and golangci-lint for Go. By outputting results in SARIF format, all findings can be aggregated into a unified view in GitHub Security tab or ADO Advanced Security.

## Next Steps

Proceed to [Lab 03: Complexity Analysis](../lab-03-complexity/).
