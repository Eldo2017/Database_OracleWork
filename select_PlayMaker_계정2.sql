/*
    <함수 FUNCTION>
    전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
    
    - 단일행 함수 : N개 값을 읽어들여 N개의 결과값 반환(매 행마다 함수 실행)
    - 그룹 함수 : N개 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)
    
    >> SELECT절에 단일행 함수와 그룹함수를 함께 사용 불가
    
    >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절
*/
------------------------------------- 단일행 함수 -------------------------------
--==============================================================================
--                                   <문자처리 함수>
--==============================================================================
/*
    * LENGTH / LENGTNB => NUMBER로 반환
    
    LENGTH(컬럼|'문자열') : 해당 문자열의 글자수 반환
    LENGTNB(컬럼|'문자열') : 해당 문자열의 BYTE수 반환
        - 한글 : XE버전일 때 => 1글자당 3BYTE(김, ㄱ, ㅠ -> 1글자에 해당)
                EE버전일 때 => 1글자당 2BYTE
        - 그외 : 1글자당 1BYTE
*/
SELECT LENGTH('오라클')||'글자', LENGTHB('오라클')||'byte'
FROM DUAL;  -- 오라클에서 제공하는 가상테이블

SELECT LENGTH('oracle')||'글자', LENGTHB('oracle')||'byte'
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME),
        EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    * INSTR : 문자열로부터 특정문자의 시작위치(INDEX)를 찾아 반환(반환형 : NUMBER)
        - ORACLE에서는 INDEX는 1부터 시작, 찾을 문자가 없으면 0반환
        
      INSTR(컬럼|'문자열', '찾고자하는 문자', [찾을위치의 시작값, [순번]])
        - 찾을위치의 시작값
          > 1 : 앞에서부터 찾기(기본값)
          > -1 : 뒤에서 부터
*/

SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A') FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 1) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 3) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', -1) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 1, 3) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', -1, 2) FROM DUAL;

-- EMPLOYEE테이블에서 EMAIL의 '_'의 INDEX번호와 '@' INDEX번호 찾기
SELECT EMAIL, INSTR(EMAIL, '_',1,1) "_위치", INSTR(EMAIL, '@') "@위치"
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    * SUBSTR : 문자열에서 특정 문자열을 추출하여 반환(반환형 : CHARCTER)
      
      SUBSTR('문자열', POSITION, [LENGTH])
       - POSITION : 문자열을 추출할 시작위치 INDEX
       - LENGTH : 추출할 문자의 갯수(생락시 맨마지막까지 추출)
*/

SELECT SUBSTR('ORACLEHTMLCSS', 7) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 7, 4) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 1, 6) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -7, 4) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -3) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -3, 3) FROM DUAL;

-- EMPLOYEE테이블에서 주민번호의 성별만 추출하여 사원명, 주민번호, 성별을 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 여자사원들만 사원번호, 사원명, 성별 조회
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
-- WHERE SUBSTR(EMP_NO, 8, 1) = '2' OR SUBSTR(EMP_NO, 8, 1) = '4';
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2','4');


-- EMPLOYEE테이블에서 남자사원들만 사원번호, 사원명, 성별 조회, 사원명의 오름차순 정렬로
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1','3')
ORDER BY 2;

-- EMPLOYEE테이블에서 EMAIL에서 아이디만 추출하여 사원명, 이메일, 아이디(@이전까지 추출)조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) 아이디
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    * LPAD / RPAD : 문자열을 조회할 때 통일감있게 조회하고자 할 때(반환형 : CHARCTER)
    
      LPAD / RPAD('문자열', 최종적으로반환할문자의길이, [덧붙이고자하는문자])
      문자열에 덧붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N길이만큼의 문자열 반환
*/
-- 20길이 중 EMAIL컬럼값은 오른쪽 정렬하고 나머지부분은 공백(왼쪽)으로 채움
SELECT EMP_NAME, LPAD(EMAIL, 20)
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 사번, 사원명, 주민번호 조회(123456-1******의 형식으로 출력) 
-- 우선 주민번호 추출
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 1, 8)
FROM EMPLOYEE;
-- 주민번호 뒤에 * 붙여주기
SELECT EMP_ID, EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 1, 8) || '******'
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    * LTRIM / RTRIM : 문자열에서 특정문자를 제거한 나머지 반환(반환형 : CHARCTER)
    * TRIM : 문자열의 앞/뒤 양쪽에 지정한 문자들을 제거한 나머지 반환
    
      LTRIM/RTRIM('문자열', [제거하고자하는 문자]) => 제거하고자하는 문자를 생략하면 공백제거
      TRIM([LEADING|TRAILING|BOTH]제거하고자하는문자들 FROM '문자열']) => 제거하고자하는 문자는 1개만 가능
