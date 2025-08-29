/*
    DML : 데이터 조작어
    테이블에 값을 검색(select), 추가(insert), 수정(update), 삭제(delete)하는 구문
    - select, insert, update, delete -
*/

--------------------------------------------------------------------------------
/*
    (')홑따옴표 : 문자열을 감싸주는 기호
    (")쌍따옴표 : 컬럼명 등을 감싸주는 기호
*/

/*
    <select>
    데이터를 조회할 때 사용하는 구문
    
    >> Result set : select문을 통하여 조회된 결과물(조회된 행들의 집합) <<
    
    [표현 방법]
    select 조회하려는 컬럼명, 컬럼명, ... from 테이블명;
    
    또는
    
    select 조회하려는 컬럼명, 컬럼명, ... 
    from 테이블명;
*/

-- EMPLOYEE 테이블의 모든 컬럼(*) --
select * from EMPLOYEE;
-- EMPLOYEE 테이블의 id, 이름, 급여만 조회
select emp_id, emp_name, salary from employee;
-- JOB 테이블의 모든 컬럼 조회 --
select * from job;


-- 실습 --
/*
1. JOB 테이블의 직급명만 조회

2. DEPARTMENT 테이블의 모든 컬럼 조회

3. DEPARTMENT 테이블의 부서코드, 부서명만 조회

4. EMPLOYEE 테이블의 사원명, 이메일, 전화번호, 입사일, 급여를 조회
*/

-- 1번
select job_name from job;

-- 2번
select * from department;

-- 3번
select dept_id, dept_title from department;

-- 4번
select emp_name, email, phone, hire_date, salary from employee;

/*
    <컬럼값을 통한 산술 연산>
    select 컬럼명 작성하는 부분에 산술 연산 기술하라(연산 결과가 조회된다)
*/

-- employee 테이블에서 사원명, 연봉(급여*12)을 조회하라 --
select emp_name, salary*12 from employee;

-- employee 테이블에서 사원명, 급여, 보너스를 조회하라 --
select emp_name, salary, bonus from employee;

-- employee 테이블에서 사원명, 급여, 보너스, 연봉, 보너스 포함 연봉(((salary*bonus)+salary)*12)을 조회하라 --
select emp_name, salary, bonus, salary*12, ((salary*bonus+salary)*12) from employee;

-- date끼리도 연산이 된다 : 결과값은 일 단위로 나온다
-- 오늘 날짜 : sysdate

-- employee 테이블에서 사원명, 입사일, 근무일수(sysdate-입사일)를 조회하라 --
select emp_name, hire_date, sysdate - hire_date from employee;

--------------------------------------------------------------------------------
/*
    <컬럼명에 별칭을 지정하려면?>
    산술연산 시 컬럼명이 산술에 들어간 수식 그대로 되었다면?
    -> 별칭으로 컬럼명을 대체하라!
    
    [표현법]
    컬럼명 별칭 / 컬럼명 as 별칭 / 컬럼명 "별칭" / 컬럼명 as "별칭"
    
    ** 반드시 별칭에 쌍따옴표(") 처리를 해야 하는 경우는?
    -> 별칭에 띄어쓰기 또는 특수기호가 들어간 경우
*/

-- employee 테이블에서 사원명, 급여, 보너스, 연봉, 보너스 포함 연봉(((salary*bonus)+salary)*12)을 조회하라 (별칭을 적용해서) --
select emp_name, salary, bonus, salary*12 ys, ((salary*bonus+salary)*12) "ys including b" from employee;
-- 별칭 앞에 as는 있어도 되고 없어도 된다 --

--------------------------------------------------------------------------------

/*
    <literal>
    임의로 지정한 문자열('')
    
    select 절에 리터럴을 제시하면 마치 테이블 상에 존재하는 데이터처럼 조회가 가능하다.
    조회된 result set의 모든 행에 반복적으로 출력이 된다.
*/

-- employee 테이블에서 사번, 사원명, 급여, 원을 조회하라 --
select emp_id, emp_name, salary, '원' as 단위 from employee;

--------------------------------------------------------------------------------

/*
    <연결 연산자 : || >
    여러 컬럼값들을 마치 하나의 컬럼인 것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있다.
*/

