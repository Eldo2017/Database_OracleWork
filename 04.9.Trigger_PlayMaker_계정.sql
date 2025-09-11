/*
    <트리거 TRIGGER>
    내가 지정한 테이블에 DML문에 의해 변경사항(이벤트)이 생겼을 때
    자동으로 매번 실행할 내용을 미리 정의해둘 수 있는 객체
    
    EX)
    회원탈퇴시 기존 회원테이블에서 삭제후 곧바로 탈퇴회원들만 보관하는 테이블에 자동으로 INSERT
    신고횟수가 일정수를 넘기면 묵시적으로 해당 회원을 블랙리스트 처리
    입출고에 대한 데이터가 기록(INSERT)할 때마다 해당 상품의 재고수량을 매번 수정(UPDATE)해야 될 때
    
    * 트리거의 종류
    - SQL문의 실행시기에 따른 분류
      > BEFORE TRIGGER : 명시한 테이블에 이벤트가 발생되기 전에 트리거 실행
      > AFTER TRIGGER : 명시한 테이블에 이벤트가 발생되기 후에 트리거 실행
      
    - SQL문에 의해 영향을 받는 각 행에 따른 분류
      > STATEMENT TRIGGER(문장 트리거) : 이벤트가 발생한 SQL문에 대해 딱 한번만 트리거 실행
      > ROW TRIGGER(행 트리거) : 해당 SQL문 실행할 때 마다 매번 트리거 실행
                                (FOR EACH ROW 옵션을 기술해야함)
                                > :OLD - 기존컬럼에 들어 있던 데이터
                                > :NEW - 새로 들어온 데이터
                                
    * 트리거의 생성 구문
      [표현식]
      CREATE [OR REPLACE] TRIGGER 트리거명
      BEFORE|AFTER INSERT|UPDATE|DELETE ON 테이블명
      [FOR EACH ROW]
      [DECLARE 변수선언;]
      BEGIN
        실행내용(지정된 이벤트가 발생되면 자동으로 실행할 구문)
      [EXCEPTION 예외처리구문;]
      END;
      /
    
    * 트리거의 삭제
      DROP TRIGGER 트리거명;
*/

SET SERVEROUT ON;

-- EMPLOYEE테이블에 새로운 행이 INSERT 될 때마다 자동으로 메시지 출력하는 트리거 정의
CREATE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원님 환영합니다');
END;
/

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES(500, '더조은', '050812-1234567', 'D5', 'J2', SYSDATE);


INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES(501, '김하나', '030812-2234567', 'D5', 'J5', SYSDATE);