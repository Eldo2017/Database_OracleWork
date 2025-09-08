-- 1. 과목유형 테이블(tb_class_type)에 데이터를 추가하라
insert into tb_class_type values
(01,'전공필수');
insert into tb_class_type values
(02,'전공선택');
insert into tb_class_type values
(03,'교양필수');
insert into tb_class_type values
(04,'교양선택');
insert into tb_class_type values
(05,'논문지도');

-- 2. 춘 기술대학교 학생들 정보가 포함돼있는 학생일반정보 테이블을 만들려고 한다. 
-- 서브쿼리를 이용해 sql문을 완성하라
create table tb_student_info
as select student_no 학번, student_name 학생이름, student_address 주소
from tb_student;

-- 3. 국어국문학과 학생들 정보만이 포함된 학과정보 테이블을 생성하라
create table tb_korean
as select student_no 학번, student_name 학생이름, to_date(substr(student_ssn,1,6),'rrmmdd') as 출생년도, nvl(professor_name,'지도교수 없음') as 교수명
from tb_student s
join tb_professor p on s.coach_professor_no = p.professor_no
join tb_department d on s.department_no = d.department_no
where d.department_name='국어국문학과';

-- 4. 현 학과들의 정원을 10% 증가시키는 sql문을 작성하라
update tb_department set capacity = round(capacity + capacity*0.1);

-- 5. 학번이 A413042인 차기철 학생의 주소를 "서울시 종로구 숭인동 181-21"로 바꿔라
update tb_student set student_address = '서울시 종로구 숭인동 181-21'
where student_name = '차기철';

-- 6. 주민등록번호 뒷자리를 지우고 앞자리만 남기게 만들어라
update tb_student set student_ssn = substr(student_ssn,1,6);

-- 7. 의학과 도창수 학생이 2005년 1학기에 수강한 '피부생리학' 점수가 잘못되어 담당 교수의
-- 확인 결과, 해당 과목 학점이 3.5로 반영된다고 했다. 이대로 반영시켜라
update tb_grade g set g.point = 3.5
where g.student_no = (
select s.student_no from tb_student s join tb_department d using(department_no)
where s.student_name = '도창수' and d.department_name = '의학과')
and g.class_no = (select c.class_no from tb_class c where c.class_name= '피부생리학')
and g.term_no = '200501';

-- 8. 휴학생들의 성적항목을 제거하라 (성적 테이블 : tb_grade 이용)
delete from tb_grade where student_no in (select student_no from tb_student where absence_yn='Y');

rollback;