-- JOINS

-- INNER JOIN

SELECT dem.employee_id,sal.first_name,occupation
FROM parks_and_recreation.employee_demographics AS dem
INNER JOIN parks_and_recreation.employee_salary AS sal
  ON dem.employee_id = sal.employee_id;
  
  -- OUTER JOIN 
  -- LEFT OUTER JOIN AND RIGHT OUTER JOIN
  
  SELECT *
FROM parks_and_recreation.employee_demographics AS dem
LEFT JOIN parks_and_recreation.employee_salary AS sal
  ON dem.employee_id = sal.employee_id;
  
  SELECT *
FROM parks_and_recreation.employee_demographics AS dem
RIGHT JOIN parks_and_recreation.employee_salary AS sal
  ON dem.employee_id = sal.employee_id;
  
  -- SELF JOIN
  
  SELECT *
FROM parks_and_recreation.employee_demographics AS dem
RIGHT JOIN parks_and_recreation.employee_salary AS sal
  ON dem.employee_id = sal.employee_id;
  
  SELECT *
  FROM parks_and_recreation.employee_salary emp1
  JOIN parks_and_recreation.employee_salary emp2
    ON emp1.employee_id + 1 = emp2.employee_id;
    
  SELECT emp1.employee_id AS emp_santa,
  emp1.first_name AS first_name_santa,
  emp1.last_name AS last_name_santa,
  emp2.employee_id AS emp_name,
  emp2.first_name AS first_name_emp,
  emp2.last_name AS last_name_emp
  FROM parks_and_recreation.employee_salary emp1
  JOIN parks_and_recreation.employee_salary emp2
    ON emp1.employee_id + 1 = emp2.employee_id;
    
    -- JOINING MULTIPLE TABLES TOGETHER
    select * 
    from parks_and_recreation.employee_salary;
    
    SELECT *
    FROM parks_and_recreation.employee_demographics AS dem
    INNER JOIN parks_and_recreation.employee_salary AS sal
		ON dem.employee_id = sal.employee_id
	INNER JOIN parks_and_recreation.parks_departments AS dep
		ON dep.department_id = sal.dept_id;
        
        -- UNIONS
        
        SELECT first_name,last_name
        FROM parks_and_recreation.employee_demographics
        UNION                                              -- UNION DISTINCT (ONLY UNIQUE VALUES BY DEFAULT)
        SELECT first_name,last_name
        FROM parks_and_recreation.employee_salary;
        
        SELECT first_name,last_name
        FROM parks_and_recreation.employee_demographics
        UNION ALL                                            
        SELECT first_name,last_name
        FROM parks_and_recreation.employee_salary;
        
        SELECT first_name,last_name
        FROM parks_and_recreation.employee_demographics
        UNION DISTINCT                                       -- UNION DISTINCT (ONLY UNIQUE VALUES BY DEFAULT)
        SELECT first_name,last_name
        FROM parks_and_recreation.employee_salary;
        
        SELECT first_name,last_name,'Old Man' AS Label
        FROM parks_and_recreation.employee_demographics
        WHERE age > 40 AND gender = 'Male'
        UNION
        SELECT first_name,last_name,'Old Lady' AS Label
        FROM parks_and_recreation.employee_demographics
        WHERE age > 40 AND gender = 'Female'
        UNION
        SELECT first_name,last_name,'Highly Paid employee' AS Label
        FROM parks_and_recreation.employee_salary
        WHERE salary > 70000
        ORDER BY first_name,last_name;
        
        -- STRING FUNCTIONS
        
        -- LENGTH OF A STRING
        
        SELECT LENGTH('SRUTHY');
        
        SELECT first_name ,LENGTH(first_name)
        FROM parks_and_recreation.employee_demographics
        ORDER BY 2;
        
        -- LOWER CASE AND UPPER CASE
         SELECT LOWER('SRUTHY');
          SELECT UPPER('data analyst');
          
          SELECT first_name ,UPPER(first_name)
		FROM parks_and_recreation.employee_demographics;
        
        -- TRIM
        -- LEFT TRIM AND RIGHT TRIM
        SELECT TRIM('       SKY    ');
         SELECT LTRIM('       SKY    ');
          SELECT RTRIM('       SKY    ');
          
 -- LEFT,RIGHT,SUBSTRING         
SELECT FIRST_NAME,
LEFT(first_name,4),
RIGHT(first_name,4),
SUBSTRING(first_name,3,2),
birth_date,
SUBSTRING(birth_date,6,2) AS birth_month
FROM parks_and_recreation.employee_demographics;

-- REPLACE

SELECT first_name ,REPLACE(first_name,'a','z')
FROM parks_and_recreation.employee_demographics;

-- LOCATE

SELECT LOCATE('U','SRUTHY');