*/

SELECT LTRIM('     TJOEUN     ') || '컴퓨터아카데미' FROM DUAL;
SELECT LTRIM('JAVAJAVASCRIPT', 'JAVA') FROM DUAL;
SELECT LTRIM('JAVAJAVASCRIPT', 'JAV') FROM DUAL;
SELECT LTRIM('BACBAACFABCD', 'ABC') FROM DUAL;
SELECT LTRIM('283980KLSK323', '0123456789') FROM DUAL;

SELECT RTRIM('     TJOEUN     ') || '컴퓨터아카데미' FROM DUAL;
SELECT RTRIM('BACBADHAFABCB', 'ABC') FROM DUAL;

-- 기본값은 BOTH로 양쪽의 문자들을 제거
SELECT TRIM(BOTH 'A' FROM 'AAADKS78AAA') FROM DUAL;
SELECT TRIM('A' FROM 'AAADKS78AAA') FROM DUAL;
SELECT TRIM(LEADING 'A' FROM 'AAADKS78AAA') FROM DUAL;   --> LTRIM과 같음
SELECT TRIM(TRAILING 'A' FROM 'AAADKS78AAA') FROM DUAL;  --> RTRIM과 같음

----------------------------------------------------------------------------
/*
    * LOWER / UPPER / INITCAP : 문자열을 대소문자로 변환 및 단어의 첫글자만 대문자로 변환
      
      LOWER / UPPER / INITCAP('문자열')
*/
SELECT LOWER('Java Javascript Oracle') FROM DUAL;
SELECT UPPER('Java Javascript Oracle') FROM DUAL;
SELECT initcap('java javascript oracle') FROM DUAL;

----------------------------------------------------------------------------
/*
    * CONCAT : 문자열 2개를 전달받아 하나로 합쳐진 결과 반환
    
      CONCAT('문자열','문자열')
*/
SELECT CONCAT('Oracle','오라클') FROM DUAL;
SELECT 'Oracle' || '오라클' FROM DUAL;

SELECT CONCAT('Oracle','오라클', '02-123-4567', '강남구') FROM DUAL;
-- 오라클 낮은 버전에서는 문자열 2개밖에 안됨

----------------------------------------------------------------------------
/*
    * REPLACE : 기존문자열을 새로운 문자열로 바꿈
    
      REPLACE('문자열', '기존문자열', '바꿀문자열')
*/
SELECT REPLACE('ORACLE 공부중', 'ORACLE', '오라클') FROM DUAL;

-- EMPLOYEE테이블에서 사원명, 기존EMAIL, 변경한 이메일(aie.or.kr -> tjoeun.co.kr)하여 조회
SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'aie.or.kr', 'tjoeun.co.kr')
  FROM EMPLOYEE;

--==============================================================================
--                                   <숫자처리 함수>
--==============================================================================
/*
    * ABS : 숫자의 절대값
    
      ABS(NUMER)
*/
SELECT ABS(-10) FROM DUAL;
SELECT ABS(-3.14) FROM DUAL;

----------------------------------------------------------------------------
/*
    * MOD : 두 수를 나눈 나머지값
    
      MOD(NUMBER, NUMBER)
*/
SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.9, 2) FROM DUAL;  -- 잘 사용안함

----------------------------------------------------------------------------
/*
    * ROUND : 반올림한 결과 반환
    
      ROUND(NUMER, [위치])
        - 위치 생략시 위치는 0(즉, 정수로 반올림)
*/
SELECT ROUND(12345.67) FROM DUAL;
SELECT ROUND(123.323) FROM DUAL;

SELECT ROUND(1234.5678, 2) FROM DUAL;
SELECT ROUND(1234.56, 4) FROM DUAL;

SELECT ROUND(1234.567, -2) FROM DUAL;

