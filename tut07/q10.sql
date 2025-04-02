CREATE TABLE student (
    sid integer,
    name text,
    PRIMARY KEY (sid)
);

CREATE TABLE course (
    code char(8),
    lic text,
    quota integer,
    numStudents integer DEFAULT 0,
    PRIMARY KEY (code)
);

CREATE TABLE enrolment (
    course char(8),
    sid integer,
    PRIMARY KEY (course, sid),
    FOREIGN KEY (course) REFERENCES Course(code),
    FOREIGN KEY (sid) REFERENCES Student(sid)
);

CREATE OR REPLACE FUNCTION num_students_update() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE
            course
        SET
            numStudents = numStudents + 1
        WHERE
            code = NEW.course;
    END IF;
    RETURN NULL;
END
$$ LANGUAGE plpgsql;

-- Define Trigger to ensure numStudents in each course = num enrolments for that course
CREATE TRIGGER num_students_check
    AFTER INSERT OR DELETE OR UPDATE
    ON enrolment
    FOR EACH ROW 
    EXECUTE FUNCTION num_students_update();

-- Define ASSERTION to ensure numStudents in each course = number of enrolments for that course
-- CREATE ASSERTION num_students_check CHECK (
--     NOT EXISTS (
--         SELECT 
--             *
--         FROM
--             course AS c
--         WHERE
--             c.numStudents != (
--                 SELECT 
--                     COUNT(*)
--                 FROM
--                     enrolment AS e
--                 WHERE
--                     e.course = c.id
--             )
--     )
-- );
