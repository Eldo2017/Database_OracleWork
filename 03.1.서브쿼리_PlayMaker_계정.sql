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

