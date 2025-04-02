-- Define our own custom aggregate called mean 
--


CREATE TYPE my_mean_state AS (total_sum numeric, count integer);

CREATE FUNCTION my_mean_sfunc(curr_state my_mean_state, curr_value numeric) RETURNS my_mean_state AS $$
DECLARE
    res my_mean_state;
BEGIN
    res := curr_state;
    res.total_sum := curr_state.total_sum + curr_value;
    res.count := curr_state.count + 1;
    RETURN res;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION my_mean_finalfunc(final_state my_mean_state) RETURNS numeric AS $$
BEGIN
    RETURN final_state.total_sum / final_state.count;

END

$$ LANGUAGE plpgsql;

CREATE AGGREGATE my_mean (numeric) (
    sfunc = my_mean_sfunc,
    stype = my_mean_state,
    initcond = '(0, 0)',
    finalfunc = my_mean_finalfunc
);
