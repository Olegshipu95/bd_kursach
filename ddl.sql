CREATE TABLE altar
(
    id        INTEGER NOT NULL,
    author_id INTEGER NOT NULL
);

ALTER TABLE
    altar
    ADD PRIMARY KEY (id);

CREATE TABLE human_status
(
    id     BIGINT       NOT NULL,
    status VARCHAR(255) NOT NULL
);

ALTER TABLE
    human_status
    ADD PRIMARY KEY (id);

CREATE TABLE action
(
    id              BIGINT                         NOT NULL,
    rating_delta    BIGINT                         NOT NULL,
    expire_duration TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    description     varchar(40)                    not null
);

ALTER TABLE
    action
    ADD PRIMARY KEY (id);

CREATE TABLE abbys
(
    id   BIGINT NOT NULL,
    mana BIGINT NOT NULL
);

ALTER TABLE
    abbys
    ADD PRIMARY KEY (id);

create table instrument_status
(
    id          BIGINT      NOT NULL,
    description VARCHAR(40) NOT NULL
);

ALTER TABLE
    instrument_status
    ADD PRIMARY KEY (id);

CREATE TABLE instrument
(
    id          BIGINT                                   NOT NULL,
    description VARCHAR(40)                              NOT NULL,
    status      BIGINT references instrument_status (id) NOT NULL
);

ALTER TABLE
    instrument
    ADD PRIMARY KEY (id);

CREATE TABLE elected
(
    id          BIGINT NOT NULL,
    human_id    BIGINT NOT NULL,
    runes       BIGINT NOT NULL,
    outsider_id BIGINT NOT NULL
);

ALTER TABLE
    elected
    ADD PRIMARY KEY (id);

create table abbey_rank_status
(
    id          BIGINT      NOT NULL,
    description VARCHAR(40) NOT NULL
);

ALTER TABLE
    abbey_rank_status
    ADD PRIMARY KEY (id);

CREATE TABLE abbey_member
(
    id       BIGINT NOT NULL,
    human_id BIGINT NOT NULL,
    rank     BIGINT NOT NULL
);

ALTER TABLE
    abbey_member
    ADD PRIMARY KEY (id);

CREATE TABLE ability
(
    id          BIGINT       NOT NULL,
    description VARCHAR(255) NOT NULL,
    cost        BIGINT       NOT NULL
);

ALTER TABLE
    ability
    ADD PRIMARY KEY (id);

CREATE TABLE runes
(
    id             INTEGER NOT NULL,
    contained_mana BIGINT  NOT NULL
);

ALTER TABLE
    runes
    ADD PRIMARY KEY (id);

CREATE TABLE sacrifice
(
    id               BIGINT                         NOT NULL,
    data             TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    created_outsider BIGINT                         NOT NULL,
    instrument_id    BIGINT                         NOT NULL,
    abbey_member     BIGINT                         NOT NULL
);

ALTER TABLE
    sacrifice
    ADD PRIMARY KEY (id);

CREATE TABLE elected_ability
(
    elected_id BIGINT NOT NULL,
    ability    BIGINT NOT NULL
);

CREATE TABLE Human_action
(
    id        BIGINT                         NOT NULL,
    human_id  BIGINT                         NOT NULL,
    action_id BIGINT                         NOT NULL,
    date      TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);

ALTER TABLE
    Human_action
    ADD PRIMARY KEY (id);

CREATE TABLE outsider
(
    id       BIGINT NOT NULL,
    human_id BIGINT NOT NULL,
    abbys_id BIGINT NOT NULL
);

ALTER TABLE
    outsider
    ADD PRIMARY KEY (id);

CREATE TABLE abbey
(
    id      BIGINT NOT NULL,
    name    BIGINT NOT NULL,
    members BIGINT NOT NULL
);

ALTER TABLE
    abbey
    ADD PRIMARY KEY (id);

CREATE TABLE human
(
    id            BIGINT                         NOT NULL,
    name          VARCHAR(255)                   NOT NULL,
    date_of_birth TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    status        BIGINT                         NOT NULL
);

ALTER TABLE
    human
    ADD PRIMARY KEY (id);

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
    human
    ADD CONSTRAINT human_status_foreign FOREIGN KEY (status) REFERENCES human_status (id);
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
    sacrifice
    ADD CONSTRAINT sacrifice_abbey_member_foreign FOREIGN KEY (abbey_member) REFERENCES abbey_member (id);
ALTER TABLE
    abbey_member
    ADD CONSTRAINT abbey_member_human_id_foreign FOREIGN KEY (human_id) REFERENCES human (id);
ALTER TABLE
    outsider
    ADD CONSTRAINT outsider_abbys_id_foreign FOREIGN KEY (abbys_id) REFERENCES abbys (id);
ALTER TABLE
    altar
    ADD CONSTRAINT altar_author_id_foreign FOREIGN KEY (author_id) REFERENCES human (id);
ALTER TABLE
    elected
    ADD CONSTRAINT elected_outsider_id_foreign FOREIGN KEY (outsider_id) REFERENCES outsider (id);
ALTER TABLE
    Human_action
    ADD CONSTRAINT human_action_action_id_foreign FOREIGN KEY (action_id) REFERENCES Action (id);