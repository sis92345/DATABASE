SELECT  empno, ename, LPAD(ename, 10, '*') AS "LAPD_1" -- 단일행 함수 
FROM    emp
WHERE   deptno = 30;

--zipcode1.sql, zipcode_ansi.sql 실행
SELECT *
FROM zipcode
WHERE dong LIKE '%개포%';

--숫자함수 복습
--일급계산
SELECT empno, ename, sal, TRUNC(sal/20) AS "일급"
FROM emp
WHERE deptno = 10;

--NLS DATA FORMET: 데이트 포멧을 확인한 후 포멧 변환 여부를 결정한다.
--NLS DATA FORMET 확인: 영구히 바꾸는게 아니므로 매번 확인 후 입력해야 한다.
SELECT *
FROM NLS_SESSION_PARAMETERS;
--NLS DATA FORMET 변경
ALTER SESSION
SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

-- 날짜함수 복습
--4.emp table에서 이름, 입사일, 입사일로부터 6개월 후 돌아오는 월요일을 구하여 출력하시오.
SELECT ename, hiredate, NEXT_DAY(ADD_MONTHS(hiredate, 6), '월요일') AS "정식사원이 되는 첫 월요일"
FROM emp
WHERE deptno = 20; --추가조건

--형 변환 함수
--TO_CHAR()
--1) MM : 달 수 (ex : 10)
--2) MON : 월 이름을 3자리 문자로 표현 (ex : JAN)
--3) MONTH : 월 이름(ex : JANUARY)
--4) DD : 날짜(ex : 14)
--5) D : 주의 일(ex : 3)
--6) DY : 요일 이름을 3자리 문자로 표현 (ex : SUN)
--7) DAY : 요일 이름(ex : SUNDAY)
--8) YYYY : 년도 4자리 수(ex :2007)
--9) YY : 년도 마지막 2자리 수(ex : 07)
--5. REM 시간 형식 요소
--1) HH or HH12 : 시간을 12시간 단위로 표현(ex : 1~ 12)
--2) HH24 : 시간을 24시간 단위로 표현 (ex : 1~ 24)
--3) MI : 분 (ex : 1~ 59)
--4) SS : 초 (ex : 1~ 59)
--5) AM or PM : 정오 지시자
--숫자 형식 요소
--1) 9 : 숫자 (ex : 9999 => 1534)
--2) 0 : 자리 수가 비면 0으로 채움(ex : 09999 => 01534)
--3) $ : 금액에 $를 표시해줌 (ex : $9999 => $1534)
--4) . : 명시한 위치에 소수점을 표시함(ex : 99999.99 => 1534.00)
--5) , : 명시한 위치에 콤마를 표시함 (ex : 999,999 => 1,534)
SELECT TO_CHAR(SYSDATE, 'CC YYYY.MM.DD DAY PM HH:MI:SS')
FROM dual;

SELECT ename, TO_CHAR(sal, 'L999,999'), TO_CHAR(comm, 'L999,999'), TO_CHAR(sal * 12 + NVL(comm, 0),'L999,999')  AS "연봉"
FROM emp
WHERE TO_CHAR(hiredate, 'YYYY') = '1981';
--TO_NUMBER()
--TO_DATE()

--NULL처리 함수
--NVL(), NVL2()
--NVL2(데이터, NULL이 아니면 처리할 식, NULL이면 처리할 식 )
--NVL2()는 NULL이 아닌 경우를 처리하는 경우는 없다.
--즉 데이터가 0이면  NULL이면 처리할 식으로 처리한다.
SELECT comm, NVL(comm, 0), NVL2(comm, comm + 100, 0)
FROM emp;

--P.174 Q1
SELECT ename, RPAD(SUBSTR(empno, 1,2),4,'*') AS "MASKING_EMPNO",  
       ename, RPAD(SUBSTR(empno, 1,1),5,'*') AS "MASKING_ENAME"
FROM emp
WHERE length(ename) >= 5 AND length(ename) <= 6;

