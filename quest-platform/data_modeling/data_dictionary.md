# Data Dictionary | Платформа квестов

## 1. Таблица: users (пользователи)

Хранит информацию о всех пользователях платформы (и авторы, и игроки).

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| user_id | SERIAL | NO | - | Уникальный идентификатор пользователя (PK) |
| username | VARCHAR(255) | NO | - | Логин пользователя (уникальный) |
| hash_password | VARCHAR(255) | NO | - | Хеш пароля (bcrypt) |

---

## 2. Таблица: authors (авторы)

Расширяет users, добавляя авторские права.

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| user_id | INT | NO | - | FK → users.user_id (PK) |
| pseudonym | VARCHAR(255) | YES | NULL | Псевдоним автора (если отличается от username) |

---

## 3. Таблица: books (книги)

Коллекция квестов с метаданными.

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| book_id | SERIAL | NO | - | Уникальный ID книги (PK) |
| name | VARCHAR(255) | NO | - | Название книги |
| description | TEXT | YES | NULL | Описание книги |
| is_published | BOOLEAN | NO | FALSE | Опубликована ли книга |
| created_date | TIMESTAMP | NO | CURRENT_TIMESTAMP | Дата создания |
| author_id | INT | NO | - | FK → authors.user_id |

---

## 4. Таблица: genres (жанры)

Справочник жанров.

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| genre_id | SERIAL | NO | - | ID жанра (PK) |
| name | VARCHAR(100) | NO | - | Название жанра (уникальное) |

---

## 5. Таблица: book_genres (связь книг и жанров)

Связь многие-ко-многим между книгами и жанрами.

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| book_id | INT | NO | - | FK → books.book_id |
| genre_id | INT | NO | - | FK → genres.genre_id |

**PK:** (book_id, genre_id)

---

## 6. Таблица: quests (квесты)

Отдельный квест внутри книги.

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | SERIAL | NO | - | ID квеста (PK) |
| name | VARCHAR(255) | NO | - | Название квеста |
| type | VARCHAR(10) | NO | 'visible' | 'visible' или 'hidden' |
| order_number | INT | YES | NULL | Порядок в книге |
| book_fk | INT | NO | - | FK → books.book_id |

**CHECK:** type IN ('visible', 'hidden')

---

## 7. Таблица: vertices (вершины графа)

Узлы графа квеста — сцены, которые видит игрок.

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | TEXT | NO | - | ID вершины (уникален в рамках квеста) |
| text | TEXT | NO | - | Сюжетный текст сцены |
| ending | VARCHAR(10) | NO | 'none' | 'none', 'bad', 'good' |
| ending_pseudonym | TEXT | YES | NULL | Название концовки (если ending != 'none') |
| timer | INT | YES | NULL | Время на выбор действия (сек) |
| quest_fk | INT | NO | - | FK → quests.id |

**CHECK:** ending IN ('none', 'bad', 'good')

---

## 8. Таблица: edges (ребра графа)

Переходы между вершинами — действия игрока.

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | TEXT | NO | - | ID ребра (уникален в рамках квеста) |
| action_description | TEXT | NO | - | Текст действия (что видит игрок) |
| visibility | VARCHAR(10) | NO | 'always' | 'always' или 'optional' |
| max_visits | INT | NO | 2147483647 | Максимальное число использований |
| vertice_1_fk | TEXT | NO | - | FK → vertices.id (откуда) |
| vertice_2_fk | TEXT | NO | - | FK → vertices.id (куда) |
| quest_fk | INT | NO | - | FK → quests.id |

**CHECK:** visibility IN ('always', 'optional')

---

## 9. Таблица: items_counters (предметы и счетчики)

Полиморфная таблица — хранит и предметы (видимые), и скрытые счетчики.

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| id | SERIAL | NO | - | ID (PK) |
| name | TEXT | NO | - | Название предмета или счетчика |
| min_value | INT | NO | -2147483648 | Минимальное значение (для счетчиков) |
| max_value | INT | NO | 2147483647 | Максимальное значение (для счетчиков) |
| type | VARCHAR(10) | NO | - | 'item' или 'counter' |
| quest_fk | INT | NO | - | FK → quests.id |

**CHECK:** type IN ('item', 'counter')

---

## 10. Таблица: vertex_item_effects (выдача предметов в вершинах)

| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | SERIAL | NO | PK |
| count | INT | NO | Количество выдаваемого предмета (>0) |
| item_fk | INT | NO | FK → items_counters.id |
| vertice_fk | TEXT | NO | FK → vertices.id |
| quest_fk | INT | NO | FK → quests.id |

---

## 11. Таблица: vertex_counter_effects (изменение счетчиков в вершинах)

| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | SERIAL | NO | PK |
| count | INT | NO | На сколько изменить (может быть отрицательным) |
| counter_fk | INT | NO | FK → items_counters.id |
| vertice_fk | TEXT | NO | FK → vertices.id |
| quest_fk | INT | NO | FK → quests.id |

---

## 12. Таблица: user_playthroughs (прохождения игроков)

Сохраняет состояние сессии игрока.

| Column | Type | Nullable | Description |
|--------|------|----------|-------------|
| id | SERIAL | NO | PK |
| current_vertex_id | TEXT | NO | Текущая вершина (FK → vertices.id) |
| inventory_state | JSON | YES | Инвентарь и счетчики в формате JSON |
| quest_fk | INT | NO | FK → quests.id |
| user_id | INT | NO | FK → users.id |
| last_updated | TIMESTAMP | NO | Время последнего обновления |

---

## Связи между таблицами
