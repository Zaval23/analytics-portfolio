-- ADVANCED SQL QUERIES | Социальная сеть
-- 10 показательных запросов

-- 1. PIVOT-аналитика: распределение рождений по временам года (запрос №38)
-- Демонстрирует: CASE-агрегация, условный подсчет
SELECT
    EXTRACT(YEAR FROM date_of_birth) AS year,
    COUNT(CASE WHEN EXTRACT(MONTH FROM date_of_birth) IN (12,1,2) THEN 1 END) AS winter,
    COUNT(CASE WHEN EXTRACT(MONTH FROM date_of_birth) IN (3,4,5) THEN 1 END) AS spring,
    COUNT(CASE WHEN EXTRACT(MONTH FROM date_of_birth) IN (6,7,8) THEN 1 END) AS summer,
    COUNT(CASE WHEN EXTRACT(MONTH FROM date_of_birth) IN (9,10,11) THEN 1 END) AS autumn
FROM Users
GROUP BY year
ORDER BY year;


-- 2. Рекурсивный CTE: правило 6 рукопожатий (запрос №60)
-- Демонстрирует: рекурсия, обход графа, защита от циклов
WITH RECURSIVE bfs AS (
    SELECT user_id1 AS start_u, user_id2 AS end_u, 1 AS depth
    FROM (SELECT user_id1, user_id2 FROM Friends UNION SELECT user_id2, user_id1 FROM Friends) f
    
    UNION
    
    SELECT b.start_u, f.user_id2, b.depth + 1
    FROM bfs b
    JOIN Friends f ON b.end_u = f.user_id1
    WHERE b.depth < 6
)
SELECT 
    start_u, 
    end_u, 
    MIN(depth) AS distance
FROM bfs
GROUP BY start_u, end_u
ORDER BY distance;


-- 3. Многотабличная аналитика: статистика по сообществам (запрос №59 - упрощенная версия)
-- Демонстрирует: CTE, COUNT(DISTINCT CASE), оконные функции
WITH community_activity AS (
    SELECT 
        c.community_id,
        c.community_name,
        COUNT(DISTINCT cm.user_id) AS total_members,
        COUNT(DISTINCT CASE 
            WHEN c2.comment_id IS NOT NULL OR l.user_id IS NOT NULL OR p2.post_id IS NOT NULL 
            THEN cm.user_id 
        END) AS active_members
    FROM Communities c
    LEFT JOIN CommunityMembers cm ON c.community_id = cm.community_id
    LEFT JOIN Posts p ON cm.community_id = p.community_id
    LEFT JOIN Comments c2 ON p.post_id = c2.post_id AND c2.user_id = cm.user_id
    LEFT JOIN Likes l ON p.post_id = l.post_id AND l.user_id = cm.user_id
    LEFT JOIN Posts p2 ON cm.community_id = p2.community_id AND p2.user_id = cm.user_id
    GROUP BY c.community_id, c.community_name
)
SELECT 
    community_name,
    total_members,
    active_members,
    ROUND(100.0 * active_members / NULLIF(total_members, 0), 2) AS active_percent,
    RANK() OVER (ORDER BY active_members DESC) AS activity_rank
FROM community_activity
ORDER BY community_name;


-- 4. Оконная функция: последнее сообщение пользователя (запрос №41)
-- Демонстрирует: подзапрос с MAX для получения последней записи
SELECT 
    u.user_id,
    u.last_name || ' ' || u.first_name AS full_name,
    m.message_text AS last_message
FROM Users u
LEFT JOIN (
    SELECT user_id, MAX(send_date) AS last_time
    FROM Messages
    GROUP BY user_id
) last_m ON u.user_id = last_m.user_id
LEFT JOIN Messages m 
    ON m.user_id = u.user_id AND m.send_date = last_m.last_time
ORDER BY u.user_id;


-- 5. MAX с ALL: пользователь с max публикаций в сообществе (запрос №43)
-- Демонстрирует: подзапрос с ALL, группировка по двум полям
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    p.community_id,
    COUNT(p.post_id) AS posts_in_community
