--0917, Day36
-- ���� ���� 6-1. JOIN �ǽ�.pdf
--3. DEPT Table�� �ִ� ��� �μ��� ����ϰ�, EMP Table�� �ִ� DATA�� JOIN�Ͽ� ���
--����� �̸�, �μ���ȣ, �μ���, �޿��� ����϶�. OUTER JOIN�� ����ؾ� �Ϻ��� ��
--��ǥ��
SELECT e.ename, e.deptno, d.dname, e.sal
FROM emp e,dept d
WHERE e.deptno = d.deptno;
--ǥ��
SELECT ename, deptno, dname, sal
FROM emp NATURAL JOIN dept;

SELECT e.ename, deptno, d.dname, e.sal
FROM emp e INNER JOIN dept d USING (deptno);

SELECT ename, d.deptno, dname, sal
FROM emp e INNER JOIN dept d ON e.deptno = d.deptno;

--5. ��ALLEN:�� ������ ���� ����� �̸�, �μ���, �޿�, ȸ����ġ, ������ ����϶�.
--���������� ����ϴ� �������� ���⼭�� SELECT�� �ι� �̻� �ߴٰ� ����
SELECT job
FROM emp
WHERE ename = 'ALLEN';
--��ǥ��
SELECT ename, dname, sal, loc, job
FROM emp e, dept d
WHERE e.deptno = d.deptno AND job = 'SALESMAN';
--ǥ��
SELECT ename, dname, sal, loc, job
FROM emp NATURAL JOIN dept
WHERE job = 'SALESMAN';

SELECT ename, dname, sal, loc, job
FROM emp INNER JOIN dept USING (deptno)
WHERE job = 'SALESMAN';

SELECT ename, dname, sal, loc, job
FROM emp e INNER JOIN dept d ON e.deptno = d.deptno
WHERE job = 'SALESMAN';

--6. ��JAMES���� �����ִ� �μ��� ��� ����� �����ȣ, �̸�, �Ի���, �޿��� ����϶�.
SELECT dname
FROM emp NATURAL JOIN dept
WHERE ename = 'JAMES';
--ǥ��
SELECT empno, ename, hiredate, sal
FROM emp e, dept d
WHERE e.deptno = d.deptno AND dname = 'SALES';
--��ǥ��
SELECT empno, ename, hiredate, sal
FROM emp NATURAL JOIN dept
WHERE dname = 'SALES';

--9. 10�� �μ� �߿��� 30�� �μ����� ���� ������ �ϴ� ����� �����ȣ, �̸�, �μ���,
--�Ի���, ������ ����϶�.
SELECT job
FROM emp
WHERE deptno = 10;
--��ǥ��
SELECT empno, ename, dname, hiredate, loc
FROM emp e, dept d
WHERE e.deptno = d.deptno AND job NOT IN ('MANAGER', 'PRESISDENT', 'CLERK');
--ǥ��
SELECT empno, ename, dname, hiredate, loc
FROM emp INNER JOIN dept USING (deptno)
WHERE job NOT IN ('MANAGER', 'PRESISDENT', 'CLERK');

--hr���� ���
SELECT *
FROM employees;

SELECT employee_id, first_name, hire_date, department_name, location_id
FROM employees e, departments d
WHERE e.department_id = d.department_id;

SELECT employee_id, first_name, hire_date, department_name, location_id
FROM employees  NATURAL JOIN departments ;

SELECT employee_id, first_name, hire_date, department_name, location_id
FROM employees  INNER JOIN departments USING (department_id);

--3�� �̻��� ���̺��� �����ϴ� ���: �� SQL���� ��ġ���� �߰��غ���: EMPLOYEES + DEPARTMENTS +LOCATIONS
--��ǥ��: ������ ��� ���δ�.
SELECT employee_id, first_name, hire_date, department_name, lo.location_id, lo.city, c.country_name
FROM  employees e, departments d, locations lo, countries c
--ER ���̾�׷��� ���� department ���̺��� Location ���̺��� �ڽ��̸� employees�� department�� �ڽ��̴�. ���踦 ��������
--ER ���̾�׷����� �θ�-�ڽİ��踦 �˷��� �ܷ�Ű(FK)�� ����
WHERE e.department_id = d.department_id AND d.location_id = lo.location_id AND lo.country_id = c.country_id AND
e.department_id IN (10, 20, 30, 40); -- ���� ������ �� �� ����!
--ǥ��: �ĺ��ڸ� ����� �� ������ ����
SELECT employee_id, first_name, hire_date, department_name, location_id, city, country_name
FROM employees  e NATURAL JOIN departments  d NATURAL JOIN locations lo NATURAL JOIN countries c
WHERE department_id IN (10, 20, 30, 40, 50);

