/*
    - PL / SQL
      오라클 자체에 내장된 절차적 언어
      SQL문장 내에서 변수의 정의, 조건 처리(if), 반복 처리(loop, for, while) 등을 지원하여 sql의 단점을 보완
      다수의 sql문을 한번에 실행 가능(block 구조)
      
    - PL / SQL 구조
      - 선언부 (Declare section) : Declare로 시작, 변수나 상수를 선언 및 초기화하는 부분이다
      - 실행부 (Executable section) : bwgin으로 시작, sql문이나 제어문(조건문, 반복문) 등의 로직을 기술하는 부분이다
      - 예외 처리부 (Exception section) : Exception으로 시작, 예외 발생 시 해결하기 위한 구문을 미리 기술해둘 수 있는 부분이다
*/

-- 화면에 출력하기 위해 반드시 ON으로 설정하라
set serveroutput on;

begin
    -- System.out.println("나 사나이다"); -> 자바
    dbms_output.put_line('나 사나이다');
end;
/

/*
    1. Declare 선언부
       변수나 상수를 선언하는 공간(선언과 동시에 초기화도 된다)
       일반 타입 변수, 레퍼런스 변수, Row 타입 변수
       
       1) 일반 타입 변수 선언 및 초기화
       
       [표현법]
       
       변수명 [constant] 자료형 [:= 값]
*/

declare 
    eid number;
    ename varchar2(20);
    pi constant number := 3.14;
    
begin
    eid := 700;
    ename := '김두한';
    dbms_output.put_line(eid);
    dbms_output.put_line('이름 : ' || ename);
    dbms_output.put_line(pi);
end;
/

set serveroutput on;

--------------------------------------------------------------------------------
declare
   eid number;
   ename varchar2(20);

begin
    eid := &번호;
    ename := '&이름';
    
    dbms_output.put_line('eid : ' || eid);
    dbms_output.put_line('ename : ' || ename);
end;
/

--------------------------------------------------------------------------------
/*
    2. 레퍼런스 변수
       어떤 테이블의 어떤 컬럼의 데이터타입을 참조해 그 타입으로 지정한다
       
       [표현법]
       변수명 테이블명.컬럼명%type;
*/

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    sal employee.salary%type;
begin
    eid := 300;
    ename := '최갈치';
    sal := 3000000;
    
    dbms_output.put_line('eid : ' || eid);
    dbms_output.put_line('ename : ' || ename);
    dbms_output.put_line('sal : ' || sal);
    
end;
/

-- 사번이 200번인 사원의 사번, 사원명, 급여를 조회 후 각 변수에 대입하라
select emp_id, emp_name, salary from employee where emp_id = 200;

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    sal employee.salary%type;
begin
    select emp_id, emp_name, salary
    into eid, ename, sal
    from employee
    where emp_id = 200;
    
    dbms_output.put_line('eid : ' || eid);
    dbms_output.put_line('ename : ' || ename);
    dbms_output.put_line('sal : ' || sal);
    
end;
/

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    sal employee.salary%type;
begin
    select emp_id, emp_name, salary
    into eid, ename, sal
    from employee
    where emp_id = &사번;
    
    dbms_output.put_line('eid : ' || eid);
    dbms_output.put_line('ename : ' || ename);
    dbms_output.put_line('sal : ' || sal);
    
end;
/

-- 예제
/*
    레퍼런스 변수를 이용하여 eid, ename, jcode, sal, dtitle을 만들고
    각 자료형 employee(emp_id, emp_name, job_code, salary), 
    department(dept_title)을 참조하도록 하라.
    
    그리고 사용자가 입력하는 사번의 사원명, 직급코드, 급여, 부서명을 조회하하고
    각 변수에 대입하여 출력하라
*/

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    jcode employee.job_code%type;
    sal employee.salary%type;
    dtitle department.dept_title%type;
    
begin
    select emp_id, emp_name, job_code, salary, dept_title
    into eid, ename, jcode, sal, dtitle
    from employee
    join department on dept_id = dept_code
    where emp_id = &사번;
    
    dbms_output.put_line('사번 : ' || eid);
    dbms_output.put_line('이름 : ' || ename);
    dbms_output.put_line('직급코드 : ' || jcode);
    dbms_output.put_line('급여 : ' || sal);
    dbms_output.put_line('부서명 : ' || dtitle);
end;
/
    
--------------------------------------------------------------------------------
/*
    3. row 변수
       테이블 한 행에 대한 모든 컬럼값을 모두 담을 수 있는 변수
       
       [표현법]
       변수명 테이블명%rowtype;
*/

declare
    e employee%rowtype;
begin
    select * into e from employee where emp_id = &사번;
    dbms_output.put_line('사원명 : ' || e.emp_name);
    dbms_output.put_line('급여 : ' || e.salary);
    -- dbms_output.put_line('보너스 : ' || e.bonus);
    -- dbms_output.put_line('보너스 : ' || nvl(e.bonus,'없음')); -> 오류: 타입이 맞지 않아서 생기는 것
    dbms_output.put_line('보너스 : ' || nvl(e.bonus,0));
