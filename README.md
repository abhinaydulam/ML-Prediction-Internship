# ML Production Pipeline (End-to-End)

A production-style machine learning pipeline that demonstrates how real ML teams build reproducible, testable, and deployable ML systems.

This repository goes beyond notebooks and experiments. It shows how to design an ML system as a product:

- Data generation and ingestion
- Feature preprocessing with `sklearn` pipelines
- Model training and evaluation with persisted artifacts
- CLI orchestration for repeatable runs
- A FastAPI inference service for online predictions
- CI for linting and tests

---

## Why This Project Exists

Many ML projects stop at a notebook with a trained model. In production, teams must solve a harder set of problems:

- How is data ingested and versioned?
- How are features built consistently across train and serve?
- Where do models and metrics live?
- How is the model exposed to downstream systems?
- How do we ensure runs are reproducible and testable?

This repository answers those questions with a clean, end-to-end design.

---

## High-Level Architecture

```
data -> features -> train -> evaluate -> model.joblib + metrics.json -> serve via FastAPI
```

- **Data**: Load existing CSV or generate a synthetic churn dataset
- **Features**: Built using `ColumnTransformer` and pipelines
- **Training**: End-to-end pipeline trains and persists artifacts
- **Evaluation**: Metrics saved alongside the model
- **Serving**: FastAPI loads the saved pipeline and serves predictions

The same preprocessing and model logic is used in both training and inference, eliminating train/serve skew.

---

## Model Performance

The default churn classifier (logistic regression with full preprocessing pipeline) achieves the following on a held-out test set:

| Metric | Value |
|--------|-------|
| AUC-ROC | 0.81 |
| Precision (threshold 0.5) | 0.74 |
| Recall (threshold 0.5) | 0.71 |
| F1 Score | 0.72 |

Metrics are generated automatically and saved to `models/metrics.json` on every run.

---

## Repository Structure

```
ml-production-pipeline/
├── config/
│   └── default.yaml          # Pipeline configuration
├── src/ml_pipeline/
│   ├── cli.py                # Entry point for running the pipeline
│   ├── data/                 # Data ingestion + synthetic generator
│   ├── features/             # Feature preprocessing
│   ├── models/               # Model factory
│   ├── training/             # Training + artifact persistence
│   ├── evaluation/           # Metrics and threshold evaluation
│   └── api/                  # FastAPI inference service
├── tests/
│   └── test_smoke_pipeline.py
└── README.md
```

Each layer has a single responsibility and is easy to extend.

---

## Quickstart

### Setup

```bash
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

### Run the Pipeline (End-to-End)

```bash
python -m ml_pipeline.cli run --config config/default.yaml
```

What this does:

- Generates a synthetic churn dataset if none exists
- Builds preprocessing and model pipelines
- Trains a classifier
- Evaluates it
- Persists artifacts to `models/`

Artifacts produced:

```
data/raw/customer_churn.csv
models/churn_model.joblib
models/metrics.json
```

### Run the Inference API

```bash
uvicorn ml_pipeline.api.app:app --host 0.0.0.0 --port 8000
```

Health check:

```bash
curl http://localhost:8000/health
```

Prediction request:

```bash
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{
    "tenure_months": 12,
    "monthly_charges": 85.5,
    "contract_type": "month-to-month",
    "has_internet": 1,
    "support_tickets_6m": 2,
    "payment_method": "credit_card"
  }'
```

---

## Engineering Decisions

**sklearn Pipelines**
Preprocessing and modeling are bundled into a single pipeline object, ensuring identical behavior during training and inference. This eliminates the most common source of train-serve skew.

**Config-driven execution**
All paths, random seeds, and hyperparameters live in YAML. Every run is deterministic and auditable from the config file alone.

**Artifact discipline**
Models and metrics are persisted to predictable, versioned locations. Nothing is ephemeral.

**CLI orchestration**
The entire pipeline runs from a single command, making it schedulable via cron, Airflow, or any other orchestrator without modification.

**API-first serving**
The model is exposed as a REST service, not a script or notebook. Downstream systems consume it over HTTP with a defined schema.

**CI-ready structure**
Linting and smoke tests are written to run in GitHub Actions with no additional configuration.

---

## What This Demonstrates

- Treating ML as a system, not a script
- Building reproducible pipelines with config-driven execution
- Separating concerns across data, features, training, and serving layers
- Eliminating train/serve skew through shared pipeline objects
- Shipping a model behind a production-style API
- Structuring an ML repository for team collaboration

---

## Future Work

- Add experiment tracking with MLflow
- Add data validation and drift monitoring
- Add batch inference jobs
- Introduce a model registry and canary deployments
- Integrate with a feature store

---

## License

MIT

---

## Contact

**Pranshu Kumar**
- GitHub: [github.com/pranshu1921](https://github.com/pranshu1921)
- LinkedIn: [linkedin.com/in/pranshu-kumar](https://www.linkedin.com/in/pranshu-kumar)
- Email: pranshukumarpremi@gmail.com
