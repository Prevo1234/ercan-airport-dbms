-- =====================================================================
-- ERCAN AIRPORT MANAGEMENT INFORMATION SYSTEM
-- File: 03_QUERIES.sql
-- 15 statistical / management queries
-- Techniques used: JOIN, LEFT JOIN, subquery, correlated subquery,
--                  GROUP BY, HAVING, DATE_FORMAT (to_char equivalent),
--                  aggregate functions, CASE, UNION, NOT EXISTS
-- =====================================================================

USE ercan_airport;

-- ---------------------------------------------------------------------
-- Q1.  Top 5 technicians by total hours spent on testing
--      Demonstrates: JOIN, GROUP BY, ORDER BY, LIMIT
-- ---------------------------------------------------------------------
SELECT  e.ssn,
        CONCAT(e.first_name,' ',e.last_name)  AS technician_name,
        t.certification_level,
        COUNT(te.test_event_id)               AS tests_performed,
        ROUND(SUM(te.hours_spent),2)          AS total_hours
FROM    Technician t
JOIN    Employee  e  ON t.ssn = e.ssn
JOIN    TestEvent te ON te.technician_ssn = t.ssn
GROUP BY e.ssn, e.first_name, e.last_name, t.certification_level
ORDER BY total_hours DESC
LIMIT 5;

-- ---------------------------------------------------------------------
-- Q2.  Average test score per plane model
--      Demonstrates: multi-table JOIN, GROUP BY, AVG, ROUND
-- ---------------------------------------------------------------------
SELECT  pm.model_no,
        pm.manufacturer,
        pm.model_name,
        COUNT(te.test_event_id)        AS total_tests,
        ROUND(AVG(te.score),2)         AS average_score,
        MIN(te.score)                  AS lowest_score,
        MAX(te.score)                  AS highest_score
FROM    PlaneModel pm
JOIN    Airplane   a  ON a.model_no = pm.model_no
JOIN    TestEvent  te ON te.plane_no = a.plane_no
GROUP BY pm.model_no, pm.manufacturer, pm.model_name
ORDER BY average_score DESC;

-- ---------------------------------------------------------------------
-- Q3.  Traffic controllers whose annual medical exam is overdue
--      (last exam more than 12 months ago)
--      Demonstrates: date arithmetic, JOIN
-- ---------------------------------------------------------------------
SELECT  e.ssn,
        CONCAT(e.first_name,' ',e.last_name) AS controller_name,
        tc.license_no,
        tc.last_medical_exam_date,
        DATEDIFF(CURDATE(), tc.last_medical_exam_date) AS days_since_exam,
        CASE
            WHEN DATEDIFF(CURDATE(), tc.last_medical_exam_date) > 365 THEN 'OVERDUE'
            WHEN DATEDIFF(CURDATE(), tc.last_medical_exam_date) > 330 THEN 'DUE SOON'
            ELSE 'OK'
        END AS exam_status
FROM    TrafficController tc
JOIN    Employee e ON e.ssn = tc.ssn
WHERE   DATEDIFF(CURDATE(), tc.last_medical_exam_date) > 330
ORDER BY tc.last_medical_exam_date ASC;

-- ---------------------------------------------------------------------
-- Q4.  Number of test events per month in 2026
--      Demonstrates: DATE_FORMAT (MySQL equivalent of to_char), GROUP BY
-- ---------------------------------------------------------------------
SELECT  DATE_FORMAT(te.test_date,'%Y-%m')   AS yr_month,
        DATE_FORMAT(te.test_date,'%M %Y')   AS month_label,
        COUNT(*)                            AS test_count,
        ROUND(AVG(te.score),2)              AS avg_score,
        ROUND(SUM(te.hours_spent),2)        AS total_hours
FROM    TestEvent te
WHERE   YEAR(te.test_date) = 2026
GROUP BY DATE_FORMAT(te.test_date,'%Y-%m'), DATE_FORMAT(te.test_date,'%M %Y')
ORDER BY yr_month;

-- ---------------------------------------------------------------------
-- Q5.  Airplanes that have NEVER been tested
--      Demonstrates: LEFT JOIN with NULL filter (anti-join)
-- ---------------------------------------------------------------------
SELECT  a.plane_no,
        a.model_no,
        a.status,
        a.manufacture_date