-- employee 테이블에서 사번, 사원명, 급여를 한 컬럼으로 조회하라 --
select emp_id, emp_name, salary from employee;

select emp_id || emp_name || salary from employee;

-- 컬럼값과 리터럴 연결 --
select emp_name || '의 월급 : ' || salary || '원' from employee;

--------------------------------------------------------------------------------

/*
    <distinct>
    컬럼의 중복된 값들을 한번씩만 표시하려고 할 때 사용한다   
*/

-- employee 테이블에서 직급코드를 조회하라 --
select job_code from employee;
-- employee 테이블에서 직급코드를 중복 없이 조회하라 --
select distinct job_code from employee;

-- employee 테이블에서 부서코드를 중복 없이 조회하라 --
select distinct dept_code from employee;

-- 주의점 : distinct는 select 절에서 단 한번만 기술할 수 있다 --

--------------------------------------------------------------------------------

/*
    <where>
    조회하려고 하는 테이블로부터 특정 조건에 맞는(= 만족하는) 데이터만 조회할 때 사용한다.
    이때 where 절에는 조건식을 제시해야 한다.
    조건식에는 다양한 연산자를 사용할 수 있다.
    
    [표현법]
    select 컬럼명, 컬럼명, 산술 연산, ... from 테이블명 where 조건식
    
    >> 조건식에는 비교 연산자를 사용할 수 있다.
       대소 비교) >, <, >=, <=
       같은지 비교) =
       같지 않은지 비교) !=, ^=, <>
*/

-- employee 테이블에서 부서코드가 'D9'인 사원들의 모든 컬럼을 조회하라 --
select * from employee where dept_code = 'D9';

-- employee 테이블에서 부서코드가 'D1'이 아닌 사원의 사번, 이름, 부서코드만 조회하라 --
select emp_id, emp_name, dept_code from employee where dept_code != 'D1';

/*
    또는
    where dept_code ^= 'D1';
    이나
    where dept_code <> 'D1';
*/

--------------------------------------------------------------------------------

-- employee 테이블에서 급여가 4000000원 이상인 사원의 이름, 부서코드, 급여를 조회하라 --
select emp_name, dept_code, salary from employee where salary >= 3000000;

-- employee 테이블에서 재직중인 사원의 사번, 이름, 입사일을 조회하라 --
select emp_id, emp_name, hire_date, ent_yn from employee where ent_yn = 'N';

--------------------------------------------------------------------------------

/*
    실습 문제 (employee 테이블 공통)
    1. 급여가 300만원 이상인 사원들의 이름, 급여, 입사일, 연봉을 조회하라
    2. 연봉이 5000만원 이상인 사원들의 이름, 급여, 연봉, 부서코드를 조회하라
    3. 직급코드가 'J3'이 아닌 사원들의 사번, 이름, 직급코드, 퇴사여부를 조회하라
*/

-- 1번
select emp_name, salary, hire_date, salary * 12 as ys from employee where salary >= 3000000;

-- 2번
select emp_name, salary, salary * 12 as ys, dept_code from employee where salary * 12 >= 50000000;

-- 3번
select emp_id, emp_name, job_code, ent_yn from employee where job_code != 'J3';

--------------------------------------------------------------------------------

/*
    <논리 연산자>
    여러 개의 조건을 제시할 때 사용한다
    
    AND(~이면서, 그리고)
    OR(~이거나, 또는)
*/

-- employee 테이블에서 부서코드가 'D9'이면서 급여가 500만원 이상인 사원들의 이름, 부서코드, 급여를 조회하라
select emp_name, dept_code, salary from employee where dept_code = 'D9' AND salary >= 5000000;

-- employee 테이블에서 부서코드가 'D6'이거나 급여가 300만원 이상인 사원들의 이름, 부서코드, 급여를 조회하라
select emp_name, dept_code, salary from employee where dept_code = 'D6' OR salary >= 3000000;

-- employee 테이블에서 급여가 350만원 이상 600만원 이하인 사원들의 사번, 이름, 급여를 조회하라
select emp_id, emp_name, salary from employee where salary >= 3500000 AND salary <= 6000000;

--------------------------------------------------------------------------------

