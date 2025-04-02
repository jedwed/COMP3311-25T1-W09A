CREATE TABLE R(
    a int, 
    b int, 
    c text
    -- we want primary key (a, b)
);


-- PRIMARY KEY
-- UNIQUE
-- NOT NULL
--
CREATE OR REPLACE FUNCTION primary_key_check() RETURNS trigger AS $$
BEGIN
    -- NOT NULL
    IF NEW.a IS NULL OR NEW.b IS NULL THEN
        RAISE EXCEPTION 'Primary key contains NULL value';
    END IF;
    -- UNIQUENESS
--
    IF TG_OP = 'UPDATE' AND NEW.a = OLD.a AND NEW.b = OLD.b THEN
        RETURN NEW;
    END IF;
    
    IF EXISTS (
        SELECT 
            *
        FROM
            r
        WHERE
            a = NEW.a
            AND b = NEW.b
    ) THEN 
        RAISE EXCEPTION 'Primary key already exists in table';
    END IF;
    
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER primary_key_trigger
    BEFORE INSERT OR UPDATE
    ON r
    FOR EACH ROW
    EXECUTE FUNCTION primary_key_check();
    

