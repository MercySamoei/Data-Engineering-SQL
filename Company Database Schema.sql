/*Creating Tables*/ 

CREATE TABLE employee (
emp_id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
birth_day DATE,
sex VARCHAR(1),
salary INT,
super_id INT,
branch_id int
);

CREATE TABLE branch ( 
branch_id INT PRIMARY KEY, 
branch_name VARCHAR(40), 
mgr_id INT,
mgr_start_date DATE,
FOREIGN KEY(mgr_id) 
REFERENCES employee(emp_id) ON DELETE SET NULL 
);

ALTER TABLE employee 
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
emp_id INT,
client_id INT,
TOTAL_SALES INT,
PRIMARY KEY(emp_id, client_id),
FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);
 
CREATE TABLE branch_supplier ( 
branch_id INT,
supplier_name VARCHAR(40),
supply_type VARCHAR(40),
PRIMARY KEY(branch_id, supplier_name),
FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

DESCRIBE employee

/* Populating the table*/

-- Corporate
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);
-- INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);

-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

-- FUNCTIONS
-- Find the number of employees
SELECT COUNT(super_id)
FROM employee; /*8*/  


SELECT ROUND(AVG(salary))
FROM employee; /*The ROUND function will round off the salary of the employees 92888.8889*/ 

-- Find the sum of all employee's salaries
SELECT SUM(salary)
FROM employee;

SELECT min(salary)
FROM employee;

-- Find out how many males and females there are
SELECT COUNT(sex) sex
FROM employee
GROUP BY sex;

-- Find the total sales of each salesman
SELECT SUM(TOTAL_SALES) emp_id
FROM works_with
GROUP BY client_id;  
 
 -- Find the total amount of money spent by each client
SELECT SUM(total_sales) client_id
FROM works_with
GROUP BY client_id;

/*Wilcards. These are like RegEx. 
They are used forstand in for unknown characters in a text value and are handy for 
locating multiple items with similar, but not identical data*/
/*Finding all companies with an LLC. % is used to find all that come before a character. _is used for one specific character.
*/
 
SELECT *
FROM client
WHERE client_name LIKE '%LLC' ;

-- Find any branch suppliers who are in the label business
SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '%label%' ;

DESCRIBE client;
-- Find any employee born on the 10th day of the month
SELECT *
FROM employee 
WHERE birth_day LIKE '_____02%'; 

 -- Find any clients who are schools
SELECT *
FROM client
WHERE client_name LIKE '%school%' ;

/*Joins- JOIN is an SQL clause used to query and access data from multiple tables, based on logical relationships
between those tables. It puts two groups together*/

-- Find a list of employee and branch names
SELECT employee.first_name AS Employee_Branch_Names
FROM employee
UNION
SELECT branch.branch_name
FROM branch ;

-- Find a list of all clients & branch suppliers' names
SELECT client.client_name AS Non_Employee_Entities
FROM client
UNION 
SELECT branch_supplier.supplier_name
FROM branch_supplier;

/*Joins. These are clauses used to combine rows from two or more tables, 
based on a related column between them.*/

-- Add the extra branch
INSERT INTO branch VALUES(4, "Buffalo", NULL, NULL);

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch    -- LEFT JOIN, RIGHT JOIN
ON employee.emp_id = branch.mgr_id;

-- Nested Queries IN is vv important
/*A nested query is a query which is nested inside a another query. It is used in: A SELECT & WHERE clause.*/
-- Find names of all employees who have sold over 50,000. For this, I will first select sales that are over 50000

DESCRIBE works_with;
DESCRIBE employee;
DESCRIBE client;
DESCRIBE branch;

SELECT employee.first_name 
FROM employee
WHERE employee.emp_id IN ( SELECT works_with.emp_id
FROM works_with 
WHERE works_with.TOTAL_SALES > 50000); 

-- Find all clients who are handled by the branch that Michael Scott manages
-- Assume you know Michael's ID

SELECT client.client_name, client.client_id
FROM client
WHERE client.client_id IN ( SELECT branch.branch_id
FROM branch
WHERE branch.mgr_id = 102);
   
 -- Find all clients who are handles by the branch that Michael Scott manages
 -- Assume you DONT'T know Michael's ID
 
 SELECT client.client_name, client.client_id
 FROM client
 WHERE client.branch_id IN ( SELECT branch.branch_id
 FROM branch
 WHERE branch.mgr_id = ( SELECT employee.emp_id
 FROM employee
 WHERE employee.first_name = 'Michael' AND employee.last_name ='Scott'
LIMIT 1));
 
-- Find the names of employees who work with clients handled by the scranton branch (My version)
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.branch_id IN (SELECT client.branch_id 
FROM client 
WHERE client.branch_id IN ( SELECT branch.branch_name
FROM branch
WHERE branch_name = 'Scranton' ));

/*Correct work*/ 
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
                         SELECT works_with.emp_id
                         FROM works_with
                         )
AND employee.branch_id = 2;

-- Find the names of all clients who have spent more than 100,000 dollars
SELECT client.client_name
FROM client
WHERE client.client_id IN (
                          SELECT client_id
                          FROM (
                                SELECT SUM(works_with.total_sales) AS totals, client_id
                                FROM works_with
                                GROUP BY client_id) AS total_client_sales
                          WHERE totals > 100000);
    /*Trigger: is a special type of stored procedure that is invoked automatically in response to an event.
--     END;                    
   -- CREATE
--     TRIGGER `event_name` BEFORE/AFTER INSERT/UPDATE/DELETE
--     ON `database`.`table`
--     FOR EACH ROW BEGIN
-- 		-- trigger body
-- 		-- this code is applied to every
-- 		-- inserted/updated/deleted */
              
CREATE TABLE trigger_test (
     message VARCHAR(100)
);        

DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES('added new employee');
    END$$
DELIMITER ;
INSERT INTO employee
VALUES(109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);
      
SELECT * FROM trigger_test ;


DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES(NEW.first_name);
    END$$
DELIMITER ;
INSERT INTO employee
VALUES(110, 'Kevin', 'Malone', '1978-02-19', 'M', 69000, 106, 3);

drop TRIGGER my_trigger ;

DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
         IF NEW.sex = 'M' THEN
               INSERT INTO trigger_test VALUES('added male employee');
         ELSEIF NEW.sex = 'F' THEN
               INSERT INTO trigger_test VALUES('added female');
         ELSE
               INSERT INTO trigger_test VALUES('added other employee');
         END IF;
    END$$
DELIMITER ;
INSERT INTO employee
VALUES(111, 'Pam', 'Beesly', '1988-02-19', 'F', 69000, 106, 3);

