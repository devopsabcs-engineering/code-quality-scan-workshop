---
title: "Half-Day Delivery Guide"
description: "3.5-hour facilitator guide for the Code Quality Scan Workshop"
---

# Half-Day Delivery Guide (3.5 hours)

## Overview

This guide covers delivery of the Code Quality Scan Workshop in a half-day format (3.5 hours). Students complete Labs 00 through 05 and choose either Lab 06 (GitHub Actions) or Lab 06-ADO (ADO Pipelines).

## Target Audience

- Developers wanting to integrate code quality scanning into CI/CD
- DevOps engineers building quality gates
- Team leads establishing coding standards

## Prerequisites for Facilitator

- [ ] Verify all tools are installable (Node.js, Python, .NET, Java, Go, Docker)
- [ ] Fork and clone the `code-quality-scan-demo-app` repository
- [ ] Run through all labs at least once
- [ ] Prepare screen sharing for demonstrations
- [ ] If using GitHub: ensure GitHub Advanced Security is enabled
- [ ] If using ADO: ensure ADO Advanced Security license is available

## Recommended Setup

- **Codespaces**: Recommended for consistent environment across all students
- **Local**: Students need admin access for tool installation

## Schedule

| Time | Duration | Activity | Notes |
|------|----------|----------|-------|
| 0:00 | 5 min | **Welcome & Introduction** | Workshop goals, architecture overview |
| 0:05 | 25 min | **Lab 00: Prerequisites** | Help students with installation issues |
| 0:30 | 25 min | **Lab 01: Explore Demo Apps** | Walk through one app together, students explore rest |
| 0:55 | 5 min | **Break** | |
| 1:00 | 40 min | **Lab 02: Linting** | Demo ESLint first, then students run all linters |
| 1:40 | 25 min | **Lab 03: Complexity Analysis** | Demo Lizard, discuss CCN thresholds |
| 2:05 | 10 min | **Break** | |
| 2:15 | 25 min | **Lab 04: Duplication Detection** | Demo jscpd, discuss clone types |
| 2:40 | 5 min | **Transition** | Explain GitHub vs ADO lab choice |
| 2:45 | 30 min | **Lab 06 or 06-ADO: CI/CD** | Students choose platform |
| 3:15 | 15 min | **Wrap-Up & Q&A** | Recap, next steps, resources |

**Total: 3.5 hours** (3 hours 30 minutes)

## Facilitation Tips

### Lab 00 (Prerequisites)
- **Codespaces users**: Skip straight to Exercise 6 (fork/clone). Most tools are pre-installed.
- **Common issues**: Python path not in PATH, Docker Desktop not running, Go not in PATH.
- **Time-saver**: Have students verify tools in parallel rather than sequentially.

### Lab 01 (Explore Demo Apps)
- Walk through `cq-demo-app-001` (TypeScript) together on the projector.
- Point out specific violations: unused variables, long functions, copy-pasted blocks.
- Let students explore the other 4 apps independently.
- **Skip** building all 5 Docker containers — just build 1 as a demo.

### Lab 02 (Linting)
- Run ESLint as a live demo first, then let students run all 5 linters.
- Focus on SARIF format understanding — this is the key concept for later labs.
- **Time-saver**: Students can pick 2–3 linters most relevant to their work.

### Lab 03 (Complexity)
- Explain CCN intuitively: "each branch adds a path to test."
- Show a before/after refactoring example live.
- The SARIF conversion step is important — ensure students understand converters.

### Lab 04 (Duplication)
- The HTML report is the most visual — show it on screen.
- Discuss real-world duplication: copy-pasted validation, boilerplate.

### Lab 06/06-ADO (CI/CD)
- If the audience is mixed: split into two groups.
- If the audience is uniform: choose the relevant platform.
- Trigger the workflow/pipeline live and walk through the results together.

## Materials Checklist

- [ ] Workshop repository forked/cloned by all students
- [ ] Demo-app repository forked/cloned by all students
- [ ] Projector/screen share for demonstrations
- [ ] Shared chat channel (Teams/Slack) for help requests
- [ ] Access to GitHub or ADO organization for Lab 06

## Post-Workshop

- Share the workshop repository link for future reference
- Point students to Lab 07 (Remediation) and Lab 08 (Dashboard) for self-paced learning
- Collect feedback via survey
