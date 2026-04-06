---
permalink: /labs/lab-01-explore-demo-apps/
title: "Lab 01: Explore Demo Apps"
description: "Browse the 5 demo applications, understand their intentional violations, and run each app locally with Docker."
---

# Lab 01: Explore Demo Apps

| Duration | Level | Prerequisites |
|----------|-------|---------------|
| 30 min | Beginner | Lab 00 |

## Learning Objectives

- Understand the 5-app, 5-language demo application structure
- Identify the types of intentional code quality violations embedded in each app
- Run each demo app locally with Docker
- Navigate the repository layout and understand how files relate to scanning tools

## Prerequisites

- Completed [Lab 00: Prerequisites](../lab-00-prerequisites/)
- The `code-quality-scan-demo-app` repository cloned locally

## Exercises

### Exercise 1: Explore the Repository Structure

> **Working Directory**: Run the following commands from the `code-quality-scan-demo-app` repository root.

View the top-level directory structure:

```powershell
Get-ChildItem -Directory | Format-Table Name, LastWriteTime
```

You should see the following key directories:

| Directory | Language | Framework |
|-----------|----------|-----------|
| `cq-demo-app-001` | TypeScript | Express |
| `cq-demo-app-002` | Python | Flask |
| `cq-demo-app-003` | C# | ASP.NET Core |
| `cq-demo-app-004` | Java | Spring Boot |
| `cq-demo-app-005` | Go | net/http |

Additional directories include `src/converters/` (SARIF converters), `src/config/` (tool configurations), `scripts/` (bootstrap and data pipeline), and `power-bi/` (PBIP dashboard).

![Repository directory structure](../../images/lab-01/lab-01-repo-structure.png)

### Exercise 2: Explore cq-demo-app-001 (TypeScript / Express)

Browse the TypeScript demo app:

```powershell
Get-ChildItem cq-demo-app-001 -Recurse -File | Select-Object FullName | Select-Object -First 20
```

Key files to examine:

| File | Purpose |
|------|---------|
| `src/index.ts` | Express server entry point |
| `src/routes/` | API route handlers |
| `src/utils/` | Utility functions with complexity/duplication violations |
| `Dockerfile` | Multi-stage Docker build |
| `infra/main.bicep` | Azure deployment infrastructure |
| `eslint.config.mjs` | ESLint configuration |

**Intentional violations in this app:**
- `prefer-const` violations (using `let` where `const` should be used)
- Unused variables and imports
- Functions with cyclomatic complexity > 10
- Duplicated utility functions
- Low test coverage (< 50%)

Build and run the app:

```powershell
cd cq-demo-app-001
docker build -t cq-demo-app-001 .
docker run -d -p 3000:3000 --name app001 cq-demo-app-001
```