/*
    <between and>
    조건식에서 사용되는 구문이다
    ~이상 ~이하인 범위에 대한 조건을 제시할 때 사용되는 연산자
    
    [표현법]
    비교대상 컬럼 between 하한값 and 상한값
    -> 해당 컬럼값이 하한값 이상이고 상한값 이하인 경우, 조회된다.
*/

-- employee 테이블에서 급여가 350만원 이상 600만원 이하인 사원들의 사번, 이름, 급여를 조회하라
select emp_id, emp_name, salary from employee where salary between 3500000 and 6000000;

-- employee 테이블에서 급여가 350만원 미만이거나 600만원을 넘는 사원들의 사번, 이름, 급여를 조회하라 (위와 반대인 상황이다)
select emp_id, emp_name, salary from employee where salary < 3500000 or salary > 6000000;

-- between 사용(~초과, ~미만인 경우)
select emp_id, emp_name, salary from employee where not salary between 3500000 and 6000000;

-- not : 논리부정연산
--       컬럼명 앞이나 between 앞에 삽입할 수 있다.

-- employee 테이블에서 입사일이 90-01-01 ~ 01-01-01인 사원의 모든 컬럼을 조회하라
select * from employee where hire_date >= '90-01-01' and hire_date <= '01-01-01';

select * from employee where hire_date between '90-01-01' and '01-01-01';

--------------------------------------------------------------------------------

/*
    <like>
    비교하려고 하는 컬럼값이 내가 제시한 특정 패턴에 만족하는 경우 조회한다.
    
    [표현법]
    비교대상컬럼 like '특정 패턴'
    
    >> '%' : 0글자 이상
    Ex) 비교대상컬럼 like '문자%' -> 비교대상컬럼값이 '문자'로 시작하는 값을 조회한다.
        비교대상컬럼 like '%문자' -> 비교대상컬럼값이 '문자'로 끝나는 값을 조회한다.
        비교대상컬럼 like '%문자%' -> 비교대상컬럼값에 '문자'가 포함돼있는 값을 조회한다.
        
    >> '_' : 1개당 1글자
    Ex) 비교대상컬럼 like '_문자' -> 비교대상컬럼값이 '문자'앞에 무조건 한 글자가 있고 문자로 끝나는 값을 조회한다.
        비교대상컬럼 like '__문자' -> 비교대상컬럼값이 '문자'앞에 무조건 두 글자가 있고 문자로 끝나는 값을 조회한다.
        비교대상컬럼 like '_문자_' -> 비교대상컬럼값이 '문자'앞과 끝부분에 무조건 두 글자가 있고 중간에 문자가 있는 값을 조회한다.
*/

-- employee 테이블에서 사원명 중 김씨인 사원들의 사원명, 급여, 입사일을 조회하라.
select emp_name, salary, hire_date from employee where emp_name like '김%';

-- employee 테이블에서 사원명 중 '영'이 포함돼있는 사원들의 사원명, 전화번호를 조회하라.
select emp_name, phone from employee where emp_name like '%영%';

-- employee 테이블에서 전화번호의 3번째 자리가 1인 사원들의 사번, 사원명, 전화번호, 이메일을 조회하라.
select emp_id, emp_name, phone, email from employee where phone like '__1%';

-- 이메일 중 언더바(_) 앞에 3글자인 사원들의 사번, 사원명, 이메일을 조회하라.
select emp_id, emp_name, email from employee where email like '____%';

/*
    와일드카드로 사용되고 있는 문자와 컬럼값에 들어있는 문자가 동일해서 조회가 안된다.
    모두 와일드카드로 인식되는 것이다.
    
    >> 어떤 것이 와일드카드, 데이터값인지 구분하려면?
    -> 데이터값으로 취급하고자 하는 값 앞에 나만의 와일드카드 (문자, 숫자, 특수기호 무관하게 아무거나)를 제시한다.
       나만의 와일드카드를 escape로 등록한다.
       
    >> 특수기호 중 '&'는 오라클에서 사용자로부터 입력받는 키워드라서 쓰지 않는 걸 추천한다.
*/

select emp_id, emp_name, email from employee where email like '___$_%' escape '$'; -- $ 뒤는 컬럼값이다.

