--學生成績-SQL語法練習
--※附件YSTUDENT.MDB (ACCESS檔) 以 檢視SQL 或 檢視設計 作下列練習:
--※學員得以將YSTUDENT.MDB 轉成MS SQL或MYSQL的資料庫，再以其語法作答。
--※題目中有A、B、C 項非單1小題，一般題是 A+B 成一題，進階題為 A+B+C成一題。

--※排名規則：如5個人，其中第3名有2個人，則排名採 1,2,3,3,5，列前3名時，應該要列1,2,3,3共4個人。

--–表因科目不同, 其他欄位重複值如sno, name，用gruop by集中統計
--1. 請計算每個人的總成績及平均(小數1位):
--欄位如右：學號，姓名，總分，平均。--有join,欄位前要加表格名;有統計要加group by; *用設計查詢: sum(score) from yscore=SUM(YSCORE.SCORE)
--排序：總分(遞減)。
SELECT  STUDENT.SNO, STUDENT.NAME, SUM(YSCORE.SCORE) AS 總分, convert(decimal(4,1),AVG(YSCORE.SCORE*1.0)) 平均
FROM      STUDENT INNER JOIN YSCORE ON STUDENT.SNO = YSCORE.SNO
GROUP BY STUDENT.SNO, STUDENT.NAME order by 總分 desc --只寫欄位

--2. 請計算每個人單科的最高成績:--承碼亞第40題,先用排名(dense法)取最高科
--欄位如右：學號，姓名，科目，最高成績。--原直取最高分max(score)不知如何跟科目掛勾(?)->洪瑪亞第40題有(5作法)
--排序：學號(遞增)。--網路很多解法left join,union…沒啥用上
select ranked.sno,student.NAME,ranked.subject,ranked.score 最高成績 
from (
select *, rank() over(partition by sno order by score desc) as rowno from yscore --rowid "各學號分組,依各科成績高低,排名"
) as ranked      --ranked是表格
inner join student on student.sno=ranked.sno
where ranked.rowno = 1 order by ranked.sno --取最高排名(成績)

--3. 請列出各門科目成績最好的學生: --邏輯同上
--欄位如右：學號，姓名，科目，成績。
--排序：成績(遞減)。
select ranked.sno,student.NAME,ranked.subject,ranked.score 
from (
select *, rank() over(partition by subject order by score desc) as rowno from yscore
) as ranked      --ranked是表格
inner join student on student.sno=ranked.sno
where ranked.rowno = 1
order by ranked.score desc

--4. 請列出各門科目成績最好的兩名學生(如第2名有多人同分者，則一起並列): 
--欄位如右：學號，姓名，科目，成績。
--排序：科目(遞增), 成績(遞減)。
select ranked.sno,student.NAME,ranked.subject,ranked.score 
from (
select *, rank() over(partition by subject order by score desc) as rowno from yscore
) as ranked      
inner join student on student.sno=ranked.sno
where ranked.rowno <=2
order by ranked.subject, ranked.score desc

--5. 請列出每個人的各科成績以及統計總分、平均 (小數1位)：(進階題)
--欄位如右：學號，姓名，國文，數學，英文，總分，平均。--3科目self join*2, 再join(整個)題1
--排序：總分(遞減)。 
Select G.SNO, G.NAME, S.國文, S.數學, S.英文, G.總分, G.平均 
from (
SELECT  STUDENT.SNO, STUDENT.NAME, sum(YSCORE.SCORE) AS 總分, convert(decimal(4,1),AVG(YSCORE.SCORE*1.0)) 平均
FROM     STUDENT INNER JOIN YSCORE ON STUDENT.SNO = YSCORE.SNO
GROUP BY STUDENT.SNO, STUDENT.NAME) G 
join (select yscore.sno, yscore.score 國文, y.score 數學, z.SCORE 英文 from yscore join yscore y on YSCORE.sno=y.SNO join yscore z on YSCORE.sno=z.SNO
where yscore.subject='國文' and y.subject ='數學' and z.SUBJECT='英文') S 
on G.sno=S.SNO order by 總分 desc

