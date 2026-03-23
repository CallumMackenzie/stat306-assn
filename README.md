# STAT 306 Term Project

Statistical analysis of sex-based pricing in medical insurance premiums using
linear regression. Full report generated from a reproducible Docker-based pipeline.

## Requirements

- [Docker](https://www.docker.com/get-started)

No local R or LaTeX installation is required.

## Setup

### 1. Clone the repository

```bash
git clone git@github.com:CallumMackenzie/stat306-assn.git 
cd stat306-assn
```

### 2. Build the Docker image

Only required once, or when the Dockerfile changes. This will take some time as it contains an entire latex distribution.

```bash
docker build --platform linux/amd64 -t stat-project .
```

## Workflow

### Regenerate plots and tables

Run this after making changes to `analysis.R`:

```bash
./scripts/run.sh
```

This will:
1. Wipe and recreate `images/`, `tables/`, and `data/`
2. Pull the dataset from Kaggle
3. Execute `analysis.R` inside the container, writing outputs to your local filesystem

### Compile the report

Add the `-c` flag to compile the report as a PDF:

```bash
./scripts/run.sh -c
```

This will:
1. Run `run.sh` to ensure plots and tables are up to date
2. Compiles all latex files in `/latex`
3. Outputs PDFs to `.build/report_draft_1.pdf`
