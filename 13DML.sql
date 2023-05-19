-- INSERT, UPDATE, DELETE 문을 작성하려면 COMMIT 명령으로 실제 반영을 처리하는 작업이 필요합니다.
-- INSERT

-- 테이블 구조 확인
DESC DEPARTMENTS;


INSERT INTO DEPARTMENTS 
VALUES(300, 'DEV', NULL, 1700); -- 전체행을 넣는 경우

INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME)
VALUES(310, 'SYSTEM'); -- 선택적으로 넣는 경우

SELECT * FROM DEPARTMENTS;

ROLLBACK;

-- 사본테이블(테이블 구조만 복사)
CREATE TABLE EMPS AS (SELECT * FROM EMPLOYEES WHERE 1 = 2);


INSERT INTO EMPS (SELECT * FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG'); -- 전체컬럼을 맞춤 (잘 안씀)
INSERT INTO EMPS (EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
VALUES (200, 
       (SELECT LAST_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = 200) ,
       (SELECT EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = 200), 
       SYSDATE,
       'TEST');

SELECT * FROM EMPS;
------------------------------------------------------------------------
-- UPDATE문장
SELECT * FROM EMPS WHERE EMPLOYEE_ID = 103;

-- EX1
UPDATE EMPS 
SET HIRE_DATE = SYSDATE, 
    LAST_NAME = 'HONG',
    SALARY = SALARY + 1000
WHERE EMPLOYEE_ID = 103;

-- EX2
UPDATE EMPS
SET COMMISSION_PCT = 0.1
WHERE JOB_ID IN('IT_PROG', 'SA_MAN');

-- EX3 : ID - 200의 급여를 103번과 동일하게 변경 (서브쿼리)
UPDATE EMPS
SET SALARY = (SELECT SALARY FROM EMPS WHERE EMPLOYEE_ID = 103)
WHERE EMPLOYEE_ID = 200;

-- EX4
UPDATE EMPS 
SET (JOB_ID, SALARY, COMMISSION_PCT) = (SELECT JOB_ID, SALARY, COMMISSION_PCT FROM EMPS WHERE EMPLOYEE_ID = 103)
WHERE EMPLOYEE_ID =200;

SELECT * FROM EMPS;

COMMIT;

------------------------------------------------------------------------
-- DELETE구문
CREATE TABLE DEPTS AS (SELECT * FROM DEPARTMENTS WHERE 1 = 1); -- 테이블 복사 + 데이터 복사
SELECT * FROM DEPTS;
SELECT * FROM EMPS;

-- EX1 : 삭제할 때는 꼭 PK를 이용합니다.
DELETE FROM EMPS WHERE EMPLOYEE_ID = 200;

-- EX2
DELETE FROM EMPS WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME = 'IT');

-- EMPLOYEE가 60번 부서를 사용하고 있기 때문에 삭제 불가
DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID = 60;

------------------------------------------------------------------------
-- MERGE구문
-- 두 테이블을 비교해서 데이터가 있으면 UPDATE, 없다면 INSERT
SELECT * FROM EMPS;

MERGE INTO EMPS E1
USING (SELECT * FROM EMPLOYEES WHERE JOB_ID IN ('IT_PROG', 'SA_MAN')) E2
ON (E1.EMPLOYEE_ID = E2.EMPLOYEE_ID)
WHEN MATCHED THEN
    UPDATE SET E1.HIRE_DATE = E2.HIRE_DATE,
               E1.SALARY = E2.SALARY,
               E1.COMMISSION_PCT = E2.COMMISSION_PCT
WHEN NOT MATCHED THEN
    INSERT VALUES (E2.EMPLOYEE_ID, 
                   E2.FIRST_NAME, 
                   E2.LAST_NAME,
                   E2.EMAIL,
                   E2.PHONE_NUMBER,
                   E2.HIRE_DATE,
                   E2.JOB_ID,
                   E2.SALARY,
                   E2.COMMISSION_PCT,
                   E2.MANAGER_ID,
                   E2.DEPARTMENT_ID);

-- EX2
SELECT * FROM EMPS;

MERGE INTO EMPS E
USING DUAL
ON (E.EMPLOYEE_ID = 103) -- PK 형태만 
WHEN MATCHED THEN
    UPDATE SET LAST_NAME = 'DEMO'
WHEN NOT MATCHED THEN
    INSERT(EMPLOYEE_ID, 
    LAST_NAME,
    EMAIL,
    HIRE_DATE,
    JOB_ID) 
    VALUES(1000, 'DEMO', 'DEMO', SYSDATE, 'DEMO');

DELETE FROM EMPS WHERE EMPLOYEE_ID = 103;

------------------------------------------------------------------------
-- 연습문제

SELECT * FROM DEPTS;

--문제 1.
INSERT INTO DEPTS VALUES (280, '개발', null, 1800);
INSERT INTO DEPTS VALUES (290, '회계부', null, 1800);
INSERT INTO DEPTS VALUES (300, '재정', 301, 1800);
INSERT INTO DEPTS VALUES (310, '인사', 302, 1800);
INSERT INTO DEPTS VALUES (320, '영업', 303, 1700);

--문제 2.
UPDATE DEPTS
SET DEPARTMENT_NAME = 'IT bank'
WHERE DEPARTMENT_NAME = 'IT Support';

UPDATE DEPTS
SET MANAGER_ID = 301
WHERE DEPARTMENT_ID = 290;

UPDATE DEPTS
SET DEPARTMENT_NAME = 'IT Help',
    MANAGER_ID = 303,
    LOCATION_ID = 1800
WHERE DEPARTMENT_NAME = 'IT Helpdesk';

UPDATE DEPTS
SET MANAGER_ID = 301
WHERE DEPARTMENT_NAME IN ('재정', '인사', '영업');

commit;
--문제 3.
DELETE FROM DEPTS WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPTS WHERE DEPARTMENT_NAME = '영업부');
DELETE FROM DEPTS WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPTS WHERE DEPARTMENT_NAME = 'NOC');

