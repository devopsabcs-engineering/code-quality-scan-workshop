---
permalink: /labs/lab-05-coverage/
title: "Lab 05: Coverage Analysis"
description: "Run test coverage tools for each language and convert results to SARIF format for unified reporting."
---

# Lab 05: Coverage Analysis

| Duration | Level | Prerequisites |
|----------|-------|---------------|
| 45 min | Intermediate | Lab 04 |

## Learning Objectives

- Run test coverage tools for each of the 5 languages
- Understand line, branch, and function coverage metrics
- Convert coverage reports to SARIF using `coverage-to-sarif.py`
- Compare coverage across all demo apps
- Identify uncovered code paths and understand their risk

## Prerequisites

- Completed [Lab 04: Duplication Detection](../lab-04-duplication/)
- Language-specific test frameworks installed (Jest, pytest, dotnet test, Maven, go test)

## Exercises

### Exercise 1: TypeScript Coverage with Jest (cq-demo-app-001)

> **Working Directory**: Run the following commands from the `code-quality-scan-demo-app` repository root.

```powershell
cd cq-demo-app-001
npm test -- --coverage --coverageReporters=json-summary --coverageReporters=text
```

Jest outputs a coverage summary table:

| Metric | Description |
|--------|-------------|
| **Statements** | Percentage of code statements executed |
| **Branches** | Percentage of conditional branches covered |
| **Functions** | Percentage of functions called |
| **Lines** | Percentage of lines executed |

![Jest coverage output](../images/lab-05/lab-05-jest-coverage.png)

The coverage summary JSON is saved to `coverage/coverage-summary.json`. Note the intentionally low coverage — many utility functions have no tests.

```powershell
cd ..
```

### Exercise 2: Python Coverage with pytest-cov (cq-demo-app-002)

```powershell
cd cq-demo-app-002
python -m pytest tests/ --cov=src --cov-report=term --cov-report=xml:coverage.xml
```

pytest-cov generates a Cobertura XML report at `coverage.xml` and prints a terminal summary.

![pytest-cov coverage output](../images/lab-05/lab-05-pytest-coverage.png)

Note which modules have low coverage — the service layer typically has the least coverage in this demo app because error-handling paths are untested.

```powershell
cd ..
```

### Exercise 3: C# Coverage with Coverlet (cq-demo-app-003)

```powershell
cd cq-demo-app-003
dotnet test --collect:"XPlat Code Coverage" --results-directory TestResults/
```

Coverlet generates Cobertura XML in the `TestResults/` directory. Find the coverage report:

```powershell
Get-ChildItem -Recurse TestResults/ -Filter "coverage.cobertura.xml" | Select-Object FullName
```

To see a summary in the terminal:

```powershell
dotnet tool install -g dotnet-reportgenerator-globaltool 2>$null
reportgenerator -reports:TestResults/**/coverage.cobertura.xml -targetdir:CoverageReport -reporttypes:TextSummary
Get-Content CoverageReport/Summary.txt
```

![Coverlet coverage output](../images/lab-05/lab-05-coverlet-output.png)

```powershell
cd ..
```

### Exercise 4: Java Coverage with JaCoCo (cq-demo-app-004)

```powershell
cd cq-demo-app-004
.\mvnw.cmd test jacoco:report
```

> **Note on cross-platform**: On Linux/macOS, use `./mvnw` instead of `.\mvnw.cmd`.

JaCoCo generates an XML report at `target/site/jacoco/jacoco.xml` and an HTML report at `target/site/jacoco/index.html`.

View the summary:

```powershell
Get-Content target/site/jacoco/jacoco.xml | Select-String "counter type" | Select-Object -First 10
```

![JaCoCo coverage output](../images/lab-05/lab-05-jacoco-output.png)

```powershell
cd ..
```

### Exercise 5: Go Coverage with go test (cq-demo-app-005)

```powershell
cd cq-demo-app-005
go test ./... -coverprofile=coverage.out -covermode=atomic
go tool cover -func=coverage.out
```

The `-func` flag shows per-function coverage. The Go demo app intentionally has minimal test files, resulting in very low coverage.

![Go test coverage output](../images/lab-05/lab-05-go-coverage.png)

To generate an HTML coverage report:

```powershell
go tool cover -html=coverage.out -o coverage.html
```

```powershell
cd ..
```

### Exercise 6: Convert Coverage to SARIF

Use the `coverage-to-sarif.py` converter to transform coverage reports from each language into SARIF format:

