-- 1. 학생 이름과 주소지를 조회하라
select student_name "학생 이름", student_address 주소지 from tb_student
order by student_name asc;

-- 2. 휴학생의 이름, 주민번호를 나이가 적은 순서대로 조회하라
select student_name, student_ssn from tb_student
where absence_yn = 'Y'
order by extract(year from sysdate) - (1900 + to_number(substr(student_ssn,1,2))) asc;

-- 3. 주소지가 강원도 또는 경기도인 학생들 중 1900년대 학번을 가진 학생명, 학번, 주소를 이름의 오름차순으로 화면에 출력하라.
select student_name 학생이름, student_no 학번, student_address "거주지 주소" from tb_student
where (substr(student_address,1,3)='경기도' or substr(student_address,1,3)='강원도')
and case
    when regexp_like(substr(student_no,1,2),'^[0-9]+')
    then (1900 + to_number(substr(student_no,1,2)))
    end between 1900 and 1999
order by student_name asc;

-- 4. 법학과 출신인 교수 중 제일 나이가 많은 사람부터 이름을 조회하라(법학과의 학과코드는 학과 테이블(tb_department)에)
select professor_name, professor_ssn from tb_professor
join tb_department using(department_no)
where department_no = '005'
order by (extract(year from sysdate) - (1900 + to_number(substr(professor_ssn,1,2)))) desc;

-- 5. 2004년 2학기에 C3118100(조형도예연구) 과목을 수강한 학생들의 학점을 찾아라
-- 조건 1) 학점이 높은 학생들부터
-- 조건 2) 만약 학점이 같을 경우, 학번이 낮은 학생들부터
select student_no, student_name, point from tb_student 
join tb_grade using(student_no)
join tb_class using(class_no)
where class_no = 'C3118100'
and substr(term_no,1,4) = 2004
and substr(term_no,5,2) = 02
order by point desc, student_no asc;

-- 6. 학번, 학생명, 학과명을 학생명으로 오름차순 정렬하라
select student_no, student_name, department_name from tb_student
join tb_department using(department_no)
order by student_name asc;

-- 7. 춘 기술대학교의 과목명, 학과명을 조회하라
select class_name, department_name from tb_class
join tb_department using(department_no);

-- 8. 과목별 교수명을 조회하라
select class_name, professor_name from tb_class
join tb_class_professor using(class_no)
join tb_professor using(professor_no);

-- 9. 8번에 있는 결과들 중 '인문사회' 계열의 과목만 선별하고 이에 속한 교수명도 조회하라
select class_name, professor_name from tb_class
join tb_class_professor using(class_no)
join tb_department using(department_no)
join tb_professor using(professor_no)
where category = '인문사회';

-- 10. 음악과 학생들의 평점을 구하라 (학번, 학생명, 전체 평점)
select student_no 학번, student_name "학생 이름", round(avg(point),1) "전체 평점"
from tb_student
join tb_department using(department_no)
join tb_grade using(student_no)
where department_name = '음악학과'
group by student_no, student_name
order by student_no;

-- 11. 학번이 A313047인 서인화가 학교에 안나와서 지도 교수에게 내용 전달을 목적으로 한다.
-- 그래서 서인화의 소속 학과 및 지도 교수 이름을 찾아라
select department_name 학과이름, student_name 학생이름, professor_name 지도교수이름 
from tb_student s
join tb_department using(department_no)
join tb_professor p on (s.coach_professor_no = p.professor_no)
where student_no = 'A313047';

-- 12-1. 2007년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생명과 수강기간을 조회하라
select student_name, term_no from tb_student
join tb_grade using(student_no)
join tb_class using(class_no)
where to_number(substr(term_no,1,4)) = 2007
and class_name = '인간관계론'
order by student_name asc;

-- 12-2. 2005년도에 '인공관절대치론' 과목을 수강한 학생을 찾아 학생명과 수강기간을 조회하라
select student_name, term_no from tb_student
join tb_grade using(student_no)
join tb_class using(class_no)
where to_number(substr(term_no,1,4)) = 2005
and class_name = '인공관절대치론'
order by student_name asc;