FROM    Airplane a
LEFT JOIN TestEvent te ON te.plane_no = a.plane_no
WHERE   te.test_event_id IS NULL
ORDER BY a.plane_no;

-- ---------------------------------------------------------------------
-- Q6.  Technicians who are experts on more than 2 plane models
--      Demonstrates: GROUP BY + HAVING, GROUP_CONCAT
-- ---------------------------------------------------------------------
SELECT  e.ssn,
        CONCAT(e.first_name,' ',e.last_name) AS technician_name,
        t.certification_level,
        COUNT(exp.model_no)                  AS model_count,
        GROUP_CONCAT(exp.model_no ORDER BY exp.model_no SEPARATOR ', ') AS expert_models
FROM    Technician t
JOIN    Employee   e   ON e.ssn = t.ssn
JOIN    TechnicianExpertise exp ON exp.ssn = t.ssn
GROUP BY e.ssn, e.first_name, e.last_name, t.certification_level
HAVING  COUNT(exp.model_no) > 2
ORDER BY model_count DESC;

-- ---------------------------------------------------------------------
-- Q7.  Hangar utilisation report — current occupancy and capacity
--      Demonstrates: correlated subquery, calculated percentage
-- ---------------------------------------------------------------------
SELECT  h.hangar_no,
        h.location,
        h.capacity,
        (SELECT COUNT(*)
           FROM HangarStay hs
          WHERE hs.hangar_no = h.hangar_no
            AND hs.out_datetime IS NULL)                  AS currently_occupied,
        h.capacity -
        (SELECT COUNT(*)
           FROM HangarStay hs
          WHERE hs.hangar_no = h.hangar_no
            AND hs.out_datetime IS NULL)                  AS free_slots,
        ROUND(100 *
            (SELECT COUNT(*)
               FROM HangarStay hs
              WHERE hs.hangar_no = h.hangar_no
                AND hs.out_datetime IS NULL) / h.capacity, 2) AS utilisation_pct
FROM    Hangar h
ORDER BY utilisation_pct DESC;

-- ---------------------------------------------------------------------
-- Q8.  Top 3 most expensive completed repair jobs with full details
--      Demonstrates: multi-table JOIN, computed total cost
-- ---------------------------------------------------------------------
SELECT  r.repair_id,
        a.plane_no,
        pm.model_name,
        CONCAT(e.first_name,' ',e.last_name)   AS technician,
        r.repair_date,
        r.parts_cost,
        r.labor_hours,
        (r.parts_cost + r.labor_hours * 75.00) AS total_cost,  -- labor at $75/hr
        r.problem_description
FROM    Repair    r
JOIN    Airplane  a  ON a.plane_no = r.plane_no
JOIN    PlaneModel pm ON pm.model_no = a.model_no
JOIN    Employee  e  ON e.ssn = r.technician_ssn
WHERE   r.status = 'COMPLETED'
ORDER BY total_cost DESC
LIMIT 3;

-- ---------------------------------------------------------------------
-- Q9.  Average time spent on each test type
--      Demonstrates: JOIN with catalog table, GROUP BY
-- ---------------------------------------------------------------------
SELECT  t.test_id,
        t.test_name,
        t.frequency_months,
        COUNT(te.test_event_id)         AS times_performed,
        ROUND(AVG(te.hours_spent),2)    AS avg_hours,
        ROUND(AVG(te.score),2)          AS avg_score
FROM    Test t
LEFT JOIN TestEvent te ON te.test_id = t.test_id
GROUP BY t.test_id, t.test_name, t.frequency_months
ORDER BY avg_hours DESC;

-- ---------------------------------------------------------------------
-- Q10. Employees hired in last 2 years, grouped by employee type
--      Demonstrates: date filtering, GROUP BY with aggregate
-- ---------------------------------------------------------------------
SELECT  e.employee_type,
        COUNT(*)                       AS new_hires,
        ROUND(AVG(e.salary),2)         AS avg_salary,
        MIN(e.hire_date)               AS earliest_hire,
        MAX(e.hire_date)               AS most_recent_hire
FROM    Employee e
WHERE   e.hire_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
GROUP BY e.employee_type
ORDER BY new_hires DESC;

