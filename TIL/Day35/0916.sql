--0916, Day35
SELECT deptno, job, COUNT(*)
FROM emp
GROUP BY deptno, job
ORDER BY deptno;
--��������, CROSS JOIN, Cartesian Product
--��ǥ�� ����
SELECT empno, ename, job, dname, loc, dept, deptno
FROM emp, dept, salgrade; -- 280�� 
--ǥ�� ����
SELECT empno
FROM emp CROSS JOIN dept CROSS JOIN salgrade CROSS JOIN bonus ;

-- �����(Equi Join), Inner Join, Simple JOin, Natural Join, Join ~ on, Join Using
-- ���̽��� ��� ��ġ�� �ִ� ��� �μ����� ���ϴ°�?
-- ��� �μ�?
SELECT ename, deptno
FROM emp
WHERE ename = 'SMITH';
-- ��� ��ġ?
SELECT deptno, loc
FROM dept
WHERE deptno = 20;
-- �� ��� �μ� = emp ���̺�, �� �μ��� ��ġ = dept ���̺�
-- �� �ΰ��� ����� �ϳ��� SELECT������ ǥ���ϱ� ���ؼ� ������� ���: ���̽��� ��� ��ġ�� �ִ� ��� �μ����� ���ϴ°�?
SELECT ename, emp.deptno, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno AND ename = 'SMITH';
-- �����ȣ, �̸�, �޿� ,�ٹ� �μ��� �Բ� ����ϵ� �޿��� 3000 �̻��� �����͸� ����Ͻÿ�.
SELECT empno AS "���", ename AS "�̸�", sal AS "�޿�", d.dname AS "�μ�" -- SELECT���� ����
FROM emp e, dept d -- ���� �� ��Ī ��� ����
WHERE e.deptno = d.deptno AND sal >= 3000; -- ��ǥ���� ������� = �����ڸ� ����Ѵ�. ��ǥ���� ������ WHERE�� ���
--ǥ��--
--NATURAL JOIN: ������ ���̺��� �˻��ؼ� ����� �÷��� ����, ������ --> =�� ����� �ʿ䰡 ����.
SELECT empno AS "���", ename AS "�̸�", sal AS "�޿�", d.dname AS "�μ�"
FROM emp e NATURAL JOIN dept d -- ǥ���� ������ FROM���� �ۼ�
WHERE e.sal >= 3000;

--����
--����̸� KING �� �μ��̸��� �ٹ����� ����Ͻÿ�.
--��ǥ��
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno AND ename = 'KING';
--ǥ��
SELECT ename, dname, loc
FROM emp NATURAL JOIN dept
WHERE ename = 'KING';

-- JOIN ~ USING
-- ��: �����ȣ, �̸�, �޿� ,�ٹ� �μ��� �Բ� ����ϵ� �޿��� 3000 �̻��� �����͸� ����Ͻÿ�.
SELECT empno AS "���", ename AS "�̸�", sal AS "�޿�", d.dname AS "�μ�" 
FROM emp e JOIN dept d USING (deptno)
WHERE sal >= 3000;

-- JOIN ~ ON
--���� ��ǥ�� � ����
SELECT empno, ename, job, sal, dname, loc, dept.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno AND sal <= 2000 AND job in ('SALESMAN', 'CLERK', 'MANAGER');
-- ǥ�� NATURAL JOIN �̿�
SELECT empno, ename, job, sal, dname, loc, deptno
FROM emp NATURAL JOIN dept
WHERE sal <= 2000 AND job in ('SALESMAN', 'CLERK', 'MANAGER');
-- ǥ�� JOIN ~ USING�̿�
SELECT empno, ename, job, sal, dname, loc, deptno
FROM emp INNER JOIN dept USING (deptno)
WHERE sal <= 2000 AND job in ('SALESMAN', 'CLERK', 'MANAGER');
-- ǥ��: JOIN ~ ON �̿�
SELECT empno, ename, job, sal, dname, loc, dept.deptno
FROM emp INNER JOIN dept ON emp.deptno = dept.deptno -- ON ����
WHERE sal <= 2000 AND job in ('SALESMAN', 'CLERK', 'MANAGER');

