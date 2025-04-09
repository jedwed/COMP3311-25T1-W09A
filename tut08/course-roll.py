#!/usr/bin/python3
import sys
import psycopg2

conn = None


if len(sys.argv) < 3:
    print("Usage: course-roll subject term")
    exit(1)
subject = sys.argv[1]
term = sys.argv[2]

STUDENTS_ENROLLED_IN_COURSE = """
SELECT
    student_id,
    family_name,
    given_name
FROM
    student_course_enrolments
WHERE
    subject_code = %s 
    AND term_code = %s 
"""

try:
    conn = psycopg2.connect("dbname=uni")
    cur = conn.cursor()
    cur.execute(STUDENTS_ENROLLED_IN_COURSE, [subject, term])
    students = cur.fetchall()
    for student_id, family_name, given_name in students:
        print(f"{student_id} {family_name}, {given_name}")

except psycopg2.Error as err:
    print("database error: ", err)
finally:
    if conn is not None:
        conn.close()
