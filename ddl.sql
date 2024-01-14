CREATE TYPE db_cs_human_status as ENUM ('alive', 'dead', 'disappeared');
CREATE TYPE  db_cs_instrument_status as ENUM ('new', 'used', 'destroyed');
CREATE TYPE db_cs_abbey_member_rank as ENUM ('recruit', 'common', 'elder', 'grand');


CREATE TABLE IF NOT EXISTS db_cs_human
(
    id            BIGSERIAL PRIMARY KEY,
    name          TEXT                           NOT NULL,
    date_of_birth TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    status        db_cs_human_status             NOT NULL
);

CREATE TABLE IF NOT EXISTS db_cs_abbys
(
    id   BIGSERIAL PRIMARY KEY,
    mana BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS db_cs_outsider
(
    id       BIGSERIAL PRIMARY KEY,
    human_id BIGINT NOT NULL,
    abbys_id BIGINT NOT NULL,
    FOREIGN KEY (human_id) REFERENCES db_cs_human (id),
    FOREIGN KEY (abbys_id) REFERENCES db_cs_abbys (id),
    CONSTRAINT outsider_human_constraint UNIQUE (human_id)
);


CREATE TABLE IF NOT EXISTS db_cs_ability
(
    id          BIGSERIAL PRIMARY KEY,
    description TEXT   NOT NULL,
    cost        BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS db_cs_abbey
(
    id   BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS db_cs_abbey_member
(
    id       BIGSERIAL PRIMARY KEY,
    human_id BIGINT                  NOT NULL,
    abbey_id BIGINT                  NOT NULL,
    rank     db_cs_abbey_member_rank NOT NULL,
    FOREIGN KEY (human_id) REFERENCES db_cs_human (id),
    CONSTRAINT abbey_member_constraint UNIQUE (human_id)
);

CREATE TABLE IF NOT EXISTS db_cs_altar
(
    id        BIGSERIAL PRIMARY KEY,
    author_id BIGINT NOT NULL,
    FOREIGN KEY (author_id) REFERENCES db_cs_human (id)
);

CREATE TABLE IF NOT EXISTS db_cs_instrument
(
    id          BIGSERIAL PRIMARY KEY,
    description TEXT                    NOT NULL,
    status      db_cs_instrument_status NOT NULL
);


CREATE TABLE IF NOT EXISTS db_cs_elected
(
    id          BIGSERIAL PRIMARY KEY,
    human_id    BIGINT NOT NULL,
    outsider_id BIGINT NOT NULL,
    FOREIGN KEY (human_id) REFERENCES db_cs_human (id),
    FOREIGN KEY (outsider_id) REFERENCES db_cs_outsider (id)
);

CREATE TABLE IF NOT EXISTS db_cs_rune
(
    id             BIGSERIAL PRIMARY KEY,
    contained_mana BIGINT NOT NULL,
    elected_id     BIGINT NOT NULL,
    FOREIGN KEY (elected_id) REFERENCES db_cs_elected (id)
);

CREATE TABLE IF NOT EXISTS db_cs_sacrifice
(
    id               BIGSERIAL PRIMARY KEY,
    data             TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    created_outsider BIGINT                         NOT NULL,
    instrument_id    BIGINT                         NOT NULL,
    abbey_member     BIGINT                         NOT NULL,
    FOREIGN KEY (created_outsider) REFERENCES db_cs_outsider (id),
    CONSTRAINT sacrifice_outsider_constraint UNIQUE (created_outsider),
    FOREIGN KEY (instrument_id) REFERENCES db_cs_instrument (id),
    FOREIGN KEY (abbey_member) REFERENCES db_cs_abbey_member (id)
);

CREATE TABLE IF NOT EXISTS db_cs_elected_ability
(
    elected_id BIGINT NOT NULL,
    ability_id BIGINT NOT NULL,
    FOREIGN KEY (elected_id) REFERENCES db_cs_elected (id),
    FOREIGN KEY (ability_id) REFERENCES db_cs_ability (id)
);

CREATE TABLE IF NOT EXISTS db_cs_action
(
    id              BIGSERIAL PRIMARY KEY,
    rating_delta    BIGINT NOT NULL,
    expire_duration BIGINT NOT NULL,
    description     TEXT   NOT NULL
);

CREATE TABLE IF NOT EXISTS db_cs_human_action
(
    id        BIGSERIAL PRIMARY KEY,
    human_id  BIGINT                         NOT NULL,
    action_id BIGINT                         NOT NULL,
    date      TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    FOREIGN KEY (human_id) REFERENCES db_cs_human (id),
    FOREIGN KEY (action_id) REFERENCES db_cs_action (id)
);