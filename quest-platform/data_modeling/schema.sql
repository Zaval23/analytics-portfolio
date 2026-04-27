-- =============================================================================
-- DDL — платформа квестов (PostgreSQL)
-- Согласуйте с ER-моделью и data_dictionary.md
-- =============================================================================
DROP TABLE IF EXISTS user_quest_completions CASCADE;
DROP TABLE IF EXISTS quest_unlock_conditions CASCADE;
DROP TABLE IF EXISTS user_playthroughs CASCADE;
DROP TABLE IF EXISTS edge_effects CASCADE;
DROP TABLE IF EXISTS edge_conditions CASCADE;
DROP TABLE IF EXISTS edges CASCADE;
DROP TABLE IF EXISTS vertex_counter_effects CASCADE;
DROP TABLE IF EXISTS vertex_item_effects CASCADE;
DROP TABLE IF EXISTS items_counters CASCADE;
DROP TABLE IF EXISTS vertices CASCADE;
DROP TABLE IF EXISTS quests CASCADE;
DROP TABLE IF EXISTS book_genres CASCADE;
DROP TABLE IF EXISTS ratings CASCADE;
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS genres CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS auth_sessions CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- 1. USERS
CREATE TABLE users (
    user_id SERIAL,
    username VARCHAR(255),
    hash_password VARCHAR(255)
);

ALTER TABLE users 
ADD CONSTRAINT PK_users PRIMARY KEY (user_id);

ALTER TABLE users 
ADD CONSTRAINT U_users_username UNIQUE (username);

-- 2. AUTHORS
CREATE TABLE authors (
    user_id INT NOT NULL,
    psevdonim VARCHAR(255)
);

ALTER TABLE authors 
ADD CONSTRAINT PK_authors PRIMARY KEY (user_id);

-- 3. BOOKS
CREATE TABLE books (
    book_id SERIAL,
    name VARCHAR(255),
    is_published BOOLEAN,
    created_date TIMESTAMP,
    author_id INT NOT NULL
);

ALTER TABLE books 
ADD CONSTRAINT PK_books PRIMARY KEY (book_id);

-- 4. GENRES
CREATE TABLE genres (
    genre_id SERIAL,
    name VARCHAR(100)
);

ALTER TABLE genres 
ADD CONSTRAINT PK_genres PRIMARY KEY (genre_id);

ALTER TABLE genres 
ADD CONSTRAINT U_genres_name UNIQUE (name);

-- 5. BOOK_GENRES
CREATE TABLE book_genres (
    book_id INT NOT NULL,
    genre_id INT NOT NULL
);

ALTER TABLE book_genres 
ADD CONSTRAINT PK_book_genres PRIMARY KEY (book_id, genre_id);

-- 6. QUESTS
CREATE TABLE quests (
    id SERIAL,
    name VARCHAR(255),
    type VARCHAR(10),
    order_number INT,
    book_fk INT NOT NULL
);

ALTER TABLE quests 
ADD CONSTRAINT PK_quests PRIMARY KEY (id);

ALTER TABLE quests 
ADD CONSTRAINT CH_quests_type CHECK (type IN ('visible', 'hidden'));

-- 7. VERTICES
CREATE TABLE vertices (
    id TEXT,
    text TEXT,
    ending VARCHAR(10),
    ending_psevdonim TEXT,
    timer INT,
    quest_fk INT NOT NULL
);

ALTER TABLE vertices 
ADD CONSTRAINT PK_vertices PRIMARY KEY (id);

ALTER TABLE vertices 
ADD CONSTRAINT CH_vertices_ending CHECK (ending IN ('none', 'bad', 'good'));

-- 8. ITEMS_COUNTERS
CREATE TABLE items_counters (
    id SERIAL,
    name TEXT,
    min_value INT,
    max_value INT,
    type VARCHAR(10),
    quest_fk INT NOT NULL
);

ALTER TABLE items_counters 
ADD CONSTRAINT PK_items_counters PRIMARY KEY (id);

ALTER TABLE items_counters 
ADD CONSTRAINT CH_items_counters_type CHECK (type IN ('item', 'counter'));

ALTER TABLE items_counters 
ALTER COLUMN min_value SET DEFAULT -2147483648;

ALTER TABLE items_counters 
ALTER COLUMN max_value SET DEFAULT 2147483647;

-- 9. VERTEX_ITEM_EFFECTS
CREATE TABLE vertex_item_effects (
    id SERIAL,
    count INT NOT NULL,
    item_fk INT NOT NULL,
    vertice_fk TEXT NOT NULL,
    quest_fk INT NOT NULL
);

ALTER TABLE vertex_item_effects 
ADD CONSTRAINT PK_vertex_item_effects PRIMARY KEY (id);

ALTER TABLE vertex_item_effects 
ADD CONSTRAINT CH_vertex_item_effects_count CHECK (count > 0);