SELECT employee_id, first_name, hire_date, department_name, department_id, location_id, city, country_name
FROM employees  e INNER JOIN departments  d USING (department_id, manager_id) 
                  INNER JOIN locations lo USING (location_id) 
                  INNER JOIN countries c USING (country_id) 
WHERE department_id IN (10, 20, 30, 40);
-- JOIN ~ ON
SELECT employee_id, first_name, hire_date, department_name, e.department_id, lo.location_id, city, state_province, c.country_name
FROM employees  e INNER JOIN departments  d ON  e.department_id = d.department_id
                  INNER JOIN locations lo ON d.location_id = lo.location_id 
                  INNER JOIN countries c ON lo.country_id = c.country_id 
WHERE e.department_id IN (10, 20, 30, 40);

-- �� ����. Non - Equi Join
-- ���� ������'='�� �ƴ� ����̴�.
-- ��ǥ��
SELECT empno, ename, sal, grade 
FROM emp , salgrade 
--WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;
WHERE sal >= losal AND sal <= hisal;
--ǥ��: JOIN ~ ON ���
SELECT empno, ename, sal, grade 
FROM emp JOIN salgrade ON sal BETWEEN losal AND hisal;

-- �ܺ����� OUTER JOIN
-- �� ���̺� ���� ���࿡�� ���� ���� ���� ��� ������ NULL�̾ ������ ����ϴ� ����� �ܺ������̶�� �Ѵ�. 
--��ǥ��
SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
FROM emp, dept
WHERE emp.deptno(+) = dept.deptno; --40�� �μ��� �Ҽӵ� ����� ����.
--WHERE emp.deptno = dept.deptno(+); -��� ����� �μ��� �ҼӵǾ� �ִ�. --> null���� �������� �ʴ´�.
-- �μ��� 10, 20, 30, 40�ε� 40�� �μ��� ����� �����Ƿ� � ������ ���� 40�� �μ��� ���� ���� �ʴ´�.
-- �� ������̺��� ������ �����ϴ�.
-- ������ ������ �ʿ� +�� �ٿ��ִ°� �ܺ������̴�.
-- ��ǥ�� OUTER JOIN ����
SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
FROM emp, dept
WHERE emp.deptno(+) = dept.deptno; -- RIGHT OUTER JOIN

SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
FROM emp, dept
WHERE emp.deptno = dept.deptno(+); --LEFT OUTER JOIN,������ ������ �����Ƿ� ����� � ���ΰ� ����

--SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
--FROM emp, dept
--WHERE emp.deptno(+) = dept.deptno(+); --FULL OUTER JOIN�� ��ǥ�� �ܺ����ο��� �������� �ʴ´�.
-- ��ǥ�ؿ��� FULL OUTER JOIN�� ����ϴ� ���: UNION�� ���
SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
FROM emp, dept
WHERE emp.deptno(+) = dept.deptno -- RIGHT OUTER JOIN
UNION
SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
FROM emp, dept
WHERE emp.deptno = dept.deptno(+); -- RIGHT OUTER JOIN

--ǥ�� OUTER JOIN
SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
FROM emp RIGHT OUTER JOIN dept ON emp.deptno = dept.deptno;
--ǥ�� �ܺ� ������ FULL OUTER JOIN�� ����� �� �ִ�.
SELECT empno, ename, emp.deptno, dept.deptno, dname, loc 
FROM emp FULL OUTER JOIN dept ON emp.deptno = dept.deptno;

--hr
--ǥ��
SELECT empolyee_id, first_name, e.department_id, d.department_id, departmoent_name
FROM employees e, departments d
WHERE e.department_id(+) = d.department_id; -- ǥ�� RIGHT OUTER JOIN
-- ��ǥ��
SELECT employee_id, first_name, e.department_id, d.department_id, department_name
FROM employees e RIGHT OUTER JOIN departments d ON e.department_id = d.department_id;

--��� �� �Ҽ� �μ��� ���� ����� �ִ°�?
--ǥ��
SELECT employee_id, first_name, e.department_id, d.department_id, department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id(+); -- ǥ�� LEFT OUTER JOIN
-- ��ǥ��
SELECT employee_id, first_name, e.department_id, d.department_id, department_name
FROM employees e LEFT OUTER JOIN departments d ON e.department_id = d.department_id;