-- 13. 예체능 계열 과목 중 과목 담당교수 배정이 하나도 안된 과목 정보를 조회하라
-- (과목명, 학과명 이용)
select class_name, department_name from tb_class
join tb_department using(department_no)
left join tb_class_professor using(class_no)
where category = '예체능' and professor_no is null;

-- 14-1. 서반아어학과 학생들의 지도교수를 찾아라
-- 조건 : 만약 지도 교수가 없는 학생들이면 "지도 교수 미지정"이라고 표시한다)
select student_name 학생이름, nvl(professor_name,'지도교수 미지정') 지도교수
from tb_student s
join tb_department using(department_no)
left join tb_professor p on s.coach_professor_no = p.professor_no
where department_name = '서반아어학과';

-- 14-2. 물리학과 학생들의 지도교수를 찾아라
select student_name 학생이름, nvl(professor_name,'지도교수 미지정') 지도교수
from tb_student
join tb_department using(department_no)
left join tb_professor on coach_professor_no = professor_no
where department_name = '물리학과';

-- 15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생들의 학번, 이름, 학과명, 평점을 찾아라
select student_no 학번, student_name 이름, department_name 학과명, round(avg(point),8) 평점
from tb_student
join tb_department using(department_no)
join tb_grade using(student_no)
where absence_yn = 'N'
group by student_no, student_name, department_name having avg(point) >= 4.0
order by 학번 asc;

-- 16. 환경조경학과 전공과목들의 과목별 평점을 찾아라
select class_no, class_name, round(avg(point),8) as "AVG(POINT)" from tb_class
join tb_grade using(class_no)
join tb_department using(department_no)
where department_name = '환경조경학과'
group by class_no, class_name
order by class_no asc;

-- 17-1. 이 대학교(춘 기술대학교)에 다니고 있는 최인순 학생과 같은 과에 속한 학생의 이름, 주소를 찾아라
select student_name 이름, student_address 주소 from tb_student
where department_no = (select department_no from tb_student where student_name = '최인순');

-- 17-2. 이 대학교(춘 기술대학교)에 다니고 있는 김유찬 학생(서울 서대문구)과 같은 과에 속한 학생의 이름, 주소를 찾아라
select student_name 이름, student_address 주소 from tb_student s
where department_no = (select department_no from tb_student where student_name = '김유찬' and substr(student_address,1,6) = '서울서대문구');

-- 18-1. 국어국문학과에서 총 평점이 가장 높은 학생의 학번과 이름을 찾아라
select student_no, student_name from tb_student
join tb_department using(department_no)
join tb_grade using(student_no)
where department_name='국어국문학과'
group by student_no, student_name
having avg(point) = (
select max(avg(point)) from tb_student
join tb_department using(department_no)
join tb_grade using(student_no)
where department_name='국어국문학과'
group by student_no);

-- 18-2. 행정학과에서 총 평점이 가장 높은 학생의 학번과 이름을 찾아라
select student_no, student_name from tb_student
join tb_department using(department_no)
join tb_grade using(student_no)
where department_name = '행정학과'
group by student_no, student_name
having avg(point) = (
select max(avg(point)) from tb_student
join tb_department using(department_no)
join tb_grade using(student_no)
where department_name = '행정학과'
group by student_no);
-- fetch first n rows only -> 12c 이상 버전에서 사용한다

-- 간단 답안 --

-- 19-1. 이 학교의 "환경조경학과"가 속해있는 같은 계열 학과들의 이름하고 전공 평점을 찾아라
select department_name "계열 학과명", round(avg(point),1) 전공평점 from tb_department
join tb_student using(department_no)
join tb_grade using(student_no)
where category = (
select category from tb_department where department_name = '환경조경학과'
)
group by department_name
order by 전공평점 asc;

-- 19-2. 이 학교의 "전자공학과"가 속해있는 같은 계열 학과들의 이름하고 전공 평점을 찾아라
select department_name "계열 학과명", round(avg(point),1) 전공평점 from tb_department
join tb_student using(department_no)
join tb_grade using(student_no)
where category = (
select category from tb_department where department_name = '전자공학과'
)
group by department_name order by 전공평점 desc;