-- 10. VERTEX_COUNTER_EFFECTS
CREATE TABLE vertex_counter_effects (
    id SERIAL,
    count INT NOT NULL,
    counter_fk INT NOT NULL,
    vertice_fk TEXT NOT NULL,
    quest_fk INT NOT NULL
);

ALTER TABLE vertex_counter_effects 
ADD CONSTRAINT PK_vertex_counter_effects PRIMARY KEY (id);

ALTER TABLE vertex_counter_effects 
ADD CONSTRAINT CH_vertex_counter_effects_count CHECK (count != 0);

-- 11. EDGES
CREATE TABLE edges (
    id TEXT,
    action_description TEXT,
    visibility VARCHAR(10),
    max_visits INT,
    vertice_1_fk TEXT NOT NULL,
    vertice_2_fk TEXT NOT NULL,
    quest_fk INT NOT NULL
);

ALTER TABLE edges 
ADD CONSTRAINT PK_edges PRIMARY KEY (id);

ALTER TABLE edges 
ADD CONSTRAINT CH_edges_visibility CHECK (visibility IN ('always', 'optional'));

ALTER TABLE edges 
ADD CONSTRAINT CH_edges_max_visits CHECK (max_visits > 0);

ALTER TABLE edges 
ALTER COLUMN max_visits SET DEFAULT 2147483647;

-- 12. EDGE_CONDITIONS
CREATE TABLE edge_conditions (
    id SERIAL,
    item_or_counter_fk INT NOT NULL,
    operator VARCHAR(2),
    value INT,
    rebro_fk TEXT NOT NULL,
    quest_fk INT NOT NULL
);

ALTER TABLE edge_conditions 
ADD CONSTRAINT PK_edge_conditions PRIMARY KEY (id);

ALTER TABLE edge_conditions 
ADD CONSTRAINT CH_edge_conditions_operator CHECK (operator IN ('>', '>=', '=', '<', '<=', '!='));

-- 13. EDGE_EFFECTS
CREATE TABLE edge_effects (
    id SERIAL,
    item_or_counter_fk INT NOT NULL,
    value INT,
    operation_type VARCHAR(10),
    rebro_fk TEXT NOT NULL,
    quest_fk INT NOT NULL
);

ALTER TABLE edge_effects 
ADD CONSTRAINT PK_edge_effects PRIMARY KEY (id);

ALTER TABLE edge_effects 
ADD CONSTRAINT CH_edge_effects_operation_type CHECK (operation_type IN ('add', 'substract'));

-- 14. USER_PLAYTHROUGHS
CREATE TABLE user_playthroughs (
    id SERIAL,
    items_counters_ending JSON,
    quest_id INT NOT NULL,
    user_id INT NOT NULL
);

ALTER TABLE user_playthroughs 
ADD CONSTRAINT PK_user_playthroughs PRIMARY KEY (id);

-- 15. QUEST_UNLOCK_CONDITIONS
CREATE TABLE quest_unlock_conditions (
    id SERIAL,
    items_counters_ending JSON,
    quest_from_fk INT NOT NULL,
    quest_target_fk INT NOT NULL
);

ALTER TABLE quest_unlock_conditions 
ADD CONSTRAINT PK_quest_unlock_conditions PRIMARY KEY (id);

-- 16. USER_QUEST_COMPLETIONS
CREATE TABLE user_quest_completions (
    prohozhdenie_id INT NOT NULL,
    quest_id INT NOT NULL
);

-- 17. COMMENTS
CREATE TABLE comments (
    id SERIAL,
    book_id INT NOT NULL,
    comment TEXT,
    created_date TIMESTAMP,
    user_id INT NOT NULL
);

ALTER TABLE comments 
ADD CONSTRAINT PK_comments PRIMARY KEY (id);

-- 18. RATINGS
CREATE TABLE ratings (
    book_id INT NOT NULL,
    user_id INT NOT NULL,
    value INT
);

ALTER TABLE ratings 
ADD CONSTRAINT CH_ratings_value CHECK (value >= 1 AND value <= 5);

-- 19. AUTH_SESSIONS
CREATE TABLE auth_sessions (
    user_id INT NOT NULL,
    session_id VARCHAR(255)
);

ALTER TABLE auth_sessions 
ADD CONSTRAINT PK_auth_sessions PRIMARY KEY (session_id);

-- ВНЕШНИЕ КЛЮЧЕЙ
ALTER TABLE authors 
ADD CONSTRAINT FK_authors_users FOREIGN KEY (user_id) REFERENCES users(user_id);

ALTER TABLE books 
ADD CONSTRAINT FK_books_authors FOREIGN KEY (author_id) REFERENCES authors(user_id);

ALTER TABLE book_genres 
ADD CONSTRAINT FK_book_genres_books FOREIGN KEY (book_id) REFERENCES books(book_id);

ALTER TABLE book_genres 
ADD CONSTRAINT FK_book_genres_genres FOREIGN KEY (genre_id) REFERENCES genres(genre_id);

