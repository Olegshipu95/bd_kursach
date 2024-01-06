CREATE TABLE if not exists altar
(
    id        SERIAL PRIMARY KEY NOT NULL,
    author_id INTEGER            NOT NULL
);
CREATE TABLE Action
(
    id              SERIAL PRIMARY KEY             NOT NULL,
    rating_delta    BIGINT                         NOT NULL CHECK ( rating_delta >= 0 and rating_delta <= 100 ),
    expire_duration TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);
CREATE TABLE abbys
(
    id        SERIAL PRIMARY KEY NOT NULL,
    mana      BIGINT             NOT NULL,
    outsiders BIGINT             NOT NULL
);
CREATE TABLE instrument
(
    id          SERIAL PRIMARY KEY NOT NULL,
    description VARCHAR(40)        NOT NULL,
    status      BIGINT             NOT NULL
);
CREATE TABLE elected
(
    id          SERIAL PRIMARY KEY NOT NULL,
    human_id    BIGINT             NOT NULL,
    runes       BIGINT             NOT NULL,
    outsider_id BIGINT             NOT NULL
);
CREATE TABLE abbey_member
(
    id       SERIAL PRIMARY KEY NOT NULL,
    human_id BIGINT             NOT NULL,
    rank     BIGINT             NOT NULL
);

CREATE TABLE ability
(
    "id"          SERIAL PRIMARY KEY NOT NULL,
    "description" VARCHAR(255)       NOT NULL,
    "cost"        BIGINT             NOT NULL
);
CREATE TABLE runes
(
    id             SERIAL PRIMARY KEY NOT NULL,
    contained_mana BIGINT             NOT NULL
);
CREATE TABLE sacrifice
(
    id               SERIAL PRIMARY KEY             NOT NULL,
    data             TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    created_outsider BIGINT                         NOT NULL,
    instrument_id    BIGINT                         NOT NULL,
    abbey            BIGINT                         NOT NULL
);
CREATE TABLE elected_ability
(
    elected_id BIGINT NOT NULL,
    ability    BIGINT NOT NULL
);
CREATE TABLE Human_action
(
    id        SERIAL PRIMARY KEY             NOT NULL,
    human_id  BIGINT                         NOT NULL,
    action_id BIGINT                         NOT NULL,
    date      TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE outsider
(
    id       SERIAL PRIMARY KEY NOT NULL,
    status   BIGINT             NOT NULL,
    human_id BIGINT             NOT NULL
);

CREATE TABLE abbey
(
    id      SERIAL PRIMARY KEY NOT NULL,
    name    BIGINT             NOT NULL,
    members BIGINT             NOT NULL
);

create table if not exists human_status
(
    id     SERIAL PRIMARY KEY NOT NULL,
    status varchar(40)        not null
);

CREATE TABLE human
(
    id        SERIAL PRIMARY KEY                   NOT NULL,
    name      VARCHAR(255)                         NOT NULL,
    status_id INTEGER references human_status (id) NOT NULL
);
ALTER TABLE
    sacrifice
    ADD CONSTRAINT sacrifice_abbey_foreign FOREIGN KEY (abbey) REFERENCES abbey (id);
ALTER TABLE
    elected_ability
    ADD CONSTRAINT elected_ability_elected_id_foreign FOREIGN KEY (elected_id) REFERENCES elected (id);
ALTER TABLE
    Human_action
    ADD CONSTRAINT human_action_id_foreign FOREIGN KEY (id) REFERENCES human (id);
ALTER TABLE
    abbey
    ADD CONSTRAINT abbey_members_foreign FOREIGN KEY (members) REFERENCES abbey_member (id);
ALTER TABLE
    elected
    ADD CONSTRAINT elected_human_id_foreign FOREIGN KEY (human_id) REFERENCES human (id);
ALTER TABLE
    elected
    ADD CONSTRAINT elected_runes_foreign FOREIGN KEY (runes) REFERENCES runes (id);
ALTER TABLE
    elected
    ADD CONSTRAINT elected_outsider_id_foreign FOREIGN KEY (outsider_id) REFERENCES outsider (id);
ALTER TABLE
    outsider
    ADD CONSTRAINT outsider_human_id_foreign FOREIGN KEY (human_id) REFERENCES human (id);
ALTER TABLE
    elected_ability
    ADD CONSTRAINT elected_ability_ability_foreign FOREIGN KEY (ability) REFERENCES ability (id);
ALTER TABLE
    sacrifice
    ADD CONSTRAINT sacrifice_created_outsider_foreign FOREIGN KEY (created_outsider) REFERENCES outsider (id);
ALTER TABLE
    sacrifice
    ADD CONSTRAINT sacrifice_instrument_id_foreign FOREIGN KEY (instrument_id) REFERENCES instrument (id);
ALTER TABLE
    abbys
    ADD CONSTRAINT abbys_outsiders_foreign FOREIGN KEY (outsiders) REFERENCES outsider (id);
ALTER TABLE
    abbey_member
    ADD CONSTRAINT abbey_member_human_id_foreign FOREIGN KEY (human_id) REFERENCES human (id);
ALTER TABLE
    altar
    ADD CONSTRAINT altar_author_id_foreign FOREIGN KEY (author_id) REFERENCES human (id);
ALTER TABLE
    Human_action
    ADD CONSTRAINT human_action_action_id_foreign FOREIGN KEY (action_id) REFERENCES Action (id);