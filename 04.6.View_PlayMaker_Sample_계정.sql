/*
    - view
      select문을 저장해둘 수 있는 객체
      (자주 쓰는 긴 select문을 저장해두면 매번 긴 select문을 할 필요가 없다)
      임시테이블이라 보면 된다(그렇다고 실제 데이터가 있는 건 아니다 -> 논리적 테이블)
*/

-- '한국'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가를 조회하라
select emp_id, emp_name, dept_title, salary, national_name
from employee
join department on (dept_code = dept_id)
join location on (location_id = local_code)
join national using (national_code)
where national_code = 'KO';

-- '일본'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가를 조회하라
select emp_id, emp_name, dept_title, salary, national_name
from employee
join department on (dept_code = dept_id)
join location on (location_id = local_code)
join national using (national_code)
where national_code = 'JP';

--------------------------------------------------------------------------------
/*
    1. view 생성 방법
    
    [표현법]
    create view 뷰명
    as 서브쿼리;
*/
create view v_employee
as select emp_id, emp_name, dept_title, salary, national_name
from employee
join department on (dept_code = dept_id)
join location on (location_id = local_code)
join national using (national_code);

-- 아래와 같은 맥락
select * from (select emp_id, emp_name, dept_title, salary, national_name
from employee
join department on (dept_code = dept_id)
join location on (location_id = local_code)
join national using (national_code));

-- 한국, 러시아, 일본에서 근무하는 사원
select * from v_employee where national_name in ('한국','일본','러시아');
select * from v_employee where national_name = '한국';
select * from v_employee where national_name = '일본';
select * from v_employee where national_name = '러시아';

--------------------------------------------------------------------------------
/*
    - view도 컬럼에 별칭을 부여할 수 있다
      서브쿼리의 select절에 함수식 또는 산술연산식이 기술되어 있는 경우는 반드시 별칭을 부여하라
*/
-- 모든 사원의 사번, 사원명, 직급명, 성별(남/여), 근무년수를 select문을 뷰(vw_emp_job)를 정의하라
-- create or replace view 뷰명 -> 같은 이름 뷰가 있다면 뷰를 갱신(덮어쓰기), 없다면 생성
create view vw_emp_job
as select emp_id, emp_name, job_name, 
decode(substr(emp_no,8,1),'1','남','2','여','3','남','여') 성별, 
extract(year from sysdate) - extract(year from hire_date) 근무년수
from employee
join job using(job_code);

-- 아래와 같은 방식으로도 별칭 부여 가능
create or replace view vw_emp_job(사번, 사원명, 직급명, 성별, 근무년수)
as select emp_id, emp_name, job_name, 
decode(substr(emp_no,8,1),'1','남','2','여','3','남','여') 성별, 
extract(year from sysdate) - extract(year from hire_date) 근무년수
from employee
join job using(job_code);

-- 여성 사원의 사원명, 직급명 조회
select 사원명, 직급명
from vw_emp_job
where 성별 = '여';

-- 근무년수가 20년 이상인 사원의 모든 컬럼 조회
select * from vw_emp_job
where 근무년수 >= 20;

--------------------------------------------------------------------------------
/*
    - 뷰 삭제하기
      drop view 뷰 이름;
*/

drop view vw_emp_job;

--------------------------------------------------------------------------------
/*
    - view에서 dml도 사용할 수 있다
      생성된 뷰를 이용해 dml(insert, update, delete)을 사용할 수 잇다.
      뷰를 통해 조작하게 되면 실제 데이터가 담겨있는 테이블에 반영된다
*/

create or replace view vw_job
as select job_code, job_name
from job;

-- 뷰를 통하여 insert하기
insert into vw_job values ('J8','인턴');
commit;

-- 뷰를 통하여 update하기
update vw_job
set job_name = '신입'
where job_code = 'J8';

-- 뷰를 통하여 delete하기
delete from vw_job where job_code = 'J8';

--------------------------------------------------------------------------------
/*
    - dml 명령 조작이 불가능한 경우가 더 많다
    1) 뷰에 정의되지 않은 컬럼을 조작하려 할 경우
    2) 뷰에 정의되지 않은 컬럼 주 중심 테이블 상에 not null 제약조건이 지정된 경우
    3) 산술 연산식이나 함수식이 정의되어 있는 경우
    4) 그룹 함수나 group by절이 포함된 경우
    5) distinct 구문이 포함된 경우
    6) join을 이용해 여러 테이블을 연결시킨 경우
*/

-- 1) 뷰에 정의되지 않은 컬럼을 조작하려 할 경우
create or replace view vw_job
as select job_code
from job;

-- insert하기 -> 오류
insert into vw_job(job_code, job_name) values ('J8','신입');

-- update하기 -> 오류
update vw_job set job_name='인턴' where job_code = 'D7';

-- delete하기 -> 오류
delete from vw_job where job_name = '부장';

-- 2) 뷰에 정의되지 않은 컬럼 중 중심 테이블 상에 not null 제약조건
create or replace view vw_job
as select job_name
from job;

-- insert하기 -> 오류(중심 테이블에 job_code가 기본키 -> null값이 있으면 안된다)
insert into vw_job values ('인턴');

