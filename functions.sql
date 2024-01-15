CREATE OR REPLACE FUNCTION check_outsider_action(p_human_id BIGINT)
    RETURNS NUMERIC AS $$
DECLARE
    average_rating_delta numeric;
BEGIN
    -- Находим все события в human_action, которые принадлежат outsider.human_id
    SELECT AVG(a.rating_delta) INTO average_rating_delta
    FROM db_cs_human_action ha
             JOIN db_cs_action a ON ha.action_id = a.id
    WHERE ha.human_id = p_human_id AND ha.date + interval '1' day * a.expire_duration> current_timestamp ;

    -- Проверяем условие: среднее значение rating_delta должно быть не выше 50
    IF average_rating_delta IS NULL THEN
        average_rating_delta := 0;
    END IF;

    RETURN average_rating_delta;
END;
$$ LANGUAGE plpgsql;