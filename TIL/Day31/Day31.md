# 0827

------



## TIL

------

1. PPT 취합 --> 점심 빨리먹고

2. main sql: Day31.sql, zipcode_ansi.sql, zipcode1.sql

3.  복습: https://github.com/swacademy/Oracle/blob/master/2.%20Basic%20SELECT.pdf

   1.  What's the Oracle DB
   2.  SQL 개념
   3.  SELECT basic/syntax
   4.  WHERE syntax
   5.  DB에서 NULL의 의미
       1.  NVL(expr1, expr2)
   6.  Alias 별칭
   7.  연결연산자

4. git 수정

   - Day29, 0825꺼 날라감 --> 받기
     - 중요 정보: 리퀘스트 페킷 GET /[요청 경로] HTTP/1.1

5.  sqlplus과 VISUAL STUDIO CODE를 연동(system version으로 다운)

    1.  설치 중 추가 작업 선택 옵션은 전부 선택

    2.  cmd에서 code . 하면 현재위치를 기준으로 비주얼 스튜디오  열린다.

        1.  또는 오른쪽 클릭으로 연다.

    3.  왼쪽 패널 Extention 클릭

        1.  korean 팩 설치

        2.  night Owl: 칼라테마

        3.  # Material Icon Theme 

    4.  UTF-8이라 께짐: 오른쪽 하단 UTF-8 클릭해서 수정

    5.  연동 방법

    6.  C:\Oracle_Home\sqlplus\admin/glogin.sql

    7.  define_editer="쓰고싶은 에디터의 절대경로"

        1.  define_editor="C:\Program Files\Microsoft VS Code\Code.exe"

    8.  CMD에서 sqlplus에서 ed 하면 여기로 열림

- ALTER SESSION SET NLS_DATE_FORMET = 'YYYY-MM-DD';
- 팀플 관련
  - 월요일: 조장회의
  - 화수목금: 조마다 돌아가면서 회의

## 1.  SQL 연산자

------

- 파일 및 교재: P.106 ~,  Day31.sql

- **NOT**

- **IN**

  ```sql
  SELECT ename, job
  FROM emp
  WHERE job IN ('CLERK', 'MANAGER', 'ANALYST');
  ```

  

- **BETWEEN A AND B**

  - 특징

  - A가 B보다 작아야 한다

  - 포함 관계

    ```sql
    -- 2. BETWEEN A AND B
    -- BETWEEN A AND B 안 쓴 경우
    SELECT ename, job, sal
    FROM emp
    WHERE sal >= 1300 AND sal<=1500
    
    -- BETWEEN A AND B 쓴 경우
    SELECT ename, job, sal
    FROM emp
    WHERE sal BETWEEN 1300 AND 1500;
    ```

- 1981년에 입사한 사원의 사번, 이름, 입사날짜를 출력하는 방법 5가지

  ```sql
  --1
  SELECT empno, ename, hiredate
  FROM emp
  WHERE hiredate >= '1987-01-01' AND hiredate <= '1987-12-31';
  
  --2
  SELECT empno, ename, hiredate
  FROM emp
  WHERE hiredate BETWEEN '1987-01-31' AND '1987-12-31';
  
  --3
  SELECT empno, ename, hiredate
  FROM emp
  WHERE hiredate LIKE '1987%';
  
  --4 SUBSTR()이용
  SELECT empno, ename, hiredate
  FROM emp
  WHERE SUBSTR(hiredate,1,4) = '1987';
  --5
  ```

- **LIKE 연산자**: zipcode_ansi.sql, zipcode1.sql

  - **%**: 개수 상관 X

  - **_**: 개수 인식

  - 와일드카드를 와일드카드로 보지 않기위해 ESCAPE활용

    - 'A\\_A%''

    - 'B\%B__'

    - EACAPE는 지정이 가능: 해 볼 것

      ```sql
      SELECT ename
      FROM emp
      WHERE ename LIKE '$_T%' ESCAPE '$';
      ```

      

  - 와일드 카드를 사용해서 검색이 가능하다.

    ```sql
    SELECT *
    FROM ZIPCODE
    WHERE dong LIKE '개포동'; -- 오직 개포동만 출력 
    ```

  - 위 코드는 오직 '역삼동과 일치하는 것만 검색' 

  - 와일드 카드를 사용하면...

    ```sql
    SELECT COUNT(*)
    FROM ZIPCODE
    WHERE dong LIKE '개포%'; -- dong이 개포로 시작하는 모든 것을 출력: 개포동 + 개포 1동 +.......
    -- 결과: 78
    ```

