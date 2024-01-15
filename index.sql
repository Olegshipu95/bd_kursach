CREATE INDEX IF NOT EXISTS index_action_expire_duration ON db_cs_action USING btree(expire_duration);
CREATE INDEX IF NOT EXISTS index_ability_cost ON db_cs_ability USING btree(cost);
CREATE INDEX IF NOT EXISTS index_ability_rune ON db_cs_rune USING btree(contained_mana);
CREATE INDEX IF NOT EXISTS index_abbey_member_rank ON db_cs_abbey_member USING hash(rank);
CREATE INDEX IF NOT EXISTS index_human_status ON db_cs_human USING hash(status);