-- ---------------------------------------------------------------------
-- Q11. Airplanes with at least one FAILING test score
--      (score below 50% of the test's max_score)
--      Demonstrates: JOIN with computed comparison, DISTINCT
-- ---------------------------------------------------------------------
SELECT  DISTINCT
        a.plane_no,
        pm.model_name,
        a.status,
        te.test_date,
        t.test_name,
        te.score,
        t.max_score,
        ROUND(100 * te.score / t.max_score, 1) AS score_percentage
FROM    Airplane  a
JOIN    PlaneModel pm ON pm.model_no = a.model_no
JOIN    TestEvent  te ON te.plane_no = a.plane_no
JOIN    Test       t  ON t.test_id   = te.test_id
WHERE   te.score < (t.max_score * 0.5)
ORDER BY score_percentage ASC;

-- ---------------------------------------------------------------------
-- Q12. For each technician, count of DISTINCT planes they have tested
--      Demonstrates: COUNT DISTINCT, JOIN
-- ---------------------------------------------------------------------
SELECT  e.ssn,
        CONCAT(e.first_name,' ',e.last_name) AS technician_name,
        COUNT(DISTINCT te.plane_no)          AS distinct_planes_tested,
        COUNT(te.test_event_id)              AS total_tests_run
FROM    Technician t
JOIN    Employee   e  ON e.ssn = t.ssn
LEFT JOIN TestEvent te ON te.technician_ssn = t.ssn
GROUP BY e.ssn, e.first_name, e.last_name
ORDER BY distinct_planes_tested DESC;

-- ---------------------------------------------------------------------
-- Q13. Plane models that have NO certified expert technician
--      Demonstrates: NOT EXISTS subquery
-- ---------------------------------------------------------------------
SELECT  pm.model_no,
        pm.manufacturer,
        pm.model_name,
        (SELECT COUNT(*) FROM Airplane a WHERE a.model_no = pm.model_no) AS planes_owned
FROM    PlaneModel pm
WHERE   NOT EXISTS (
            SELECT 1
            FROM   TechnicianExpertise exp
            WHERE  exp.model_no = pm.model_no
        )
ORDER BY planes_owned DESC;

-- ---------------------------------------------------------------------
-- Q14. Flights handled per traffic controller, grouped by month
--      Demonstrates: DATE_FORMAT, GROUP BY with multiple columns
-- ---------------------------------------------------------------------
SELECT  CONCAT(e.first_name,' ',e.last_name) AS controller,
        tc.shift,
        DATE_FORMAT(f.departure_datetime,'%Y-%m') AS yr_month,
        COUNT(f.flight_id) AS flights_handled,
        SUM(CASE WHEN f.flight_status='ARRIVED'   THEN 1 ELSE 0 END) AS `completed`,
        SUM(CASE WHEN f.flight_status='DELAYED'   THEN 1 ELSE 0 END) AS `delayed`,
        SUM(CASE WHEN f.flight_status='CANCELLED' THEN 1 ELSE 0 END) AS `cancelled`
FROM    TrafficController tc
JOIN    Employee e ON e.ssn = tc.ssn
JOIN    Flight   f ON f.controller_ssn = tc.ssn
GROUP BY e.ssn, e.first_name, e.last_name, tc.shift,
         DATE_FORMAT(f.departure_datetime,'%Y-%m')
ORDER BY yr_month, flights_handled DESC;

-- ---------------------------------------------------------------------
-- Q15. Airplanes that spent more than 5 days TOTAL in hangars in 2026
--      Demonstrates: DATEDIFF, COALESCE for open stays, GROUP BY + HAVING
-- ---------------------------------------------------------------------
SELECT  a.plane_no,
        pm.model_name,
        COUNT(hs.stay_id) AS number_of_stays,
        SUM(
            DATEDIFF(
                COALESCE(hs.out_datetime, NOW()),
                hs.in_datetime
            )
        ) AS total_days_in_hangar
FROM    Airplane  a
JOIN    PlaneModel pm ON pm.model_no = a.model_no
JOIN    HangarStay hs ON hs.plane_no = a.plane_no
WHERE   YEAR(hs.in_datetime) = 2026
GROUP BY a.plane_no, pm.model_name
HAVING  total_days_in_hangar > 5
ORDER BY total_days_in_hangar DESC;

-- =====================================================================
-- END OF QUERIES
-- =====================================================================