- **IS NULL연산**

  - NULL 연산을 할 수 없기에 =를 사용해서 비교할 수 없다.

  - 따라서 NULL값을 찾고 싶을 때 `IS NULL` 사용

    ```sql
    --우리회사에서 보너스를 받지 않는 사원 정보를 조회하시오
    SELECT *
    FROM emp
    WHERE comm IS NULL;
    --응용
    --우리회사에서 메니저가 없는 사원을 조회하시오.
    SELECT ename, job
    FROM emp
    WHERE mgr IS NULL;
    ```

  - 반대로 IS NOT NULL은 NULL이 아닌 행을 조회

    ```sql
    --우리회사에서 보너스를 받는 사원 정보를 조회하시오
    SELECT *
    FROM emp
    WHERE comm IS NOT NULL;
    ```

  - **NULL의 정렬: NULL은 제일 큰 값이라고 간주한다.**

    ```sql
    SELECT *
    FROM emp
    ORDER BY comm DESC;
    -- 결과: 보너스가 없는 SMITH는 COMM 내림차순하면 1위이다.
    ```

- **집합 연산자**: P.119 ~ ,

  ```sql
  -- 집합연산자 연습용 테이블 
  CREATE TABLE emp10
  AS 
  SELECT * FROM emp
  WHERE deptno = 10; 
  
  CREATE TABLE emp20
  AS 
  SELECT * FROM emp
  WHERE deptno = 10; 
  
  ```

  

- 두 게 이상의 SELECT문의 결과 값을 연결할 때 사용

- 종류

  - UNION: 합집합, 중복 결과는 제거

    ```sql
    -- UNION
    SELECT empno, ename, deptno
    FROM emp10
    UNION
    SELECT empno, ename, deptno
    FROM emp20;
    ```

  - 문제 

  1. emp_clerk(직무가 clerk), emp_manager(직무가 manager) 생성

     ```sql
     -- CREATE TABLE emp_clerk
     CREATE TABLE emp_clerk
     AS
     SELECT *
     FROM emp
     WHERE job = 'CLERK';
     -- CREATE TABLE emp_manager
     CREATE TABLE emp_manager
     AS
     SELECT *
     FROM emp
     WHERE job = 'MANAGER';
     ```

  2. emp_tf 테이블 생성, 각 사원의 사번, 이름, 직무만으로 구성된 두개의 테이블을 합쳐라

     ```sql
     -- 연습2: UNION을 활용한 emp_tf 테이블 생성, 각 사원의 사번, 이름, 직무만으로 구성된 두개의 테이블을 합쳐라
     CREATE TABLE emp_tf
     AS
     SELECT  empno, ename, job
     FROM emp
     WHERE job = 'CLERK'
     UNION
     SELECT empno, ename, job
     FROM emp
     WHERE job = 'MANAGER';
     ```

     - UNION ALL: 합집합, 중복 결과 포함

     - MINUS: 차집합

       ```sql
       --MINUS
       SELECT ename, job
       FROM emp       --14명
       MINUS
       SELECT ename, job
       FROM emp_clerk; --4명
       --결과: 10명
       ```

       

     - INTERSECT: 교집합

       ```sql
       --INTERSECT
       SELECT ename, job
       FROM emp       --14명
       INTERSECT
       SELECT ename, job
       FROM emp_clerk; --4명
       --결과 4명
       ```

- SQL 연산자 종합 문제

  ```sql
  --P.125 문제
  --1
  SELECT *
  FROM emp
  WHERE ename LIKE '%S';
  --2
  SELECT empno, ename, job, deptno
  FROM emp
  WHERE deptno = 30 AND job = 'SALESMAN';
  --3
  --3-1 집합연산자 X
  SELECT empno, ename, sal, deptno
  FROM emp
  WHERE deptno IN (20, 30) AND sal > 2000;
  --3-2 집합연산자 사용:
  SELECT empno, ename, sal, deptno
  FROM emp 
  WHERE sal > 2000
  MINUS
  SELECT  empno, ename, sal, deptno
  FROM emp 
  WHERE deptno NOT IN (20, 30);
  --4
  SELECT *
  FROM emp
  WHERE NOT(sal >= 2000 AND sal <= 3000);
  --5
  SELECT ename, empno, sal, deptno
  FROM emp
  WHERE (sal NOT BETWEEN  1000 AND 2000) AND ename LIKE '%E%';
  --6
  --6-1 ONLY AND
  SELECT *
  FROM emp
  WHERE comm is null AND job IN ('MANAGER', 'CLERK') AND mgr IS NOT NULL AND NOT ename = '_L%';
  --6-2 위에꺼 집합 연산으로
  SELECT *
  FROM emp
  WHERE comm is null
  INTERSECT
  SELECT *
  FROM emp
  WHERE job IN ('MANAGER', 'CLERK')
  INTERSECT
  SELECT *
  FROM emp
  WHERE mgr IS NOT NULL
  INTERSECT
  SELECT *
  FROM emp
  WHERE NOT ename = '_L%';
  
  ```

