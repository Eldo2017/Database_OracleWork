--------------------------------------------------------------------------------

/*
    서브쿼리(subquery)
    - 한 sql문 내에 포함된 또다른 select문이다
    - 메인 sql문을 보조하기 위한 쿼리문이라고 보면 된다
*/

-- 간단한 서브쿼리 
-- 예제1) 문영철 사원과 같은 부서에 속한 사람들을 조회하라
-- 1) 문영철 사원이 속한 부서코드를 찾아라
-- 2) 부서코드가 ??인 사원을 찾아라

-- 1) 문영철 사원이 속한 부서코드
select dept_code from employee where emp_name = '문영철';

-- 2) 부서코드가 D9인 사원들의 이름
select emp_name from employee where dept_code = 'D9';

-- 3) 위의 단계의 코드를 하나의 쿼리 코드로 통합하면?
select emp_name, dept_code from employee where dept_code = (select dept_code from employee where emp_name = '문영철');

-- 예제2) 모든 직원의 평균급여보다 더 많이 급여를 받는 사원의 사번, 사원명, 급여를 찾아라

-- 1) 전 직원의 평균 급여
select round(avg(salary)) 평균급여 from employee;

-- 2) 급여가 3047663 이상인 사원들의 사번, 사원명, 급여를 찾아라
select emp_id, emp_name, salary from employee where salary >= 3047663;

-- 3) 위 코드를 하나로 합치면?
select emp_id, emp_name, salary from employee where salary >= (select round(avg(salary)) from employee);

--------------------------------------------------------------------------------

/*
    서브쿼리의 구분
     - 서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라 구분한다
     
      >> 단일행 서브쿼리 : 서브쿼리를 수행한 결과값이 오로지 하나일 때(1행 1열)
      >> 다중행 서브쿼리 : 서브쿼리를 수행한 결과값이 여러 행일 때(여러 행 1열)
      >> 다중열 서브쿼리 : 서브쿼리를 수행한 결과값이 여러 열일 때(1행 여러 열)
      >> 다중행 다중열 서브쿼리 : 서브쿼리를 수행한 결과값이 여러 행 여러 열일 때(여러 행 여러 열)
      
      --> 서브쿼리 종류가 뭐냐에 따라 서브쿼리 앞에 붙는 연산자가 달라진다
*/

/*
    1. 단일행 서브쿼리(single row subquery)
    - 서브쿼리를 수행한 결과값이 오로지 하나일 때(1행 1열)
    - 일반 비교연산자 사용 가능
      ( =, !=, >, >=, <, <= )
    - 조인 또한 가능
    - group by도 가능
*/

-- 1) 전 직원의 평균 급여보다 급여를 더 적게 받는 사원들의 사원명, 직급코드, 급여 조회
select emp_name, job_code, salary from employee
where salary < (select avg(salary) from employee);

-- 2) 최저급여를 받는 사원의 사번, 사원명, 급여를 조회
select emp_id, emp_name, salary from employee where salary = (select min(salary) from employee);

-- 3) 신영균의 급여보다 더 많이 받는 사원들의 사번, 사원명, 부서코드, 급여 조회
select emp_id, emp_name, dept_code, salary from employee where salary > (select salary from employee where emp_name = '신영균');

-- 4) 김관철의 급여보다 더 많이 받는 사원들의 사번, 사원명, 부서명, 급여 조회
-- 1. 오라클 전용 구문
select emp_id, emp_name, dept_title, salary from employee, department
where salary > (select salary from employee where emp_name = '김관철')
and dept_code = dept_id;
-- 2. ansi 구문
select emp_id, emp_name, dept_title, salary from employee
join department on (dept_code = dept_id)
where salary > (select salary from employee where emp_name = '김관철');

-- 5) 김삼수 사원과 같은 부서원들의 사번, 사원명, 전화번호, 입사일, 부서명 조회 (하지만 김삼수 본인 제외)
-- 1. 오라클 전용 구문
select emp_id, emp_name, phone, hire_date, dept_title from employee, department
where dept_code = (select dept_code from employee where emp_name = '김삼수')
and dept_code = dept_id and emp_name <> '김삼수';
-- 2. ansi 구문
select emp_id, emp_name, phone, hire_date, dept_title from employee
join department on (dept_code = dept_id)
where dept_code = (select dept_code from employee where emp_name = '김삼수')
and emp_name <> '김삼수';

-- 6) 부서별 급여합이 가장 큰 부서의 부서코드, 급여의 합 조회
select dept_code, sum(salary) from employee
group by dept_code having sum(salary) = (select max(sum(salary))
from employee group by dept_code);

--------------------------------------------------------------------------------
/*
    2. 다중행 서브쿼리(multi row subquery)
    - 서브쿼리를 수행한 결과값이 여러 행일 때(여러 행 1열)
    - in 서브쿼리 : 여러개의 결과값 중 한개라도 일치하는 값이 있다면 가져와라
    - > any 서브쿼리 : 여러개의 결과값 중 한개라도 큰 값이 있을 경우 가져와라
                     (여러개의 결과값 중에서 가장 작은값보다 클 경우)
    - < any 서브쿼리 : 여러개의 결과값 중 한개라도 작은 값이 있을 경우 가져와라
                     (여러개의 결과값 중에서 가장 큰값보다 작을 경우)
    - all : 서브쿼리 값들 중 가장 큰값보다 더 큰 값을 얻어올 때 사용한다
                     
    - 비교대상 > ANY (값1, 값2, 값3)
      (= 비교대상 > 값1 or 비교대상 > 값2 or 비교대상 > 값3)
*/

-- 1. 김영태 또는 한채린 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여 조회
------- 1) 김영태 또는 한채린이 어느 직급인가
select job_code from employee where emp_name in ('김영태','한채린');