--JOIN ���� 6-1. Join �ǽ�.pdf
--1. ��� ����� �̸�, �μ� ��ȣ, �μ� �̸��� ǥ���ϴ� ���Ǹ� �ۼ��Ͻÿ�.
--��ǥ��
SELECT ename, d.deptno, dname -- ��ǥ�ؽ� ����� Į���� ���̺� �� ���
FROM emp e, dept d
WHERE e.deptno = d.deptno;
--ǥ�� NATURAL JOIN
SELECT ename, deptno, dname -- ǥ�� NATURAL JOIN�� ��� ����� Į���� �ĺ��� ��� �Ұ�
FROM emp e NATURAL JOIN dept d;
-- ǥ�� JOIN ~ USING
SELECT ename, deptno, dname -- ǥ�� NATURAL JOIN�� ��� ����� Į���� �ĺ��� ��� �Ұ�
FROM emp INNER JOIN dept USING (deptno);

--2. comm�� �޴� ��� ����� �̸�, �μ� �̸� �� ��ġ�� ǥ���ϴ� ���Ǹ� �ۼ��Ͻÿ�.
--��ǥ��
SELECT ename, comm, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno AND REPLACE(COMM, 0, null) IS NOT NULL; --comm�� 0�� ����� null�� ó���� ���
--ǥ�� NATURAL JOIN
SELECT ename, comm, dname, loc
FROM emp NATURAL JOIN dept
WHERE COMM IS NOT NULL; --��� ����
--ǥ�� JOIN ~ USING
SELECT ename, comm, dname, loc
FROM emp INNER JOIN dept USING (deptno)
WHERE COMM IS NOT NULL;

--4. DALLAS�� �ٹ��ϴ� ��� ����� �̸�, ����, �μ� ��ȣ �� �μ� �̸��� ǥ���ϴ� ���Ǹ� �ۼ��Ͻÿ�.
--��ǥ��
SELECT ename, job, dept.deptno, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno AND loc = UPPER('DALLAS');
--ǥ�� NATURAL JOIN
SELECT ename, job, deptno, dname, loc
FROM emp NATURAL JOIN dept
WHERE loc = UPPER('DALLAS');
--ǥ�� JOIN ~ USING
SELECT ename, job, deptno, dname, loc
FROM emp INNER JOIN dept USING (deptno)
WHERE loc = UPPER('DALLAS');
--6. �̸��� ��ALLEN���� ����� �μ����� ����϶�.
--��ǥ��
SELECT ename, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND ename = 'ALLEN';
--ǥ�� NATURAL JOIN
SELECT ename, dname
FROM emp NATURAL JOIN dept
WHERE ename = 'ALLEN';
--ǥ�� JOIN ~ USING
SELECT ename, dname
FROM emp INNER JOIN dept USING (deptno)
WHERE ename = 'ALLEN';
--ǥ�� JOIN ~ ON
SELECT ename, dname
FROM emp INNER JOIN dept ON emp.deptno = dept.deptno
WHERE ename = 'ALLEN';
--5. EMP�� DEPT Table�� JOIN�Ͽ� �μ���ȣ, �μ���, �̸�, �޿��� ����϶�.
--��ǥ��
SELECT d.deptno, dname, ename, sal
FROM emp e, dept d
WHERE e.deptno = d.deptno;
--ǥ�� NATURAL JOIN
SELECT deptno, dname, ename, sal
FROM emp NATURAL JOIN dept;
--ǥ�� JOIN ~ USING
SELECT deptno, dname, ename, sal
FROM emp INNER JOIN dept USING (deptno);
--ǥ�� JOIN ~ ON
SELECT deptno, dname, ename, sal
FROM emp INNER JOIN dept ON emp.deptno = dept.deptno;

