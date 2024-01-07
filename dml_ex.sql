insert into instrument_status(id, description)
values (1, 'broken');
insert into human_status(id, status)
values (1, 'dead');
insert into human(id, name, date_of_birth, status) values (1, 'Vadim', '1994-11-29', 1);
insert into abbys(id, mana) values (1, 500);
insert into outsider(id, human_id, abbys_id) values (1, 1, 1);
insert into ability(id, description, cost) values (1,'help', 100);
insert into runes(id, contained_mana) values (1, 500);
insert into elected(id, human_id, runes, outsider_id) VALUES (1,1,1,1);
insert into elected_ability(elected_id, ability) VALUES (1,1);
insert into action(id, rating_delta, expire_duration, description) VALUES (1, 40, '2994-11-29', 'kill');