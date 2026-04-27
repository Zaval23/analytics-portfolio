# Data Dictionary — платформа квестов
Документ соответствует скрипту `schema.sql` (PostgreSQL). Имена колонок — **как в DDL** (`pseudonim`, `ending_pseudonim`).
**Условные обозначения:** PK — первичный ключ; FK — внешний ключ; UQ — UNIQUE; CH — CHECK.
---
## 1. `users` — учётные записи
| Column | Type | Nullable | Default | Constraints | Description |
|--------|------|----------|---------|---------------|-------------|
| user_id | SERIAL | NO | автовывод | PK | Идентификатор пользователя |
| username | VARCHAR(255) | YES | — | UQ | Логин |
| hash_password | VARCHAR(255) | YES | — | — | Хеш пароля |
---
## 2. `authors` — авторы
Расширение `users`: право владеть книгами.
| Column | Type | Nullable | Default | Constraints | Description |
|--------|------|----------|---------|---------------|-------------|
| user_id | INT | NO | — | PK, FK → `users(user_id)` | Тот же id, что в `users` |
| pseudonim | VARCHAR(255) | YES | NULL | — | Отображаемое имя |
---
## 3. `books` — книги
| Column | Type | Nullable | Default | Constraints | Description |
|--------|------|----------|---------|---------------|-------------|
| book_id | SERIAL | NO | автовывод | PK | Идентификатор книги |
| name | VARCHAR(255) | YES | NULL | — | Название |
| is_published | BOOLEAN | YES | NULL | — | Опубликована ли книга |
| created_date | TIMESTAMP | YES | NULL | — | Дата создания |
| author_id | INT | NO | — | FK → `authors(user_id)` | Автор |
---
## 4. `genres` — жанры
| Column | Type | Nullable | Default | Constraints | Description |
|--------|------|----------|---------|---------------|-------------|
| genre_id | SERIAL | NO | автовывод | PK | Идентификатор жанра |
| name | VARCHAR(100) | YES | NULL | UQ | Название (уникальное) |
---
## 5. `book_genres` — книги и жанры (M:N)
**PK:** `(book_id, genre_id)`.
| Column | Type | Nullable | FK |
|--------|------|----------|-----|
| book_id | INT | NO | `books(book_id)` |
| genre_id | INT | NO | `genres(genre_id)` |
---
## 6. `quests` — квест внутри книги
| Column | Type | Nullable | Default | Constraints | Description |
|--------|------|----------|---------|---------------|-------------|
| id | SERIAL | NO | автовывод | PK | Идентификатор квеста |
| name | VARCHAR(255) | YES | NULL | — | Название |
| type | VARCHAR(10) | YES | NULL | CH: `visible` \| `hidden` | Видимость в книге |
| order_number | INT | YES | NULL | — | Порядок |
| book_fk | INT | NO | — | FK → `books(book_id)` | Родительская книга |
---
## 7. `vertices` — вершины графа (сцены)
| Column | Type | Nullable | Default | Constraints | Description |
|--------|------|----------|---------|---------------|-------------|
| id | TEXT | YES* | — | PK | Идентификатор вершины в рамках квеста |
| text | TEXT | YES | NULL | — | Текст сцены |
| ending | VARCHAR(10) | YES | NULL | CH: `none` \| `bad` \| `good` | Тип финала |
| ending_pseudonim | TEXT | YES | NULL | — | Подпись концовки |
| timer | INT | YES | NULL | — | Лимит времени (сек) |
| quest_fk | INT | NO | — | FK → `quests(id)` | Квест |
\* Для целостности данных обычно задают `NOT NULL` на `id` отдельной миграцией.
---
## 8. `items_counters` — предметы и счётчики
| Column | Type | Nullable | Default | Constraints | Description |
|--------|------|----------|---------|---------------|-------------|
| id | SERIAL | NO | автовывод | PK | Идентификатор |
| name | TEXT | YES | NULL | — | Название |
| min_value | INT | YES | -2147483648 | — | Нижняя граница счётчика |
| max_value | INT | YES | 2147483647 | — | Верхняя граница счётчика |
| type | VARCHAR(10) | YES | NULL | CH: `item` \| `counter` | Тип строки |
| quest_fk | INT | NO | — | FK → `quests(id)` | Квест |
---
## 9. `vertex_item_effects` — выдача предмета на вершине
| Column | Type | Nullable | Constraints | Description |
|--------|------|----------|-------------|-------------|
| id | SERIAL | NO | PK | |
| count | INT | NO | CH: `count > 0` | Количество |
| item_fk | INT | NO | FK → `items_counters(id)` | Предмет (`type = item`) |
| vertice_fk | TEXT | NO | FK → `vertices(id)` | Вершина |
| quest_fk | INT | NO | FK → `quests(id)` | Квест |
---
## 10. `vertex_counter_effects` — изменение счётчика на вершине
| Column | Type | Nullable | Constraints | Description |
|--------|------|----------|-------------|-------------|
| id | SERIAL | NO | PK | |
| count | INT | NO | CH: `count <> 0` | Изменение (может быть < 0) |
| counter_fk | INT | NO | FK → `items_counters(id)` | Счётчик |
| vertice_fk | TEXT | NO | FK → `vertices(id)` | Вершина |
| quest_fk | INT | NO | FK → `quests(id)` | Квест |
---
## 11. `edges` — рёбра (переходы)
| Column | Type | Nullable | Default | Constraints | Description |
|--------|------|----------|---------|---------------|-------------|
| id | TEXT | YES* | — | PK | Идентификатор ребра |
| action_description | TEXT | YES | NULL | — | Текст действия |
| visibility | VARCHAR(10) | YES | NULL | CH: `always` \| `optional` | Видимость |
| max_visits | INT | YES | 2147483647 | CH: `> 0` | Лимит проходов |
| vertice_1_fk | TEXT | NO | FK → `vertices(id)` | Из вершины |
| vertice_2_fk | TEXT | NO | FK → `vertices(id)` | В вершину |
| quest_fk | INT | NO | FK → `quests(id)` | Квест |
---
## 12. `edge_conditions` — условия на ребро
| Column | Type | Nullable | Constraints | Description |
|--------|------|----------|-------------|-------------|
| id | SERIAL | NO | PK | |
| item_or_counter_fk | INT | NO | FK → `items_counters(id)` | Что проверять |
| operator | VARCHAR(2) | YES | CH: `>`, `>=`, `=`, `<`, `<=`, `!=` | Оператор |
| value | INT | YES | — | Значение |
| rebro_fk | TEXT | NO | FK → `edges(id)` | Ребро |
| quest_fk | INT | NO | FK → `quests(id)` | Квест |
---
## 13. `edge_effects` — эффекты при переходе по ребру
| Column | Type | Nullable | Constraints | Description |
|--------|------|----------|-------------|-------------|
| id | SERIAL | NO | PK | |
| item_or_counter_fk | INT | NO | FK → `items_counters(id)` | Цель |
| value | INT | YES | — | Величина |
| operation_type | VARCHAR(10) | YES | CH: `add` \| `substract`* | Операция |
\* В DDL допущена форма `substract` (не `subtract`).
| Column (продолжение) | Type | Nullable | Constraints |
|---------------------|------|----------|-------------|
| rebro_fk | TEXT | NO | FK → `edges(id)` |
| quest_fk | INT | NO | FK → `quests(id)` |
---
## 14. `user_playthroughs` — прохождение квеста
| Column | Type | Nullable | Constraints | Description |
|--------|------|----------|-------------|-------------|
| id | SERIAL | NO | PK | Сессия прохождения |
| items_counters_ending | JSON | YES | NULL | Состояние предметов/счётчиков |
| quest_id | INT | NO | FK → `quests(id)` | Квест |
| user_id | INT | NO | FK → `users(user_id)` | Пользователь |
---
## 15. `quest_unlock_conditions` — условия разблокировки квеста
| Column | Type | Nullable | Constraints | Description |
|--------|------|----------|-------------|-------------|
| id | SERIAL | NO | PK | |
| items_counters_ending | JSON | YES | NULL | Условие в JSON |
| quest_from_fk | INT | NO | FK → `quests(id)` | Контекст |
| quest_target_fk | INT | NO | FK → `quests(id)` | Целевой квест |
---
## 16. `user_quest_completions` — завершение квеста в сессии
| Column | Type | Nullable | Constraints | Description |
|--------|------|----------|-------------|-------------|
| prohozhdenie_id | INT | NO | FK → `user_playthroughs(id)` | Прохождение |
| quest_id | INT | NO | FK → `quests(id)` | Квест |
**Примечание:** в DDL нет PRIMARY KEY; для однозначности строк рекомендуется PK или UNIQUE `(prohozhdenie_id, quest_id)`.
---
## 17. `comments` — комментарии к книге
| Column | Type | Nullable | Constraints | Description |
|--------|------|----------|-------------|-------------|
| id | SERIAL | NO | PK | |
| book_id | INT | NO | FK → `books(book_id)` | Книга |
| comment | TEXT | YES | NULL | Текст |
| created_date | TIMESTAMP | YES | NULL | Дата |
| user_id | INT | NO | FK → `users(user_id)` | Автор |
---
## 18. `ratings` — оценки книг
| Column | Type | Nullable | Constraints | Description |
|--------|------|----------|-------------|-------------|
| book_id | INT | NO | FK → `books(book_id)` | Книга |
| user_id | INT | NO | FK → `users(user_id)` | Пользователь |
| value | INT | YES | CH: 1–5 | Оценка |
**Примечание:** PK в DDL не задан; типично UNIQUE `(book_id, user_id)` или составной PK.
---
## 19. `auth_sessions` — сессии входа
| Column | Type | Nullable | Constraints | Description |
|--------|------|----------|-------------|-------------|
| user_id | INT | NO | FK → `users(user_id)` | Пользователь |
| session_id | VARCHAR(255) | NO | PK | Идентификатор сессии |
---
## Карта внешних ключей
| Дочерняя таблица | Поля FK | Родитель |
|------------------|---------|----------|
| authors | user_id | users |
| books | author_id | authors |
| book_genres | book_id, genre_id | books, genres |
| quests | book_fk | books |
| vertices, items_counters | quest_fk | quests |
| vertex_item_effects | item_fk, vertice_fk, quest_fk | items_counters, vertices, quests |
| vertex_counter_effects | counter_fk, vertice_fk, quest_fk | items_counters, vertices, quests |
| edges | vertice_1_fk, vertice_2_fk, quest_fk | vertices, quests |
| edge_conditions | item_or_counter_fk, rebro_fk, quest_fk | items_counters, edges, quests |
| edge_effects | item_or_counter_fk, rebro_fk, quest_fk | items_counters, edges, quests |
| user_playthroughs | quest_id, user_id | quests, users |
| quest_unlock_conditions | quest_from_fk, quest_target_fk | quests |
| user_quest_completions | prohozhdenie_id, quest_id | user_playthroughs, quests |
| comments | book_id, user_id | books, users |
| ratings | book_id, user_id | books, users |
| auth_sessions | user_id | users |
