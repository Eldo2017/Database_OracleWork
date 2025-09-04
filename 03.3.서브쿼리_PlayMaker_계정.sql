--------------------------------------------------------------------------------
/*
   1. Inline View (인라인 뷰)
   - From 절에 서브쿼리를 작성한다
   
   - 서브쿼리를 수행할 결과를 마치 테이블처럼 사용한다
*/

-- 1. 사원들의 사번, 사원명, 보너스포함연봉(별칭 부여), 부서코드 조회
------- 조건1) 연봉에 null없어야 함
------- 조건2) 보너스포함연봉이 4000만원 이상인 사람들만 조회
select emp_id, emp_name, (salary + salary*nvl(bonus,0))*12 as 보너스포함연봉, dept_code
from employee
where (salary + salary*nvl(bonus,0))*12 >= 40000000;

-- where 절에 별칭으로 사용하려면 inline view를 사용하라
select * from (select emp_id, emp_name, (salary + salary*nvl(bonus,0))*12 as 보너스포함연봉, dept_code
from employee) where 보너스포함연봉 >= 40000000; -- 테이블처럼 사용 가능하다

select emp_name, 보너스포함연봉, dept_code, phone from (select emp_id, emp_name, (salary + salary*nvl(bonus,0))*12 as 보너스포함연봉, dept_code
from employee) where 보너스포함연봉 >= 40000000; -- 오류 : from 뒤 테이블에는 phone이란 컬럼 없다

-- 인라인 뷰는 주로 TOP-N(상위 몇번째만 가져온다) 분석에 이용된다
-- 2. 모든 직원 중 가장 높은 상위 5명만 조회
------ rownum : 오라클에서 제공하는 컬럼, 조회된 순서대로 1부터 순번 부여함
select rownum, emp_name, salary from employee;

-- 급여의 내림차순 정렬로 조회
select rownum, emp_name, salary from employee order by salary desc;
-- 수행순서 : from -> select -> order

-- 수행순서 : from -> select -> order -> rownum

select rownum, * from (select emp_name, salary from employee order by salary desc); -- 오류

-- 테이블에 별칭을 부여해라
select rownum, e.* from (select emp_name, salary from employee order by salary desc) e
where rownum <= 5;

-- 3. 제일 최근에 입사한 사원 5명의 이름하고 급여, 입사일을 조회하라
select a.* from (select emp_name, salary, hire_date from employee order by hire_date desc) a
where rownum <= 5;
-- 4. 각 부서별 평균급여가 높은 3개의 부서코드와 평균급여를 조회하라
select b.* from (select dept_code, round(avg(salary)) from employee group by dept_code order by avg(salary) desc) b
where rownum <= 3;

--------------------------------------------------------------------------------
/*
   2. With
   - 서브쿼리에 이름을 붙여주고 인라인 뷰로 사용 시 서브쿼리 이름으로 from절에 기술한다
   - 한번의 sql문장에서만 유효하다
   
   - 장점
   1) 같은 서브쿼리가 여러번 사용될 경우 중복 작성을 피할 수 있다
   2) 실행속도가 빨라진다
   3) 가독성이 좋아진다
*/

with TOP_N_SAL as (select dept_code, round(avg(salary)) 평균급여 from employee group by dept_code order by avg(salary) desc)
select * from TOP_N_SAL where rownum <= 3;

/*
select dept_code, 평균급여 from TOP_N_SAL where rownum <= 3; >> 이렇게도 가능하지만 세미콜론이 된 후에는 실행이 불가한 점 유의바란다
*/

--------------------------------------------------------------------------------
/*
   3. 순위 함수
   - rank() over(정렬기준), dense_rank() over(정렬기준)
   - 1) rank() over(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원수만큼 건너뛴 다음에 순위를 계산한다
                                Ex) 공동 1위가 2명이라면 그 다음 순위는 3위다.
   - 2) dense_rank() over(정렬기준) : 동일한 순위 이후의 등수는 무조건 1씩 증가한다.
                                    Ex) 공동 1위가 2명이라면 그 다음 순위는 2위다.
*/

-- 1. 급여가 높은 순서대로 순위를 매겨 사원명, 급여, 순위를 조회하라
select emp_name, salary, rank() over(order by salary desc) 순위 from employee;

-- 2. 급여가 상위 5위인 사원명, 급여, 순위 조회
select emp_name, salary, rank() over(order by salary desc) 순위 from employee
where rank() over(order by salary desc) <= 5; -- where 절에만 사용 가능

select * from (select emp_name, salary, rank() over(order by salary desc) 순위 from employee)
where 순위 <= 5;

-- with도 사용할 수 있다
with top_n_salary as (select emp_name, salary, rank() over(order by salary desc) 순위 from employee)
select * from top_n_salary where 순위 <= 5;