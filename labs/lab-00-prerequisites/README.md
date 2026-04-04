---
permalink: /labs/lab-00-prerequisites/
title: "Lab 00: Prerequisites"
description: "Install all required tools and verify your development environment for the Code Quality Scan Workshop."
---

# Lab 00: Prerequisites

| Duration | Level | Prerequisites |
|----------|-------|---------------|
| 30 min | Beginner | None |

## Learning Objectives

- Install all required language runtimes (Node.js, Python, .NET, Java, Go)
- Install code quality scanning tools (ESLint, Ruff, jscpd, Lizard, golangci-lint)
- Fork and clone the `code-quality-scan-demo-app` repository
- Verify Docker is working for local container builds
- Understand the workshop directory structure

## Prerequisites

- A GitHub account with access to the [devopsabcs-engineering](https://github.com/devopsabcs-engineering) organization
- A computer with administrator access (or a GitHub Codespace)
- An internet connection for downloading tools and packages

> **Tip**: If you are using **GitHub Codespaces**, most tools are pre-installed by the dev container. Skip to [Exercise 6](#exercise-6-fork-and-clone-the-demo-app-repository) after verifying versions.

## Exercises

### Exercise 1: Install Node.js 20+

Download and install Node.js from [nodejs.org](https://nodejs.org/) or use a version manager.

Verify the installation:

```powershell
node --version
npm --version
```

You should see Node.js version 20.x or higher.

![Node.js version verification](../images/lab-00/lab-00-node-version.png)

### Exercise 2: Install Python 3.12+

Download and install Python from [python.org](https://www.python.org/downloads/) or use a version manager.

Verify the installation:

```powershell
python --version
pip --version
```

You should see Python version 3.12.x or higher.

![Python version verification](../images/lab-00/lab-00-python-version.png)

### Exercise 3: Install .NET 8 SDK

Download and install the .NET 8 SDK from [dotnet.microsoft.com](https://dotnet.microsoft.com/download/dotnet/8.0).

Verify the installation:

```powershell
dotnet --version
```

You should see version 8.0.x or higher.

![.NET SDK version verification](../images/lab-00/lab-00-dotnet-version.png)

### Exercise 4: Install Java 21+

Download and install the JDK from [Adoptium](https://adoptium.net/) or [Oracle](https://www.oracle.com/java/technologies/downloads/). Ensure Maven is also installed.

Verify the installation:

```powershell
java --version
mvn --version
```

You should see Java version 21.x or higher.

![Java version verification](../images/lab-00/lab-00-java-version.png)

### Exercise 5: Install Go 1.22+

Download and install Go from [go.dev](https://go.dev/dl/).

Verify the installation:

```powershell
go version
```

You should see Go version 1.22.x or higher.

![Go version verification](../images/lab-00/lab-00-go-version.png)

### Exercise 6: Install Docker

Download and install Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop/).

> **Codespaces**: Docker is available via the Docker-in-Docker feature in the dev container.

Verify the installation:

```powershell
docker --version
docker run hello-world
```

![Docker version verification](../images/lab-00/lab-00-docker-version.png)

### Exercise 7: Install Scanning Tools

Install the 5 scanning tools used throughout the workshop:

**ESLint** (TypeScript/JavaScript linter):

```powershell
npm install -g eslint@latest
eslint --version
```

**Ruff** (Python linter):

```powershell
pip install ruff
ruff --version
```

**jscpd** (code duplication detection):

```powershell
npm install -g jscpd@latest
jscpd --version
```

**Lizard** (cyclomatic complexity analysis):

```powershell
pip install lizard
lizard --version
```

**golangci-lint** (Go linter):

On Windows (PowerShell):

```powershell
# Download the latest release from https://github.com/golangci/golangci-lint/releases
# Or use go install:
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
golangci-lint --version
```

On macOS/Linux:

```powershell
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin latest
golangci-lint --version
```

Verify all tools are installed:

```powershell
Write-Host "ESLint:        $(eslint --version)"
Write-Host "Ruff:          $(ruff --version)"
Write-Host "jscpd:         $(jscpd --version)"
Write-Host "Lizard:        $(lizard --version)"
Write-Host "golangci-lint: $(golangci-lint --version)"
```

![All scanning tools verified](../images/lab-00/lab-00-tools-installed.png)

### Exercise 8: Fork and Clone the Demo App Repository

Fork the `code-quality-scan-demo-app` repository to your GitHub account:

```powershell
gh repo fork devopsabcs-engineering/code-quality-scan-demo-app --clone
cd code-quality-scan-demo-app
```

If you prefer to clone without forking (read-only):

```powershell
git clone https://github.com/devopsabcs-engineering/code-quality-scan-demo-app.git
cd code-quality-scan-demo-app
```

Verify the directory structure:

```powershell
Get-ChildItem -Directory | Select-Object Name
```

You should see 5 demo app directories:

```
cq-demo-app-001
cq-demo-app-002
cq-demo-app-003
cq-demo-app-004
cq-demo-app-005
```

![Cloning the demo-app repository](../images/lab-00/lab-00-clone-repo.png)

### Exercise 9: Verify Docker Builds

Test that you can build one of the demo apps as a Docker container:

> **Working Directory**: Run the following commands from the `code-quality-scan-demo-app` repository root.

```powershell
cd cq-demo-app-001
docker build -t cq-demo-app-001 .
docker run -d -p 3000:3000 --name cq-test cq-demo-app-001
```

Open [http://localhost:3000](http://localhost:3000) in your browser to verify the app is running.

Clean up the test container:

```powershell
docker stop cq-test
docker rm cq-test
cd ..
```

## Verification Checkpoint

Verify your setup before continuing:

- [ ] Node.js 20+ is installed (`node --version`)
- [ ] Python 3.12+ is installed (`python --version`)
- [ ] .NET 8 SDK is installed (`dotnet --version`)
- [ ] Java 21+ is installed (`java --version`)
- [ ] Go 1.22+ is installed (`go version`)
- [ ] Docker is running (`docker run hello-world`)
- [ ] ESLint is installed (`eslint --version`)
- [ ] Ruff is installed (`ruff --version`)
- [ ] jscpd is installed (`jscpd --version`)
- [ ] Lizard is installed (`lizard --version`)
- [ ] golangci-lint is installed (`golangci-lint --version`)
- [ ] The demo-app repository is cloned with all 5 app directories visible

## Summary

You have set up a complete development environment for code quality scanning. All 5 language runtimes, 5 scanning tools, and Docker are ready to use. The demo-app repository is cloned with 5 sample applications containing intentional quality violations.

## Next Steps

Proceed to [Lab 01: Explore Demo Apps](../lab-01-explore-demo-apps/).