----------------------------------------------------------------------------
/*
    * CEIL : 무조건 올림
    
      CEIL(NUMBER)
*/
SELECT CEIL(145.278) FROM DUAL;
SELECT CEIL(-145.278) FROM DUAL;

----------------------------------------------------------------------------
/*
    * FLOOR : 무조건 내림
    
      FLOOR(NUMBER)
*/
SELECT FLOOR(145.278) FROM DUAL;
SELECT FLOOR(-145.278) FROM DUAL;

----------------------------------------------------------------------------
/*
    * TRUNC : 위치지정 가능한 버림처리 함수
    
      TRUNC(NUMBER, [위치])
*/
SELECT TRUNC(123.789) FROM DUAL;
SELECT TRUNC(123.789, 1) FROM DUAL;
SELECT TRUNC(123.789, -1) FROM DUAL;

SELECT TRUNC(-123.789) FROM DUAL;
SELECT TRUNC(-123.789, -2) FROM DUAL;

-----------------------------------------------------------------------------

/*
    날짜 처리 함수
    * SYSDATE : 시스템 날짜 및 시간 반환
*/

select sysdate from dual;

-- months_between(date1, date2) : 두 날짜 사이 개월 수를 반환

select emp_name, hire_date, sysdate-hire_date 근무일수
from employee;

select emp_name, hire_date, ceil(months_between(sysdate, hire_date)) 근무개월수
from employee;

-- 427개월 차 -> 이렇게 바꿔라
select emp_name, hire_date, ceil(months_between(sysdate, hire_date)) || '개월 차' 근무개월수
from employee;

----------------------------------------------------------------------------

-- add_months(date, number) : 특정 날짜에 해당 숫자만큼 개월 수를 더해 그 날짜를 반환

select add_months(sysdate, 7) from dual;

-- employee 테이블에서 사원명, 입사일, 정직원이 된 날짜를 조회하라
-- (단, 입사일로부터 6개월 수습 기간을 포함한다)
select emp_name, hire_date, add_months(hire_date, 6) 진급날짜 from employee;

--------------------------------------------------------------------------------

-- next_day(date, 요일(문자 or 숫자)) : 특정 날짜 이후 가까운 해당 요일의 날짜를 반환

select sysdate, next_day(sysdate, '화');
select sysdate, next_day(sysdate, 2);

-- 오류 : 현재 언어는 한국이다
-- select sysdate, next_day(sysdate, 'monday') from dual;

-- 언어 변경하기
alter session set nls_language = korean;
-- select sysdate, next_day(sysdate, 'friday') from dual;

-------------------------------------------------------------------------------

-- last day(date) : 해당 월의 마지막 날짜를 반환
select last_day(sysdate) from dual;

select emp_name, hire_date, last_day(hire_date) from employee;

----------------------------------------------------------------------------

-- extract : 특정날짜로부터 년도|월|일 값을 추출해 반환 (반환형:숫자)

-- extract(year from date) : 년도 추출
-- extract(month from date) : 월 추출
-- extract(day from date) : 일 추출

select emp_name, 
extract(year from hire_date) 입사년도, 
extract(month from hire_date) 입사월, 
extract(day from hire_date) 입사일
from employee 
order by 입사년도 asc;

----------------------------------------------------------------------------

/*
    to_char : 숫자 또는 날짜 타입 값을 문자로 변환
    to_char(숫자 | 날짜, [포맷])
*/

---------------------------------- 숫자 -> 문자 ----------------------------------

/*
    9: 해당 자리의 숫자
    - 값이 없다면 소수점 이상은 공백, 소수점 이하는 0
    0: 해당 자리의 숫자
    - 값이 없을 경우 0으로 표시하면 숫자의 길이를 고정적으로 표시한다
    FM: 해당 자리값이 없다면 자리 차지를 하지 않는다
*/

select to_char(1972) from dual;
select to_char(1972,'999999') from dual; -- 6칸을 확보, 좌방향 정렬, 빈칸이 공백이다
select to_char(1972,'000000') from dual; -- 위와 비슷하지만, 빈칸이 0으로 채워진다.
select to_char(1972,'L99999') from dual; -- 앞에 \이 붙고 오른쪽으로 정렬된다. 빈칸은 공백이다. (현재 설정된 나라(Local)의 화폐단위이다)
select to_char(1121,'L99,999') from dual;