Open [http://localhost:3000](http://localhost:3000) to see the running app.

![TypeScript Express app running](../../images/lab-01/lab-01-app-001-running.png)

Clean up:

```powershell
docker stop app001; docker rm app001
cd ..
```

### Exercise 3: Explore cq-demo-app-002 (Python / Flask)

Browse the Python demo app:

```powershell
Get-ChildItem cq-demo-app-002 -Recurse -File | Select-Object FullName | Select-Object -First 20
```

Key files:

| File | Purpose |
|------|---------|
| `src/app.py` | Flask application entry point |
| `src/services/` | Business logic with violations |
| `src/utils/` | Utility functions |
| `pyproject.toml` | Python project config with Ruff settings |
| `Dockerfile` | Container build definition |

**Intentional violations:**
- Unused imports and variables (Ruff F401, F841)
- Missing type annotations
- Functions exceeding 50 lines
- Duplicated data validation logic
- Minimal test coverage

Build and run:

```powershell
cd cq-demo-app-002
docker build -t cq-demo-app-002 .
docker run -d -p 5000:5000 --name app002 cq-demo-app-002
```

Open [http://localhost:5000](http://localhost:5000) to verify.

![Python Flask app running](../../images/lab-01/lab-01-app-002-running.png)

Clean up:

```powershell
docker stop app002; docker rm app002
cd ..
```

### Exercise 4: Explore cq-demo-app-003 (C# / ASP.NET Core)

Browse the C# demo app:

```powershell
Get-ChildItem cq-demo-app-003 -Recurse -File -Include *.cs,*.csproj,*.bicep,Dockerfile | Select-Object FullName | Select-Object -First 20
```

Key files:

| File | Purpose |
|------|---------|
| `src/Program.cs` | ASP.NET Core entry point |
| `src/Controllers/` | API controllers |
| `src/Services/` | Business logic with violations |
| `src/*.csproj` | Project file with analyzer settings |
| `.editorconfig` | .NET Analyzer rules |

**Intentional violations:**
- CA1822 (methods that can be made static)
- CA2007 (missing ConfigureAwait)
- High cyclomatic complexity in data processing methods
- Duplicated validation logic across controllers
- Missing unit tests for service layer

Build and run:

```powershell
cd cq-demo-app-003
docker build -t cq-demo-app-003 .
docker run -d -p 8080:8080 --name app003 cq-demo-app-003
```

Open [http://localhost:8080](http://localhost:8080) to verify.

![C# ASP.NET Core app running](../../images/lab-01/lab-01-app-003-running.png)

Clean up:

```powershell
docker stop app003; docker rm app003
cd ..
```

### Exercise 5: Explore cq-demo-app-004 (Java / Spring Boot)

Browse the Java demo app:

```powershell
Get-ChildItem cq-demo-app-004 -Recurse -File -Include *.java,pom.xml,Dockerfile | Select-Object FullName | Select-Object -First 20
```

Key files:

| File | Purpose |
|------|---------|
| `src/main/java/.../Application.java` | Spring Boot entry point |
| `src/main/java/.../controllers/` | REST controllers |
| `src/main/java/.../services/` | Service layer with violations |
| `pom.xml` | Maven build with Checkstyle plugin |
| `checkstyle.xml` | Checkstyle configuration |

**Intentional violations:**
- Checkstyle naming convention violations
- Methods exceeding recommended length
- Deeply nested conditionals (> 4 levels)
- Copy-pasted utility methods
- Missing JUnit test cases

Build and run:

```powershell
cd cq-demo-app-004
docker build -t cq-demo-app-004 .
docker run -d -p 8080:8080 --name app004 cq-demo-app-004
```

Open [http://localhost:8080](http://localhost:8080) to verify.

![Java Spring Boot app running](../../images/lab-01/lab-01-app-004-running.png)

Clean up:

```powershell
docker stop app004; docker rm app004
cd ..
```

### Exercise 6: Explore cq-demo-app-005 (Go / net/http)

Browse the Go demo app:

```powershell
Get-ChildItem cq-demo-app-005 -Recurse -File -Include *.go,go.mod,Dockerfile | Select-Object FullName | Select-Object -First 20
```

Key files:

| File | Purpose |
|------|---------|
| `main.go` | HTTP server entry point |
| `handlers/` | Request handler functions |
| `utils/` | Utility functions with violations |
| `go.mod` | Go module definition |
| `.golangci.yml` | golangci-lint configuration |

**Intentional violations:**
- `errcheck` — unchecked error returns
- `ineffassign` — ineffective assignments
- High cyclomatic complexity in parsing functions
- Duplicated string processing logic
- No test files (`*_test.go`)

Build and run:

```powershell
cd cq-demo-app-005
docker build -t cq-demo-app-005 .
docker run -d -p 8080:8080 --name app005 cq-demo-app-005
```

Open [http://localhost:8080](http://localhost:8080) to verify.

![Go net/http app running](../../images/lab-01/lab-01-app-005-running.png)

Clean up:

```powershell
docker stop app005; docker rm app005
cd ..
```

### Exercise 7: Preview Code Quality Issues

Open any demo app in VS Code and look for common violation patterns:

```powershell
code cq-demo-app-001
```

Look for these patterns:

1. **Unused variables**: Variables declared but never referenced
2. **Long functions**: Functions with more than 50 lines
3. **Nested conditions**: `if/else` chains nested 4+ levels deep
4. **Copy-pasted blocks**: Similar code blocks in different files
5. **Missing tests**: Source files without corresponding test files

![Sample code with intentional violations](../../images/lab-01/lab-01-violations-preview.png)

## Verification Checkpoint

Verify your work before continuing:

- [ ] You can list all 5 demo app directories (`cq-demo-app-001` through `005`)
- [ ] You successfully built and ran at least one demo app with Docker
- [ ] You can identify at least 3 types of intentional violations in the source code
- [ ] You understand the purpose of `src/converters/`, `src/config/`, and `scripts/` directories

## Summary

The `code-quality-scan-demo-app` repository contains 5 demo applications, each written in a different language and framework. Every app includes intentional code quality violations — lint errors, high complexity, code duplication, and low test coverage — that you will detect and remediate in subsequent labs.

All apps follow a consistent structure with source code, Dockerfile, Bicep infrastructure, and a deploy workflow. They can all be built and run locally with Docker, making them ideal for hands-on scanning exercises.

## Next Steps

Proceed to [Lab 02: Linting](../lab-02-linting/).
