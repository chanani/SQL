--1. 모든 사원의 사원번호, 이름, 입사일, 급여를 출력하세요.
--2. 모든 사원의 이름과 성을 붙여 출력하세요. 열 별칭은 name으로 하세요.
--3. 50번 부서 사원의 모든 정보를 출력하세요.
--4. 50번 부서 사원의 이름, 부서번호, 직무아이디를 출력하세요.
--5. 모든 사원의 이름, 급여 그리고 300달러 인상된 급여를 출력하세요.
--6. 급여가 10000보다 큰 사원의 이름과 급여를 출력하세요.
--7. 보너스를 받는 사원의 이름과 직무, 보너스율을 출력하세요.
--8. 2003년도 입사한 사원의 이름과 입사일 그리고 급여를 출력하세요.(BETWEEN 연산자 사용)
--9. 2003년도 입사한 사원의 이름과 입사일 그리고 급여를 출력하세요.(LIKE 연산자 사용)
--10. 모든 사원의 이름과 급여를 급여가 많은 사원부터 적은 사원순서로 출력하세요.
--11. 위 질의를 60번 부서의 사원에 대해서만 질의하세요. (컬럼: department_id)
--12. 직무아이디가 IT_PROG 이거나, SA_MAN인 사원의 이름과 직무아이디를 출력하세요.
--13. Steven King 사원의 정보를 “Steven King 사원의 급여는 24000달러 입니다” 형식으로 출력하세요.
--14. 매니저(MAN) 직무에 해당하는 사원의 이름과 직무아이디를 출력하세요. (컬럼:job_id)
--15. 매니저(MAN) 직무에 해당하는 사원의 이름과 직무아이디를 직무아이디 순서대로 출력하세요.


SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY FROM EMPLOYEES; -- 1
SELECT FIRST_NAME || ' ' || LAST_NAME AS name FROM EMPLOYEES; -- 2
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50; -- 3
SELECT FIRST_NAME, LAST_NAME, JOB_ID FROM EMPLOYEES WHERE DEPARTMENT_ID= 50; -- 4
SELECT FIRST_NAME, LAST_NAME, SALARY  + 300 FROM EMPLOYEES ; -- 5
SELECT FIRST_NAME, LAST_NAME, SALARY FROM EMPLOYEES WHERE SALARY > 10000; -- 6 
SELECT FIRST_NAME, LAST_NAME, JOB_ID, COMMISSION_PCT FROM EMPLOYEES WHERE COMMISSION_PCT IS NOT NULL; --7
SELECT FIRST_NAME, LAST_NAME, HIRE_DATE, SALARY FROM EMPLOYEES WHERE HIRE_DATE BETWEEN '03/01/01' AND '03/12/31'; -- 8
SELECT FIRST_NAME, LAST_NAME, HIRE_DATE, SALARY FROM EMPLOYEES WHERE HIRE_DATE LIKE '03%'; --9
SELECT FIRST_NAME, LAST_NAME, SALARY FROM EMPLOYEES ORDER BY SALARY DESC; --10
SELECT FIRST_NAME, LAST_NAME, SALARY FROM EMPLOYEES WHERE DEPARTMENT_ID = 60 ORDER BY SALARY DESC  ; -- 11
SELECT FIRST_NAME, LAST_NAME, JOB_ID FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG' OR JOB_ID = 'SA_MAN'; -- 12
SELECT FIRST_NAME, LAST_NAME, JOB_ID FROM EMPLOYEES WHERE JOB_ID IN ('IT_PROG', 'SA_MAN'); -- 12
SELECT FIRST_NAME || ' '||  LAST_NAME || '의 급여는' || SALARY || '입니다.' AS Steaven
        FROM EMPLOYEES WHERE FIRST_NAME = 'Steven' AND LAST_NAME = 'King'; -- 13
SELECT FIRST_NAME, LAST_NAME, JOB_ID FROM EMPLOYEES WHERE JOB_ID LIKE'%MAN'; -- 14
SELECT FIRST_NAME, LAST_NAME, JOB_ID FROM EMPLOYEES WHERE JOB_ID LIKE'%MAN' ORDER BY JOB_ID ASC; -- 15