-- 위의 사원을 제외한 나머지를 조회하려면?
select emp_id, emp_name, email from employee where not email like '___$_%' escape '$';

--------------------------------------------------------------------------------

-- 실습 예제
-- 1. employee 테이블에서 이름이 '영'으로 끝나는 사원들의 사원명, 입사일을 찾아라
select emp_name, hire_date from employee where emp_name like '%영';

-- 2. employee 테이블에서 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호를 찾아라
select emp_name, phone from employee where not phone like '010%';

-- 3. employee 테이블에서 이름에 '영'이 포함되어 있고 급여가 240만원 이상인 사원들의 사원명, 급여를 찾아라
select emp_name, salary from employee where emp_name like '%영%' and salary >=2400000;

-- 4. department 테이블에서 해외영업부 부서들의 부서코드, 부서명을 찾아라
select dept_id, dept_title from department where dept_title like '해외영업%부';

--------------------------------------------------------------------------------

/*
    <is (not) null>
    컬럼값이 null인 경우 null값을 비교하는데 사용되는 연산자
*/

-- employee 테이블에서 보너스를 받지 않는 사원들의 사번과 사원명, 급여, 보너스를 찾아라
select emp_id, emp_name, salary, bonus from employee where bonus is null;

-- employee 테이블에서 보너스를 받는 사원들의 사번과 사원명, 급여, 보너스를 찾아라
select emp_id, emp_name, salary, bonus from employee where bonus is not null;

-- employee 테이블에서 사수가 없는 사원들의 사원명, 부서코드, 사수번호를 찾아라
select emp_name, dept_code, manager_id from employee where manager_id is null;

-- employee 테이블에서 부서가 없지만 보너스를 받는 사원들의 사원명, 보너스, 부서코드를 찾아라
select emp_name, bonus, dept_code from employee where dept_code is null and bonus is not null;

--------------------------------------------------------------------------------

/*
    <in /not in>
    in : 컬럼값이 내가 제시한 목록들 중에서 일치하는 값이 존재하는 것만 조회한다
    not in : 컬럼값이 내가 제시한 목록들 중에서 일치하는 값을 뺀 나머지를 조회한다
    
    [표현법]
    비교대상컬럼 in ('값1','값2','값3',...)
*/

--------------------------------------------------------------------------------

-- employee 테이블에서 부서코드가 'D6'이거나 'D5'이거나 'D8'인 부서원들의 사원명, 부서코드, 급여를 찾아라
select emp_name, dept_code, salary from employee where dept_code = 'D6' or dept_code ='D5' or dept_code ='D8';
select emp_name, dept_code, salary from employee where dept_code in ('D5','D6','D8');

-- employee 테이블에서 위 사원들을 제외한 나머지를 찾아라
select emp_name, dept_code, salary from employee where dept_code not in ('D5','D6','D8');

/*
    <연산자 우선순위>
    1) ()
    2) 산술연산자
    3) 연결연산자
    4) 비교연산자
    5) is (not) null
    6) between and
    7) not(논리연산자)
    8) and(논리연산자)
    9) or(논리연산자)
*/

-- >> and가 or보다 우선순위가 높다
-- 직급코드가 J7이거나 J2인 사원들 중 급여가 200만원 이상인 사원들의 모든 컬럼을 찾아라
select * from employee where job_code = 'J7' or job_code = 'J2' and salary >= 2000000;

------------------- 실습문제----------------------
--1. 사수가 없고 부서배치도 받지 않은 사원들의 사원명, 사수사번, 부서코드 조회
select emp_name, manager_id, dept_code from employee where manager_id is null and dept_code is null;

--2. 연봉(보너스포함X)이 3000만원 이상이고 보너스를 받지 않은 사원들의 사번, 사원명, 연봉, 보너스 조회
select emp_id, emp_name, salary*12 as 연봉, bonus from employee where salary*12 >= 30000000 and bonus is null;

--3. 입사일이 95/01/01이상이고 부서배치를 받은 사원들의 사번, 사원명, 입사일, 부서코드 조회
select emp_id, emp_name, hire_date, dept_code from employee where hire_date >= '95/01/01' and dept_code is not null;

