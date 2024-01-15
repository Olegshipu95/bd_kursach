CREATE OR REPLACE FUNCTION check_sacrifice_instrument_status()
    RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.instrument_id IS NOT NULL THEN
        -- Проверка, что instrument_status не равен "used" или "broken"
        IF (SELECT status FROM db_cs_instrument WHERE id = NEW.instrument_id) IN ('used', 'destroyed') THEN
            RAISE EXCEPTION 'Instrument status is "used" or "broken", cannot insert into sacrifice table.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

drop trigger if exists before_insert_sacrifice on db_cs_sacrifice;
CREATE TRIGGER before_insert_sacrifice
    BEFORE INSERT
    ON db_cs_sacrifice
    FOR EACH ROW
EXECUTE FUNCTION check_sacrifice_instrument_status();


CREATE OR REPLACE FUNCTION check_abbey_member_before_insert()
    RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS(
            SELECT 1
            FROM db_cs_abbey_member
            WHERE human_id = NEW.human_id
        ) THEN
        RAISE EXCEPTION 'Cannot insert into db_cs_outsider, human_id already exists in db_cs_abbey_member';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_abbey_member_before_insert_trigger
    BEFORE INSERT
    ON db_cs_outsider
    FOR EACH ROW
EXECUTE FUNCTION check_abbey_member_before_insert();

CREATE OR REPLACE FUNCTION check_outsider_status()
    RETURNS TRIGGER AS
$$
DECLARE
    human_status_value db_cs_human_status;
BEGIN
    -- Получение статуса из human_status по human_id
    SELECT db_cs_human.status
    INTO human_status_value
    FROM db_cs_human
    WHERE db_cs_human.id = NEW.human_id;

    RAISE NOTICE 'human_status_value: %', human_status_value;
    -- Проверка, что статус не "dead"
    IF human_status_value = 'dead' THEN
        RAISE EXCEPTION 'Cannot add new outsider. Associated human has status "dead".';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

drop trigger if exists before_insert_outsider_2 on db_cs_outsider;
CREATE TRIGGER before_insert_outsider_2
    BEFORE INSERT
    ON db_cs_outsider
    FOR EACH ROW
EXECUTE FUNCTION check_outsider_status();

CREATE OR REPLACE FUNCTION check_outsider_action()
    RETURNS TRIGGER AS $$
DECLARE
    total_rating_delta bigint;
    average_rating_delta numeric;
BEGIN
    -- Находим все события в human_action, которые принадлежат outsider.human_id
    SELECT AVG(a.rating_delta) INTO average_rating_delta
    FROM human_action ha
             JOIN action a ON ha.action_id = a.id
--     todo change
    WHERE ha.human_id = NEW.human_id AND a.expire_duration > extract(epoch FROM current_timestamp);

    -- Проверяем условие: среднее значение rating_delta должно быть не выше 50
    IF average_rating_delta IS NOT NULL AND average_rating_delta > 50 THEN
--         RAISE EXCEPTION 'Cannot add new outsider. Average rating delta is above 50.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

drop trigger if exists before_insert_outsider_3 on db_cs_outsider;
-- CREATE TRIGGER before_insert_outsider_3
--     BEFORE INSERT
--     ON db_cs_outsider
--     FOR EACH ROW
-- EXECUTE FUNCTION check_outsider_action();