- `2-1. Basic SELECT 실습.pdf` 문제

## 2. SQL에서 날짜 

------

- 파일 및 교재:Day31.sql, 2-1. Basic SELECT 실습.pdf

- 날짜형: Date

  - ' ' 로 묶는다.

  - DATE 형식은 항상 NLS_DATE_FORMAT 형식에 맞추어야 한다.

  - 그전에 아래의 명령어를 통해 NLS_DATE_FORMAT 확인

    ```sql
    SELECT parameter, value 
    FROM NLS_SESSION_PARAMETERS; 
    ```

  -  다음 명령어로 항상 DB 시작하면 바꾼다.

    ```sql
    ALTER SESSION
    SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
    ```

- 연산자 우선순위

- SQL 연산자 종합 문제

  ```sql
  --P.125 문제
  --1
  SELECT *
  FROM emp
  WHERE ename LIKE '%S';
  --2
  SELECT empno, ename, job, deptno
  FROM emp
  WHERE deptno = 30 AND job = 'SALESMAN';
  --3
  --3-1 집합연산자 X
  SELECT empno, ename, sal, deptno
  FROM emp
  WHERE deptno IN (20, 30) AND sal > 2000;
  --3-2 집합연산자 사용: 반대로 구현 가능
  SELECT empno, ename, sal, deptno
  FROM emp 
  WHERE sal > 2000
  MINUS
  SELECT  empno, ename, sal, deptno
  FROM emp 
  WHERE deptno NOT IN (20, 30);
  ```

- `2-1. Basic SELECT 실습.pdf` 문제

  ```sql
  --2-1. Basic SELECT 실습.pdf 문제
  --11: 날짜형도 연산이 된다. 
  SELECT *
  FROM emp
  WHERE hiredate >= '1983-01-01' ;
  --12: 급여가 보너스 이하인 사원의 이름, 급여 및 보너스를 출력하시오
  SELECT *
  FROM emp
  WHERE sal <= comm;
  --20:
  SELECT ename, sal, comm, sal + comm AS "총액"
  FROM emp
  WHERE comm IS NOT NULL
  ORDER BY "총액" DESC;
  --21
  SELECT ename, sal, sal * 0.13 AS "보너스 급여", deptno
  FROM emp
  WHERE deptno = 10;
  --40
  SELECT ename
  FROM emp
  MINUS
  SELECT ename
  FROM emp
  WHERE ename >= 'K';
  
  ```

  

  

## 3.  SQL 함수

------

- 파일 및 교재:
- 

## 4.  오라클 함수

------

- 파일 및 교재: P.128 ~, https://github.com/swacademy/Oracle/blob/master/4.%20Single%20Row%20Function.pdf
- 함수
  - 내장함수(Built-in): 기본으로 들어있는 함수
    - 단일행 함수: 행 단위로 결과가 나온다.
      - 문자
      - 숫자
      - 치환
      - 기타
      - 등
    - 다중행 함수: 여러 행이 입력되어 하나의 행으로 결과를 반환
  - 외장함수(Function)

## 5. 단일행 함수

------

- 파일 및 교재: https://github.com/swacademy/Oracle/blob/master/4.%20Single%20Row%20Function.pdf