--4. 급여가 200만원 이상 500만원 이하고 입사일이 01/01/01이상이고 보너스를 받지 않는 사원들의 사번, 사원명, 급여, 입사일, 보너스 조회
select emp_id, emp_name, salary, hire_date, bonus from employee where (salary between 2000000 and 5000000) and hire_date >= '01/01/01' and bonus is null;

--5. 보너스포함 연봉이 NULL이 아니고 이름에 '신'이 포함되어 있는 사원들의 사번, 사원명, 급여, 보너스포함연봉 조회 (별칭부여)
select emp_id, emp_name, salary, ((salary*bonus+salary)*12) as 보너스포함연봉 from employee where (salary*bonus+salary)*12 is not null and emp_name like '%신%';

--------------------------------------------------------------------------------

/*
    <order by>
    select 문 가장 마지막 줄에 작성 뿐만 아니라 실행도 가장 마지막에 된다
    
    [표현법]
    select 조회할 컬럼명, 산술연산식 as "별칭"
    from 테이블명
    where 조건식
    order by 정렬기준의 정렬명 | 별칭 | 컬럼순서 (ASC | DESC) (nulls first | nulls last)
    
    - asc : 오름차순 정렬
    - desc : 내림차순 정렬
    
    - nulls first : null값이 있는 경우, 데이터의 맨 앞에 배치한다(생략 시 DESC일 때, 기본값)
    - nulls last : null값이 있는 경우, 데이터의 맨 뒤에 배치한다(생략 시 ASC일 때, 기본값)
*/

select * from employee 
-- order by bonus; 
-- order by bonus desc; 오름차순 정렬 기본값 nulls first
order by bonus nulls first;

select emp_name, bonus from employee order by bonus desc nulls last;

-- 정렬 기준을 여러개 사용
select emp_name, bonus, salaryfrom employee order by bonus desc, salary;

-- 전 사원의 사원명, 연봉조회 연봉의 내림차순 정렬조회
select emp_name, salary*12 연봉 from employee 
-- order by 연봉 desc; -- 별칭 사용 가능
-- order by salary*12 desc;
order by 2 desc; -- 컬럼 번호 사용 가능

------------------------------- 종합 문제 ----------------------------------
-- 1. JOB 테이블에서 모든 정보 조회
select * from job;
-- 2. JOB 테이블에서 직급 이름 조회
select job_name from job;
-- 3. DEPARTMENT 테이블에서 모든 정보 조회
select * from department;
-- 4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회
select emp_name, email, phone, hire_date from employee;
-- 5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
select hire_date, emp_name, salary from employee;
-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회
select emp_name, salary*12 as 연봉, (salary+salary*bonus)*12 as 총수령금, ((salary+salary*bonus)*12 - ((salary*12)*0.03)) as 실수령액 from employee;
-- 7. EMPLOYEE테이블에서 JOB_CODE가 J1인 사원의 이름, 월급, 고용일, 연락처 조회
select emp_name, salary, hire_date, phone from employee where job_code = 'J1';
-- 8. EMPLOYEE테이블에서 실수령액(6번 참고)이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
select emp_name, salary, ((salary+salary*bonus)*12 - ((salary*12)*0.03)) as 실수령액, hire_date from employee where ((salary+salary*bonus)*12 - ((salary*12)*0.03)) >= 50000000;
-- 9. EMPLOYEE테이블에 월급이 4000000 이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
select * from employee where salary >= 4000000 and job_code = 'J2';
-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 
--     고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
select emp_name, dept_code, hire_date from employee where (dept_code = 'D9' or dept_code = 'D5') and hire_date < '02-01-01';
-- 11. EMPLOYEE테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용을 조회
select * from employee where hire_date between '90/01/01' and '01/01/01';
-- 12. EMPLOYEE테이블에서 이름 끝이 '영'으로 끝나는 사원의 이름 조회
select emp_name from employee where emp_name like '%영';
-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
select emp_name, phone from employee where phone not like '010%';
-- 14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 
--     고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회
select * from employee where email like '____$_%' escape '$' and (dept_code = 'D9' or dept_code = 'D6') and (hire_date between '90/01/01' and '00/12/01') and salary >= 2700000;