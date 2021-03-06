# 0826

## TIL

------

1.  Enterprise 버전 삭제 방법: p70
    1.  HKEY_LOCAL_MACHINE
        1.  SOFTWARE에서 ORACLE 삭제
        2.  ControlSet001/Services에서 oracle로 시작하는거 삭제
    2.  HKEY_CLASSER_ROOT에서  Ora로 시작하는거 전부(대략 8개) 삭제
2.   설치 순서
    1.  Oracle Enterprise 설치
    2.  설치 후 확인
    3.  SYS계정 login해서 scott계정 생성
    4.  scott가 사용할 table 생성
    5.  sql developer에서 확인
    6.  포트번호 5500 -> EnterpriseManager
        1.  https://localhost:5500/em/
3.  교수님 공인결석 가능한 날 알아보기 + 공인결석 확인
4.  P.74 ~  DB
    1.  SELECT
5.  

## 1.  DB

------

- 파일 및 교재: 
- DB: table + view + Index + synonym + sequence 
- RDBMS: Oracle, Mysql, MariaDB
- DB Tool: SQL*PLUS, SQL DEVELOPER, toad, orange

## 2. 시작 명령어

------

- 파일 및 교재:
- sql plus /nolog: 로그인 없이 시작
- sql*plus 명령어는 ;를 붙이지 않어도, 또 약어를 사용해도 실행되고 sql명령어는 ;를 붙여야 실행된다.
- connect sys as sysdba: sysdbs로 sys로 로그인
- 다양한 로그인 방법
  - FM 로그인: sqlplus <user>/<password>@<hostname or ip>:#port/SID
  - 간편하게
    - sqlplus scott -> 비밀번호 입력
  - 직접
    - sqlplus scott/tiger
    - 비밀번호 직접 노출 가능
- 계정 생성: scott 생성
  - ALTER SESSION SET "_ORACLE_SCRIPT"=true;  
  - What to do after Oracle 12c Installation in Windowsㅇ,; 5번을 순서대로 실행
    - SQL> CREATE USER scott
        2  IDENTIFIED BY tiger //비밀번호 생성
        3  DEFAULT TABLESPACE USERS 
        4  TEMPORARY TABLESPACE temp;
  - ALTER USER scott DEFAULT TABLESPACE USERS  //quota 지정
  - GRANT resource, connect TO scott  

## 3. 관리 명령어

------

- 파일 및 교재:
- lsnrctl: listener의 상태를 알려주는 
- lsnrctl stop/start
- ed: 입력하면 버퍼로 받아서 메모장에서 확인, 저장
  - ed <위치>: 위치에 저장
    -  ed C:\TEMP\0826.sql
- **DESC <table>**: 테이블의 구조를 출력

## 4. sqlDeveloper

------

- 파일 및 교재: 
- 블록으로 부분 실행 가능
- ctrl + enter: 표형식으로 스크립트 출력

## 5. SQL 개요

------

- 파일 및 교재: https://github.com/swacademy/Oracle/blob/master/1.%20Introduction.pdf

- SQL(Structured Query Language): 구조적 질의 언어로 데이터베이스와 대화하기위한 언어이다.

  - PL/SQL: 오라클 DB에서만 사용하는 SQL언어
    - SQL에 반복문, 변수 등 논리적인 부분을 추가한 것
    - 프로시저, 커서 사용을 위해서 알아야 한다.

- SQL의 종류

  - DML(Data Manipulation Language)
    - 오라클에서는 SELECT을 따로 분류한다.: DQL(Data Query Language)
  - DDL(Data Definition Language)
  - DCL(Data Control Language)
  - TCL(Trnsaction Control Langiage)

- SQL문 작성 

  - DATA값은 대소문자를 구별한다.

    ```sql
    SELECT *
    FROM emp
    WHERE ename = 'scott';
    ----------------------ename 이 scott라면 위 명령어는 아무 것도 반환하지 않는다.
    ```

  - SQL의 각 절은 되도록 다른 행에 작성

  - TAB과 들여쓰기활용해서 가독성 유지

  - 띄워쓰기 법칙을 지켜소 SQL문 통일

  - 컬럼명과 TABLE명은 SQL 절과 구분되도록 작성

    ```sql
    --FM으로 작성하는 방법
    SELECT e,p.empno, emp.jop --컬럼 이름: table이름과 구분해야 한다.
    FROM scott.emp -- table 이름
    WHERE ename = 'SCOTT';
    ```

    - 조인을 할 경우 명시적으로 컬럼명에 테이블 이름을 넣어주어야 한다.
    - scott.emp의 의미
      - **<u>오라클만 객체가 계정소속이 된다.</u>**
      - emp는 scott 계정 소속

  - 문장의 끝은 ; 또는 /, RUN 명령어도 가능

    - Buffer에 들어가있는 마지막 명령어를 다시 실행(/) 등등의 의미

  - SQL의 데이터 형

    - 숫자: NUMBER()
      - 정수: NUMBER(4) 
        - 4자리 정수
      - 실수: NUMBER(7, 2)
        - 7자리 전체 자리수와 2자리 소수점
    - 문자열형: VARCHAR2()
    - DATE