- **문자함수**

  - <u>오라클 DB 문자열의 시작 인덱스는 1이다.</u>

  - UPPER/LOWER

    ```sql
    SELECT *
    FROM emp
    --WHERE job = UPPER('salesman'); --데이터는 대, 소문자를 구분하므로 결과는 나오지 않는다 --> 문자 함수 사용: 행 단위로 문자를 읽어서 바꾸므로 단일 행 함수
    WHERE LOWER(job) = 'SALESMAN';
    
    SELECT UPPER('hello, world ') || LOWER('HELLO, WORLD ') || INITCAP('HELLO, WORLD ')
    FROM dual;
    ```

  - LENGTH: 문자 개수

    ```sql
    SELECT LENGTH('SCOTT') ,LENGTH('안녕하세요')
    FROM dual; 
    ```

  - LENGTHB: 바이트길이

    ```sql
    --LENGTH
    SELECT LENGTHB('SCOTT') ,LENGTHB('안녕하세요') --한글은 3바이트: Character set이 UTF-8일 경우
    FROM dual; 
    ```

  - **SUBSTR**: subString()처럼 문자열의 일부분을 출력

    - SUBSTR(column| expression, m[,n])
      - n은 n개로
      - SUBSTR(1,6)은 1부터 6개까지이다.
      - 오라클은 1부터 인덱스 시작: 자바도 JDBC를 사용할 때 !로 시작
      - 개수 안쓰면 끝까지 , m이 음수면 문자 값의 끝부터 센다.

    ```sql
    --SUBSTR
    SELECT job, SUBSTR(job, 1, 3), SUBSTR(job, 3)
    FROM emp
    WHERE deptno = 10;
    ```

  - **INSTR**: P.137볼 것

    - 문자열 데이터 안에 특정 문자나 문자열이 어디에 위치하는지 알고자할 때 INSTR함수 이용
    - 패킷의 GET / HTTP/1.1이 바로 INSTR

  - 형식:

    - INSTR([대상 문자열 데이터(필수), [위치를 찾으려는 부분 문자(필수)], [위치 찾기를 시작할 대상 문자열 데이터 위치(선택, 기본값은 0), [시작 위치에서 찾으려는 문자가 몇 번째인지 지정(선택, 기본값은 1)])
    - INSTR(column | expression, 'String', [,m] (찾기 시작할 인덱스 지정), [,n] (찾으려는 문자열의 몇 번째 문자열의 위치를 출력할것인가))
    -  INSTR(ename, 'A') -->  이름에서 'A'가 몇번쩨인지 출력

    ```SQL
    --INSTR
    SELECT ename, LENGTH(ename), LOWER(ename), SUBSTR(ename, 1, 3), INSTR(ename, 'A')
    FROM emp
    WHERE deptno = 20;
    ```

  - REPLACE(COLUMN|expression, original, replace)

  - LPAD()/RPAD(): 데이터의 빈 공간을 특정 문자로 체운다

    - LPAD: 남은 빈 공간을 왼쪽으로 채운다, RPAD: 오른쪽으로 채운다
      - 예: LPAD(ename. 10, '*'): 10글자 중 남은 공간을 왼쪽으로 *로 채운다.

  - CONCAT()

    - 오라클은 개수 제한 있음: 인자는 무조건 2개 --> 중첩해서 사용해야 함

      - WHERE dong LIKE CONCAT(CONCAT('개포', '%'),'%', )

      ```sql
      --CONCAT
      SELECT *
      FROM zipcode
      WHERE dong LIKE '%개포%';
      --나중에 자바가 %개포%를 변수로 받아야 하므로 오라클만 이렇게 해야한다.
      SELECT *
      FROM zipcode
      --WHERE dong LIKE '%개포%';
      WHERE dong LIKE CONCAT(CONCAT('%','개포'),'%');
      ```

    - TRIM()

      - RTRIM(): 오른쪽트리밍 

      - LTRIM(): 왼쪽트리밍

        ```sql
        SELECT 'aaHelloaa', LTRIM('aaHelloaa','a'), RTRIM('aaHelloaa','a'), TRIM(BOTH 'a' FROM 'aaHelloaa'), TRIM(LEADING 'a' FROM 'aaHelloaa'), TRIM(TRAILING 'a' FROM 'aaHelloaa')
        FROM dual;
        --TRIM() 유의
        -- TRIM(BOTH 'a' FROM 'aaHelloaa')
        -- TRIM(LEADING 'a' FROM 'aaHelloaa')
        --  TRIM(TRAILING 'a' FROM 'aaHelloaa')
        ```

        

      - TRIM(): 둘 다

        - 옵션: LEADING == LTRIM, TRAILING == RTRIM, BOTH: 둘다

      - CHR()

        - 숫자에 맞는 ASCII문자 출력

          ```sql
          SELECT 'Hello' || 'WORLD' || CHR(10) || CHR(36) ||'Oracle Programming'
          FROM dual;
          -- 표(Grid)가 아닌 일반 실행으로 ㄱ
          ```

          

      - ASCII()

        - 문자를 입력하면 숫자를 반환
        - 중요한 거: /n은 10

      - GREATEST()

      - LEAST()

## 6.

------

- 파일 및 교재:

## 7.

------

- 파일 및 교재:

## 8.

------

+ CMD 명령어

  + 와일드 카드

    + *.txt: 여러글자 대용	

      ```cmd
      dir *.txt
      ```

      

    + ????.txt 4글자 대응

      ```
      dir D????.sql
      D로시작하고 5글자인 sql파일을 찾는다.
      ```

      