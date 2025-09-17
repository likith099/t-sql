# T-SQL Database Project (Azure DevOps CI/CD)

This repository contains a SQL Database Project using MSBuild.Sdk.SqlProj that builds a DACPAC and deploys to Azure SQL via Azure Pipelines.

## What you get
- SDK-style SQL project at `src/Database`
- Azure Pipelines YAML: `azure-pipelines.yml` (build + deploy)
- VS Code recommendations and `.gitignore`

## Build locally
- Requires .NET 6 SDK
- Build a DACPAC:

```powershell
# from repo root
dotnet restore .\src\Database\Database.sqlproj
dotnet build .\src\Database\Database.sqlproj -c Release
```

DACPAC output: `src/Database/bin/Release/TsqlSampleDatabase.dacpac`

## Push to Azure Repos
1. Create an Azure DevOps repo (or use an existing one).
2. Add the remote and push:

```powershell
git init
git branch -M main
git add .
git commit -m "feat: initial SQL project and pipeline"
# Replace with your org/project/repo path
git remote add origin https://dev.azure.com/<org>/<project>/_git/<repo>
git push -u origin main
```

## Configure Azure Pipeline
- In Azure DevOps, create a new pipeline from `azure-pipelines.yml` on the `main` branch.
- Create a Service Connection (Azure Resource Manager) named in variable `azureServiceConnection`.
- Add the following pipeline variables (Library or Pipeline variables):
  - `azureServiceConnection` – name of the service connection
  - `sqlServerName` – e.g. myserver.database.windows.net
  - `sqlDatabaseName` – target DB name
  - `sqlUser` and `sqlPassword` – SQL auth (or switch task to use AAD)

## Project layout
- `src/Database/Database.sqlproj` – project file
- `src/Database/Tables/` – sample table `dbo.Sample`
- `src/Database/Scripts/PostDeployment.sql` – post-deploy hook

## Notes
- For AAD auth, change SqlAzureDacpacDeployment inputs accordingly or use a DACPAC deploy script step.
- Use additional SQLCMD variables by adding them to a publish profile or passing `/v:Var=Value` in `AdditionalArguments`.
