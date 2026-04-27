-- =============================================================================
-- DDL — платформа квестов (PostgreSQL)
-- Согласуйте с ER-моделью и data_dictionary.md
-- =============================================================================

-- Расширения при необходимости:
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- -----------------------------------------------------------------------------
-- Пользователи и роли (пример — замените под вашу модель)
-- -----------------------------------------------------------------------------

-- CREATE TABLE users (
--     user_id       BIGSERIAL PRIMARY KEY,
--     login         VARCHAR(128) NOT NULL UNIQUE,
--     display_name  VARCHAR(256) NOT NULL,
--     created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
-- );

-- CREATE TABLE quests (
--     quest_id      BIGSERIAL PRIMARY KEY,
--     author_id     BIGINT NOT NULL REFERENCES users (user_id),
--     title         VARCHAR(512) NOT NULL,
--     status        VARCHAR(32) NOT NULL,
--     start_step_id BIGINT,
--     created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
-- );

-- CREATE TABLE quest_steps (
--     step_id    BIGSERIAL PRIMARY KEY,
--     quest_id   BIGINT NOT NULL REFERENCES quests (quest_id) ON DELETE CASCADE,
--     title      VARCHAR(512),
--     step_kind  VARCHAR(64) NOT NULL,
--     sort_order INTEGER
-- );

-- CREATE TABLE quest_edges (
--     edge_id       BIGSERIAL PRIMARY KEY,
--     quest_id      BIGINT NOT NULL REFERENCES quests (quest_id) ON DELETE CASCADE,
--     from_step_id  BIGINT NOT NULL REFERENCES quest_steps (step_id) ON DELETE CASCADE,
--     to_step_id    BIGINT NOT NULL REFERENCES quest_steps (step_id) ON DELETE CASCADE,
--     choice_label  VARCHAR(256),
--     CONSTRAINT chk_no_self_loop CHECK (from_step_id <> to_step_id)
-- );

-- ALTER TABLE quests
--     ADD CONSTRAINT fk_quests_start_step
--     FOREIGN KEY (start_step_id) REFERENCES quest_steps (step_id);

-- Индексы для типовых выборок:
-- CREATE INDEX idx_quest_steps_quest ON quest_steps (quest_id);
-- CREATE INDEX idx_quest_edges_from ON quest_edges (from_step_id);
-- CREATE INDEX idx_quest_edges_to ON quest_edges (to_step_id);
