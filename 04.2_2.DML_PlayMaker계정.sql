--==============================================================================
/*
    2. UPDATE
       테이블에 기록되어 있는 기존의 데이터를 수정하는 구문
       
       [표현식]
       UPDATE 테이블명
       SET 컬럼명 = 바꿀값,
           컬럼명 = 바꿀값,
           ...
       [WHERE 조건];   --> 주의 : 조건을 생략하면 전체 모든 행의 데이터가 변경됨.    
*/
-- DEPARTMENT테이블 복사본 만들기(데이터까지)
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

-- D9 부서의 부서명을 '전략기획팀'으로 변경
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀';
-- 전체 데이터가 모두 변경됨

ROLLBACK;

UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

-- EMPLOYEE테이블의 컬럼 EMP_ID, EMP_NAME, SALARY, BOUNS으로 복사본 만들기
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
     FROM EMPLOYEE;

-- 정진영 사원의 급여를 4백만원으로 변경
UPDATE EMP_SALARY
SET SALARY = 4000000
WHERE EMP_NAME = '정진영';

-- 김무옥 사원의 급여를 7백만원으로, 보너스를 0.2로 변경
UPDATE EMP_SALARY
SET SALARY = 7000000,
    BONUS = 0.2
WHERE EMP_NAME = '김무옥';    

-- 전체 사원의 급여를 기존급여에 10%인상한 금액으로 변경
UPDATE EMP_SALARY
SET SALARY = SALARY * 1.1;

------------------------------------------------------------------------
/*
    * UPDATE시 서브쿼리 사용 가능
      UPDATE 테이블명
      SET 컬럼명 = (서브쿼리)
      WHERE 조건;
*/
-- 휘발유 사원의 급여와 보너스를 김영태 사원의 급여와 보너스값으로 변경
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY
                FROM EMP_SALARY
               WHERE EMP_NAME = '김영태'  
              ),
    BONUS = (SELECT BONUS
                FROM EMP_SALARY
               WHERE EMP_NAME = '김영태'  
             )
WHERE EMP_NAME = '휘발유';

-- 다중열 서브쿼리로도 가능
UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                         FROM EMP_SALARY
                        WHERE EMP_NAME = '김영태'  
                       )
WHERE EMP_NAME = '휘발유';

-- 홍만길, 한채린, 김관철, 심아구, 황번개 사원의 급여와 보너스를 신영균의 급여와 보너스가 같도록 변경
UPDATE EMP_SALARY
SET(SALARY, BONUS) = (SELECT SALARY, BONUS
                        FROM EMP_SALARY
                       WHERE EMP_NAME = '신영균')
WHERE EMP_NAME IN ('홍만길', '한채린', '김관철', '심아구', '황번개');

-- ASIA 지역에서 근무하는 사원들의 보너스를 0.3으로 변경하기
SELECT EMP_ID
  FROM EMP_SALARY
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
 WHERE LOCAL_NAME LIKE 'ASIA%'; 
 
UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID
                  FROM EMP_SALARY
                  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                 WHERE LOCAL_NAME LIKE 'ASIA%');

-------------------------------------------------------------------------
-- UPDATE시에도 제약조건에 위배되면 안됨
-- 사번이 200번인 사원의 이름을 NULL
UPDATE EMPLOYEE
SET EMP_NAME = NULL
WHERE EMP_ID = 200;     --> NOT NULL 위배

-- DEPARTMENT테이블의 DEPT_ID가 D9인 부서의 LOCAITON_ID를 L7 변경
UPDATE DEPARTMENT
SET LOCATION_ID = 'L7'
WHERE DEPT_ID = 'D9';      --> FOREIGN KEY 위배

COMMIT;
--==============================================================================
/*
    3. DELETE
       테이블에 기록된 데이터를 삭제하는 구문 (행단위로 삭제됨)
       
       [표현식]
       DELETE FROM 테이블
       [WHERE 조건];      --> WHERE절이 없으면 전체 행 삭제
       
       ** 특히 삭제시에은 조건절을 반드시 넣어줘야됨
*/
-- 김성훈 사원의 데이터를 삭제하기
DELETE FROM EMPLOYEE;

ROLLBACK;

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '김성훈';

ROLLBACK;

-- 선관일 삭제
DELETE FROM EMPLOYEE
WHERE EMP_NAME = '선관일';

-- DEPARTMENT테이블에서 DEPT_ID가 D1인 부서 삭제
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';       --> FOREIGN KEY 제약조건 위반


DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D3';

ROLLBACK;

-----------------------------------------------------------------------
/*
    * TRUNCATE : 테이블의 전체 행을 삭제할 때 사용되는 구문
        - DELETE보다 수행속도가 빠름
        - 별도의 조건 제시 불가, ROLLBACK도 불가
        
      TRUNCATE TABEL 테이블명;  
*/
TRUNCATE TABLE EMP_SALARY;

ROLLBACK;