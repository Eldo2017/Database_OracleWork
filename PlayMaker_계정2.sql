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