select emp_name, to_char(salary, 'L99,999,999') 월급, to_char(salary*12,'L99,999,999') 연봉 from employee;

select to_char(123.456,'FM999990.999'),
to_char(1234.56,'FM999990.999'),
to_char(0.1000,'FM9990.999'),
to_char(0.1000,'FM9999.999')
from dual;

select to_char(123.456,'999990.999'),
to_char(123.45,'9990.999')
from dual;

--------------------------- 날짜 -> 문자 ----------------------------------------
select to_char(sysdate, 'am') korea,
to_char(sysdate, 'pm','nls_date_language=american') american
from dual; -- 'am','pm' 뭘 쓰든 상관없다

select to_char(sysdate, 'am hh:mi:ss') 현재시간 from dual; -- hh: 12시간 형식
select to_char(sysdate, 'hh24:mi:ss') 현재시간 from dual; -- hh24: 24시간 형식

select to_char(sysdate, 'yyyy-mm-dd day') 현재날짜 from dual; -- 월요일
select to_char(sysdate, 'yyyy-mm-dd dy') 현재날짜 from dual; -- 월
select to_char(sysdate, 'mon, yyyy') from dual; -- 9월, 2025

-- 2025년 09월 01일 월요일 출력하기

select to_char(sysdate, 'yyyy"년" mm"월" dd"일" day') from dual;
select to_char(sysdate, 'dl') from dual;

select emp_name, to_char(hire_date,'yy-mm-dd') from employee;
select emp_name, to_char(hire_date,'dl') from employee;

-- 년도의 경우

/*
    yy : 현재 세기가 앞에 붙는다
    
    예제)
    050109 -> 2005
    721121 -> 2072
    
    rr : 50년 기준으로 50보다 작으면 현재 세기, 크거나 같다면 이전 세기
    
    예제)
    050109 -> 2005
    721121 -> 1972
*/

select to_char(sysdate, 'yyyy'), to_char(sysdate, 'yy'), 
to_char(sysdate, 'rrrr'), to_char(sysdate, 'rr'),
to_char(sysdate, 'year')
from dual;

-- 월
select to_char(sysdate, 'mm'), to_char(sysdate, 'mon'),
to_char(sysdate, 'month'), to_char(sysdate, 'rm')
from dual;

alter session set nls_language = american;

select to_char(sysdate, 'mm'), to_char(sysdate, 'mon'),
to_char(sysdate, 'month'), to_char(sysdate, 'rm')
from dual;

alter session set nls_language = korean;

-- 일
select to_char(sysdate, 'ddd'), to_char(sysdate, 'dd'), -- ddd: 년을 기준으로 며칠인가, dd: 월을 기준으로 며칠인가
to_char(sysdate, 'd') -- d: 일주일을 기준으로 며칠인가
from dual;

-- 요일
select to_char(sysdate, 'day'), to_char(sysdate, 'dy')
from dual;

------------------------ 숫자 or 문자 -> 날짜 ----------------------------------------
/*
    to_date : 숫자 또는 문자 형식의 타입을 날짜 타입으로 변경한다
    to_date(숫자 or 문자, 포맷)
*/

select to_date(20170320) from dual; 
select to_date(170320) from dual; -- 숫자는 앞이 0일 때, 0을 제거하므로 오류
select to_date('010920') from dual; -- 0이 앞에 붙으면 문자열로 넣어주기

select to_date('031027 103000','yymmdd hh:mi:ss') from dual;
select to_date('031027 143000','yymmdd hh24:mi:ss') from dual;

select to_char(to_date('031027 103000','yymmdd hh:mi:ss'),'yy-mm-dd hh:mi:ss') from dual;

select to_date('190825','yymmdd') from dual; -- 현재세기
select to_date('721121','yymmdd') from dual;

select to_char(to_date('721121','yymmdd'),'yyyy-mm-dd') from dual;

select to_date('190825','rrmmdd') from dual; -- 이전세기
select to_date('721121','rrmmdd') from dual;

select to_char(to_date('721121','rrmmdd'),'rrrr-mm-dd') from dual;

select to_char(to_date('72/11/21','rr/mm/dd'), 'rrrr-mm-dd') from dual;

--------------------------------------------------------------------------------

