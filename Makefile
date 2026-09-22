.PHONY: setup lint test run-pipeline run-api

setup:
	python -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt

lint:
	ruff check src tests

test:
	pytest -q

run-pipeline:
	python -m ml_pipeline.cli run --config config/default.yaml

run-api:
	uvicorn ml_pipeline.api.app:app --host 0.0.0.0 --port 8000
