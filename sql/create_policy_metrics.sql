-- ============================================================
-- create_policy_metrics.sql
-- Build aggregated policy-level metrics table for scoring
-- ============================================================

-- 1. Drop previous table if it exists
DROP TABLE IF EXISTS policy_metrics_agg;

-- 2. Create a clean, one-row-per-policy table
-- frequency  = total number of claims
-- severity   = average loss per claim
-- is_fraud   = set to 1 if any claim from this policy was marked fraudulent
CREATE TABLE policy_metrics_agg AS
SELECT
    policy_id,
    SUM(frequency) AS frequency,
    AVG(severity) AS severity,
    MAX(is_fraud) AS is_fraud
FROM policy_metrics
GROUP BY policy_id;

-- 3. Sanity check (optional)
SELECT COUNT(*) AS total_policies,
       SUM(is_fraud) AS fraud_marked_policies
FROM policy_metrics_agg;

-- ============================================================
-- END OF FILE
-- ============================================================