-- update하기 -> 성공
update vw_job
set job_name = '인턴'
where job_name = '사원';

rollback;

-- delete하기 -> 오류(외래키가 걸려있다. 자식 테이블에서 값을 사용하면 삭제가 불가능하다)
delete from vw_job where job_name = '사원';

-- 3) 산술 연산식이나 함수식이 정의되어 있는 경우
create view vw_emp_sal
as select emp_id, emp_name, salary, salary*12 연봉
from employee;

-- insert하기 -> 오류(연봉은 데이터베이스 상에 없다)
insert into vw_emp_sal values(226,'한병수',3000000,36000000);

-- update하기
update vw_emp_sal
set 연봉 = 45000000
where emp_id = 226;

-- 206번 유보미 사원의 급여를 3000000만원으로 변경
update vw_emp_sal
set salary = 3000000
where emp_id = '206';

-- delete하기
delete from vw_emp_sal where 연봉 = 36000000;

rollback;

-- 4) 그룹함수나 group by 절 포함
create view vw_group_dept
as select dept_code, sum(salary) 합계, ceil(avg(salary)) 평균
from employee group by dept_code;

-- insert하기(오류)
insert into vw_group_dept values ('D3',8000000,4000000);

-- update하기 -> 오류(D1인 사원이 3명인데 그 중 누구의 급여를 수정할지 애매하다)
update vw_group_dept
set 합계 = 8000000
where dept_code = 'D1';

select emp_id, dept_code, salary
from employee
where dept_code = 'D1';

-- delete하기
delete from vw_group_dept where dept_code is null;

-- 5) distinct 구문이 포함된 경우
create view vw_di_job
as select distinct job_code
from employee;

-- insert하기 -> 오류
insert into vw_di_job values('J8');

-- update하기 -> 오류
update vw_di_job 
set job_code = 'J8' where job_code = 'J7';

-- delete하기
delete from vw_di_job where job_code = 'J4';

-- 6) join을 이용해 여러 테이블을 연결시킨 경우
create view vw_join
as select emp_id, emp_name, dept_title
from employee
join department on (dept_code = dept_id);

-- insert하기 -> 오류
insert into vw_join values(224,'조수연','인사관리부');

-- update하기 -> 둘 다 성공(하지만, 조인으로 부서를 가져왔으므로 employee 테이블의 dept_code는 수정 불가)
update vw_join set emp_name = '임성호' where emp_id = '223';

update vw_join set dept_title = '해외영업1부' where emp_id = '223';

rollback;

-- delete하기 -> 성공
delete from vw_join
where emp_id = 223;

rollback;
--------------------------------------------------------------------------------
/*
    - view 옵션
      [상세 표현식] create [or replace] [force | noforce] view 뷰 이름
      as 서브쿼리
      [with check option]
      [with read only];
      
      1) or replace : 기존에 동일한 뷰가 있다면 갱신, 없다면 생성하라
      2) force | noforce
      >> force : 서브쿼리에 기술된 테이블이 없어도 뷰를 생성한다
      >> noforce : 서브쿼리에 기술된 테이블이 있어야만 뷰가 생성이 된다(생략시 기본값)
      3) with check option : dml시 서브쿼리에 기술된 조건에 부합한 값으로만 dml 가능하게 한다
      4) with read only : 뷰에 대해 조회만 가능(dml은 수행불가)하게 한다
*/

-- 1) force | noforce
--    noforce : 서브쿼리에 기술된 테이블이 있어야만 뷰가 생성이 된다(생략시 기본값)
create /* noforce */ view vw_emp
as select tcode, tname, tcontent
from tt; -- tt 테이블이 없어서 오류

create force view vw_emp
as select tcode, tname, tcontent
from tt; -- view 생성은 가능

select * from vw_emp; --> 오류 : 중심 테이블이 없어 select 못한다

-- vw_emp를 사용하기 위해서는 tt테이블을 생성해야만 사용이 가능하다
create table tt(
    tcode number,
    tname varchar2(20),
    tcontent varchar2(100)
);

select * from vw_emp;

insert into vw_emp values(1,'김두한','나 김두한이다');

rollback;

-- 2) with check option
-- with check option 없이 해보기
create or replace view vw_emp
as select * from employee
where salary >= 3000000;

select * from vw_emp;

-- 223번 선관일 사원의 급여를 2백만원으로 변경
update vw_emp set salary = 2000000 where emp_id = 223;

-- with check option 쓰고 하면
create or replace view vw_emp
as select * 
from employee
where salary >= 3000000
with check option;

update vw_emp
set salary = 2000000
where emp_id = 217; -- 오류

update vw_emp
set salary = 4000000
where emp_id = 217; -- 성공

rollback;

-- 3) with read only
create or replace view vw_emp
as select emp_id, emp_name, bonus
from employee
where bonus is not null
with read only;

-- select만 가능하다
select * from vw_emp;
select * from vw_emp where bonus > 0.1;

-- update하기 -> 수행 불가
update vw_emp
set bonus = 0.35
where emp_id = 200;

-- delete하기 -> 수행 불가
delete from vw_emp
where emp_id = 200;