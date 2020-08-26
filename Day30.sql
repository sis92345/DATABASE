-- 1. ��� row�� ��� column ��ȸ�ϱ�
SELECT ALL *
FROM salgrade;

-- 2. ��� row�� Ư�� column ��ȸ�ϱ�
SELECT deptno, Dname
FROM dept;
--�μ����̺��� �μ���ȣ�� �μ��� ��ȸ�ϱ�
--SELECT deptno, dname
--FROM dept
SELECT empno, deptno
FROM emp;

--������̺��� ������ ��������
SELECT DISTINCT job
FROM emp;
--������̺��� ������� �� ���� �μ��� �ҼӵǾ� �ִ°�?
SELECT DISTINCT deptno
FROM emp;

--3. ��Ī ����ϱ�
SELECT empno EmpolyeeNumber, ename EmpolyeeName
FROM emp;

SELECT empno AS "��� ��ȣ", ename AS "��� �̸�"
FROM emp;

SELECT sal * 12 + NVL(COMM,0) AS "����"
FROM EMP;

-- ������̺��� ���, ����� �̸�, ����, ����, ���ʽ�, ������ ��ȸ�Ͻÿ�
SELECT empno AS "���", ename AS "����� �̸�",job  AS "����", 
sal AS "����", comm AS "���ʽ�", sal * 12 + NVL(comm,0) AS "����"
FROM emp;

--4. �����ϱ� ORDER BY
--������̺��� �μ���ȣ�� ������������ �����ϰ�, ������ ������������ ����
SELECT deptno, sal
FROM emp
ORDER BY deptno ASC, sal DESC;

-- SELECT�� �ǰ� �� �� ORDER BY�� �����ϱ⿡ ���̺� ���� �÷����� ���� ����
SELECT empno AS "���", ename AS "����� �̸�",job  AS "����", 
sal AS "����", comm AS "���ʽ�", sal * 12 + NVL(comm,0) AS "����"
FROM emp
ORDER BY "����" DESC;

-- P. 92 3��
SELECT empno AS EMPLOYEE_NO, ename AS EMPLOYEE_NAME, mgr AS MANAGER, sal AS SALARY,
comm AS COMMISSION, deptno AS DEPARTMENT_NO
FROM emp
ORDER BY deptno DESC, ename;

--5. NULL ó��
--NVL()�Լ�
--SELECT NVL(COMM, '�� ����')
SELECT NVL(COMM, 100) 
FROM emp;

SELECT DISTINCT NVL(mgr, 0)
FROM emp;

--6. ���ڿ� �����ϱ�: ���� ������.
SELECT 'HELLO' || ', World'
FROM dual;

SELECT '�����ȣ ' || empno || '�� '|| ename || '�Դϴ�.'
FROM emp;

-- 7. ������ WHERE
SELECT ename, job, sal
FROM emp
WHERE deptno = 10;

SELECT ename, sal * 12 + NVL(comm,0) AS "����"
FROM emp
WHERE empno = 7782;

--������̺��� �μ���ȣ�� 20�� �μ��� �����ִ� ��� �߿� ������ 1000�� ������ ����� ������ ��ȸ
SELECT *
FROM emp
WHERE deptno = 20 AND sal<=1000;

SELECT *
FROM emp 
WHERE empno = 7499 AND deptno = 30;

--������̺��� �μ���ȣ�� 10���̰ų� ������ 3000�� ~ 5000������ ����� ���, �̸�, ����, �μ���ȣ ��ȸ
SELECT empno, ename, sal, deptno
FROM emp
WHERE deptno = 10 OR (sal >= 3000 AND sal <= 5000); 

--������������
SELECT deptno, dname, loc
FROM dept
WHERE NOT (deptno = 10 OR deptno = 20);

-- IN ������
SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (10, 20);
--������̺��� ������ SALESMAN�̰ų� MANAGER�̰ų� PRESIDENT�� ����� ����̸�, ���� ��ȸ
SELECT ename, job
FROM emp
WHERE job IN('SALESMAN', 'MANAGER', 'PRESIDENT');