ALTER TABLE quests 
ADD CONSTRAINT FK_quests_books FOREIGN KEY (book_fk) REFERENCES books(book_id);

ALTER TABLE vertices 
ADD CONSTRAINT FK_vertices_quests FOREIGN KEY (quest_fk) REFERENCES quests(id);

ALTER TABLE items_counters 
ADD CONSTRAINT FK_items_counters_quests FOREIGN KEY (quest_fk) REFERENCES quests(id);

ALTER TABLE vertex_item_effects 
ADD CONSTRAINT FK_vertex_item_effects_items_counters FOREIGN KEY (item_fk) REFERENCES items_counters(id);

ALTER TABLE vertex_item_effects 
ADD CONSTRAINT FK_vertex_item_effects_vertices FOREIGN KEY (vertice_fk) REFERENCES vertices(id);

ALTER TABLE vertex_item_effects 
ADD CONSTRAINT FK_vertex_item_effects_quests FOREIGN KEY (quest_fk) REFERENCES quests(id);

ALTER TABLE vertex_counter_effects 
ADD CONSTRAINT FK_vertex_counter_effects_items_counters FOREIGN KEY (counter_fk) REFERENCES items_counters(id);

ALTER TABLE vertex_counter_effects 
ADD CONSTRAINT FK_vertex_counter_effects_vertices FOREIGN KEY (vertice_fk) REFERENCES vertices(id);

ALTER TABLE vertex_counter_effects 
ADD CONSTRAINT FK_vertex_counter_effects_quests FOREIGN KEY (quest_fk) REFERENCES quests(id);

ALTER TABLE edges 
ADD CONSTRAINT FK_edges_vertices_1 FOREIGN KEY (vertice_1_fk) REFERENCES vertices(id);

ALTER TABLE edges 
ADD CONSTRAINT FK_edges_vertices_2 FOREIGN KEY (vertice_2_fk) REFERENCES vertices(id);

ALTER TABLE edges 
ADD CONSTRAINT FK_edges_quests FOREIGN KEY (quest_fk) REFERENCES quests(id);

ALTER TABLE edge_conditions 
ADD CONSTRAINT FK_edge_conditions_items_counters FOREIGN KEY (item_or_counter_fk) REFERENCES items_counters(id);

ALTER TABLE edge_conditions 
ADD CONSTRAINT FK_edge_conditions_edges FOREIGN KEY (rebro_fk) REFERENCES edges(id);

ALTER TABLE edge_conditions 
ADD CONSTRAINT FK_edge_conditions_quests FOREIGN KEY (quest_fk) REFERENCES quests(id);

ALTER TABLE edge_effects 
ADD CONSTRAINT FK_edge_effects_items_counters FOREIGN KEY (item_or_counter_fk) REFERENCES items_counters(id);

ALTER TABLE edge_effects 
ADD CONSTRAINT FK_edge_effects_edges FOREIGN KEY (rebro_fk) REFERENCES edges(id);

ALTER TABLE edge_effects 
ADD CONSTRAINT FK_edge_effects_quests FOREIGN KEY (quest_fk) REFERENCES quests(id);

ALTER TABLE user_playthroughs 
ADD CONSTRAINT FK_user_playthroughs_quests FOREIGN KEY (quest_id) REFERENCES quests(id);

ALTER TABLE user_playthroughs 
ADD CONSTRAINT FK_user_playthroughs_users FOREIGN KEY (user_id) REFERENCES users(user_id);

ALTER TABLE quest_unlock_conditions 
ADD CONSTRAINT FK_quest_unlock_conditions_quests_from FOREIGN KEY (quest_from_fk) REFERENCES quests(id);

ALTER TABLE quest_unlock_conditions 
ADD CONSTRAINT FK_quest_unlock_conditions_quests_target FOREIGN KEY (quest_target_fk) REFERENCES quests(id);

ALTER TABLE user_quest_completions 
ADD CONSTRAINT FK_user_quest_completions_playthroughs FOREIGN KEY (prohozhdenie_id) REFERENCES user_playthroughs(id);

ALTER TABLE user_quest_completions 
ADD CONSTRAINT FK_user_quest_completions_quests FOREIGN KEY (quest_id) REFERENCES quests(id);

ALTER TABLE comments 
ADD CONSTRAINT FK_comments_books FOREIGN KEY (book_id) REFERENCES books(book_id);

ALTER TABLE comments 
ADD CONSTRAINT FK_comments_users FOREIGN KEY (user_id) REFERENCES users(user_id);

ALTER TABLE ratings 
ADD CONSTRAINT FK_ratings_books FOREIGN KEY (book_id) REFERENCES books(book_id);

ALTER TABLE ratings 
ADD CONSTRAINT FK_ratings_users FOREIGN KEY (user_id) REFERENCES users(user_id);

ALTER TABLE auth_sessions 
ADD CONSTRAINT FK_auth_sessions_users FOREIGN KEY (user_id) REFERENCES users(user_id);