FROM Users u
JOIN Posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.first_name, u.last_name, p.community_id
HAVING COUNT(p.post_id) >= ALL (
    SELECT COUNT(p2.post_id)
    FROM Users u2
    JOIN Posts p2 ON u2.user_id = p2.user_id
    GROUP BY u2.user_id, p2.community_id
)
ORDER BY u.user_id;


-- 6. NOT EXISTS: пользователи, писавшие ВСЕМ друзьям (запрос №48)
-- Демонстрирует: двойное NOT EXISTS (нет друга, которому не писал)
SELECT u.*
FROM Users u
WHERE NOT EXISTS (
    SELECT 1
    FROM Friends f
    WHERE f.user_id1 = u.user_id
    AND NOT EXISTS (
        SELECT 1
        FROM Messages m
        WHERE m.user_id = u.user_id AND m.receiver_id = f.user_id2
    )
);


-- 7. HAVING с агрегацией: пользователи, пишущие ТОЛЬКО друзьям (запрос №32)
-- Демонстрирует: сравнение счетчиков через HAVING
SELECT u.user_id, u.last_name, u.first_name
FROM Users u
JOIN Messages m ON u.user_id = m.user_id
LEFT JOIN Friends f
    ON (m.user_id = f.user_id1 AND m.receiver_id = f.user_id2)
    OR (m.user_id = f.user_id2 AND m.receiver_id = f.user_id1)
GROUP BY u.user_id, u.last_name, u.first_name
HAVING COUNT(m.message_id) = COUNT(f.user_id1);


-- 8. Сложная фильтрация: пользователи в топ-2 и флоп-2 сообществах (запрос №46)
-- Демонстрирует: множественные подзапросы, IN с агрегациями
WITH community_post_counts AS (
    SELECT community_id, COUNT(*) AS post_count
    FROM Posts
    GROUP BY community_id
)
SELECT u.first_name, u.last_name
FROM Users u
WHERE (
    SELECT COUNT(DISTINCT p.community_id)
    FROM Posts p
    WHERE p.user_id = u.user_id
      AND p.community_id IN (
          SELECT community_id FROM community_post_counts
          WHERE post_count = (SELECT MAX(post_count) FROM community_post_counts)
      )
) >= 2
AND (
    SELECT COUNT(DISTINCT p.community_id)
    FROM Posts p
    WHERE p.user_id = u.user_id
      AND p.community_id IN (
          SELECT community_id FROM community_post_counts
          WHERE post_count = (SELECT MIN(post_count) FROM community_post_counts)
      )
) >= 2;


-- 9. Вложенные NOT EXISTS: пользователи, не ответившие не-друзьям (запрос №54)
-- Демонстрирует: тройную вложенность, сложную логику EXISTS
SELECT DISTINCT u.last_name, u.first_name, u.middle_name
FROM Users u
WHERE NOT EXISTS (
    SELECT 1
    FROM Messages m_in
    WHERE m_in.receiver_id = u.user_id
      AND NOT EXISTS (
          SELECT 1 FROM Friends f
          WHERE (f.user_id1 = u.user_id AND f.user_id2 = m_in.user_id)
             OR (f.user_id2 = u.user_id AND f.user_id1 = m_in.user_id)
      )
      AND NOT EXISTS (
          SELECT 1 FROM Messages m_out
          WHERE m_out.user_id = u.user_id
            AND m_out.receiver_id = m_in.user_id
            AND m_out.send_date > m_in.send_date
      )
);


-- 10. GENERATE_SERIES + анти-JOIN: дни без публикаций (запрос №58)
-- Демонстрирует: генерация временного ряда, NOT EXISTS
SELECT d::DATE AS day_date
FROM GENERATE_SERIES(
    DATE_TRUNC('year', CURRENT_DATE)::DATE,
    DATE_TRUNC('year', CURRENT_DATE)::DATE + INTERVAL '1 year' - INTERVAL '1 day',
    '1 day'
) AS d
WHERE NOT EXISTS (
    SELECT 1 FROM Posts p
    WHERE p.post_date = d::DATE
)
ORDER BY d;


