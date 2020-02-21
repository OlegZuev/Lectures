CREATE OR REPLACE PROCEDURE error_example(_mu_name municipal_units.name%type, _command varchar) AS $$
BEGIN
    RAISE NOTICE 'error_example(%)', _mu_name;
    ASSERT exists(SELECT * FROM municipal_units WHERE name = _mu_name), 'Такого МО нет';
    EXECUTE _command USING _mu_name;
    RAISE EXCEPTION 'Все равно ошибка << % >>', _command
        USING HINT = 'Я просто так работаю';
END;
$$ LANGUAGE plpgsql;

DO -- По умолчанию plpgsql
$$
    BEGIN
        CALL error_example('Александровский муниципальный район', 'SELECT $1');
        -- CALL error_example('Центральный муниципальный район');
    EXCEPTION
        WHEN assert_failure THEN
            RAISE NOTICE 'Oops';
        WHEN syntax_error_or_access_rule_violation THEN -- xx000 - целый класс ошибок (например, класс 42 в том случае, если код - 42000)
            RAISE NOTICE 'Syntax Oops';
        WHEN OTHERS THEN
            RAISE NOTICE 'Others Oops';
    END;
$$;

-- CALL error_example('Александровский муниципальный район');
-- CALL error_example('Центральный муниципальный район');
