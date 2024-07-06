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
