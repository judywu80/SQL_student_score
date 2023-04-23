--�ǥͦ��Z-SQL�y�k�m��
--������YSTUDENT.MDB (ACCESS��) �H �˵�SQL �� �˵��]�p �@�U�C�m��:
--���ǭ��o�H�NYSTUDENT.MDB �নMS SQL��MYSQL����Ʈw�A�A�H��y�k�@���C
--���D�ؤ���A�BB�BC ���D��1�p�D�A�@���D�O A+B ���@�D�A�i���D�� A+B+C���@�D�C

--���ƦW�W�h�G�p5�ӤH�A�䤤��3�W��2�ӤH�A�h�ƦW�� 1,2,3,3,5�A�C�e3�W�ɡA���ӭn�C1,2,3,3�@4�ӤH�C

--�V��]��ؤ��P, ��L��쭫�ƭȦpsno, name�A��gruop by�����έp
--1. �Эp��C�ӤH���`���Z�Υ���(�p��1��):
--���p�k�G�Ǹ��A�m�W�A�`���A�����C--��join,���e�n�[���W;���έp�n�[group by; *�γ]�p�d��: sum(score) from yscore=SUM(YSCORE.SCORE)
--�ƧǡG�`��(����)�C
SELECT  STUDENT.SNO, STUDENT.NAME, SUM(YSCORE.SCORE) AS �`��, convert(decimal(4,1),AVG(YSCORE.SCORE*1.0)) ����
FROM      STUDENT INNER JOIN YSCORE ON STUDENT.SNO = YSCORE.SNO
GROUP BY STUDENT.SNO, STUDENT.NAME order by �`�� desc --�u�g���

--2. �Эp��C�ӤH��쪺�̰����Z:--�ӽX�Ȳ�40�D,���αƦW(dense�k)���̰���
--���p�k�G�Ǹ��A�m�W�A��ءA�̰����Z�C--�쪽���̰���max(score)�����p����ر���(?)->�x���Ȳ�40�D��(5�@�k)
--�ƧǡG�Ǹ�(���W)�C--�����ܦh�Ѫkleft join,union�K�Sԣ�ΤW
select ranked.sno,student.NAME,ranked.subject,ranked.score �̰����Z 
from (
select *, rank() over(partition by sno order by score desc) as rowno from yscore --rowid "�U�Ǹ�����,�̦U�즨�Z���C,�ƦW"
) as ranked      --ranked�O���
inner join student on student.sno=ranked.sno
where ranked.rowno = 1 order by ranked.sno --���̰��ƦW(���Z)

--3. �ЦC�X�U����ئ��Z�̦n���ǥ�: --�޿�P�W
--���p�k�G�Ǹ��A�m�W�A��ءA���Z�C
--�ƧǡG���Z(����)�C
select ranked.sno,student.NAME,ranked.subject,ranked.score 
from (
select *, rank() over(partition by subject order by score desc) as rowno from yscore
) as ranked      --ranked�O���
inner join student on student.sno=ranked.sno
where ranked.rowno = 1
order by ranked.score desc

--4. �ЦC�X�U����ئ��Z�̦n����W�ǥ�(�p��2�W���h�H�P���̡A�h�@�_�æC): 
--���p�k�G�Ǹ��A�m�W�A��ءA���Z�C
--�ƧǡG���(���W), ���Z(����)�C
select ranked.sno,student.NAME,ranked.subject,ranked.score 
from (
select *, rank() over(partition by subject order by score desc) as rowno from yscore
) as ranked      
inner join student on student.sno=ranked.sno
where ranked.rowno <=2
order by ranked.subject, ranked.score desc

--5. �ЦC�X�C�ӤH���U�즨�Z�H�βέp�`���B���� (�p��1��)�G(�i���D)
--���p�k�G�Ǹ��A�m�W�A���A�ƾǡA�^��A�`���A�����C--3���self join*2, �Ajoin(���)�D1
--�ƧǡG�`��(����)�C 
Select G.SNO, G.NAME, S.���, S.�ƾ�, S.�^��, G.�`��, G.���� 
from (
SELECT  STUDENT.SNO, STUDENT.NAME, sum(YSCORE.SCORE) AS �`��, convert(decimal(4,1),AVG(YSCORE.SCORE*1.0)) ����
FROM     STUDENT INNER JOIN YSCORE ON STUDENT.SNO = YSCORE.SNO
GROUP BY STUDENT.SNO, STUDENT.NAME) G 
join (select yscore.sno, yscore.score ���, y.score �ƾ�, z.SCORE �^�� from yscore join yscore y on YSCORE.sno=y.SNO join yscore z on YSCORE.sno=z.SNO
where yscore.subject='���' and y.subject ='�ƾ�' and z.SUBJECT='�^��') S 
on G.sno=S.SNO order by �`�� desc

--6. �ЦC�X�U����ت��������Z(�p��1��)�G
--���p�k�G��ءA��إ����C
--�ƧǡG���(���W)�C
select subject, convert(decimal(4,1),avg(SCORE*1.0)) �쥭�� from yscore group by subject order by subject

--7. �ЦC�X�^�妨�Z���ƦW�G(�i���D)
--���p�k�G�Ǹ��A�m�W�A�^��A�ƦW
--�ƧǡG�^�����(����)�A�Ǹ�(���W)�C
select ranked.sno,student.NAME,ranked.subject,ranked.score,ranked.rowno 
from (
select *, rank() over(partition by subject order by score desc) as rowno from yscore
) as ranked      
inner join student on student.sno=ranked.sno
where ranked.SUBJECT='�^��'
order by ranked.score desc, ranked.SNO

--8. �ЦC�X�ƾǦ��Z�b2-3�W���ǥ͡G
--���p�k�G�Ǹ��A�m�W�A��ءA���Z
--���Z(����)
select ranked.sno,student.NAME,ranked.subject,ranked.score 
from (
select *, rank() over(partition by subject order by score desc) as rowno from yscore
) as ranked      
inner join student on student.sno=ranked.sno
where ranked.rowno between 2 and 3 and ranked.SUBJECT='�ƾ�'
order by ranked.score desc

--9. �ЦC�X�U����ؤ����ή�(0-59)�ӡA�}(60-80)�ӡA�u(81-100)��--������
--���p�k�G��ءA���ή�A�}�n�A�u�q
--���(���W)�C
Select A.subject, A.���ή�, B.�}�n, C.�u�q 
from (
Select subject, count(score) ���ή� from yscore where score<60 group by subject) A
join (
Select subject, count(score) �}�n from yscore where score between 60 and 80 group by subject) B
on A.subject= B.subject
join (
Select subject, count(score) �u�q from yscore where score >80 group by subject) C
on A.subject= C.subject
order by subject

--10. �ЦC�X�Ǹ����@1002�B1005�B1006�B1009���ƾǤ��ơG
--���p�k�G�Ǹ��A�m�W�A�ƾ�
--�Ǹ�(���W)�C
select ranked.sno,student.NAME,ranked.subject,ranked.score 
from (
select *, rank() over(partition by subject order by score desc) as rowno from yscore
) as ranked      
inner join student on student.sno=ranked.sno
where ranked.sno in (1002,1005,1006,1009) and ranked.SUBJECT='�ƾ�'
order by ranked.SNO

--11. �Эp��C�@�Ӭ�س��ή檺�ǥͤ��`�������Z(�p��2��)
--���p�k�G�Ǹ��A�m�W�A���A�ƾǡA�^��A����
--�Ǹ�(���W)�C
--��ܦX�G����ǥͪ��`����(�p��2��)��̥��C���̥���(�i���D)�C
Select G.SNO, G.NAME, S.���, S.�ƾ�, S.�^��, G.���� from
(SELECT  STUDENT.SNO, STUDENT.NAME, convert(decimal(5,2),SUM(YSCORE.SCORE)/3.0) ����
FROM     STUDENT INNER JOIN YSCORE ON STUDENT.SNO = YSCORE.SNO
GROUP BY STUDENT.SNO, STUDENT.NAME) G 
join (select yscore.sno, yscore.score ���, y.score �ƾ�, z.SCORE �^�� from yscore join yscore y on YSCORE.sno=y.SNO join yscore z on YSCORE.sno=z.SNO
where yscore.subject='���' and y.subject ='�ƾ�' and z.SUBJECT='�^��') S on G.sno=S.SNO 
where s.���>60 and s.�ƾ�>60 and s.�^��>60 order by g.SNO

--12. �Эp��Ǹ� 1002����妨�Z���ƦW�G(�i���D)(�ƦW��Rank Over�P���P�W��)
--���p�k�G�Ǹ��A�m�W�A���A�ƦW 
select ranked.sno,student.NAME,ranked.subject,ranked.score, ranked.rowno �ƦW 
from (
select *, rank() over(partition by subject order by score desc) as rowno from yscore
) as ranked      
inner join student on student.sno=ranked.sno
where ranked.sno='1002' and ranked.SUBJECT='���'
order by ranked.score desc

--13. �ЦC�X�^�妨�Z�b2-4�W���ǥ͡G
--���p�k�G�Ǹ��A�m�W�A��ءA���Z
--���Z(����)
select ranked.sno,student.NAME,ranked.subject,ranked.score, ranked.rowno 
from (
select *, rank() over(partition by subject order by score desc) as rowno from yscore
) as ranked      
inner join student on student.sno=ranked.sno
where ranked.rowno between 2 and 4 and ranked.SUBJECT='�^��'
order by ranked.score desc
