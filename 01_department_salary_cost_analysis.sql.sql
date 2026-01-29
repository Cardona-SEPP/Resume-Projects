/* Project: Department Salary Cost Analysis 

Business Question:
Which departments contribute the most to total payroll?

Metrics:
- Total salary cost per department
- Headcount
- Average salary
- % of total payroll
- Department ranking

Purpose:
Support leadership in understanding payroll concentration and identifying high-cost departments.
*/
 
SELECT COALESCE(es.dept_id, 'Unassigned') AS department_id,
	COALESCE(pd.department_name, 'Unassigned') AS department_name, # Label unknowns
    SUM(es.salary) AS total_salary,
    COUNT(es.employee_id) AS headcount, # Assuming one salary record per employee
    ROUND(AVG(es.salary)) AS emp_avg_salary,
    ROUND(SUM(es.salary) / SUM(SUM(es.salary)) OVER() * 100,2) AS pct_of_total_payroll,
    ROW_NUMBER() OVER(ORDER BY SUM(salary) DESC) AS department_rank
FROM employee_salary AS es
LEFT JOIN parks_departments AS pd # Left Join to ensure all departments with a salary is included
	ON es.dept_id = pd.department_id
GROUP BY es.dept_id, pd.department_name # Group on stable identifiers and select descriptive fields
;