SELECT first_name ,LOCATE('An',first_name)
FROM parks_and_recreation.employee_demographics;

-- CONCAT

SELECT first_name,last_name,
CONCAT(first_name,' ',last_name) AS Full_name
FROM parks_and_recreation.employee_demographics;

-- CASE STATEMENT

SELECT first_name,
last_name,
age,
CASE
	WHEN age < 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Old'
    WHEN age > 50 THEN "On Death's Door"
END AS Age_Bracket
FROM parks_and_recreation.employee_demographics;

-- Pay increase and Bonus
-- < 50000 = 5%
-- > 50000 = 7%
-- Finace - 10% bonus

SELECT first_name,
last_name,
salary,
dept_id,
CASE
	WHEN salary < 50000 THEN salary * 1.05
    WHEN salary > 50000 THEN salary * 1.07
END AS New_Salary,
CASE
	WHEN dept_id = 6 THEN salary * .10
END AS Bonus
FROM parks_and_recreation.employee_salary;

SELECT *
FROM parks_and_recreation.employee_demographics;

SELECT *
FROM parks_and_recreation.parks_departments;

SELECT * 
FROM parks_and_recreation.employee_salary;

-- SUBQUERIES ------------------------------------

SELECT *
FROM parks_and_recreation.employee_demographics;

SELECT *
FROM parks_and_recreation.parks_departments;

SELECT * 
FROM parks_and_recreation.employee_salary;

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE employee_id IN
					(SELECT employee_id    -- morethan one column not allowed if operant is use IN is operant
                    FROM parks_and_recreation.employee_salary
                    WHERE dept_id = 1)
;


SELECT first_name,salary,AVG(salary)
FROM parks_and_recreation.employee_salary
GROUP BY first_name , salary;

SELECT first_name,salary,
(SELECT AVG(salary)
FROM parks_and_recreation.employee_salary) 
FROM parks_and_recreation.employee_salary;


SELECT gender,AVG(age),MIN(age),MAX(age),COUNT(age)
FROM parks_and_recreation.employee_demographics
GROUP BY gender;

SELECT *
FROM(SELECT gender,AVG(age),MIN(age),MAX(age),COUNT(age)
FROM parks_and_recreation.employee_demographics
GROUP BY gender) AS Agg_table
;

SELECT gender,AVG(`MAX(age)`)
FROM(SELECT gender,AVG(age),MIN(age),MAX(age),COUNT(age)
FROM parks_and_recreation.employee_demographics
GROUP BY gender) AS Agg_table
GROUP BY gender
;

-- Windows Functions

SELECT gender,AVG(salary) AS avg_salary
FROM parks_and_recreation.employee_demographics as dem
JOIN
parks_and_recreation.employee_salary AS sal
	ON dem.employee_id = sal.employee_id
    GROUP BY gender;
    
    SELECT dem.first_name,dem.last_name,gender,
    AVG(salary) OVER(PARTITION BY gender)  -- nothing effect the avg column if additional column come
    FROM parks_and_recreation.employee_demographics as dem
JOIN
parks_and_recreation.employee_salary AS sal                      -- but in group by effect avg column beacause needs to group each column again
	ON dem.employee_id = sal.employee_id;
    

					

        
SELECT dem.employee_id,dem.first_name,dem.last_name,gender,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total
    FROM parks_and_recreation.employee_demographics as dem
JOIN
parks_and_recreation.employee_salary AS sal    
	ON dem.employee_id = sal.employee_id;
    
    -- ROW NUMBER AND DENCE
    
SELECT dem.employee_id,dem.first_name,dem.last_name,gender,
ROW_NUMBER() OVER()
    FROM parks_and_recreation.employee_demographics as dem
JOIN
parks_and_recreation.employee_salary AS sal    
	ON dem.employee_id = sal.employee_id;
    
    SELECT dem.employee_id,dem.first_name,dem.last_name,gender,
ROW_NUMBER() OVER(PARTITION BY gender)
    FROM parks_and_recreation.employee_demographics as dem
JOIN
parks_and_recreation.employee_salary AS sal    
	ON dem.employee_id = sal.employee_id;
    
     SELECT dem.employee_id,dem.first_name,dem.last_name,gender,sal.salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC)
    FROM parks_and_recreation.employee_demographics as dem
JOIN
parks_and_recreation.employee_salary AS sal    
	ON dem.employee_id = sal.employee_id;
    
        
            SELECT dem.employee_id,dem.first_name,dem.last_name,gender,sal.salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS Row_num, -- numerically count just row count
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS Rank_num,  -- positionally count duplicates come same int and count the position wise
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS Dense_Rank_num -- numerically
    FROM parks_and_recreation.employee_demographics as dem
JOIN
parks_and_recreation.employee_salary AS sal    
	ON dem.employee_id = sal.employee_id;  
    
  
  