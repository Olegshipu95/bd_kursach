DROP TRIGGER IF EXISTS before_insert_sacrifice ON db_cs_sacrifice;
DROP TRIGGER IF EXISTS before_insert_outsider_1 ON db_cs_outsider;
DROP TRIGGER IF EXISTS before_insert_outsider_2 ON db_cs_outsider;
DROP TRIGGER IF EXISTS before_insert_outsider_3 ON db_cs_outsider;

DROP INDEX IF EXISTS index_action_expire_duration;
DROP INDEX IF EXISTS index_ability_cost;
DROP INDEX IF EXISTS index_ability_rune;
DROP INDEX IF EXISTS index_abbey_member_rank;
DROP INDEX IF EXISTS index_human_status;


DROP TABLE IF EXISTS db_cs_human_action;
DROP TABLE IF EXISTS db_cs_action;
DROP TABLE IF EXISTS db_cs_elected_ability;
DROP TABLE IF EXISTS db_cs_sacrifice;
DROP TABLE IF EXISTS db_cs_abbey_rank_status;
DROP TABLE IF EXISTS db_cs_rune;
DROP TABLE IF EXISTS db_cs_elected;
DROP TABLE IF EXISTS db_cs_instrument;
DROP TABLE IF EXISTS db_cs_altar;
DROP TABLE IF EXISTS db_cs_abbey_member;
DROP TABLE IF EXISTS db_cs_abbey;
DROP TABLE IF EXISTS db_cs_ability;
DROP TABLE IF EXISTS db_cs_outsider;
DROP TABLE IF EXISTS db_cs_abbys;
DROP TABLE IF EXISTS db_cs_human;

DROP TYPE IF EXISTS db_cs_human_status;
DROP TYPE IF EXISTS db_cs_instrument_status;
DROP TYPE IF EXISTS db_cs_abbey_member_rank;
