-- 1. 영어영문학과(학과코드 002) 학생들 정보 출력하기
select student_no as 학번, 
student_name as 이름, 
to_char(to_date(entrance_date,'rrrr-mm-dd'),'rrrr-mm-dd') as 입학년도 
from tb_student
where department_no = '002'
order by to_date(entrance_date,'rrrr-mm-dd') asc;

-- 2. 이름이 세 글자가 아닌 교수 이름, 주민번호 조회하기
select professor_name, professor_ssn from tb_professor where length(professor_name)!=3;

-- 3. 남자 교수들의 이름, 나이를 조회하라 (나이는 오름차순, 2000년 이후 출생자가 없다 생각하고 나이는 만으로 통일하라)
select professor_name 교수이름, floor(months_between(
                                    sysdate, 
                                    to_date(
                                    case when substr(professor_ssn,8,1) in ('1','2') 
                                    then '19' || substr(professor_ssn,1,6) 
                                    end, 'yyyymmdd'))/12) as 나이
from tb_professor
where substr(professor_ssn,8,1) in ('1','3') -- 남자만 추출한다
order by 나이 asc;

-- 4. 성을 제외한 이름만 조회하라 (성이 두 글자인 이름 제외)
select substr(professor_name, 2) 이름 from tb_professor
where substr(professor_name,1,2) not in ('독고');

-- 5. 기술대학교 재수생 입학자를 찾아라 (19살에 입학하면 재수를 안 했다고 간주한다)
select student_no, student_name from tb_student where extract(year from entrance_date) - extract(year from to_date(substr(student_ssn,1,2),'rrrr')) > 19;

-- 6. 2020년 크리스마스는 무슨 요일?
select to_char(to_date('20201225', 'yyyymmdd'), 'day') 전체요일, to_char(to_date('20201225', 'yyyymmdd'), 'dy') 약식요일
from dual;

-- 7. 기술대학교 2000년도 이전 학생들의 학번, 이름을 조회하라
select student_no, student_name from tb_student 
where entrance_date < to_date('2000-01-01','yyyy-mm-dd');

-- 8. 학번이 A517178인 한아름 학생의 학점의 총 평점은?
select round(avg(point),1) as 평점
from tb_grade
where student_no = 'A517178';