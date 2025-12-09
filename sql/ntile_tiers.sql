-- ============================================================
-- ntile_tiers.sql
-- Build normalized scoring views + NTILE(3) risk tiers
-- ============================================================

-- -----------------------------
-- Drop old views if they exist
-- -----------------------------
DROP VIEW IF EXISTS vw_policy_scores_agg;
DROP VIEW IF EXISTS vw_risk_tiers_agg;
DROP VIEW IF EXISTS vw_tier_ntile_agg;

-- ------------------------------------------------
-- 1. Normalized view (min–max scaling)
-- ------------------------------------------------
CREATE VIEW vw_policy_scores_agg AS
SELECT
    policy_id,
    frequency,
    severity,
    is_fraud,

    -- Normalized severity: 0 to 1
    (CASE WHEN (SELECT MAX(severity) FROM policy_metrics_agg) =
               (SELECT MIN(severity) FROM policy_metrics_agg)
          THEN 0.5
          ELSE (severity - (SELECT MIN(severity) FROM policy_metrics_agg)) /
               ((SELECT MAX(severity) FROM policy_metrics_agg) -
                (SELECT MIN(severity) FROM policy_metrics_agg))
     END) AS severity_norm,

    -- Normalized frequency
    (CASE WHEN (SELECT MAX(frequency) FROM policy_metrics_agg) =
               (SELECT MIN(frequency) FROM policy_metrics_agg)
          THEN 0.5
          ELSE (frequency - (SELECT MIN(frequency) FROM policy_metrics_agg)) /
               ((SELECT MAX(frequency) FROM policy_metrics_agg) -
                (SELECT MIN(frequency) FROM policy_metrics_agg))
     END) AS frequency_norm,

    -- Normalized fraud indicator
    (CASE WHEN (SELECT MAX(is_fraud) FROM policy_metrics_agg) =
               (SELECT MIN(is_fraud) FROM policy_metrics_agg)
          THEN 0.5
          ELSE (is_fraud - (SELECT MIN(is_fraud) FROM policy_metrics_agg)) /
               ((SELECT MAX(is_fraud) FROM policy_metrics_agg) -
                (SELECT MIN(is_fraud) FROM policy_metrics_agg))
     END) AS fraud_norm

FROM policy_metrics_agg;

-- ------------------------------------------------
-- 2. Final Score view
-- Final Score = 0.4*severity + 0.3*frequency + 0.3*fraud
-- ------------------------------------------------
CREATE VIEW vw_risk_tiers_agg AS
SELECT
    *,
    (0.4 * severity_norm +
     0.3 * frequency_norm +
     0.3 * fraud_norm) AS final_score
FROM vw_policy_scores_agg;

-- ------------------------------------------------
-- 3. NTILE(3) Risk Tiers
-- 1 = Low Risk
-- 2 = Medium Risk
-- 3 = High Risk
-- ------------------------------------------------
CREATE VIEW vw_tier_ntile_agg AS
SELECT
    *,
    NTILE(3) OVER (ORDER BY final_score) AS tier_bucket
FROM vw_risk_tiers_agg;

-- ------------------------------------------------
-- 4. Useful queries (reference only)
-- ------------------------------------------------

-- Count policies in each tier
-- SELECT tier_bucket, COUNT(*) FROM vw_tier_ntile_agg GROUP BY tier_bucket;

-- Top 10 highest risk policies
-- SELECT * FROM vw_tier_ntile_agg ORDER BY final_score DESC LIMIT 10;

-- ============================================================
-- END OF FILE
-- ============================================================