/*
    to_number: 문자 타입 데이터를 숫자로 변환
    
    to_number(문자, 포맷)
*/
select to_number('012341234') from dual;
select '1000000' + '550000' from dual; -- 자동 형변환(숫자로)
-- select '1,000,000' + '250,000' from dual; -> 오류: 숫자 외의 콤마(,) 특수기호가 있으면 자동 형변환 불가하다
select to_number('1,000,000', '9,999,999') + to_number('250,000','999,999') 합계 from dual;

-----------------------------------------------------------------------------------
--                              <null 처리 함수>                                --
----------------------------------------------------------------------------------

/*
    nvl(컬럼, 해당 컬럼값이 null일 때 반환할 값)
*/
select emp_name, nvl(bonus, 0) from employee;

-- 모든 사원의 이름과 보너스를 포함한 연봉
select emp_name, (salary*(1+nvl(bonus,0)))*12
from employee;

-- 모든 사원의 이름, 부서코드를 조회하라 (만약 부서코드가 null이라면 '부서 없음'이다)
select emp_name, nvl(dept_code,'부서없음') from employee;

--------------------------------------------------------------------------------------

/*
    nvl2(컬럼, 반환값1, 반환값2)
    - 컬럼값이 존재하면 반환값1
    - 존재하지 않는다면 반환값2
*/

-- employee 테이블에서 사원명, 급여, 보너스, 성과급(보너스를 받는 사람은 50%, 보너스를 받지 않는 사람은 10%)
select emp_name, salary, nvl(bonus, 0), salary*nvl2(bonus, 0.5, 0.1) from employee;

-- employee 테이블에서 사원명, 부서(부서에 속해있다면 "부서있음", 아니면 "부서없음")
select emp_name 사원명, nvl2(dept_code, '부서있음', '부서없음') 부서여부 from employee;

---------------------------------------------------------------------------------------

/*
    nullif(비교대상1, 비교대상2)
    - 2개 값이 일치하면 null
    - 그렇지 않으면 비교대상1 값 반환
*/

select nullif('1972','1972') from dual;
select nullif('1972','1121') from dual;

------------------------------- 종합 문제 ----------------------------------
-- 1. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
select emp_name, 
substr(emp_no,1,2) as 생년,
substr(emp_no, 3,2) as 생월,
substr(emp_no,5,2) as 생일
from employee;
-- 2. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
select emp_name, substr(emp_no,1,6) || '-' || RPAD('*', 7, '*') as 주민번호 from employee;
-- 3. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
--   (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)
select emp_name, 
floor(abs(hire_date - sysdate)) 근무일수1,
floor(abs(sysdate-hire_date)) 근무일수2
from employee;
-- 4. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
select * from employee where mod(emp_id,2) = 1;
-- 5. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
select * from employee where floor(months_between(sysdate, hire_date)/12)>=20;
-- 6. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
select emp_name, to_char(salary,'L9,999,999') as "급여(형식포함)" from employee;
-- 7. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이 조회
--   (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며 
--   나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)
select emp_name, dept_code, to_char(to_date(substr(emp_no, 1,6),'rrmmdd'), 'yy"년" mm"월" dd"일"') as 생년월일,
floor(months_between(sysdate, to_date(substr(emp_no,1,6),'rrmmdd'))/12) 나이
from employee;
-- 8. EMPLOYEE테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리, 
--    주민번호 앞자리와 뒷자리의 합 조회
select emp_name, substr(emp_no,1,6) 앞자리,substr(emp_no,8,7) 뒷자리,
to_number(substr(emp_no,1,6)) + to_number(substr(emp_no,8,7)) 합계
from employee where emp_id = 201;
--------------------------------------------------------------------------------

/*
    decode(비교하려는 대상(컬럼이나 산술연산, 함수식 중 하나), 비교값1, 결과값1, 비교값2, 결과값2, ...)

    - switch case문과 유사
        switch(비교대상)
            case 비교값1:
                결과값1;
            case 비교값2:
                결과값2;
            ...
            default:
                결과값N;
*/

-- employee 테이블에서 사번, 사원명, 주민번호, 성별을 조회하라
select emp_id, emp_name, emp_no, 
decode(substr(emp_no,8,1),'1','남자','2','여자','3','남자','4','여자') 성별 
from employee;