------- 2) 두 사람과 같은 직급(J5, J7)인 사원들은 누구인가
select emp_id, emp_name, job_code, salary from employee where job_code in ('J5','J7');

------- 3) 위의 두 코드를 하나로 합치면?
select emp_id, emp_name, job_code, salary from employee where job_code in (select job_code from employee where emp_name in ('김영태','한채린'));

-- 2. 대리 직급임에도 과장 직급의 급여들 중, 최소 급여보다 많이 받는 사원의 사번, 사원명, 직급, 급여 조회
------- 1) 과장 직급의 급여
select salary from employee join job using(job_code) where job_name = '과장';  -- 결과값 : 3760000, 2200000, 2500000

------- 2) 직급이 대리이며 위 급여의 목록값들 중 하나라도 큰 사원의 사번, 사원명, 직급, 급여
select emp_id, emp_name, job_name, salary from employee
join job using(job_code) where job_name = '대리' and 
salary > any(3760000, 2200000, 2500000);

------- 3) 위 쿼리문을 하나로 표현!
select emp_id, emp_name, job_name, salary from employee
join job using(job_code) where job_name = '대리' and 
salary > any(select salary from employee join job using(job_code) where job_name = '과장');

------- 4) 단일행 쿼리로도 된다
select emp_id, emp_name, job_name, salary from employee
join job using(job_code) where job_name = '대리' and 
salary > (select min(salary) from employee join job using(job_code) where job_name = '과장');

-- 3. 차장 직급임에도 과장 직급의 급여보다 적게 받는 사원의 사번, 사원명, 직급, 급여 조회
------- 1) 과장 직급의 급여
select salary from employee
join job using(job_code) where job_name = '과장';

------- 2) 직급이 차장이며 위 급여의 목록값들 중 하나라도 적은 사원의 사번, 사원명, 직급, 급여
select emp_id, emp_name, job_name, salary from employee
join job using(job_code) where job_name = '차장' and 
salary < any(3760000, 2200000, 2500000);

------- 3) 위 쿼리문을 하나로 표현!
select emp_id, emp_name, job_name, salary from employee
join job using(job_code) where job_name = '차장' and 
salary < any(select salary from employee join job using(job_code) where job_name = '과장');

------- 4) 단일행 쿼리로도 된다
select emp_id, emp_name, job_name, salary from employee
join job using(job_code) where job_name = '차장' and 
salary < (select max(salary) from employee join job using(job_code) where job_name = '과장');

-- 4. 과장 직급임에도 차장 직급의 사원들의 모든 급여보다 많이 받는 사원의 사번, 사원명, 직급, 급여 조회
------- 1) 차장 직급의 급여
select salary from employee
join job using(job_code) where job_name = '차장';

------- 2) 직급이 과장이며 위 급여의 목록값들 중 하나라도 큰 사원의 사번, 사원명, 직급, 급여
select emp_id, emp_name, job_name, salary from employee
join job using(job_code) where job_name = '과장' and 
salary > all(2800000, 2480000, 2490000, 1550000);

------- 3) 위 쿼리문을 하나로 표현!
select emp_id, emp_name, job_name, salary from employee
join job using(job_code) where job_name = '과장' and 
salary > all(select salary from employee
join job using(job_code) where job_name = '차장');

--------------------------------------------------------------------------------
/*
    3. 다중열 서브쿼리(multi column subquery)
    - 서브쿼리를 수행한 결과값이 여러 열일 때(1행 여러열)
*/
-- 1. 홍만길 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사원명, 부서코드, 직급코드, 입사일자를 구하라
select emp_name, dept_code, job_code, hire_date from employee
where dept_code = (select dept_code from employee where emp_name = '홍만길')
and job_code = (select job_code from employee where emp_name = '홍만길');

-- >> 이를 다중열 서브쿼리로!
select emp_name, dept_code, job_code, hire_date from employee
where (dept_code, job_code) = (select dept_code, job_code from employee where emp_name = '홍만길');

-- 2. 김관철 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 사번, 사원명, 직급코드, 사수사번 조회
select emp_id, emp_name, job_code, manager_id from employee
where (job_code, manager_id) = (select job_code, manager_id from employee where emp_name = '김관철');

--------------------------------------------------------------------------------
/*
    4. 다중행 다중열 서브쿼리
    - 서브쿼리를 수행한 결과값이 여러행 여러열일때(여러행 여러열)
*/

-- 1. 각 직급별 최소급여 금액을 받는 사원의 사번, 사원명, 직급코드, 급여 조회
------- 1) 각 직급별 최소급여 금액, 직급코드 조회
select job_code, min(salary) from employee group by job_code;
------- 2) 위 조건에 해당하는 사원의 사번, 사원명, 직급코드, 급여 조회
select emp_id, emp_name, job_code, salary from employee group by job_code = 'J1' and salary = 8000000
                                                              or job_code = 'J2' and salary = 3700000
                                                              ... ;
select emp_id, emp_name, job_code, salary from employee
where (job_code, salary) = ('J1',8000000)
or (job_code, salary) = ('J2',3700000)
...;

------- 3) 서브쿼리로!
select emp_id, emp_name, job_code, salary from employee
where (job_code, salary) in (select job_code, min(salary) from employee group by job_code);

-- 2. 각 부서별 최고급여를 받는 사원들의 사번, 사원명, 부서코드, 급여 조회
------- 1) 각 부서별 최고급여 (부서코드, 급여 이용)
select dept_code, max(salary) from employee group by dept_code;

------- 2) 위 부서들에 속한 사원들의 사번, 사원명, 부서코드, 급여 조회
select emp_id, emp_name, dept_code, salary from employee
where (dept_code, salary) in (select dept_code, max(salary) from employee group by dept_code);