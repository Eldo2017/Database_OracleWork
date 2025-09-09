/*
    - 시퀀스 sequence
      자동으로 번호를 발생시켜주는 역할을 하는 객체
      정수값을 순차적으로 일정값씩 증가시키면서 생성한다
      
      Ex) 회원번호, 사원번호, 게시글번호 등등
*/

/*
    1. 시퀀스 생성하기
    
       [표현법]
       create sequence 시퀀스명
       [start with 시작숫자]         -> 처음 발생시킬 시작점 숫자를 지정한다(기본값 1)
       [increment by 단위숫자]       -> 몇씩 증가시킬지 지정한다(기본단위값 1)
       [maxvalue 숫자]              -> 최대값을 지정한다
       [minvalue 숫자]              -> 최소값을 지정한다(지정 안하면 기본값 1)
       [cycle | nocycle]           -> 값의 순환 여부 지정(기본값 nocycle)
       [nocache | cache 바이트 크기] -> 캐시 메모리 할당(기본값 cache 20)

       캐시 메모리 : 미리 발생될 값들을 생성해 저장하는 공간
                   매번 호출될 때마다 새롭게 번호를 생성하는게 아닌
                   캐시 메모리에 미리 생성된 값들을 가져다 쓸 수 있다(속도가 빨라진다)
                   접속이 해제되면 -> 캐시 메모리에 미리 만들어 둔 번호들은 모두 날라간다(소멸한다)
*/
-- 시퀀스 생성
create sequence seq_test;

-- 옵션을 추가하여 생성
create sequence seq_empno
start with 226
increment by 1
maxvalue 250
nocycle
nocache;

/*
    2. 시퀀스 사용하기
    
    시퀀스명.currval : 현재 시퀀스값(마지막으로 성공적으로 수행한 nextval값)
    시퀀스명.nextval : 시퀀스값의 일정값을 증가시켜서 발생된 값
                     현재 시퀀스값에서 increment by값만큼 증가시킨 값
                     = 시퀀스명.currval + increment by값
*/

select seq_empno.currval from dual;
-- nextval을 단 한번도 수행하지 않은 이상 currval할 수 없다
-- currval은 성공적으로 수행된 nextval값이다

select seq_empno.nextval from dual;

select seq_empno.currval from dual;

select seq_empno.nextval from dual;
select seq_empno.nextval from dual;

/*
    3. 시퀀스 구조 바꾸기
    
    alter sequence 시퀀스명
    [increment by 숫자]
    [maxvalue 숫자]
    [minvalue 숫자]
    [cycle | nocycle]
    [cache | nocache]
    
    >> start with는 변경 불가
*/

alter sequence seq_empno
increment by 10
maxvalue 300;

select seq_empno.nextval from dual;

-- 시퀀스 삭제
drop sequence seq_empno;

--------------------------------------------------------------------------------
-- 사원번호를 sequence로 생성
create sequence seq_eid
start with 226
nocache;

insert into employee (emp_id, emp_name, emp_no, job_code, hire_date)
values(seq_eid.nextval,'이정재','020825-1039264','J2', sysdate);

insert into employee (emp_id, emp_name, emp_no, job_code, hire_date)
values(seq_eid.nextval,'조희창','061001-1532022','J3', sysdate);