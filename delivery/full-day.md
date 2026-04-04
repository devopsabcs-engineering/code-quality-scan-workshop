---
title: "Full-Day Delivery Guide"
description: "7-hour facilitator guide for the Code Quality Scan Workshop"
---

# Full-Day Delivery Guide (7 hours)

## Overview

This guide covers delivery of the Code Quality Scan Workshop in a full-day format (7 hours). Students complete all labs including both GitHub and ADO variants, remediation exercises, and the Power BI dashboard.

## Target Audience

- Developers integrating code quality scanning into CI/CD
- DevOps engineers building quality gates and dashboards
- Platform engineers establishing organization-wide coding standards
- Team leads evaluating code quality metrics

## Prerequisites for Facilitator

- [ ] All half-day prerequisites (see `half-day.md`)
- [ ] Power BI Desktop installed for Lab 08 demonstration
- [ ] ADLS Gen2 storage deployed (or ready to deploy via Bicep)
- [ ] Power BI workspace available for report deployment
- [ ] Both GitHub and ADO environments configured
- [ ] Familiarity with remediation patterns for at least 2 languages

## Schedule

### Morning Session (3.5 hours)

| Time | Duration | Activity | Notes |
|------|----------|----------|-------|
| 0:00 | 10 min | **Welcome & Introduction** | Full agenda, learning objectives, architecture |
| 0:10 | 20 min | **Lab 00: Prerequisites** | Fast-track with Codespaces |
| 0:30 | 25 min | **Lab 01: Explore Demo Apps** | Detailed walkthrough of all 5 apps |
| 0:55 | 5 min | **Break** | |
| 1:00 | 40 min | **Lab 02: Linting** | All 5 linters, SARIF deep-dive |
| 1:40 | 25 min | **Lab 03: Complexity Analysis** | Lizard + SARIF conversion |
| 2:05 | 10 min | **Break** | |
| 2:15 | 25 min | **Lab 04: Duplication Detection** | jscpd + threshold configuration |
| 2:40 | 5 min | **Transition** | |
| 2:45 | 40 min | **Lab 05: Coverage Analysis** | All 5 languages + SARIF conversion |
| 3:25 | 5 min | **Morning Recap** | Key concepts: SARIF, tools, thresholds |

### Lunch Break (45 minutes)

| Time | Duration | Activity |
|------|----------|----------|
| 3:30 | 45 min | **Lunch** |

### Afternoon Session (2.75 hours)

| Time | Duration | Activity | Notes |
|------|----------|----------|-------|
| 4:15 | 30 min | **Lab 06: GitHub Actions** | Scan workflow, Security tab |
| 4:45 | 25 min | **Lab 06-ADO: ADO Pipelines** | ADO pipeline, Advanced Security |
| 5:10 | 10 min | **Break** | |
| 5:20 | 40 min | **Lab 07: Remediation (GitHub)** | Fix, re-scan, verify |
| 6:00 | 30 min | **Lab 07-ADO: Remediation (ADO)** | Same fixes, ADO workflow |
| 6:30 | 10 min | **Break** | |
| 6:40 | 35 min | **Lab 08: Power BI Dashboard** | Deploy, configure, explore |
| 7:15 | 15 min | **Wrap-Up & Q&A** | Recap, next steps, feedback |

**Total: 7.5 hours** (including breaks and lunch)

## Facilitation Tips

### General Tips
- **Pace check**: Ask for thumbs up/down after each lab to gauge completion.
- **Pair programming**: Encourage students to pair up, especially for remediation labs.
- **Parking lot**: Keep a "parking lot" for questions that are off-topic but worth addressing.
- **Early finishers**: Direct them to explore additional linter configurations or try fixing more violations.

### Lab 05 (Coverage)
- This is the most language-dependent lab. Students with only one language may struggle.
- **Suggestion**: Have students focus on 2 languages they know best.
- The SARIF conversion step is critical — ensure everyone completes it for at least one language.

### Lab 06 & 06-ADO (CI/CD)
- Run both platforms in the full-day format.
- Show the GitHub workflow first (30 min), then transition to ADO (25 min).
- Highlight the **parallels**: same tools, same SARIF, different CI platform.
- If some students lack ADO access, have them observe the facilitator demo.

### Lab 07 (Remediation)
- This is the most hands-on lab. Students should fix real code.
- **Start with ESLint auto-fix** — it gives immediate gratification.
- **Complexity refactoring**: Walk through one example together, then let students try.
- **Coverage improvement**: Start with the simplest function to test.
- **Time management**: Not every student needs to fix everything. Target: 5 lint fixes + 1 complexity reduction + 2 new tests.

### Lab 07-ADO (Remediation)
- Students apply the same fixes from Lab 07 to the ADO repo.
- Focus on the **workflow comparison**: push → pipeline → results.
- Students who already fixed code in Lab 07 can push the same changes to ADO.

### Lab 08 (Dashboard)
- This lab requires Azure resources. Options:
  1. **Live demo**: Facilitator deploys and shows the dashboard.
  2. **Shared workspace**: All students use a pre-configured Power BI workspace.
  3. **Individual**: Each student deploys their own (requires Power BI Pro licenses).
- The PBIP structure walkthrough is valuable even without deployment.
- Focus on the **star schema** and how SARIF maps to fact table rows.

## Materials Checklist

All half-day materials, plus:

- [ ] ADO organization access for all students
- [ ] Azure subscription for ADLS Gen2 deployment (shared or per-student)
- [ ] Power BI workspace with write access
- [ ] Power BI Desktop installed (for local PBIP editing)
- [ ] Pre-deployed ADLS Gen2 storage (optional, as fallback)
- [ ] Sample scan data in ADLS Gen2 (optional, for Lab 08 demo)

## Assessment (Optional)

For instructor-led workshops with formal assessment:

| Lab | Assessment Criteria | Points |
|-----|---------------------|--------|
| 02 | Run 3+ linters and generate SARIF | 15 |
| 03 | Identify 3+ high-CCN functions | 10 |
| 04 | Detect duplication and explain clone types | 10 |
| 05 | Generate coverage SARIF for 2+ languages | 15 |
| 06 | Successfully run scan workflow in CI/CD | 15 |
| 07 | Fix 5+ violations and verify via re-scan | 25 |
| 08 | Deploy and explore Power BI dashboard | 10 |
| **Total** | | **100** |

## Post-Workshop

- Share workshop repository link and recorded demos (if any)
- Distribute the half-day subset guide for quick reference
- Point students to the framework documentation for advanced topics:
  - Custom rule configuration
  - MegaLinter integration
  - Multi-repo scanning strategies
  - Power BI DAX optimization
- Collect feedback via survey — target key improvements for next delivery
- Schedule follow-up session (2 weeks) to check on adoption
