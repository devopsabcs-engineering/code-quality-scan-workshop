# Code Quality Scan Workshop

[![GitHub Pages](https://img.shields.io/badge/docs-GitHub%20Pages-blue)](https://devopsabcs-engineering.github.io/code-quality-scan-workshop/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Hands-on workshop for code quality scanning with ESLint, Ruff, jscpd, Lizard, and coverage tools. Learn to integrate a **4-tool scanning architecture** into your CI/CD pipelines and visualize results in GitHub Advanced Security, Azure DevOps Advanced Security, and Power BI.

## Quick Start

### Option 1: GitHub Codespaces (Recommended)

1. Click **Code → Codespaces → New codespace** on this repository.
2. Wait for the dev container to build (~3 minutes).
3. Open the terminal and start with [Lab 00](labs/lab-00-prerequisites/).

### Option 2: Local Setup

1. Clone this repository:

   ```powershell
   git clone https://github.com/devopsabcs-engineering/code-quality-scan-workshop.git
   cd code-quality-scan-workshop
   ```

2. Clone the companion demo-app repository as a sibling:

   ```powershell
   git clone https://github.com/devopsabcs-engineering/code-quality-scan-demo-app.git
   ```

3. Install prerequisites from [Lab 00](labs/lab-00-prerequisites/).

## Labs

| # | Lab | Duration | Level |
|---|-----|----------|-------|
| 00 | [Prerequisites](labs/lab-00-prerequisites/) | 30 min | Beginner |
| 01 | [Explore Demo Apps](labs/lab-01-explore-demo-apps/) | 30 min | Beginner |
| 02 | [Linting](labs/lab-02-linting/) | 45 min | Intermediate |
| 03 | [Complexity Analysis](labs/lab-03-complexity/) | 30 min | Intermediate |
| 04 | [Duplication Detection](labs/lab-04-duplication/) | 30 min | Intermediate |
| 05 | [Coverage Analysis](labs/lab-05-coverage/) | 45 min | Intermediate |
| 06 | [GitHub Actions CI/CD](labs/lab-06-github-actions/) | 30 min | Intermediate |
| 06-ADO | [ADO Pipelines CI/CD](labs/lab-06-ado-pipelines/) | 30 min | Intermediate |
| 07 | [Remediation (GitHub)](labs/lab-07-remediation-github/) | 45 min | Advanced |
| 07-ADO | [Remediation (ADO)](labs/lab-07-ado-remediation/) | 45 min | Advanced |
| 08 | [Power BI Dashboard](labs/lab-08-dashboard/) | 45 min | Advanced |

## Scanning Architecture

The workshop teaches a **4-tool architecture** for comprehensive code quality scanning:

| Tool | Role | Output |
|------|------|--------|
| Per-language linters (ESLint, Ruff, .NET Analyzers, Checkstyle, golangci-lint) | Static analysis | Native SARIF |
| jscpd | Code duplication detection | Native SARIF |
| Lizard | Cyclomatic complexity analysis | CSV → SARIF via `lizard-to-sarif.py` |
| Coverage tools (Jest, pytest-cov, Coverlet, JaCoCo, go test) | Test coverage measurement | Various → SARIF via `coverage-to-sarif.py` |

All results are normalized to **SARIF v2.1.0** and uploaded to GitHub Security tab or ADO Advanced Security for unified triage.

## Companion Repository

This workshop uses the [code-quality-scan-demo-app](https://github.com/devopsabcs-engineering/code-quality-scan-demo-app) repository, which contains:

- 5 demo applications (TypeScript, Python, C#, Java, Go) with intentional quality violations
- SARIF converter scripts for Lizard and coverage tools
- CI/CD pipelines for GitHub Actions and Azure DevOps
- Power BI PBIP report for quality dashboards

## Prerequisites Summary

- Node.js 20+ · Python 3.12+ · .NET 8 SDK · Java 21+ · Go 1.22+
- Docker Desktop (or Codespaces with Docker-in-Docker)
- Visual Studio Code with ESLint, Python, C#, and Go extensions
- GitHub CLI (`gh`) authenticated

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding labs, screenshots, and fixes.

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.
