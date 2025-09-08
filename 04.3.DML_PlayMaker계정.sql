/*
    - alter
      객체를 변경하는 구문
      
      [표현법]
      alter table 테이블명 변경할 내용;
      
      - 변경할 내용
        1) 컬럼 추가 / 수정 / 삭제
        2) 제약조건 추가 / 삭제 (수정만 할 수 없다 -> 삭제 후 다시 추가)
        3) 컬럼명 / 제약조건명 / 테이블명 수정
*/

------------------------------------------------------------------------
/*
    1. 컬럼 추가 / 수정 / 삭제
        1) 컬럼 추가(add)
        
        [표현법]
        add 컬럼명 데이터타입 [default 기본값]
*/

-- dept_copy 테이블에 cname(varchar2(20)) 컬럼 추가
alter table dept_copy add cname varchar2(20);

-- dept_copy 테이블에 lname(varchar2(20)) default는 한국으로 컬럼 추가
alter table dept_copy add lname varchar2(20) default '한국';

-------------------------------------------------------------------------
/*
    2. 컬럼 타입이나 데이터타입 수정 (modify)
    
        1) 데이터 타입 수정
        [표현법]
        modify 컬럼명 바꾸려고 하는 데이터 타입
        
        2) default값 수정
        [표현법]
        modify 컬럼명 default 바꾸려고 하는 기본값
*/

-- dept_copy 테이블의 dept_id의 데이터 타입을 char(3)로 변경
alter table dept_copy modify dept_id char(3);

-- dept_copy 테이블의 dept_id의 데이터 타입을 number로 변경
alter table dept_copy modify dept_id number;
-- 오류: 컬럼에 영문이 있고, 컬럼의 데이터 유형을 바꾸려면 그 컬럼의 값을 모두 지워야 가능하다

-- dept_copy 테이블의 dept_title의 데이터의 바이트를 10으로 바꿔라
alter table dept_copy modify dept_title varchar2(10);
-- 오류 : 컬럼 데이터값이 10바이트 넘는 것도 있다

-- dept_copy 테이블의 dept_title 컬럼을 varchar2(40)으로 바꿔라
alter table dept_copy modify dept_title varchar2(40);
-- dept_copy 테이블의 location_id 컬럼을 varchar2(2)으로 바꿔라
alter table dept_copy modify location_id varchar2(2);
-- dept_copy 테이블의 lname 컬럼의 기본값을 '미국'으로 바꿔라
alter table dept_copy modify lname default '미국';
-- 다중변경도 된다
alter table dept_copy 
modify dept_title varchar2(40)
modify location_id varchar2(2)
modify lname default '미국';

-------------------------------------------------------------------------
/*
    3. 컬럼 삭제
    
    [표현법]
    drop column 컬럼명
*/
create table dept_copy2
as select * from dept_copy;

-- dept_copy2 테이블에서 dept_id 컬럼을 삭제
alter table dept_copy2 drop column dept_id;

-------------------------------------------------------------------------
/*
    4. 제약조건 추가 / 삭제
        1) 제약조건 추가
            alter table 테이블명 추가나 변경할 내용
                - primary key : alter table 테이블명 add primary key(컬럼명)
                - foreign key : alter table 테이블명 add foreign key(컬럼명) references 참조할 테이블명 [(참조할 컬럼명)]
                - unique : alter table 테이블명 add unique(컬럼명)
                - check : alter table 테이블명 add check(컬럼에 대한 조건식)
                - not null : alter table 테이블명 modify 컬럼명 not null
                
            --> 제약조건명을 지정하러면? : constraint 제약조건명 제약조건
        2) 제약조건 삭제
            drop constraint 제약조건
            modify 컬럼명 null / not null
*/

-- dept_copy 테이블에서 dept_id에 primary key 제약조건 추가하기
alter table dept_copy add primary key (dept_id);
-- dept_copy 테이블에서 dept_title의 값이 유일한 값이어야 하는 제약조건을 적어라
alter table dept_copy add unique(dept_title);
-- dept_copy 테이블에서 lname 값이 null을 가질수 없게 하라
alter table dept_copy modify lname not null;

rollback;

-- 다중 연결 가능
alter table dept_copy
add constraint dcopy_pk primary key (dept_id)
add constraint dcopy_uq unique (dept_name)
modify lname constraint dcopy_nn not null;

-- 제약조건 dcopy_pk를 삭제
alter table dept_copy drop constraint dcopy_pk;
alter table dept_copy modify lname null;

-------------------------------------------------------------------------
/*
    5. 컬럼명 / 제약조건명 / 테이블명 변경
        1) 컬럼명 변경하기
            [표현법]
            rename column 기존컬럼명 to 변경컬럼명
            
        2) 제약조건명 변경하기
            [표현법]
            rename constraint 기존제약조건명 to 변경제약조건명
*/
-- dept_copy 테이블의 dept_title을 dept_name으로 바꿔라
alter table dept_copy rename column dept_title to dept_name;

-- dept_copy 테이블의 dcopy_uq의 제약조건명을 dcopy_unique로 바꿔라
alter table dept_copy rename constraint dcopy_uq to dcopy_unique;

-------------------------------------------------------------------------
/*
    6. 테이블 삭제
*/

drop table dept_copy2;

/*
    - 테이블을 삭제 시 외래키의 부모테이블은 삭제가 되지 않는다
      그래도 정 삭제하려면
      1) 자식 테이블 먼저 삭제한 뒤, 부모테이블을 삭제
      2) 부모테이블만 삭제하는데 제약조건을 같이 삭제
      drop table 부모테이블명 cascade constraints
*/