## 6. SELECT Basic

------

- 파일 및 교재: https://github.com/swacademy/Oracle/blob/master/2.%20Basic%20SELECT.pdf, 수업에 사용하는 테이블은 scott.sql(Temp)를 볼 것, P.73 ~

- SELECT: DB에 들어있는 Data를 검색, 조회하여 읽어온다.

- SELECT의 기능

  - Seletion: Row에 대한 필터링

    ```sql
    SELECT * --모든 컬럼 조회
    FROM dept
    WHERE deptno = 10 --부서번호가 10번인 행만 가져온다.
    ```

    - <u>WHERE절을 활욯</u>한다.

  - Projection: column에 대한 필터링

    ```sql
    SELECT dname --부서테이블의 부서 이름열을 모두 가져온다.
    FROM dept
    ```

    

  - Join: 여러 테이블 검색 --> 나중에

## 7. SELECT Syntax

------

- 파일 및 교재: P.80 ~, 수업에 사용하는 테이블은 scott.sql(Temp)를 볼 것

- **형식**

  ```sql
  -- DISTINCT: 중복 제거해서 가져오기 | ALL: 모두 가져오기 --> 아무것도 안쓰면 ALL 생략한 것
  -- SELECT * --> 전체컬럼 가져온다.
  -- SELECT column1, column2, column3 --> 해당하는 컬럼만 조회한다.
  SELECT [DISTINCT|ALL] column1, column2 --필수: 아무것도 안쓰면 ALL이 생략된 것
  FROM table_name --필수
  WHERE condition 
  ORDER BY column1;
  ```

  - **작성 순서: FROM ->WHERE -> SELECT -> ORDER BY**

  - 예

    ```sql
    -- 1. 모든 row와 모든 column 조회하기
    SELECT * --emp테이블의 모든 열을 출력: ALL 생략
    FROM emp;
    --위 코드는 다음과 같다
    --SELECT ALL *
    --FROM emp;
    
-- 2. 모든 row와 특정 column 조회하기
    SELECT job, sal, empno, ename
    FROM emp;
    --문제: 부서테이블에서 부서번호와 부서명 조회하기
--SELECT empno, deptno
    --FROM emp;
    ```
    

- **DISTINCT**: 중복된 데이터를 제외하고 가져온다.

  ```sql
  SELECT job
  FROM emp;
  --실행결과: 14개 데이터 출력
  --위 코드에 DISTINCT사용하면 중복을 제외한 5개의 job data를 출력
  SELECT DISTINCT job
  FROM emp;
  ```

- **별칭(alias)**:  SQL문에서 최종 출력되는 열 이름을 임의로 지정하는 것

  - 별칭을 만드는 방법

    ```sql
    
    SELECT empno AS "사원 번호", ename AS "사원 이름"
    FROM emp;-- 가본
    SELECT empno, ename 
    FROM emp;
    -- 열의 이름은 empno, ename으로 출력
    
    -- 1. column 한 칸 띄고 영어 별칭 사용
    SELECT empno EmpolyeeNumber, ename EmpolyeeName
    FROM emp;
    
    -- 2. column 한 칸 띄고 "별칭": 공백을 사용하거나, 특수문자를 사용하거나, 한글을 사용하고자 할 때 사용
    SELECT empno "사원 번호", ename "사원 이름"
    FROM emp;
    
    -- 3. column 다음 한 칸 띄는 대신 명시적으로 AS 사용
    SELECT empno AS "사원 번호", ename AS "사원 이름"
    FROM emp;
    ```

  - alias를 사용하는 이유: 열들을 연산하여 나오는 <u>추출속성</u>의 경우 원래 없는 column이므로 이름이 없다. 따라서 추출속성은 별칭을 사용해야 한다.

    ```sql
    SELECT sal * 12 + COMM 
    FROM EMP;
    -- 이 SQL을 출력하면 column명은 sal * 12 + COMM
    -- 이때 alias를 사용하는 것 
    -- 따라서 다음과 같이 수정하면 열 이름을 별칭으로 사용할 수 있다.
    SELECT sal * 12 + NVL(COMM, ) AS "연봉"
    FROM EMP;
    ```

