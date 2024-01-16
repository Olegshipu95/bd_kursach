CREATE OR REPLACE FUNCTION check_outsider_action(p_human_id BIGINT)
    RETURNS NUMERIC AS
$$
DECLARE
    average_rating_delta numeric;
BEGIN
    -- Находим все события в human_action, которые принадлежат outsider.human_id
    SELECT AVG(a.rating_delta)
    INTO average_rating_delta
    FROM db_cs_human_action ha
             JOIN db_cs_action a ON ha.action_id = a.id
    WHERE ha.human_id = p_human_id
      AND ha.date + interval '1' day * a.expire_duration > current_timestamp;

    -- Проверяем условие: среднее значение rating_delta должно быть не выше 50
    IF average_rating_delta IS NULL THEN
        average_rating_delta := 0;
    END IF;

    RETURN average_rating_delta;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_outsider_action(p_human_id BIGINT, p_outsider_id BIGINT, p_mana BIGINT)
    returns BOOLEAN as
$$
declare
    check_human_id    BIGINT;
    check_outsider_id BIGINT;
    check_altar       BIGINT;
    check_mana        BIGINT;
    new_id_elected    BIGINT;
BEGIN
    select id into check_human_id from db_cs_human where id = p_human_id;
    IF check_human_id IS NULL THEN
        RAISE NOTICE 'check_outsider_action: p_human_id is incorrect';
        return false;
    END IF;
    select id into check_outsider_id from db_cs_outsider where id = p_outsider_id;
    IF check_outsider_id IS NULL THEN
        RAISE NOTICE 'check_outsider_action: db_cs_outsider is incorrect';
        return false;
    END IF;
    select id into check_altar from db_cs_altar where author_id = p_human_id;
    if check_altar is null then
        raise notice 'check_outsider_action: need to build altar';
        return false;
    end if;
    select db_cs_abbys.mana
    into check_mana
    from db_cs_abbys
             join db_cs_outsider dco on db_cs_abbys.id = dco.abbys_id
    where dco.id = p_outsider_id;
    if check_mana <= p_mana then
        raise notice 'abbys has not enough mana';
        return false;
    end if;
        insert into db_cs_elected(human_id, outsider_id)
        values (p_human_id, p_outsider_id)
        returning id into new_id_elected;
        insert into db_cs_rune(contained_mana, elected_id) VALUES (p_mana, new_id_elected);
        update db_cs_abbys set mana = mana - p_mana where db_cs_abbys.id = (select db_cs_outsider.abbys_id from db_cs_outsider where id = p_outsider_id);
    END;
$$ LANGUAGE plpgsql;