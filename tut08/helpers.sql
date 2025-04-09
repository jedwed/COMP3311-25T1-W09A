CREATE OR REPLACE VIEW student_course_enrolments (
    subject_code, 
    subject_name,
    term_code,
    student_id,
    family_name,
    given_name
) AS
    SELECT
        s.code,
        s.name,
        t.code,
        stu.id,
        p.family,
        p.given
    FROM
        subjects AS s
    JOIN
        courses AS c
        ON s.id = c.subject
    JOIN
        course_enrolments AS e
        ON c.id = e.course
    JOIN
        students AS stu
        ON e.student = stu.id
    JOIN
        people AS p
        ON stu.id = p.id
    JOIN
        terms AS t
        ON c.term = t.id;
