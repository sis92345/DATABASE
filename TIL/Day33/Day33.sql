SELECT  empno, ename, LPAD(ename, 10, '*') AS "LAPD_1" -- ������ �Լ� 
FROM    emp
WHERE   deptno = 30;

--zipcode1.sql, zipcode_ansi.sql ����
SELECT *
FROM zipcode
WHERE dong LIKE '%����%';

--�����Լ� ����
--�ϱް��
SELECT empno, ename, sal, TRUNC(sal/20) AS "�ϱ�"
FROM emp
WHERE deptno = 10;

--NLS DATA FORMET: ����Ʈ ������ Ȯ���� �� ���� ��ȯ ���θ� �����Ѵ�.
--NLS DATA FORMET Ȯ��: ������ �ٲٴ°� �ƴϹǷ� �Ź� Ȯ�� �� �Է��ؾ� �Ѵ�.
SELECT *
FROM NLS_SESSION_PARAMETERS;
--NLS DATA FORMET ����
ALTER SESSION
SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

-- ��¥�Լ� ����
--4.emp table���� �̸�, �Ի���, �Ի��Ϸκ��� 6���� �� ���ƿ��� �������� ���Ͽ� ����Ͻÿ�.
SELECT ename, hiredate, NEXT_DAY(ADD_MONTHS(hiredate, 6), '������') AS "���Ļ���� �Ǵ� ù ������"
FROM emp
WHERE deptno = 20; --�߰�����

--�� ��ȯ �Լ�
--TO_CHAR()
--1) MM : �� �� (ex : 10)
--2) MON : �� �̸��� 3�ڸ� ���ڷ� ǥ�� (ex : JAN)
--3) MONTH : �� �̸�(ex : JANUARY)
--4) DD : ��¥(ex : 14)
--5) D : ���� ��(ex : 3)
--6) DY : ���� �̸��� 3�ڸ� ���ڷ� ǥ�� (ex : SUN)
--7) DAY : ���� �̸�(ex : SUNDAY)
--8) YYYY : �⵵ 4�ڸ� ��(ex :2007)
--9) YY : �⵵ ������ 2�ڸ� ��(ex : 07)
--5. REM �ð� ���� ���
--1) HH or HH12 : �ð��� 12�ð� ������ ǥ��(ex : 1~ 12)
--2) HH24 : �ð��� 24�ð� ������ ǥ�� (ex : 1~ 24)
--3) MI : �� (ex : 1~ 59)
--4) SS : �� (ex : 1~ 59)
--5) AM or PM : ���� ������
--���� ���� ���
--1) 9 : ���� (ex : 9999 => 1534)
--2) 0 : �ڸ� ���� ��� 0���� ä��(ex : 09999 => 01534)
--3) $ : �ݾ׿� $�� ǥ������ (ex : $9999 => $1534)
--4) . : ����� ��ġ�� �Ҽ����� ǥ����(ex : 99999.99 => 1534.00)
--5) , : ����� ��ġ�� �޸��� ǥ���� (ex : 999,999 => 1,534)
SELECT TO_CHAR(SYSDATE, 'CC YYYY.MM.DD DAY PM HH:MI:SS')
FROM dual;

SELECT ename, TO_CHAR(sal, 'L999,999'), TO_CHAR(comm, 'L999,999'), TO_CHAR(sal * 12 + NVL(comm, 0),'L999,999')  AS "����"
FROM emp
WHERE TO_CHAR(hiredate, 'YYYY') = '1981';
--TO_NUMBER()
--TO_DATE()

--NULLó�� �Լ�
--NVL(), NVL2()
--NVL2(������, NULL�� �ƴϸ� ó���� ��, NULL�̸� ó���� �� )
--NVL2()�� NULL�� �ƴ� ��츦 ó���ϴ� ���� ����.
--�� �����Ͱ� 0�̸�  NULL�̸� ó���� ������ ó���Ѵ�.
SELECT comm, NVL(comm, 0), NVL2(comm, comm + 100, 0)
FROM emp;

--P.174 Q1
SELECT ename, RPAD(SUBSTR(empno, 1,2),4,'*') AS "MASKING_EMPNO",  
       ename, RPAD(SUBSTR(empno, 1,1),5,'*') AS "MASKING_ENAME"
FROM emp
WHERE length(ename) >= 5 AND length(ename) <= 6;

