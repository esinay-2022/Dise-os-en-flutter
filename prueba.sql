SELECT @s:=@s+1  id, u.id as userid, 
        Concat(u.firstname,' ', u.lastname) AS nombre, 
        u.username AS codigo, 
        u.country, 
        c.fullname AS curso, 
        c.startdate AS inicio_curso, 
        u.department, 
        notascourse.notas,  
        DATE_FORMAT(DATE_ADD(FROM_UNIXTIME(usrcourse.timestart, '%Y-%m-%d %h:%i'),INTERVAL 7 HOUR),'%d/%m/%Y %H:%i') AS inicio_matricula,
        DATE_FORMAT(DATE_ADD(FROM_UNIXTIME(usrcourse.timeend, '%Y-%m-%d %h:%i'),INTERVAL 7 HOUR),'%d/%m/%Y %H:%i') AS fin_matricula,
        DATE_FORMAT(DATE_ADD(FROM_UNIXTIME(cc.timecompleted, '%Y-%m-%d %h:%i'),INTERVAL 7 HOUR),'%d/%m/%Y %H:%i') AS completado, 
        coursedate.tiempo AS ultimo_acceso, 
        grupo.name AS grupo, 
        CASE 
        WHEN notas.finalgrade <= 0 
        OR notas.finalgrade IS NULL THEN '0' 
        ELSE notas.finalgrade 
        end AS nota, 
        CASE 
        WHEN compl.num <= 0 
        OR compl.num IS NULL THEN '0%' 
        ELSE Concat(Cast(((compl.num*100)/act.num) AS DECIMAL(16, 0)), '%') 
        end AS avance 
        FROM  (SELECT @s:= 0) AS s,
        mdl_user u
        LEFT JOIN (SELECT DISTINCT
        ue.userid, 
        en.courseid, u.firstname AS Firstname, u.lastname AS Lastname, ue.timestart, ue.timeend, 
        u.idnumber Employee_ID, course.fullname AS Course 
        FROM mdl_course AS course JOIN mdl_enrol AS en ON en.courseid = course.id 
        JOIN mdl_user_enrolments AS ue ON ue.enrolid = en.id  
        JOIN mdl_user as u ON u.id = ue.userid) AS usrcourse 
        ON u.id = usrcourse.userid 
        LEFT JOIN (SELECT gi.courseid, 
        gg.userid, 
        gg.finalgrade 
        FROM mdl_grade_items gi 
        INNER JOIN mdl_grade_grades gg 
        ON gg.itemid = gi.id 
        WHERE gi.itemtype = 'course')AS notas 
        ON u.id = notas.userid 
        AND usrcourse.courseid = notas.courseid 
        LEFT JOIN mdl_course_completions cc 
        ON u.id = cc.userid 
        AND usrcourse.courseid = cc.course 
        LEFT JOIN(SELECT Count(id)AS num, 
        course 
        FROM mdl_course_completion_criteria 
        GROUP BY course) AS act 
        ON act.course = usrcourse.courseid 
        LEFT JOIN (SELECT userid, 
        course, 
        Count(id)AS num 
        FROM mdl_course_completion_crit_compl 
        GROUP  BY course, 
        userid)AS compl 
        ON compl.userid = u.id 
        AND compl.course = usrcourse.courseid 
        LEFT JOIN (SELECT g.name, gm.userid FROM mdl_course c
        INNER JOIN mdl_groups g ON g.courseid = c.id 
        INNER JOIN mdl_groups_members gm ON gm.groupid = g.id) as grupo
        on u.id = grupo.userid 
        LEFT JOIN ( SELECT  DISTINCT sl.userid, sl.courseid, max(sl.timecreated) as tiempo FROM mdl_course c
        INNER JOIN mdl_logstore_standard_log sl ON sl.courseid = c.id 
        INNER JOIN mdl_user u on u.id = sl.userid 
        WHERE target like '%course' 
        group by sl.userid, sl.courseid) as coursedate 
        ON coursedate.courseid = usrcourse.courseid AND coursedate.userid = u.id 
        LEFT JOIN mdl_course c 
        ON usrcourse.courseid = c.id 
        LEFT JOIN(select mc.id, mq.course,  GROUP_CONCAT(concat(mq.name, ' ', FORMAT(mqa.sumgrades, '2')))AS notas, mqa.userid from mdl_course mc  
        INNER JOIN mdl_quiz mq on mc.id = mq.course  
        INNER JOIN mdl_quiz_attempts mqa on mq.id = mqa.quiz group by mqa.userid) as notascourse 
        ON u.id = notascourse.userid