-- FULL ��������: �Ҽ��� ���� ��� + ����� ���� �μ�
--ǥ��
SELECT employee_id, first_name, e.department_id, d.department_id, department_name
FROM employees e, departments d
WHERE e.department_id(+) = d.department_id -- ǥ�� LEFT OUTER JOIN
UNION
SELECT employee_id, first_name, e.department_id, d.department_id, department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id(+); -- ǥ�� RIGHT OUTER JOIN
--��ǥ��
SELECT employee_id, first_name, e.department_id, d.department_id, department_name
FROM employees e FULL OUTER JOIN departments d ON e.department_id = d.department_id;


--��ü ����, SELF JOIN
--��ǥ��
SELECT ����.empno, ����.ename, ����.mgr, ���.empno, ���.ename
FROM emp ����, emp ��� --��ü������ �ݵ�� ��Ī�� ����ؾ� �Ѵ�.
WHERE ���.empno = ����.mgr; --������ �޴����� ����� �����ȣ�� ��ġ�Ѵٸ� 

SELECT ����.empno, ����.ename, ����.mgr, ���.empno, ���.ename
FROM emp ����, emp ��� --��ü������ �ݵ�� ��Ī�� ����ؾ� �Ѵ�.
WHERE ���.empno(+) = ����.mgr; --LEFT OUTER JOIN
--ǥ��
SELECT ����.empno, ����.ename, ����.mgr, ���.empno, ���.ename
FROM emp ���� INNER JOIN emp ��� ON ����.mgr = ���.empno; --��ü������ �ݵ�� ��Ī�� ����ؾ� �Ѵ�.

-- ��ü���� ����
--��ǥ��
--4. EMP Table�� �ִ� EMPNO�� MGR�� �̿��Ͽ� ������ ���踦 ������ ���� ����϶�.��SMTH�� �Ŵ����� FORD�̴١�
SELECT ����.ename || '�� �޴����� ' || NVL(���.ename,'����') || '�̴�.'
FROM emp ����, emp ���
WHERE ����.mgr = ���.empno(+);
--ǥ��
SELECT ����.ename || '�� �޴����� ' || ���.ename || '�̴�.'
FROM emp ���� INNER JOIN emp ��� ON ����.mgr = ���.empno;

--���� ���� P.239 
--Q1 �޿��� 2000�ʰ��� ������� �μ�, ����, ��� ������ ���
-- ��ǥ��
SELECT dept.deptno, dname, empno, ename, sal
FROM emp, dept
WHERE emp.deptno = dept.deptno AND sal > 2000;
-- ǥ��
SELECT dept.deptno, dname, empno, ename, sal
FROM emp INNER JOIN dept ON emp.deptno = dept.deptno
WHERE sal > 2000;

--Q2. �� �μ��� ��� �޿�, �ִ� �޿�, �ּ� �޿�, ������� ���
- ��ǥ��
SELECT d.deptno, dname ,TRUNC(AVG(sal)) AS "AVG_SAL", MAX(sal) AS "MAX_SAL",MIN(sal) AS "MIN_SAL", COUNT(*) AS "CNT"
FROM emp e, dept d
WHERE e.deptno = d.deptno
-- GROUP BY ������: ���� SELECT���� �����Լ��� ���� ���� ����� ��ȯ�ϴ� �÷��� ���� ����ϸ� ����
-- �� GROUP BY�� ���� ���ؿ��� SELECT���� ù��° �Ķ���Ϳ� ������ ������ �ȳ���. ��
-- dname�� �̶� ������ �Ǵµ� �Ʒ��� ���� GROUP BY���� �Է��� ���
-- GROUP BY d.deptno
-- �� GROUP BY���� dname�� �����Ƿ� dname�� �������� ����� ��ȯ�ϴ� �÷����� ���ֵǾ� ����
-- ���� dname�� GROUP BY���� ���� ����ϸ� �ذ�ȴ�.
GROUP BY d.deptno, dname 
ORDER BY d.deptno;
--ǥ��
SELECT d.deptno, dname ,ROUND(AVG(sal)) AS "AVG_SAL", ROUND(MAX(sal)) AS "MAX_SAL", ROUND(MIN(sal)) AS "MIN_SAL", ROUND(COUNT(*)) AS "CNT"
FROM emp e INNER JOIN dept d ON  e.deptno = d.deptno
GROUP BY d.deptno, dname
ORDER BY d.deptno;

