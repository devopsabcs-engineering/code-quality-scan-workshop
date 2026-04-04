---
permalink: /labs/lab-06-ado-pipelines/
title: "Lab 06-ADO: ADO Pipelines CI/CD"
description: "Import the code-quality-scan.yml pipeline in Azure DevOps, run it, and view findings in ADO Advanced Security."
---

# Lab 06-ADO: ADO Pipelines CI/CD

| Duration | Level | Prerequisites |
|----------|-------|---------------|
| 30 min | Intermediate | Lab 05 |

## Learning Objectives

- Import the `code-quality-scan.yml` pipeline into Azure DevOps
- Run the scan pipeline and monitor its execution
- View SARIF results in ADO Advanced Security
- Understand the differences between GitHub and ADO scan integration

## Prerequisites

- Completed [Lab 05: Coverage Analysis](../lab-05-coverage/)
- Access to the Azure DevOps organization `MngEnvMCAP675646` and project `Agentic Accelerator Framework`
- ADO Advanced Security enabled on the project (requires Azure DevOps Advanced Security license)

## Exercises

### Exercise 1: Import the Repository into Azure DevOps

If the repository has not been imported to ADO yet, use the bootstrap script or import manually:

1. Navigate to **Azure DevOps → Project → Repos → Import**.
2. Enter the clone URL: `https://github.com/devopsabcs-engineering/code-quality-scan-demo-app.git`.
3. Click **Import**.

Alternatively, use the `bootstrap-demo-apps-ado.ps1` script which automates this process.

![Importing repository into ADO](../images/lab-06-ado/lab-06-ado-pipeline-import.png)

### Exercise 2: Create the Pipeline

1. Navigate to **Pipelines → New Pipeline**.
2. Select **Azure Repos Git** as the source.
3. Select the imported `code-quality-scan-demo-app` repository.
4. Select **Existing Azure Pipelines YAML file**.
5. Choose the path: `.azuredevops/pipelines/code-quality-scan.yml`.
6. Click **Run** to save and run the pipeline.

The ADO pipeline structure mirrors the GitHub Actions workflow:

```yaml
trigger:
  branches:
    include:
      - main

pool:
  vmImage: 'ubuntu-latest'

strategy:
  matrix:
    app001:
      APP_ID: '001'
    app002:
      APP_ID: '002'
    app003:
      APP_ID: '003'
    app004:
      APP_ID: '004'
    app005:
      APP_ID: '005'

steps:
  - script: |
      # Run linter for the target app
      # Run complexity analysis
      # Run duplication detection
      # Run coverage
    displayName: 'Code Quality Scan'

  - task: AdvancedSecurity-Publish@1
    inputs:
      SarifFileDirectory: '$(Build.ArtifactStagingDirectory)'
```

### Exercise 3: Monitor Pipeline Execution

1. Navigate to **Pipelines → Recent runs**.
2. Click on the running pipeline to see job progress.
3. Each matrix job runs independently and produces its own SARIF output.

![ADO pipeline running](../images/lab-06-ado/lab-06-ado-pipeline-run.png)

Wait for all 5 matrix jobs to complete:

![ADO pipeline completed](../images/lab-06-ado/lab-06-ado-pipeline-complete.png)

### Exercise 4: View Results in ADO Advanced Security

1. Navigate to **Repos → Advanced Security**.
2. The SARIF findings uploaded by the `AdvancedSecurity-Publish@1` task appear here.
3. Filter by:
   - **Severity**: Critical, High, Medium, Low
   - **Tool**: The scanner name from the SARIF `tool.driver.name` field
   - **Rule**: Individual rule IDs

![ADO Advanced Security findings](../images/lab-06-ado/lab-06-ado-advanced-security.png)

### Exercise 5: Examine a Finding

Click on any finding to see its detail view:

- **Rule ID** and description
- **File location** with line number
- **Severity** mapped from the SARIF level
- **Remediation guidance** from the SARIF `help.markdown` field

![ADO finding detail](../images/lab-06-ado/lab-06-ado-finding-detail.png)

### Exercise 6: Compare GitHub vs. ADO Integration

| Feature | GitHub | Azure DevOps |
|---------|--------|-------------|
| SARIF upload | `codeql-action/upload-sarif@v4` | `AdvancedSecurity-Publish@1` |
| Findings dashboard | Security → Code scanning alerts | Repos → Advanced Security |
| Category support | `category` parameter | Automatic from tool name |
| PR integration | Code scanning PR checks | Advanced Security PR annotations |
| API access | Code Scanning API | ADO Advanced Security API |
| License | Free for public repos | Requires ADO Advanced Security license |

Both platforms consume the same SARIF v2.1.0 format, so the scanner workflow produces identical output regardless of the CI/CD platform.

## Verification Checkpoint

Verify your work before continuing:

- [ ] You imported the repository into Azure DevOps
- [ ] You created and ran the pipeline from `.azuredevops/pipelines/code-quality-scan.yml`
- [ ] All 5 matrix jobs completed successfully
- [ ] You can view SARIF findings in ADO Advanced Security
- [ ] You examined the detail of at least one finding

## Summary

Azure DevOps Pipelines provides equivalent code quality scanning capabilities to GitHub Actions. The same 4-tool architecture runs in ADO with matrix jobs, and SARIF results are published to ADO Advanced Security via the `AdvancedSecurity-Publish@1` task. The key difference is the findings dashboard — ADO uses **Repos → Advanced Security** instead of GitHub's **Security → Code scanning alerts**.

## Next Steps

Proceed to [Lab 07-ADO: ADO Remediation](../lab-07-ado-remediation/) or go back to try [Lab 06: GitHub Actions CI/CD](../lab-06-github-actions/).
