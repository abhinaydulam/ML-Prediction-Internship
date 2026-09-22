# Model Card — Customer Churn Classifier

## Model
- Logistic Regression (sklearn Pipeline)
- Saved as `models/churn_model.joblib`

## Data
- Synthetic churn dataset (unless CSV exists)
- Target: `churned`

## Inputs
- tenure_months
- monthly_charges
- contract_type
- has_internet
- support_tickets_6m
- payment_method

## Metrics
- ROC AUC
- Average Precision

## Limitations
- Synthetic data
- Simple linear model
- No calibration

## Intended use
- Demonstration of production ML pipeline
- Not for real business decisions