end;
/

-- 아래는 오류 발생
declare
    e employee%rowtype;

begin
    select emp_name, salary, bonus -- 무조건 *을 사용해야 가능하다
    into e
    from employee
    where emp_id = '&사번';
    
    dbms_output.put_line('사원명 : ' || e.emp_name);
    dbms_output.put_line('급여 : ' || e.salary);
    dbms_output.put_line('보너스 : ' || nvl(e.bonus,0));

end;
/
--------------------------------------------------------------------------------
/*
    2. begin 실행부
     - 조건문
     1) 단일 if문 : 
        if 조건식 then 실행내용 end if
        
     2) if else문 1 :
        if 조건식 then 실행내용
        else 실행내용 end if
        
     3) if else문 2 :
        if 조건식1 then 실행 내용1;
        elsif 조건식2 then 실행 내용2;
        elsif 조건식3 then 실행 내용3;
        else 실행 내용4
        end if
*/

-- 사번을 입력받은 후 해당 사원의 사번, 사원명, 급여, 보너스율(%)을 출력하는데
-- 단, 보너스를 받지 않는 사원의 경우, 보너스율을 출력 전 '보너스를 받지 않는 사원'이라 메시지를 띄워라

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    sal employee.salary%type;
    bonus employee.bonus%type;
    
begin
    select emp_id, emp_name, salary, nvl(bonus,0)
    into eid, ename, sal, bonus
    from employee
    where emp_id = '&사번';
    
    dbms_output.put_line('사번 : ' || eid);
    dbms_output.put_line('사원명 : ' || ename);
    dbms_output.put_line('급여 : ' || sal);
    if bonus = 0
        then dbms_output.put_line('보너스를 받지 않는 사원');
    end if;
    dbms_output.put_line('보너스 : ' || bonus*100||'%');  
end;
/
    
declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    sal employee.salary%type;
    bonus employee.bonus%type;
    
begin
    select emp_id, emp_name, salary, nvl(bonus,0)
    into eid, ename, sal, bonus
    from employee
    where emp_id = '&사번';
    
    dbms_output.put_line('사번 : ' || eid);
    dbms_output.put_line('사원명 : ' || ename);
    dbms_output.put_line('급여 : ' || sal);
    if bonus = 0
        then dbms_output.put_line('보너스를 받지 않는 사원');
    else
        dbms_output.put_line('보너스 : ' || bonus*100||'%');
    end if;
end;
/

-- 예제
/*
    레퍼런스 변수 : eid, ename, dtitle, ncode
    참조 컬럼 : emp_id, emp_name, dept_title, national_code
    일반 변수 : team(소속)
    
    실행문 : 사용자가 입력한 사번의 사번, 이름, 부서명, 근무국가코드를 변수에 대입한다
            단) ncode값이 KO라면? -> team 변수에 '국내팀 소속'
               ncode값이 KO가 아니라면? -> team 변수에 '해외팀 소속'
*/

set serveroutput on;

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    dtitle department.dept_title%type;
    ncode location.national_code%type;
    team varchar2(20);
    
begin
    select emp_id, emp_name, dept_title, national_code
    into eid, ename, dtitle, ncode
    from employee
    join department on dept_id = dept_code
    join location on location_id = local_code
    where emp_id = &사번;
    
    if ncode = 'KO'
        then team := '국내팀 소속';
    else
        team := '해외팀 소속';
    end if;
    
    dbms_output.put_line('사번 : ' || eid);
    dbms_output.put_line('사원명 : ' || ename);
    dbms_output.put_line('부서명 : ' || dtitle);
    dbms_output.put_line('근무국가 코드 : ' || ncode);
    dbms_output.put_line('소속 : ' || team);
end;
/
    
-- 사용자로부터 점수를 입력받아 학점 출력
-- 변수 2개 필요 (점수, 학점)

declare
    score number;
    grade char(1);

begin
    score := &점수;
    
    if score >= 90 then grade := 'A';
    elsif score >= 80 then grade := 'B';
    elsif score >= 70 then grade := 'C';
    elsif score >= 60 then grade := 'D';
    else grade := 'F';
    end if;
    
    dbms_output.put_line('당신의 점수 : '|| score);
    dbms_output.put_line('학점 : ' || grade);
end;
/
    
-- 예제
/*
    사용자에게 입력받은 사번의 급여를 조회하고 sal변수에 대입한다.
    그리고 그게 500만원 이상이면 '고급', 300만원 이상이면 '중급', 
    그 이하도 아닌 경우는 '초급'으로 설정하여 보여줘야 한다.
    
    출력 : ??? 사원의 급여 등급 : ???
*/

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    sal varchar2(10);
    sal2 employee.salary%type;
    
begin
    select emp_id, emp_name, salary
    into eid, ename, sal2
    from employee
    where emp_id = &사번;
    
    if sal2 >= 5000000 then sal := '고급';
    elsif sal2 >= 3000000 then sal := '중급';
    else sal := '초급';
    end if;

    dbms_output.put_line(ename || ' 사원의 급여 등급 : ' || sal);
    
end;
/