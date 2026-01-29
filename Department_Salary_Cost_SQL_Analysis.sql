/* Total salary cost by department */

SELECT COALESCE(es.dept_id, 'Unassigned') AS department_id,
	COALESCE(pd.department_name, 'Unassigned') AS department_name, # Label unknowns
    SUM(es.salary) AS total_salary,
    COUNT(es.employee_id) AS headcount, # Assuming one salary record per employee
    ROUND(AVG(es.salary)) AS avg_salary,
    ROUND(SUM(es.salary) / SUM(SUM(es.salary)) OVER() * 100,2) AS pct_of_total_payroll,
    ROW_NUMBER() OVER(ORDER BY SUM(salary) DESC) AS row_num
FROM employee_salary AS es
LEFT JOIN parks_departments AS pd # Left Join to ensure all departments with a salary is included
	ON es.dept_id = pd.department_id
GROUP BY es.dept_id, pd.department_name # Group on stable identifiers and select descriptive fields
;
