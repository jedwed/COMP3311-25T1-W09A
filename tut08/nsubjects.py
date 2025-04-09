#!/usr/bin/python3
import sys
import psycopg2

conn = None
if len(sys.argv) < 2:
    print("Usage: pytho3 nsubjects.py school_search_string")
    exit(1)
school_search_string = sys.argv[1]

SCHOOL_QUERY = """
SELECT
    id,
    longname
FROM
    orgunits
WHERE 
    longname ~* %s
"""

NUM_SUBJECT_QUERY = """
SELECT
    COUNT(*)
FROM
    subjects AS s
JOIN
    orgunits AS o
    ON s.offeredby = o.id
WHERE
    o.id = %s
"""

try:
    conn = psycopg2.connect("dbname=uni")
    cur = conn.cursor()
    cur.execute(SCHOOL_QUERY, [school_search_string])
    schools = cur.fetchall()
    if len(schools) == 1:
        # Print out the number of subjects that school offers
        school_id, school_name = schools[0]
        cur.execute(NUM_SUBJECT_QUERY, [school_id])
        (num_subjects,) = cur.fetchone()
        print(f"{school_name} teaches {num_subjects} subjects")
    elif len(schools) > 1:
        print("Multiple schools match")
        for school_id, school_name in schools:
            print(school_name)
except psycopg2.Error as err:
    print("database error: ", err)
finally:
    if conn is not None:
        conn.close()
