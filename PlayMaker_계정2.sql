--------------------------------------------------------------------------------
--                          <Group By>
--------------------------------------------------------------------------------

select sum(salary)
from employee;

-- 각 부서별 총 급여
select dept_code, sum(salary) 총급여
from employee
group by dept_code order by dept_code asc;

-- 각 부서별 사원수
select dept_code, count(*) 인원수
from employee
group by dept_code order by dept_code asc;

-- 위의 2개 한번에 조회하기
select dept_code, count(*) 인원수, sum(salary) 총급여
from employee
group by dept_code order by dept_code asc;

-- 직급별 사원수 및 총 급여
select job_code, count(*), sum(salary)
from employee
group by job_code order by job_code asc;

-- 직급별 사원수 및 보너스를 받는 사원수, 총 급여와 평균급여, 최저급여, 최고급여를 조회하라
select job_code, count(*) 총사원, count(bonus) "사원(보너스지급)", sum(salary) 총급여, round(avg(salary)) 평균급여, min(salary) 최저급여, max(salary) 최고급여
from employee 
group by job_code
order by job_code;

-- 남녀별 사원 수
-- decode() 함수는 오라클에서만 사용할 수 있다. 
select decode(substr(emp_no,8,1),'1','남','2','여','3','남','4','여') 성별, count(*) 인원수
from employee
group by substr(emp_no,8,1);

-- 모든 DB 다 사용하기
select case 
when substr(emp_no,8,1) = '1' then '남'
when substr(emp_no,8,1) = '2' then '여'
when substr(emp_no,8,1) = '3' then '남'
when substr(emp_no,8,1) = '4' then '여'
end 성별,
count(*) 인원수
from employee
group by case 
when substr(emp_no,8,1) = '1' then '남'
when substr(emp_no,8,1) = '2' then '여'
when substr(emp_no,8,1) = '3' then '남'
when substr(emp_no,8,1) = '4' then '여'
end;

--------------------------------------------------------------------------------
/*
    Having절
    - 그룹에 대한 조건을 제시할 때, 사용된다.
    - 주로 그룹함수식을 가지고 조건을 제시한다.
*/

-- 각 부서별 급여를 조회하라(부서코드와 평균급여)
select dept_code, round(avg(salary)) from employee group by dept_code;

-- 각 부서별 평균급여가 300만원 이상인 부서만 찾아라
select dept_code, round(avg(salary)) 
from employee
group by dept_code
having round(avg(salary)) >= 3000000;

/*
    <select문 실행 순서>
    1) from
    2) where
    3) group by
    4) having
    5) select
    6) distinct
    7) order by
    
    1) from
    2) on : 조인 조건을 확인한다
    3) join
    4) where
    5) group by
    6) having
    7) select
    8) distinct
    9) order by
*/

-- 1. 직급별 총 급여합(단, 직급별 급여합이 1000만원 이상인 직급만 조회) 직급코드, 급여합 조회
select job_code, sum(salary) from employee group by job_code having sum(salary) >= 10000000;

-- 2. 부서별 보너스를 받는 사원 없는 부서의 부서코드를 조회
select dept_code, count(bonus) from employee group by dept_code having count(bonus) = 0;

--------------------------------------------------------------------------------
/*
    집계함수
    - 그룹별 산출된 결과값의 중간집계를 계산
    
    rollup, cube
    => group by 절에 기술하는 함수
    
    - rollup(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간집계를 내는 함수
    - cube(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간집계를 내고, 컬럼2를 가지고도 중간집계를 내는 함수
*/

-- 각 직급별 급여의 합

-- 1) 마지막 행에 전체 총 급여합까지 조회
select job_code, sum(salary) from employee
group by rollup(job_code)order by job_code;

-- 2) 그룹 기준의 컬럼이 하나일 때, cube, rollup의 차이는 존재하지 않는다.
select job_code, sum(salary)from employee 
group by cube(job_code) order by job_code;

-- 3) cube 및 rollup의 차이점을 보기 위해, 그룹 기준의 컬럼이 2개가 있어야 한다.
-- 4) rollup(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간집계를 내는 함수
select dept_code, job_code, sum(salary) from employee
group by rollup(dept_code, job_code) order by dept_code;

-- 5) cube(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간집계를 내고, 컬럼2를 가지고도 중간집계를 내는 함수
select dept_code, job_code, sum(salary) from employee 
group by cube(dept_code, job_code) order by dept_code;

--------------------------------------------------------------------------------
/*
    집합연산자
    - 여러 개의 쿼리문을 가지고 하나의 쿼리문을 만드는 연산자
    
    - union : or | 합집합(두 쿼리문을 수행한 결과값을 더한 후 중복되는 값은 한번만 더해지게 한다)
    - intersect : and | 교집합(두 쿼리문을 수행한 결과값 중 중복된 값만 보여준다)
    - union all : 합집합 + 교집합(중복되는 값은 두 번 보여진다)
    - minus : 차집합(선행결과값에서 후행결과값을 뺀 나머지값)
*/

-- 부서코드가 D5인 사원이나 급여가 300만원을 넘는 사원들을 찾아라

-- 1) 부서코드가 D5인 사원
select emp_name, dept_code, salary from employee where dept_code = 'D5'; -- 6명
-- 2) 급여가 300만원을 넘는 사원
select emp_name, dept_code, salary from employee where salary >= 3000000; -- 8명
-- 3) union 사용
select emp_name, dept_code, salary from employee where dept_code = 'D5' union
select emp_name, dept_code, salary from employee where salary >= 3000000 order by salary asc;
-- 4) or 사용
select emp_name, dept_code, salary from employee where dept_code = 'D5' or salary >= 3000000;