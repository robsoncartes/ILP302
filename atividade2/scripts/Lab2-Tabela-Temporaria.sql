-- DROP TABLE calculo_reajuste_salarial;

CREATE GLOBAL TEMPORARY TABLE calculo_reajuste_salarial (
    employee_id NUMBER(6) PRIMARY KEY,
    first_name VARCHAR2(20),
    last_name VARCHAr2(25) NOT NULL,
    salary NUMBER(8, 2),
    job_id VARCHAR2(10) NOT NULL,
    job_title VARCHAR2(35) NOT NULL,
    avg_job_salary NUMBER(8, 2),
    department_id NUMBER(4) NOT NULL,
    department_name VARCHAR2(30) NOT NULL,
    avg_dpt_salary NUMBER(8, 2)

) ON COMMIT PRESERVE ROWS;

INSERT INTO calculo_reajuste_salarial (
    SELECT
           e.employee_id, e.FIRST_NAME, e.LAST_NAME, e.SALARY,
           j.job_id, j.job_title, g.avg_job_salary,
           d.department_id, d.department_name, h.avg_dpt_salary
    FROM DEPARTMENTS d
        INNER JOIN EMPLOYEES E on e.DEPARTMENT_ID = d.DEPARTMENT_ID
        INNER JOIN JOBS  j on j.JOB_ID = e.JOB_ID
        INNER JOIN (
            SELECT f.job_id, f.department_id, ROUND(AVG(f.salary), 2)  avg_job_salary FROM EMPLOYEES f
            GROUP BY f.job_id, f.department_id) g ON e.JOB_ID = g.JOB_ID
        INNER JOIN (
            SELECT f.department_id, ROUND(AVG(f.salary), 2) avg_dpt_salary FROM EMPLOYEES f
            GROUP BY f.department_id ) h ON d.DEPARTMENT_ID = h.DEPARTMENT_ID
    WHERE d.DEPARTMENT_ID = g.DEPARTMENT_ID
) ORDER BY d.department_name;

SELECT c.job_id, c.job_title, c.department_id, c. department_name, c.avg_dpt_salary, COUNT(c.employee_id)
FROM calculo_reajuste_salarial c GROUP BY c.job_id, c.job_title, c.department_id, c.department_name, c.avg_dpt_salary
ORDER BY COUNT(c.employee_id) DESC;

SELECT department_id, department_name, first_name || ' ' || last_name AS full_name, salary, avg_dpt_salary,
    CASE 
        WHEN SALARY < avg_dpt_salary THEN 'Salário menor que a média salarial do departmento'
        WHEN SALARY > avg_dpt_salary THEN 'Salário maior que a média salarial do departmento'
    END AS "Departamento x Salário"
FROM calculo_reajuste_salarial WHERE department_name = 'IT';

UPDATE calculo_reajuste_salarial
SET salary = salary + (ABS(avg_dpt_salary - salary) * 0.1);

SELECT *FROM calculo_reajuste_salarial;