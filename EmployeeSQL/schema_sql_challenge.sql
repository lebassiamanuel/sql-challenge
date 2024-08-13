DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;


CREATE TABLE titles (
	title_id VARCHAR(5) PRIMARY KEY,
	title  TEXT NOT NULL
);

CREATE TABLE departments (
	dept_no  VARCHAR(4) PRIMARY KEY,
	dept_name  TEXT NOT NULL
);


CREATE TABLE employees(
    emp_no INT PRIMARY KEY,
	emp_title_id VARCHAR(5) NOT NULL,
    birth_date DATE NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    sex VARCHAR(1) NOT NULL,
    hire_date DATE NOT NULL,
    FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
    PRIMARY KEY (emp_no, dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);


CREATE TABLE dept_manager(
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
    PRIMARY KEY (dept_no, emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);


CREATE TABLE salaries(
	emp_no INT NOT NULL,
    salary INT NOT NULL,
    PRIMARY KEY (emp_no, salary),
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);



SELECT * FROM departments;
SELECT * FROM titles;
SELECT * FROM employees;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM salaries;

-- Data Analysis Queries
-- 1. List the employee number, last name, first name, sex, and salary of each employee.

SELECT emp.emp_no, emp.first_name, emp.last_name, emp.sex, sal.salary
FROM employees AS emp
INNER JOIN salaries AS sal ON
emp.emp_no = sal.emp_no;
	-- resulted in 300024 raws

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT emp.first_name, emp.last_name, emp.hire_date
FROM employees AS emp
WHERE date_part('year', hire_date) = 1986;
	-- resulted in 36150 raws


-- 3. List the manager of each department along with their department number, department name, employee number, 
--    last name, and first name.

SELECT manager.dept_no, dept.dept_name,  
emp.emp_no, emp.first_name, emp.last_name
FROM dept_manager AS manager 
INNER JOIN departments AS dept ON
	manager.dept_no = dept.dept_no
INNER JOIN employees AS emp ON
    manager.emp_no = emp.emp_no;
	-- resulted in 24 raws 


--4. List the department number for each employee along with that employee’s employee number, last name, 
--   first name, and department name.

SELECT dept_emp.dept_no
    , dept_emp.emp_no
    , emp.last_name
    , emp.first_name
    , dept.dept_name
FROM dept_emp
INNER JOIN employees AS emp ON
    dept_emp.emp_no = emp.emp_no
INNER JOIN departments AS dept ON
    dept_emp.dept_no = dept.dept_no;
    -- resulted in 331,603 raws

--5. List first name, last name, and sex of each employee whose first name is Hercules and 
--    whose last name begins with the letter B.

SELECT first_name
    , last_name
    , sex
FROM employees as emp
WHERE emp.first_name = 'Hercules'
    AND emp.last_name LIKE 'B%'
	-- resulted in 20 raws



--6. List each employee in the Sales department, including their employee number, last name, and first name.

SELECT emp.emp_no,
     emp.last_name,
	 emp.first_name
FROM employees AS emp
INNER JOIN dept_emp ON
	dept_emp.emp_no = emp.emp_no
INNER JOIN departments AS dept ON
	dept.dept_no = dept_emp.dept_no
WHERE dept.dept_name = 'Sales';
	-- resulted in 52,245 raws


--7. List each employee in the Sales and Development departments, including their employee number, last name, 
--   first name, and department name.

SELECT emp.emp_no,
	emp.last_name,
	emp.first_name,
	dept.dept_name
FROM employees AS emp
INNER JOIN dept_emp ON
      dept_emp.emp_no = emp.emp_no
INNER JOIN departments AS dept ON
    dept.dept_no = dept_emp.dept_no
WHERE dept.dept_name IN ('Sales', 'Development');
    -- resulted in 137,952 raws


--8. List the frequency counts, in descending order, of all the employee last names 
--   (that is, how many employees share each last name).


SELECT emp.last_name,
       count(emp.last_name)
FROM employees AS emp
GROUP BY emp.last_name
ORDER BY count(emp.last_name) DESC;
    -- resulted in 1,638 last names


