# Runbook — ML Production Pipeline

This runbook describes how to operate the **ml-production-pipeline** like a lightweight service: how to run it, validate outputs, troubleshoot, and handle common operational workflows.

---

## Service overview

**What it does**
- Builds an end-to-end ML pipeline:
  - Ingest/generate data
  - Build preprocessing + model pipeline
  - Train + evaluate
  - Persist artifacts (`models/`)
- Serves the trained model via FastAPI (`/predict`)

**Primary entrypoints**
- Pipeline: `python -m ml_pipeline.cli run --config config/default.yaml`
- API: `uvicorn ml_pipeline.api.app:app --host 0.0.0.0 --port 8000`

**Key artifacts**
- `data/raw/customer_churn.csv`
- `models/churn_model.joblib`
- `models/metrics.json`
