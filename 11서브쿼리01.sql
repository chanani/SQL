-- 서브쿼리
-- SELECT문이 SELECT구문으로 들어가는 형태 : 스칼라 서브쿼리
-- SELECT문이 FROM구문으로 들어가는 형태 : 인라인뷰
-- SELECT문이 WHERE구문으로 들어가면 : 서브쿼리
-- 서브쿼리는 반드시 () 안에 적습니다.

-- 단일행 서브쿼리 : 리턴되는 행이 1개인 서브쿼리

SELECT * 
FROM EMPLOYEES 
WHERE SALARY > (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy');

-- EMPLOYEE_ID가 103번인 사람과 동일한 적군
SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 103);

-- 주의할점, 단일행 이어야 합니다., 컬럼 값도 1개 여야합니다.
-- ERR
SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 103 OR EMPLOYEE_ID = 104);

-----------------------------------------------------------------------------
-- 다중행 서브쿼리 : 행이 여러개라면 IN, ANY, ALL로 비교합니다.
SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David';

-- IN 동일한 값을 찾습니다. IN (4800, 6800, 9500)
SELECT * 
FROM EMPLOYEES
WHERE SALARY IN (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- ANY : 최소값 보다 큼, 최대값 보다 작음
SELECT *
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David') ; -- 급여가 4800보다 큰 사람들

SELECT *
FROM EMPLOYEES
WHERE SALARY < ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David') ; -- 급여가 9500보다 작은 사람들

-- ALL : 최대값 보다 큼, 최소값 보다 작음

SELECT *
FROM EMPLOYEES
WHERE SALARY > ALL (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David'); -- 급여가 9500보다 큰 사람들

SELECT *
FROM EMPLOYEES
WHERE SALARY < ALL (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David'); -- 급여가 4800보다 작은 사람들

-- 직업이 IT_PROG인 사람들의 최소값 보다 큰 급여를 받는 사람들
SELECT *
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG');

-----------------------------------------------------------------------------
-- 스칼라 서브쿼리
-- JOIN시에 특정테이블의 1컬럼을 가지고 올 때 유용합니다.
SELECT FIRST_NAME,
       EMAIL,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID )
FROM EMPLOYEES E
ORDER BY FIRST_NAME;

--  각 부서의 매니저 이름 출력
-- JOIN
SELECT D.*,
       E.FIRST_NAME
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E
ON D.MANAGER_ID = E.MANAGER_ID;


-- 스칼라
SELECT D.*,
       (SELECT FIRST_NAME FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = E.MANAGER_ID)
FROM DEPARTMENTS D;

-- 스칼라쿼리는 여러번 사용 가능
SELECT * FROM JOBS; -- JOB_TITLE
SELECT * FROM DEPARTMENTS; -- DEAPARTMENT_NAME
SELECT * FROM EMPLOYEES;

SELECT E.FIRST_NAME,
       E.JOB_ID, 
       (SELECT JOB_TITLE FROM JOBS J WHERE j.JOB_ID = E.JOB_ID) AS TITLE,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) AS NAME
FROM EMPLOYEES E;

-- 각 부서의 사원 수를 출력 + 부서정보.
SELECT DEPARTMENT_ID,
      COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

SELECT D.*,
       NVL( (SELECT COUNT(*) FROM EMPLOYEES E WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID GROUP BY DEPARTMENT_ID), 0) AS 사원수
FROM DEPARTMENTS D;

-----------------------------------------------------------------------------
-- 인라인 뷰
-- 가짜 테이블 형태

-- ROWNUM는 조회된 순서이기 떄문에, ORDER와 같이 사용되면 ROWNUM 섞이는 문제
SELECT FIRST_NAME, 
       SALARY,
       ROWNUM
FROM(SELECT *
        FROM EMPLOYEES
        ORDER BY SALARY DESC);

-- 문법2
SELECT ROWNUM,
       A.*
FROM (SELECT FIRST_NAME,
             SALARY
        FROM EMPLOYEES
        ORDER BY SALARY
        ) A ;

-- ROWNUM은 무조건 1번째부터 조회가 가능하기 때문에 그렇습니다.
SELECT FIRST_NAME, 
       SALARY,
       ROWNUM
FROM(SELECT *
        FROM EMPLOYEES
        ORDER BY SALARY DESC)
WHERE ROWNUM BETWEEN 11 AND 20; -- 1번부터 시작하지 않아 조회가 안됨

-- 2번째 인라인 뷰에서 ROWNUM을 RN으로 컬럼화
SELECT *
FROM (SELECT FIRST_NAME, 
               SALARY,
               ROWNUM AS RN
        FROM(SELECT *
                FROM EMPLOYEES
                ORDER BY SALARY DESC)    
    )
WHERE RN >= 11 AND RN <= 20;

-- 인라인 뷰의 예시
SELECT TO_CHAR(REGDATE, 'YY-MM-DD') AS REDGDATE,
        NAME
FROM (SELECT '홍길동' AS NAME, SYSDATE AS REGDATE FROM DUAL 
        UNION ALL
        SELECT '이순신', SYSDATE FROM DUAL);

-- 인라인 뷰의 응용
-- 부서별 사원수 
SELECT D.*,
       E.TOTAL
FROM DEPARTMENTS D
LEFT JOIN (SELECT DEPARTMENT_ID, COUNT(*) AS TOTAL
            FROM EMPLOYEES 
            GROUP BY DEPARTMENT_ID) E
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID;

-- 정리
-- 단일행( 대소비교 ) VS 다중행 서브쿼리(IN, ANY, ALL)
-- 스칼라쿼리 : LEFT JOIN과 같은 역할, 한번에 1개의 컬럼을 가져올 때
-- 인라인뷰 : FROM에 들어가는 가짜 테이블

SELECT *
FROM EMPLOYEES;