-- employee 테이블에서 사번, 사원명, 직급, 직급별로 인상한 급여를 조회하라
-- J7인 사원은 급여 10%
-- J6인 사원은 급여 15%
-- J5인 사원은 급여 20%
-- 그외의 사원은 급여 5% 인상한다
select emp_id, emp_name, job_code,
decode(job_code,'J5',salary + salary*0.2,'J6', salary + salary*0.15, 'J7', salary + salary*0.1, salary+salary*0.05) 직급별_급여
from employee;

--------------------------------------------------------------------------------
--                          <선택 함수>
--------------------------------------------------------------------------------

/*
    case when then
    end
    
    case when 조건식1 then 결과값1
         when 조건식2 then 결과값2
         ...
         else 결과값N
    end
    
    프로그램의 if else문과 동일하다
    
    if(조건식)
        결과값1
    else if(조건식2)
        결과값2
    ...
    else
        결과값N
*/

-- employee 테이블에서 사원명, 급여, 급여에 따라 등급을 조회하라
-- 고급 : 500만원이상
-- 중급 : 300만원 이상이면서 500만원 미만
-- 초급 : 300만원 미만

select emp_name, salary, 
case when salary >= 5000000 then '고급'
     when salary >= 3000000 then '중급'
     else '초급'
end 등급
from employee;

--------------------------------------------------------------------------------
--                             <그룹 함수>
--------------------------------------------------------------------------------
/*
    sum(컬럼(숫자 타입)) : 해당 컬럼들의 합산을 반환한다
*/

-- employee 테이블의 급여의 총합
select sum(salary) 합계 from employee;

-- employee 테이블의 성별이 남자인 사원들의 급여 총합
select sum(salary) "합계(남자사원)" from employee where substr(emp_no,8,1) in ('1','3');
select sum(salary) "합계(남자사원)" from employee where decode(substr(emp_no,8,1),'1','남','3','남')='남';

-- employee 테이블 부서코드가 'D5'인 사원의 총 급여
select sum(salary) "합계(D5 사원)" from employee where dept_code = 'D5';

-- employee 테이블 부서코드가 'D5'인 사원의 총 연봉
select sum(salary*12) 연봉합계 from employee where dept_code = 'D5';

-- employee 테이블 모든 사원의 총 급여를 구하라 (형식: \999,999,000)
select to_char(sum(salary),'L999,999,999') 급여합계 from employee;

-- employee 테이블 부서코드가 'D5'인 사원의 총 연봉(보너스 포함)
select sum((salary+salary*nvl(bonus,0))*12) 연봉합계 from employee where dept_code = 'D5';

--------------------------------------------------------------------------------

/*
    avg(컬럼(숫자 타입)) : 해당 컬럼값들의 평균을 반환한다  
*/

-- employee 테이블에서 전 사원의 급여 평균
select avg(salary) from employee;
select round(avg(salary),0) from employee;

--------------------------------------------------------------------------------

/*
    min(컬럼(모든 타입)) : 해당 컬럼값들의 최소값을 반환한다
    max(컬럼(모든 타입)) : 해당 컬럼값들의 최대값을 반환한다
*/

select min(emp_name), min(salary), min(hire_date) from employee;
select max(emp_name), max(salary), max(hire_date) from employee;

--------------------------------------------------------------------------------

/*
    count(*|컬럼|distinct) : 행의 개수를 반환한다
    
    - count(*): 조회된 결과의 모든 행의 개수
    - count(컬럼): 제시한 컬럼의 null값을 뺀 행의 개수
    - count(distinct 컬럼): 해당 컬럼값에서 중복값을 뺀 행의 개수
*/

-- employee 테이블에서 전체 사원수
select count(*) 사원수 from employee;

-- employee 테이블에서 여성 사원수
select count(*) 사원수 from employee where decode(substr(emp_no,8,1),'2','여','4','여')='여';

-- employee 테이블에서 보너스를 주는 사원수
select count(*) 사원수 from employee where bonus is not null;
select count(bonus) 사원수 from employee;

-- employee 테이블에서 부서배치를 받은 사원수
select count(dept_code) 사원수 from employee;

-- employee 테이블에서 현재 사원이 총 몇개 부서에 분포돼있는지 조회하라
select count(distinct dept_code) 부서수 from employee;