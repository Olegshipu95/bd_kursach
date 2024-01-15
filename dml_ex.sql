INSERT INTO db_cs_human(id, name, date_of_birth, status) VALUES (1008, 'Nigger', '1545-03-08', 'alive');
INSERT INTO db_cs_abbys (id, mana) VALUES (100, 38706);
INSERT INTO db_cs_outsider (id, human_id, abbys_id) VALUES (1008, 1008, 1008);



INSERT INTO db_cs_human(id, name, date_of_birth, status) VALUES (1012, 'Nigger', '1545-03-08', 'dead');
INSERT INTO db_cs_abbys (id, mana) VALUES (1010, 38706);
INSERT INTO db_cs_outsider (id, human_id, abbys_id) VALUES (1012, 1015, 1009);





INSERT INTO db_cs_human(id, name, date_of_birth, status) VALUES (1015, 'Nigger', '1545-03-08', 'dead');
INSERT INTO db_cs_action (id, rating_delta, expire_duration, description) VALUES (1015, 20, 365, 'Helping the elderly cross the street');
INSERT INTO db_cs_action (id, rating_delta, expire_duration, description) VALUES (1016, 40, 365, 'Helping the elderly cross the street');
INSERT INTO db_cs_human_action(human_id, action_id, date) VALUES (1015, 1015, '2024-01-12');
INSERT INTO db_cs_human_action(human_id, action_id, date) VALUES (1015, 1016, '2024-01-12');



--
-- INSERT INTO db_cs_human(id, name, date_of_birth, status) VALUES (1000, 'Nigger', '1545-03-08', 'alive');
-- INSERT INTO db_cs_abbys (id, mana) VALUES (1000, 38706);
-- INSERT INTO db_cs_outsider (human_id, abbys_id) VALUES (1000, abbys_id);