**TypeScript (JSON summary):**

```powershell
python src/converters/coverage-to-sarif.py --input cq-demo-app-001/coverage/coverage-summary.json --format json-summary --output cq-001-coverage.sarif --threshold 80
```

**Python (Cobertura XML):**

```powershell
python src/converters/coverage-to-sarif.py --input cq-demo-app-002/coverage.xml --format cobertura --output cq-002-coverage.sarif --threshold 80
```

**C# (Cobertura XML):**

```powershell
$coberturaFile = Get-ChildItem -Recurse cq-demo-app-003/TestResults/ -Filter "coverage.cobertura.xml" | Select-Object -First 1 -ExpandProperty FullName
python src/converters/coverage-to-sarif.py --input $coberturaFile --format cobertura --output cq-003-coverage.sarif --threshold 80
```

**Java (JaCoCo XML):**

```powershell
python src/converters/coverage-to-sarif.py --input cq-demo-app-004/target/site/jacoco/jacoco.xml --format jacoco --output cq-004-coverage.sarif --threshold 80
```

**Go (cover profile):**

```powershell
python src/converters/coverage-to-sarif.py --input cq-demo-app-005/coverage.out --format gocover --output cq-005-coverage.sarif --threshold 80
```

![coverage-to-sarif.py conversion](../images/lab-05/lab-05-sarif-conversion.png)

### Exercise 7: Compare Coverage Across Apps

Create a summary comparison:

```powershell
Write-Host "`nCoverage Comparison Across Demo Apps"
Write-Host "======================================"
Write-Host "App 001 (TypeScript):"
Get-Content cq-001-coverage.sarif | ConvertFrom-Json | Select-Object -ExpandProperty runs | Select-Object -ExpandProperty results | Measure-Object | Select-Object -ExpandProperty Count | ForEach-Object { Write-Host "  Files below threshold: $_" }

Write-Host "App 002 (Python):"
Get-Content cq-002-coverage.sarif | ConvertFrom-Json | Select-Object -ExpandProperty runs | Select-Object -ExpandProperty results | Measure-Object | Select-Object -ExpandProperty Count | ForEach-Object { Write-Host "  Files below threshold: $_" }

Write-Host "App 003 (C#):"
Get-Content cq-003-coverage.sarif | ConvertFrom-Json | Select-Object -ExpandProperty runs | Select-Object -ExpandProperty results | Measure-Object | Select-Object -ExpandProperty Count | ForEach-Object { Write-Host "  Files below threshold: $_" }

Write-Host "App 004 (Java):"
Get-Content cq-004-coverage.sarif | ConvertFrom-Json | Select-Object -ExpandProperty runs | Select-Object -ExpandProperty results | Measure-Object | Select-Object -ExpandProperty Count | ForEach-Object { Write-Host "  Files below threshold: $_" }

Write-Host "App 005 (Go):"
Get-Content cq-005-coverage.sarif | ConvertFrom-Json | Select-Object -ExpandProperty runs | Select-Object -ExpandProperty results | Measure-Object | Select-Object -ExpandProperty Count | ForEach-Object { Write-Host "  Files below threshold: $_" }
```

![Coverage comparison across apps](../images/lab-05/lab-05-coverage-comparison.png)

The 80% threshold is the CI quality gate standard. Any file below this threshold generates a SARIF finding that would block a merge in a production CI pipeline.

## Verification Checkpoint

Verify your work before continuing:

- [ ] You ran coverage tools for all 5 languages
- [ ] You generated SARIF files from each coverage report
- [ ] You can compare coverage levels across the demo apps
- [ ] You understand the difference between line, branch, and function coverage
- [ ] You identified at least 3 files with coverage below the 80% threshold

## Summary

Test coverage is a critical code quality metric that measures how much of your code is exercised by tests. Each language has its own coverage tooling — Jest for TypeScript, pytest-cov for Python, Coverlet for C#, JaCoCo for Java, and `go test -cover` for Go. The `coverage-to-sarif.py` converter normalizes all formats into SARIF, enabling unified coverage tracking alongside lint, complexity, and duplication findings.

The workshop enforces an 80% coverage threshold. Files below this threshold generate SARIF findings that appear in GitHub Security tab or ADO Advanced Security.

## Next Steps

Proceed to [Lab 06: GitHub Actions CI/CD](../lab-06-github-actions/) or [Lab 06-ADO: ADO Pipelines CI/CD](../lab-06-ado-pipelines/).