--Q3. ��� �μ� ������ ��� ������ �μ� ��ȣ, ��� �̸������� �����ؼ� ����϶�
-- ��ǥ��: ��� �μ� ���� �̹Ƿ� �ܺ� ������ ���
SELECT d.deptno, dname, empno, ename, job, sal
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno --  ������ �ܺ� ���� ���ǽ� ������ ����  ���� �� �����Ϳ� ������� ��� �����͸� ����ϴ� ��
ORDER BY d.deptno, ename;
-- ǥ�� 
SELECT d.deptno, dname, empno, ename, job, sal
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno  
ORDER BY d.deptno, ename;

--Q4. ��� �μ� ����, ��� ����, �޿� ��� ���� ,�� ����� ���� ����� ������ �μ� ��ȣ, ��� ��ȣ ������ �����Ͽ� ��� ��
-- ��ǥ��
SELECT d.deptno, dname, e.empno, e.ename, e.mgr, e.sal, b.deptno, s.losal, s.hisal, s.grade, b.empno, b.ename
FROM emp e, dept d, salgrade s, emp b
WHERE (e.deptno(+) = d.deptno)AND (e.sal BETWEEN losal(+) AND hisal(+)) AND e.mgr = b.empno(+) --  ������ �ܺ� ���� ���ǽ� ������ ����  ���� �� �����Ϳ� ������� ��� �����͸� ����ϴ� ��
ORDER BY d.deptno,e.empno;
-- losal, hisal, grade�� null�� ���;� �Ѵ�.
--����� ���� �ٿ�޾Ƽ� ���� ���� �Ѵ�.

--ǥ��
SELECT d.deptno, dname, e.empno, e.ename, e.mgr, b.deptno, s.losal, s.hisal, s.grade, b.empno, b.ename
FROM emp e INNER JOIN dept d ON e.deptno = d.deptno 
     emp INNER JOIN salgrade s ON e.sal BETWEEN losal AND hisal 
     FULL OUTER JOIN emp b on  e.mgr = b.empno
ORDER BY d.deptno, e.empno;

--����� ����
SELECT dept.deptno, dname, ����.empno, ����.ename, ����.mgr, ���.deptno, losal, hisal, grade, ���.empno, ���.ename
FROM dept LEFT OUTER JOIN emp ���� ON (����.deptno = dept.deptno) 
     LEFT OUTER JOIN salgrade ON (����.sal BETWEEN losal AND hisal)
    LEFT OUTER JOIN emp ��� ON (����.mgr = ���.empno)    --���������̸鼭 ��������
ORDER BY dept.deptno, ����.empno;

--DML
--INSERT: ���ο� ������ �߰�
--INSERT INTO ���̺�� VALUE (������....) 
--��¥���� �������� �ݵ�� `''`�� ����ؾ� �Ѵ�.
--ä���� �� �÷� ������ ������ literal�� ������, NULL, Ÿ�Ը� �����ؾ� �Ѵ�.
INSERT INTO dept 
VALUES(50, 'DEVELOPEMENT', 'SEOUL'); --ä���� �� �÷� ������ ������ literal�� ������, NULL, Ÿ�Ը� �����ؾ� �Ѵ�.

--������ ������� �����ϱ� ���ؼ��� ������ ���� �����Ѵ�.
INSERT INTO dept(loc, deptno, dname)
VALUES('BUSAN', 60, 'DESIGN');

INSERT INTO dept(dname, loc, deptno) -- ���̺��� ������ �ٸ��� �Ϸ��� �ݵ�� ����ؾ� �Ѵ�.
VALUES ('MARKETING', 'KWANGJUKWANGYUKSI', 70); --������ ���, ���� �������� �����ʹ� ������ �� ����.

--INSERT INTO dept
--VALUES (10, 20, 30); Ÿ���� �������

--INSERT INTO dept
--VALUES(80, 'JAVA'); -- NULL�� ��������: ���� ���� ������� �ʽ��ϴ�. ��� ������ �߻�
--������ NULL�� �Ͻ������� ó���ϱ� ���� ���
INSERT INTO dept(deptno, dname)
VALUES(70, 'SERVICE'); --�Ͻ������� ó��
-- NULL�� ��������� ó���ϴ� ���
INSERT INTO dept
VALUES(80, 'MAINTANCE', null);
--loc�� 13����Ʈ
SELECT *
FROM dept;
--dept ���̺� ����
-- ������ �ڽ� ���̺����
--scott.sql ���
SELECT *
FROM emp;
SELECT *
FROM dept;
SELECT *
FROM salgrade;


