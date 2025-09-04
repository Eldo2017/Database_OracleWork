-- SUBQUERY_연습문제
-- 1. 70년대 생(1970~1979) 중 여자이면서 한씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회
select emp_name, emp_no, dept_title, job_name from employee
join department on dept_code = dept_id
join job using(job_code)
where emp_no in(
select emp_no from employee
where substr(emp_no,1,2) between '70' and '79'
and substr(emp_no,8,1)='2')
and emp_name like '한%';
-- 2. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회
select emp_id, emp_name, extract(year from sysdate) - (1900 + to_number(substr(emp_no,1,2))) as 나이, 
dept_title, job_name from employee
join department on dept_code = dept_id
join job using(job_code)
where extract(year from sysdate) - (1900 + to_number(substr(emp_no,1,2))) 
= (select min(extract(year from sysdate) - (1900 + to_number(substr(emp_no,1,2)))) from employee);
-- 3. 이름에 '철'이 들어가는 사원의 사번, 사원명, 직급명 조회
select emp_id, emp_name, job_name from employee
join job using(job_code)
where emp_name like '%철%';
-- 4. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
select emp_name, job_name, dept_code, dept_title from employee
join department on (dept_code = dept_id)
join job using (job_code)
where dept_code in ('D5','D6');
-- 5. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
select emp_name, bonus, dept_title, local_name from employee
join department on (dept_code = dept_id)
join location on (location_id = local_code)
where bonus is not null;
-- 6. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회
select emp_name, job_name, dept_title, local_name from employee
join department on (dept_code = dept_id)
join job using(job_code)
join location on (location_id = local_code);
-- 7. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회
select emp_name, dept_title, local_name, national_name from employee
join department on (dept_code = dept_id)
join location on (location_id = local_code)
join national using (national_code)
where national_name in ('한국', '일본');
-- 8. 김무옥 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회
select emp_name, dept_code from employee
where dept_code = (select dept_code from employee where emp_name = '김무옥');
-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회 (NVL 이용)
select emp_name, job_name, salary from employee
join job using(job_code)
where nvl(bonus, 0) = 0
and job_code in ('J4','J7');
-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
select count(case when end_date is null then 1 end) as "퇴사를 안 한 사람",
count(case when end_date is not null then 1 end) as "퇴사를 한 사람"
from employee;
-- 안함 11. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회
-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--	12-1. JOIN과 HAVING 사용
select dept_title, sum(salary) as "부서별 급여합"
from employee 
join department on dept_code = dept_id 
group by dept_title
having sum(salary) > (select sum(salary)*0.2 from employee);
--	12-2. 인라인 뷰 사용
select * from (select dept_title, sum(salary) "부서별 급여합" from employee
join department on dept_code = dept_id
group by dept_title
having sum(salary) > (select sum(salary)*0.2 from employee));

--	12-3. WITH 사용
with result_of_salary_sum as (select dept_title, sum(salary) "부서별 급여합" from employee
join department on dept_code = dept_id
group by dept_title
having sum(salary) > (select sum(salary)*0.2 from employee))
select * from result_of_salary_sum;
-- 13. 부서명별 급여 합계 조회(NULL도 조회되도록)
select nvl(dept_title,'부서없음') as 부서명, sum(salary) as 급여합 from employee
left join department on dept_code = dept_id
group by dept_title;
-- 14. WITH를 이용하여 급여합과 급여평균 조회
with sum_and_avg as (select dept_code, sum(salary), round(avg(salary)) from employee group by dept_code)
select * from sum_and_avg;