--6. 請列出各門科目的平均成績(小數1位)：
--欄位如右：科目，科目平均。
--排序：科目(遞增)。
select subject, convert(decimal(4,1),avg(SCORE*1.0)) 科平均 from yscore group by subject order by subject

--7. 請列出英文成績的排名：(進階題)
--欄位如右：學號，姓名，英文，排名
--排序：英文分數(遞減)，學號(遞增)。
select ranked.sno,student.NAME,ranked.subject,ranked.score,ranked.rowno 
from (
select *, rank() over(partition by subject order by score desc) as rowno from yscore
) as ranked      
inner join student on student.sno=ranked.sno
where ranked.SUBJECT='英文'
order by ranked.score desc, ranked.SNO

--8. 請列出數學成績在2-3名的學生：
--欄位如右：學號，姓名，科目，成績
--成績(遞減)
select ranked.sno,student.NAME,ranked.subject,ranked.score 
from (
select *, rank() over(partition by subject order by score desc) as rowno from yscore
) as ranked      
inner join student on student.sno=ranked.sno
where ranked.rowno between 2 and 3 and ranked.SUBJECT='數學'
order by ranked.score desc

--9. 請列出各門科目之不及格(0-59)個，良(60-80)個，優(81-100)個--類等級
--欄位如右：科目，不及格，良好，優秀
--科目(遞增)。
Select A.subject, A.不及格, B.良好, C.優秀 
from (
Select subject, count(score) 不及格 from yscore where score<60 group by subject) A
join (
Select subject, count(score) 良好 from yscore where score between 60 and 80 group by subject) B
on A.subject= B.subject
join (
Select subject, count(score) 優秀 from yscore where score >80 group by subject) C
on A.subject= C.subject
order by subject

--10. 請列出學號為　1002、1005、1006、1009的數學分數：
--欄位如右：學號，姓名，數學
--學號(遞增)。
select ranked.sno,student.NAME,ranked.subject,ranked.score 
from (
select *, rank() over(partition by subject order by score desc) as rowno from yscore
) as ranked      
inner join student on student.sno=ranked.sno
where ranked.sno in (1002,1005,1006,1009) and ranked.SUBJECT='數學'
order by ranked.SNO

--11. 請計算每一個科目都及格的學生之總平均成績(小數2位)
--欄位如右：學號，姓名，國文，數學，英文，平均
--學號(遞增)。
--顯示合乎條件學生的總平均(小數2位)於最末列之最末行(進階題)。
Select G.SNO, G.NAME, S.國文, S.數學, S.英文, G.平均 from
(SELECT  STUDENT.SNO, STUDENT.NAME, convert(decimal(5,2),SUM(YSCORE.SCORE)/3.0) 平均
FROM     STUDENT INNER JOIN YSCORE ON STUDENT.SNO = YSCORE.SNO
GROUP BY STUDENT.SNO, STUDENT.NAME) G 
join (select yscore.sno, yscore.score 國文, y.score 數學, z.SCORE 英文 from yscore join yscore y on YSCORE.sno=y.SNO join yscore z on YSCORE.sno=z.SNO
where yscore.subject='國文' and y.subject ='數學' and z.SUBJECT='英文') S on G.sno=S.SNO 
where s.國文>60 and s.數學>60 and s.英文>60 order by g.SNO

--12. 請計算學號 1002的國文成績的排名：(進階題)(排名採Rank Over同分同名次)
--欄位如右：學號，姓名，國文，排名 
select ranked.sno,student.NAME,ranked.subject,ranked.score, ranked.rowno 排名 
from (
select *, rank() over(partition by subject order by score desc) as rowno from yscore
) as ranked      
inner join student on student.sno=ranked.sno
where ranked.sno='1002' and ranked.SUBJECT='國文'
order by ranked.score desc

--13. 請列出英文成績在2-4名的學生：
--欄位如右：學號，姓名，科目，成績
--成績(遞減)
select ranked.sno,student.NAME,ranked.subject,ranked.score, ranked.rowno 
from (
select *, rank() over(partition by subject order by score desc) as rowno from yscore
) as ranked      
inner join student on student.sno=ranked.sno
where ranked.rowno between 2 and 4 and ranked.SUBJECT='英文'
order by ranked.score desc