commit;
--문제4
DELETE FROM DEPTS WHERE DEPARTMENT_ID > 200;

UPDATE DEPTS
SET MANAGER_ID = 100
WHERE MANAGER_ID IS NOT NULL;

MERGE INTO DEPTS D1
 USING(SELECT * FROM DEPARTMENTS) D2
 ON (D1.DEPARTMENT_ID = D2.DEPARTMENT_ID)
 WHEN MATCHED THEN
    UPDATE SET D1.DEPARTMENT_NAME = D2.DEPARTMENT_NAME,
               D1.MANAGER_ID = D2.MANAGER_ID,
               D1.LOCATION_ID = D2.LOCATION_ID
 WHEN NOT MATCHED THEN
    INSERT VALUES (D2.DEPARTMENT_ID,
                   D2.DEPARTMENT_NAME,
                   D2.MANAGER_ID,
                   D2.LOCATION_ID);

--문제 5
CREATE TABLE JOBS_IT AS( SELECT * FROM JOBS WHERE MIN_SALARY > 6000) ;

INSERT INTO JOBS_IT
VALUES ('IT_DEV', '아이디개발팀', 6000, 20000);
INSERT INTO JOBS_IT
VALUES ('NET_DEV', '네트워크개발팀', 5000, 20000);
INSERT INTO JOBS_IT
VALUES ('SEC_DEV', '보안개발팀', 6000, 19000);

MERGE INTO JOBS_IT J1
USING (SELECT * FROM JOBS WHERE MIN_SALARY > 0) J2
ON (J1.JOB_ID = J2.JOB_ID)
WHEN MATCHED THEN 
    UPDATE SET J1.MIN_SALARY = J2.MIN_SALARY,
               J1.MAX_SALARY = J2.MAX_SALARY
WHEN NOT MATCHED THEN 
    INSERT VALUES (J2.JOB_ID,
                   J2.JOB_TITLE,
                   J2.MIN_SALARY,
                   J2.MAX_SALARY);


SELECT *
FROM JOBS_IT;