- **ORDER BY**: 데이터를 정렬해서 출력한다.

  - **ASC: 오름차순**: 기본, DESC 명시 안하면 ASC

    ```sql
    SELECT ename
    FROM emp
    ORDER BY ename; --ename 기준으로 오름차순 정렬
    ```

    

  - **DESC: 내림차순**

    ```sql
    SELECT ename
    FROM emp
    ORDER BY ename DESC; --ename 기준으로 내림차순 정렬
    ```

    

  - ORDER BY 특징

    - 여러 컬럼을 정렬 가능: 1차 정렬 -> 2차 정렬 ... 

      ```sql
      SELECT deptno, sal
      FROM emp
      ORDER BY deptno ASC, sal DESC; --ASC 생략 가능
      ```

      - 사원테이블에서 부서번호로 오름차순으로 정렬하고, 월급을 내림차순으로 정렬
        - 즉 같은 부서안에서는 월급을 기준으로 정렬

    - SELECT가 되고 난 후 ORDER BY를 시행하기에 테이블에 없는 컬럼으로 정렬 가능

      ```sql
      SELECT empno AS "사번", ename AS "사원의 이름",job  AS "직무", 
      sal AS "월급", comm AS "보너스", sal * 12 + NVL(comm,0) AS "연봉"
      FROM emp
      ORDER BY "연봉" DESC; -- "연봉" 이란 column은 없지만 SELECT이후 OREDR BY를 하기에 정렬할 수 있다.
      ```

      

    - 여러 정렬 기준 설정 가능

    - 속도에 문제가 생기기에 특별한 경우가 아니면 사용 X

  - 종합문제: P.92 3번

    ```sql
    SELECT empno AS EMPLOYEE_NO, ename AS EMPLOYEE_NAME, mgr AS MANAGER, sal AS SALARY,
    comm AS COMMISSION, deptno AS DEPARTMENT_NO
    FROM emp
    ORDER BY deptno DESC, ename;
    ```

    

  - **NULL**: DB에서 NULL은 계산되지 않는다. DB에서 NULL은 공간은 있지만 값이 없는 경우, 모르는 경우를 말한다.

    - 따라서 DB에서 0원과 NULL은 다르다 --> <u>NULL은 연산이 불가</u>
      - **0원: 값이 0**
      - **NULL: 값 자체가 없음**
    - 위 `alias를 사용하는 이유`에서 COMMITION이 NULL인 사원은 연산은 NULL이되지만 COMMITION이 0인 10번은 연산이 된다.
    - NULL 처리: NVL()함수

  - **Concatenation Operator**: 연결 연산자

    - 문자열과 문자열을 이을때는 "||" 사용

      ```sql
      SELECT 'HELLO' || ', World'
      FROM dual;
      -- 결과: HELLO, World
      ```

    - 응용

      ```sql
      SELECT '사원번호 ' || empno || '는 '|| ename || '입니다.'
      FROM emp;
      --결과: 사원번호 7369는 SMITH입니다.
      ```

  - Literals

    - Chatacter literal: ' '
      - 날짜 타입도: ' '
      - DB는 문자형없다.
    - Number literal: 그냥 사용

## 8. WHERE Syntax

------

- 파일 및 교재: P.94 ~ 

- WHERE: 특정 조건에 맞는 ROW 출력

  - FROM 다음에 시행

- **형식**: 

  ```sql
  SELECT [DISTINCT|ALL] column1, column2 --필수
  FROM table_name --필수
  WHERE condition --조건
  ORDER BY column1;
  ```

  - 예

    ```sql
    SELECT ename, job, sal
    FROM emp
    WHERE deptno = 10;
    ```

- **AND, OR 연산**

  - AND 예

    ```sql
    --사원테이블에서 부서번호가 20번 부서에 속해있는 사원 중에 월급이 1000불 이하인 사원의 정보를 조회
    SELECT *
    FROM emp
    WHERE deptno = 20 AND sal<=1000;
    ```

  - OR 예

    ```sql
    SELECT empno, ename, sal, deptno
    FROM emp
    WHERE deptno = 10 OR (sal >= 3000 AND sal <= 5000); 
    ```

- 연산자: P.101 ~ 

  - %안씀 

  - mod() 함수를 사용

  - **NOT 연산자**: 논리부정연산자

    - IN, BETWEEN, IS NULL과 함께 복합적으로 사용

    ```sql
    --논리부정연산자
    SELECT deptno, dname, loc
    FROM dept
    WHERE NOT (deptno = 10 OR deptno = 20);
    -- 결과: 부서번호가 10번과 20번이 아닌 부서 전부 출력
    ```

  - **IN연산자**

    - OR대용으로 사용하는 연산자로 특정 열에 해당하는 조건을 여러 개 지정 할 수 있다.

      ```sql
      -- IN 연산자
      SELECT deptno, dname, loc
      FROM dept
      WHERE deptno IN (10, 20); -- 부서번호가 10번과 20번인 부서를 조건으로 지정
      --WHERE dept no NOT IN (10, 20); 앞에 NOT 코드와 같은 것
      ```

    - 예

      ```sql
      --사원테이블에서 직무가 SALESMAN이거나 MANAGER이거나 PRESIDENT인 사원의 사원이름, 직무 조회
      SELECT ename, job
      FROM emp
      WHERE job IN('SALESMAN', 'MANAGER', 'PRESIDENT');
      ```

      

## 9. SQL 함수

------

1. **NVL(colmun, NULL이면 바꿀 값)**: 데이터가 NULL일 경우 지정한 값으로 치환

    

   ```sql
   SELECT sal * 12 + NVL(COMM,0 ) AS "연봉"
   FROM EMP;
   ```

   - 주의점

     - **치환을 할 때 타입이 같아야 한다.**

       - 예를 들어 HIREDATE의 타입이 DATE라면 치환할 값도 Date이어야 한다.

       ```sql
       --SELECT NVL(COMM, '값 없음') --오류: comm은 NUMBER인데 치환할 값이 문자열이라 오류
       SELECT NVL(COMM, 100)
       FROM emp;
       ```

       