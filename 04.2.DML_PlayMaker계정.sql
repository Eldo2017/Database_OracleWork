/*
    DML(Data Manipulation Language) : 데이터 조작어
    테이블 값을 검색(Select), 삽입(Insert), 수정(Update), 삭제(Delete)하는 구문
*/

--------------------------------------------------------------------------------
/*
    1. Insert
       테이블에 새로운 행을 추가하는 구문
       
       
       [표현식]
       1) insert into 테이블명 values(값1, 값2, 값3,...);
          테이블에 모든 컬럼에 대한 값을 직접 넣어 한 행을 넣으려고 할때 사용한다
          컬럼 순서를 지켜 values에 값을 나열해야 한다
          
          부족하게 값을 넣었을 때 -> not enough value 오류
          값을 더 많이 넣었을 때 -> too many values 오류
          
*/

insert into employee values 
(223,'선관일','060109-3289561','seon@aie.or.kr','01083205262','D2','J5',3500000,0.15, 202, sysdate, null, default);

--------------------------------------------------------------------------------
/*
    2. insert into 테이블명(컬럼명, 컬럼명, ...) values (값1, 값2, ...)
       테이블에 내가 선택한 컬럼에 대한 값만 insert하려고 할 때 사용
       그래도 한 행 단위로 추가되므로 선택하지도 않은 컬럼은 기본적으로 null값이 된다
       단, default 값이 지정돼있다면 null이 아닌 기본값이 들어간다
       
       -- 주의점 --
       --- not null 제약조건이 걸려있는 컬럼이라면 반드시 선택해서 데이터를 넣어줘야 한다
       
*/

insert into employee(emp_id, emp_name, emp_no, job_code, hire_date) values 
(224, '엄용식','120509-1952476','J2',sysdate);

insert into employee(
emp_id, 
emp_name, 
emp_no, 
job_code, 
hire_date
) 
values (
225, 
'김성훈',
'060826-1736528',
'J3',
sysdate
);

--------------------------------------------------------------------------------
/*
    3. insert into 테이블명 (서브쿼리);
       values로 값을 직접 명시하는 대신에 서브쿼리로 조회된 데이터를 모두 insert한다
       (여러행 insert까지 가능)
*/

-- 테이블 생성
create table emp_01(
    emp_id number,
    emp_name varchar(20),
    dept_name varchar(35)
);

-- 전체 사원들의 사번, 이름, 부서명을 조회하여 테이블에 넣어라
-- 1) 전체 사원들의 사번, 이름, 부서명 조회
select emp_id, emp_name, dept_title from employee
left join department on dept_code = dept_id;

insert into emp_01 (select emp_id, emp_name, dept_title from employee
left join department on dept_code = dept_id);

--------------------------------------------------------------------------------
/*
    4. insert all
       두 개 이상의 테이블에 각각 insert할 때
       이때 사용되는 서브쿼리가 동일한 경우
       
       [표현법]
       insert all
       into 테이블명1 values(컬럼명, 컬럼명, ...)
       into 테이블명2 values(컬럼명, 컬럼명, ...)
       서브쿼리;
*/

-- 테스트용 테이블 2개 생성하기
create table emp_dept as 
select emp_id, emp_name, dept_code, hire_date from employee
where 1=0;

create table emp_manager as 
select emp_id, emp_name, manager_id from employee 
where 1=0;

-- 부서코드가 D9인 사원들의 사번, 이름, 부서코드, 입사일, 사수번호를 조회하라
select emp_id, emp_name, dept_code, hire_date, manager_id from employee where dept_code = 'D9';

insert all 
into emp_dept values (emp_id, emp_name, dept_code, hire_date)
into emp_manager values (emp_id, emp_name, manager_id)
select emp_id, emp_name, dept_code, hire_date, manager_id
from employee where dept_code = 'D9';

--------------------------------------------------------------------------------
/*
    5. 조건을 사용한 insert도 가능하다
    
       [표현식]
       insert all
       when 조건1 then into 테이블명1 
       values (컬럼명, 컬럼명, 컬럼명, ...)
       when 조건2 then into 테이블명2 
       values (컬럼명, 컬럼명, 컬럼명, ...)
       서브쿼리
*/

-- 2000년도 이전에 입사한 직원들에 대한 정보
create table emp_previous as
select emp_id, emp_name, hire_date, salary from employee where 1=0;

-- 2000년도 이후에 입사한 직원들에 대한 정보
create table emp_after as
select emp_id, emp_name, hire_date, salary from employee where 1=0;

-- insert
insert all 
when hire_date < '2000/01/01' then 
into emp_previous values(emp_id, emp_name, hire_date, salary)
when hire_date >= '2000/01/01' then
into emp_after values(emp_id, emp_name, hire_date, salary)
select emp_id, emp_name, hire_date, salary from employee;