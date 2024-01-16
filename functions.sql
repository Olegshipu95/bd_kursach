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

CREATE OR REPLACE FUNCTION make_elected(p_human_id BIGINT, p_outsider_id BIGINT, p_mana BIGINT)
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
    update db_cs_abbys
    set mana = mana - p_mana
    where db_cs_abbys.id = (select db_cs_outsider.abbys_id from db_cs_outsider where id = p_outsider_id);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION make_outsider(p_abbey_member BIGINT)
    returns BOOLEAN as
$$
declare
    good_human_id        BIGINT;
    check_abbey_member   BIGINT;
    random_abbys_id      BIGINT;
    random_instrument_id BIGINT;
    new_outsider         BIGINT;
BEGIN
    select id into check_abbey_member from db_cs_abbey_member where db_cs_abbey_member.id = p_abbey_member;
    if check_abbey_member is null then
        raise notice 'make_outsider:check_abbey_member is null';
        return false;
    end if;
    SELECT id
    into good_human_id
    FROM db_cs_human
    ORDER BY check_outsider_action(id) DESC
    LIMIT 1;
    update db_cs_human set status = 'disappeared' where id = good_human_id;
    select id into random_abbys_id from db_cs_abbys ORDER BY RANDOM() LIMIT 1;
    select id into random_instrument_id from db_cs_instrument where status = 'new' ORDER BY RANDOM() LIMIT 1;
    if random_abbys_id is null or random_instrument_id is null then
        raise notice 'make_outsider:abbys_id or instrument_id is null';
        return false;
    end if;
    insert into db_cs_outsider(human_id, abbys_id)
    VALUES (good_human_id, random_abbys_id)
    returning id into new_outsider;
    insert into db_cs_sacrifice(data, created_outsider, instrument_id, abbey_member)
    VALUES (current_timestamp, new_outsider, random_instrument_id, p_abbey_member);
    return true;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION make_new_member(p_abbey_member BIGINT)
    returns BOOLEAN as
$$
declare
    bad_human_id       BIGINT;
    check_abbey_member BIGINT;
    new_abbey_id       bigint;
BEGIN
    select id into check_abbey_member from db_cs_abbey_member where db_cs_abbey_member.id = p_abbey_member;
    if check_abbey_member is null then
        raise notice 'new_member:check_abbey_member is null';
        return false;
    end if;
    SELECT id
    into bad_human_id
    FROM db_cs_human
    where current_timestamp - date_of_birth < interval '18' year
    ORDER BY check_outsider_action(id)
    LIMIT 1;
    update db_cs_human set status = 'disappeared' where id = bad_human_id;
    if bad_human_id is null then
        raise notice 'new_member: no bad human';
        return false;
    end if;
    select db_cs_abbey_member.abbey_id into new_abbey_id from db_cs_abbey_member where id = p_abbey_member;
    insert into db_cs_abbey_member(human_id, abbey_id, rank)
    values (bad_human_id, new_abbey_id, 'recruit');
    return true;
end;
$$ LANGUAGE plpgsql;
