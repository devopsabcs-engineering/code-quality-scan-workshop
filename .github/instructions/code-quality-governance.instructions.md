---
description: "Code quality governance rules, coverage thresholds, complexity limits, and scan conventions for multi-language code analysis."
applyTo: "**/*.ts,**/*.js,**/*.py,**/*.cs,**/*.java,**/*.go"
---

# Code Quality Governance Rules

## Coverage Thresholds

Every scanned application must meet the following minimum coverage levels:

| Metric | Threshold | Action |
|--------|-----------|--------|
| Line coverage | ≥ 80% | Must fix before release |
| Branch coverage | ≥ 80% | Must fix before release |
| Function coverage | ≥ 80% | Must fix before release |
| New code coverage | ≥ 90% | Warn on PR |

## Complexity Limits

Functions exceeding complexity limits are flagged by the Lizard scanner:

| Metric | Threshold | SARIF Level |
|--------|-----------|-------------|
| Cyclomatic complexity (CCN) | > 15 | `error` |
| Cyclomatic complexity (CCN) | > 10 | `warning` |
| Function length | > 80 lines | `warning` |
| Parameter count | > 5 | `note` |

## Duplication Rules

Code duplication is detected by jscpd across all languages:

| Metric | Threshold | Action |
|--------|-----------|--------|
| Duplication rate | > 5% | Must reduce before release |
| Minimum clone tokens | 50 | Detection sensitivity |
| Cross-file duplication | Any | Flag for refactoring |

## Required Scan Coverage

Every demo application must be scanned for the following categories:

| # | Category | Tool | Rule Examples |
|---|----------|------|---------------|
| 1 | Linting | MegaLinter (ESLint, Ruff, golangci-lint, .NET Analyzers, Checkstyle) | Style violations, unused variables, error-prone patterns |
| 2 | Duplication | jscpd | Copy-paste code blocks across files |
| 3 | Complexity | Lizard | High cyclomatic complexity, long functions |
| 4 | Coverage | jest, pytest-cov, Coverlet, JaCoCo, go test | Untested functions, low branch coverage |

## Severity Mapping

Code quality findings map to SARIF severity levels:

| Condition | SARIF Level | Description | Action |
|-----------|-------------|-------------|--------|
| Coverage < 50% | `error` | Critical coverage gap | Immediate fix required |
| Coverage 50–70% | `error` | Significant gap | Fix within current sprint |
| Coverage 70–80% | `warning` | Below threshold | Address before release |
| CCN > 15 | `error` | Dangerously complex | Refactor immediately |
| CCN 10–15 | `warning` | Moderately complex | Simplify in current sprint |
| Duplication > 10% | `error` | Excessive duplication | Refactor immediately |
| Duplication 5–10% | `warning` | Moderate duplication | Plan refactoring |
| Lint violation | `note` | Style or minor issue | Fix opportunistically |

## SARIF Output Conventions

- `automationDetails.id` must be prefixed with `code-quality/coverage/`
- `partialFingerprints` use hash of `ruleId:file:function`
- `tool.driver.name` is `code-quality-scanner`
- Include `properties.tags` with `code-quality` plus category tags
