-- ex1:
SELECT 
COUNT(
  CASE
    WHEN device_type = 'laptop' THEN 1
    ELSE null
  END) laptop_views,
COUNT(
  CASE
    WHEN device_type = 'tablet' OR device_type='phone' THEN 1
    ELSE null
  END) mobile_views
FROM viewership;

-- ex2:
SELECT *,
CASE
    WHEN x+y>z AND x+z>y AND z+y>x THEN 'Yes'
    ELSE 'No'
END triangle
FROM Triangle

-- ex3:
SELECT
ROUND(
  100.0 *COUNT(CASE 
  WHEN call_category='n/a' OR call_category IS NULL THEN 1 
  END) / COUNT(*),1) AS uncategorised_percentage
FROM callers

-- ex4:
SELECT name FROM Customer
WHERE referee_id <> 2 OR referee_id IS NULL;

-- ex5:
SELECT
    survived,
    COUNT(CASE WHEN pclass='1' THEN 1 END) AS first_class,
    COUNT(CASE WHEN pclass='2' THEN 1 END) AS second_class,
    COUNT(CASE WHEN pclass='3' THEN 1 END) AS third_class
FROM titanic
GROUP BY survived
    
