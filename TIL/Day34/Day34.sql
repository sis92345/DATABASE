SELECT empno, ename, TO_CHAR(hiredate, 'YYYY/MM/DD'), 
      TO_CHAR(NEXT_DAY(ADD_MONTHS(hiredate, 3), '������'), 'YYYY-MM-DD') AS "R_Job",
      NVL(TO_CHAR(COMM), 'N/A') AS "COMM" --COMM�� �������̱� ������ ��ġ�� ���ڴ� �������̾�� �Ѵ�. ���� �� Ÿ���� ��ġ�ؾ� �Ѵ�.
FROM emp;

--�׷��Լ�, �������Լ�
--�׷��Լ�, �������Լ��� �������� ���� �� ����� �����ش�.
--�׷��Լ�, �������Լ��� �������� ����� �����ִ� �Լ��� ���� ����� �� ����. ��
SELECT empno, SUM(sal)
FROM emp;
--�� ������ ����.
--�׷��Լ�, �������Լ��� NULL���� �����Ѵ�.
SELECT AVG(comm), AVG(NVL(comm,0))
FROM emp;
-- AVG(comm)�� NULL�� �����ϱ� ������  AVG(NVL(comm,0))�� �и� �޶�����.
--�� COUNT(*)�� NULL�� �����Ѵ�.
--COUNT(*)�� NULL�� �����Ϸ��� WHERE���� ������ �����ϸ� �ȴ�.
SELECT COUNT(DISTINCT comm)
FROM emp
WHERE comm IS NOT NULL;

--
SELECT MAX(hiredate)
FROM emp
WHERE deptno = 20;

-- ������ �Լ��� ��
SELECT SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND(AVG(sal),1)
FROM emp
WHERE deptno = 10;
UNION ALL
SELECT SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND(AVG(sal),1)
FROM emp
WHERE deptno = 20;
UNION ALL
SELECT SUM(sal), MIN(sal), MAX(sal), COUNT(sal), ROUND(AVG(sal),1)
FROM emp
WHERE deptno = 30;
