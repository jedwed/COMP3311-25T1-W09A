-- Part a
CREATE TABLE subject (
    code char(8) PRIMARY KEY CHECK (code ~ '[A-Z]{4}[0-9]{4}')
);

CREATE TABLE teacher (
    staff_number integer,
    teaches char(8) NOT NULL,
    semester char(4),
    PRIMARY KEY (staff_number),
    FOREIGN KEY (teaches) REFERENCES subject (code)

);
