-- 그룹합수 : 여러행에 대하여 집계출력
-- AVG, SUM, MIN, MAX, COUNT
SELECT AVG(SALARY), SUM(SALARY), MIN(SALARY), MAX(SALARY), COUNT(SALARY) FROM EMPLOYEES;
SELECT MIN(HIRE_DATE), MAX(HIRE_DATE) FROM EMPLOYEES; -- 날짜에도 적용 가능
SELECT MIN(FIRST_NAME), MAX(FIRST_NAME) FROM EMPLOYEES; -- 문자에도 적용 가능

-- COUNT(컬럼) : NULL이 아닌 데이터개수
-- COUNT(*) : 전체행의 개수
SELECT COUNT(FIRST_NAME) FROM EMPLOYEES;
SELECT COUNT(DEPARTMENT_ID) FROM EMPLOYEES;
SELECT COUNT(COMMISSION_PCT) FROM EMPLOYEES;
SELECT COUNT(*) FROM EMPLOYEES;

------주의할 점--------
-- 그룹함수 : 그룹함수와 일반 컬럼은 동시에 출력할 수 없습니다. (오라클만)
SELECT FIRST_NAME, SUM(SALARY) FROM EMPLOYEES;


------------------------------------------------------------

SELECT DEPARTMENT_ID, AVG(SALARY), SUM(SALARY), COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

-- 주의할점 : 그룹절에 사용한 컬럼만, SELECT절에서 사용합니다.
SELECT DEPARTMENT_ID, FIRST_NAME
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID; -- ERR

-- 2개 이상의 그룹화
SELECT DEPARTMENT_ID,JOB_ID, SUM(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID;

-- 그룹함수를 WHERE절에 적용할 수 없습니다.
SELECT JOB_ID, AVG(SALARY)
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 50
GROUP BY JOB_ID;

------------------------------------------------------------
-- 그룹의 조건은 HAVING절을 사용합니다.
SELECT JOB_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY JOB_ID
HAVING AVG(SALARY) >= 10000;

SELECT DEPARTMENT_ID, COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING COUNT(*) >= 30;

SELECT JOB_ID, SUM(SALARY), SUM( NVL(COMMISSION_PCT, 0 ) )
FROM EMPLOYEES
WHERE JOB_ID NOT IN ('IT_PROG')
GROUP BY JOB_ID
HAVING SUM(SALARY) >= 20000
ORDER BY SUM(SALARY) DESC;

-- 부서아이디가 50번 이상인 부서를 그룹화 시키고 그룹평균 급여 5000이상만 출력
SELECT DEPARTMENT_ID, AVG(SALARY) 
FROM EMPLOYEES
WHERE  DEPARTMENT_ID >= 50
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 5000;

------------------------------------------------------------
-- ROLLUP : 각 그룹의 소계, 총계를 아래에 출력
SELECT DEPARTMENT_ID, TRUNC(SUM(SALARY))
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID);

SELECT DEPARTMENT_ID, JOB_ID, TRUNC(SUM(SALARY))
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID);

-- CUBE : 서브그룹에 대한 컬럼 출력
SELECT DEPARTMENT_ID, JOB_ID, TRUNC(SUM(SALARY))
FROM EMPLOYEES
GROUP BY CUBE(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID;

-- GROUPING() : 그룹절로 생성되면 0 반환, 롤업 OR 큐브로 만들어지면 1반환
SELECT DEPARTMENT_ID, 
       JOB_ID, 
       DECODE(GROUPING(JOB_ID), 1, '소계', JOB_ID) AS A,
       GROUPING(JOB_ID) AS B,
       SUM(SALARY) AS C , 
       COUNT(*) AS D
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID;

------------------------------------------------------------
-- 연습문제
SELECT * FROM EMPLOYEES;
-- 1. 사원 테이블에서 JOB_ID별 사원 수를 구하세요.
-- 사원 테이블에서 JOB_ID별 월급의 평균을 구하세요. 월급의 평균 순으로 내림차순 정렬하세요
SELECT JOB_ID, 
        COUNT(*) AS 사원수, 
        AVG(SALARY) AS 급여평균
FROM EMPLOYEES
GROUP BY JOB_ID
ORDER BY 급여평균 DESC;

-- 2. 사원 테이블에서 입사 년도 별 사원 수를 구하세요.
SELECT TO_CHAR(HIRE_DATE, 'YY'),
        COUNT(*)
FROM EMPLOYEES
GROUP BY TO_CHAR(HIRE_DATE, 'YY');

-- 3. 급여가 1000 이상인 사원들의 부서별 평균 급여를 출력하세요. 단 부서 평균 급여가 2000이상인 부서만 출력
SELECT DEPARTMENT_ID, 
       TRUNC(AVG(SALARY))
FROM EMPLOYEES
WHERE SALARY >= 1000
GROUP BY DEPARTMENT_ID
HAVING TRUNC(AVG(SALARY)) >= 2000 ;

-- 4. 사원 테이블에서 commission_pct(커미션) 컬럼이 null이 아닌 사람들의 department_id(부서별) salary(월급)의 평균, 합계, count를 구합니다.
-- 조건 1) 월급의 평균은 커미션을 적용시킨 월급입니다. 조건 2) 평균은 소수 2째 자리에서 절삭 하세요.
SELECT DEPARTMENT_ID, 
       TRUNC(AVG(SALARY + SALARY * COMMISSION_PCT), 2) AS 급여평균, 
       SUM(SALARY + SALARY * COMMISSION_PCT) AS 급여합, 
       COUNT(*) AS 사원수
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL 
GROUP BY DEPARTMENT_ID;

-- 5. 직업별 월급합, 총합계를 출력하세요.
SELECT DECODE(GROUPING(JOB_ID), 1, '합계', JOB_ID) AS JOB_ID, 
SUM(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(JOB_ID) 
ORDER BY JOB_ID ASC;


-- 6. 부서별, JOB_ID를 그룹핑 하여 토탈, 합계를 출력하세요. GROUPING() 을 이용하여 소계 합계를 표현하세요
SELECT  
DECODE(GROUPING(DEPARTMENT_ID), 1, '합계', DEPARTMENT_ID) AS DEPARTMENT_ID ,
DECODE(GROUPING(JOB_ID), 1, '소계', JOB_ID) AS JOB_ID,
COUNT(*) AS TOTAL,
SUM(SALARY) AS SUM
FROM EMPLOYEES
GROUP BY ROLLUP (DEPARTMENT_ID, JOB_ID)
ORDER BY SUM ASC;

       










