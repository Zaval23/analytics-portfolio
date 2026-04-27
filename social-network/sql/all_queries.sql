
-- Все 60 SQL-запросов по ТЗ (ТЗ_соцсеть.md)
-- PostgreSQL

-- 1. Выбрать все данные о пользователях. 
-- Результат отсортировать по фамилии в порядке обратном лексикографическому.
SELECT *
FROM Users
ORDER BY last_name DESC;

-- 2. Выбрать годы рождения пользователей без повторений. 
-- Результат отсортировать в порядке возрастания года.
SELECT DISTINCT EXTRACT(YEAR FROM date_of_birth) AS birth_year
FROM Users
ORDER BY birth_year;

-- 3. Выбрать фамилию и инициалы пользователей, рожденных в 1999, 1997, 2000, 1993, 1990 годах. 
-- Результат отсортировать по месяцу рождения от января до декабря.
SELECT last_name || ' ' || LEFT(first_name,1) || '.' || LEFT(middle_name,1) || '.' AS FIO
FROM Users
WHERE EXTRACT(YEAR FROM date_of_birth) IN (1990,1993,1997,1999,2000)
ORDER BY EXTRACT(MONTH FROM date_of_birth);

-- 4. Выбрать текст публикаций пользователя с id = 1, сделанных в текущем месяце.
SELECT post_text
FROM Posts
WHERE user_id = 74
  AND EXTRACT(MONTH FROM post_date) = EXTRACT(MONTH FROM CURRENT_DATE)
  AND EXTRACT(YEAR FROM post_date) = EXTRACT(YEAR FROM CURRENT_DATE);

-- 5. Выбрать все данные о пользователях, рожденных с 1990 по 2000 год.
SELECT *
FROM Users
WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 1990 AND 2000;

-- 6. Выбрать все данные публикаций, текст которых содержит «ВГУ» или «ПММ 50 лет». 
-- Результат отсортировать по дате в порядке убывания и по id пользователя в убывающем порядке.
SELECT *
FROM Posts
WHERE post_text LIKE '%ВГУ%' OR post_text LIKE '%ПММ 50 лет%'
ORDER BY post_date DESC, user_id DESC;

-- 7. Выбрать данные публикаций, текст которых содержит символы: «-», «_», «%» или «&», но не содержат «ВГУ».
SELECT *
FROM Posts
WHERE (post_text LIKE '%-%' OR post_text LIKE '%_%' OR post_text LIKE '%%%' OR post_text LIKE '%&%')
  AND post_text NOT LIKE '%ВГУ%';

-- 8. Выбрать данные сообществ, у которых не указано описание.
SELECT *
FROM Communities
WHERE description IS NULL;

-- 9. Выбрать фамилию, инициалы и дату рождения пользователя в одном столбце. 
-- Результат отсортировать по дате в убывающем порядке, по длине фамилии, имени, отчества в возрастающем порядке.
SELECT last_name || ' ' || LEFT(first_name,1) || '.' || LEFT(middle_name,1) || '.' || ' ' || CAST(date_of_birth AS VARCHAR(20)) AS FIO_AND_BIRTH
FROM Users
ORDER BY date_of_birth DESC, LENGTH(last_name), LENGTH(first_name), LENGTH(middle_name);

-- 10. Выбрать id и фамилии, имена, отчества пользователей. 
-- В отдельном столбце указать название времени года, в котором пользователь празднует день рождения. 
-- Результат отсортировать: 
-- 1) пользователи, рожденные с 1990 по 2000 год, 
-- 2) пользователи, рожденные после 2000 года, 
-- 3) остальные.
SELECT 
    user_id,
    last_name,
    first_name,
    middle_name,
    CASE
        WHEN EXTRACT(MONTH FROM date_of_birth) IN (12, 1, 2) THEN 'Зима'
        WHEN EXTRACT(MONTH FROM date_of_birth) IN (3, 4, 5) THEN 'Весна'
        WHEN EXTRACT(MONTH FROM date_of_birth) IN (6, 7, 8) THEN 'Лето'
        WHEN EXTRACT(MONTH FROM date_of_birth) IN (9, 10, 11) THEN 'Осень'
    END AS season
FROM Users
ORDER BY 
    CASE
        WHEN EXTRACT(YEAR FROM date_of_birth) BETWEEN 1990 AND 2000 THEN 1
        WHEN EXTRACT(YEAR FROM date_of_birth) > 2000 THEN 2
        ELSE 3
    END,
    date_of_birth;

-- 11. Выбрать название сообщества, идущего первым в списке сообществ, 
-- упорядоченных по названию в лексикографическом порядке (без LIMIT).
SELECT community_name
FROM Communities
WHERE community_name = (SELECT MIN(community_name) FROM Communities);

-- 12. Выбрать средний возраст пользователей.
SELECT AVG(EXTRACT(YEAR FROM AGE(date_of_birth))) AS average_age
FROM Users;

-- 13. Выбрать общее количество различных годов рождения пользователей.
SELECT COUNT(DISTINCT EXTRACT(YEAR FROM date_of_birth)) AS unique_birth_years
FROM Users;

-- 14. Выбрать максимальный и минимальный возраст пользователей.
SELECT 
    MAX(EXTRACT(YEAR FROM AGE(date_of_birth))) AS max_age,
    MIN(EXTRACT(YEAR FROM AGE(date_of_birth))) AS min_age
FROM Users;

-- 15. Выбрать год рождения самого молодого пользователя, рожденного весной (без LIMIT).
SELECT EXTRACT(YEAR FROM date_of_birth) AS birth_year
FROM Users
WHERE EXTRACT(MONTH FROM date_of_birth) IN (3, 4, 5)
  AND date_of_birth = (
      SELECT MAX(date_of_birth)
      FROM Users
      WHERE EXTRACT(MONTH FROM date_of_birth) IN (3, 4, 5)
  );

--16. Вывести фамилию, имя, отчество пользователя, даты и
--тексты всех публикаций. Результат отсортировать по фамилии,
--Имени, отчеству в порядке обратном лексикографическому
SELECT last_name || ' ' || LEFT(first_name,1) || '.' || LEFT(middle_name,1) || '.' AS FIO, --почмотерть по отчеству
	   p.post_date,
	   p.post_text
FROM Users u JOIN Posts p ON u.user_id = p.user_id
ORDER BY u.last_name DESC,
	     u.first_name DESC, 
		 u.middle_name DESC;

-- 17. Вывести фамилию, имя, отчество пользователя, даты и тексты всех публикаций,
-- названия сообществ, на которые подписан пользователь, тексты сообщений, которые писал пользователь.
-- Результат отсортировать по дате рождения пользователя в убывающем порядке,
-- по фамилии, имени и отчеству в порядке обратном лексикографическому,
-- по дате публикации в возрастающем порядке.

SELECT 
    last_name || ' ' || LEFT(first_name,1) || '.' || LEFT(middle_name,1) || '.' AS FIO,
    p.post_date,
    p.post_text,
    c.community_name,
    m.message_text
FROM Users u
LEFT JOIN Posts p ON u.user_id = p.user_id
LEFT JOIN CommunityMembers cm ON u.user_id = cm.user_id
LEFT JOIN Communities c ON cm.community_id = c.community_id
LEFT JOIN Messages m ON u.user_id = m.user_id 
ORDER BY 
    u.date_of_birth DESC,
    u.last_name DESC,
    u.first_name DESC,
    u.middle_name DESC,
    p.post_date ;

-- 18. Выбрать фамилии, имена, отчества всех друзей пользователя Иванова Ивана Ивановича
SELECT 
    u2.last_name,
    u2.first_name,
    u2.middle_name
FROM Users u1
JOIN Friends f 
    ON u1.user_id = f.user_id1 OR u1.user_id = f.user_id2
JOIN Users u2 
    ON (u2.user_id = f.user_id1 OR u2.user_id = f.user_id2)
   AND u2.user_id <> u1.user_id
WHERE 
    u1.last_name = 'Иванов'
    AND u1.first_name = 'Иван'
    AND u1.middle_name = 'Иванович';

-- 19. Выбрать фамилии, имена, отчества пользователей,
-- которые отправляли сообщения друзьям и получали от них ответные сообщения.

SELECT DISTINCT u.last_name, u.first_name, u.middle_name
FROM Users u
JOIN Messages m1 ON u.user_id = m1.user_id             
JOIN Messages m2 ON m1.receiver_id = m2.user_id                    
    AND m1.user_id = m2.receiver_id;                    

-- 20. Вывести имя пользователя, дату рождения и количество сообщений, им написанных.
SELECT 
    u.first_name ||' ' || u.last_name AS User_name,
    u.date_of_birth,
    COUNT(m.message_id) AS message_count
FROM Users u
LEFT JOIN Messages m ON u.user_id = m.user_id
GROUP BY u.first_name,	u.last_name, u.date_of_birth;

-- 21. Выбрать все данные пользователей, которые участвуют
-- как минимум в двух сообществах.
SELECT 
FROM Users
WHERE user_id IN 
   (SELECT user_id
    FROM CommunityMembers
    GROUP BY user_id
    HAVING COUNT(community_id) >= 2);

-- 22. Выбрать фамилии, имена, отчества несовершеннолетних пользователей
-- и количество их друзей. Результат отсортировать по количеству друзей в убывающем порядке.
SELECT 
    u.last_name,
    u.first_name,
    u.middle_name,
    COUNT(f.*) AS friend_count
FROM Users u
JOIN Friends f 
    ON u.user_id IN (f.user_id1, f.user_id2)
WHERE 
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, u.date_of_birth)) < 18
GROUP BY 
    u.user_id, u.last_name, u.first_name, u.middle_name
ORDER BY 
    friend_count DESC;

-- 23. Выбрать фамилии, имена, отчества пользователей младше 30 лет,
-- у которых более д друзей. Результат отсортировать по фамилии, имени, отчеству.

SELECT 
    u.last_name,
    u.first_name,
    u.middle_name
FROM Users u
JOIN Friends f 
    ON u.user_id = f.user_id1 OR u.user_id = f.user_id2
WHERE 
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, u.date_of_birth)) < 30
GROUP BY 
    u.user_id, u.last_name, u.first_name, u.middle_name
HAVING 
    COUNT(*) > 2
ORDER BY 
    u.last_name, u.first_name, u.middle_name;

-- 24. Выбрать все данные о пользователях – полных тезках 
-- (фамилии, имена, отчества совпадают), рожденных в один день, но в разные годы.
-- полумать насчет повторений дистинкта
SELECT  u1.*
FROM Users u1
JOIN Users u2 
    ON u1.last_name = u2.last_name
   AND u1.first_name = u2.first_name
   AND u1.middle_name = u2.middle_name
   AND EXTRACT(MONTH FROM u1.date_of_birth) = EXTRACT(MONTH FROM u2.date_of_birth)
   AND EXTRACT(DAY FROM u1.date_of_birth) = EXTRACT(DAY FROM u2.date_of_birth)
   AND EXTRACT(YEAR FROM u1.date_of_birth) <> EXTRACT(YEAR FROM u2.date_of_birth);

-- 25. Для каждого пользователя указать даты первой и последней публикаций. 
--В результат включить пользователей старше 20 лет, 
--входящих в сообщество N (например, community_id = 1), имеющих более трех друзей.
WITH user_friend_count AS (
    SELECT 
        u.user_id,
        COUNT(f.user_id2) AS friend_count
    FROM Users u
    LEFT JOIN Friends f ON u.user_id = f.user_id1
    GROUP BY u.user_id
)
SELECT 
    u.user_id,
    u.last_name,
    u.first_name,
    u.middle_name,
    MIN(p.post_date) AS first_post_date,
    MAX(p.post_date) AS last_post_date
FROM Users u
JOIN user_friend_count ufc ON u.user_id = ufc.user_id
JOIN CommunityMembers cm ON u.user_id = cm.user_id
JOIN Posts p ON u.user_id = p.user_id
WHERE cm.community_id = 22 
  AND ufc.friend_count > 3
  AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, u.date_of_birth)) > 20
GROUP BY u.user_id, u.last_name, u.first_name, u.middle_name
ORDER BY u.last_name, u.first_name, u.middle_name;

-- 26. Вывести данные всех пользователей и, если есть сообщения у пользователя, то вывести текст сообщений.
SELECT 
    u.user_id,
    u.last_name,
    u.first_name,
    u.middle_name,
    u.date_of_birth,
    u.place_of_residence,
    u.place_of_work,
    u.phone,
    u.email,
    u.password,
    u.settlement_id,
    m.message_text
FROM Users u
LEFT JOIN Messages m ON u.user_id = m.user_id
ORDER BY u.user_id, m.send_date;

-- 27. Вывести для каждого пользователя количество его сообщений.
SELECT 
    u.user_id,
    u.last_name,
    u.first_name,
    u.middle_name,
    COUNT(m.message_id) AS message_count
FROM Users u
LEFT JOIN Messages m ON u.user_id = m.user_id
GROUP BY u.user_id, u.last_name, u.first_name, u.middle_name
ORDER BY message_count DESC, u.user_id;

-- 28. Для каждого пользователя, имеющего друзей, вывести
-- названия всех сообществ.
SELECT
    u.user_id,
    u.last_name,
    u.first_name,
    u.middle_name,
    c.community_name
FROM Users u
JOIN Friends f
    ON u.user_id = f.user_id1 OR u.user_id = f.user_id2   
CROSS JOIN Communities c                                    
GROUP BY 
    u.user_id, u.last_name, u.first_name, u.middle_name, c.community_name
ORDER BY 
	u.user_id, u.last_name, u.first_name, u.middle_name, c.community_name;

--29. Для каждого пользователя вывести названия всех
--сообществ. И, если пользователь является членом сообщества, то
--вывести в последнем столбце результирующей таблицы +.
SELECT u.user_id,
    u.last_name,
    u.first_name,
    u.middle_name,
    c.community_name,
    CASE 
        WHEN cm.user_id IS NOT NULL THEN '+'
        ELSE ''
    END AS is_member
FROM Users u
CROSS JOIN Communities c
LEFT JOIN CommunityMembers cm
    ON u.user_id = cm.user_id 
   AND c.community_id = cm.community_id
ORDER BY 
    u.last_name, u.first_name, u.middle_name, c.community_name;

-- 30. Для каждого пользователя выбрать количество людей, с которыми он обменивался сообщениями.
SELECT 
    u.user_id,
    u.last_name,
    u.first_name,
    u.middle_name,
    COUNT(DISTINCT 
        CASE 
            WHEN m.user_id = u.user_id THEN m.receiver_id
            WHEN m.receiver_id = u.user_id THEN m.user_id
        END
    ) AS unique_correspondents
FROM Users u
LEFT JOIN Messages m ON u.user_id = m.user_id OR u.user_id = m.receiver_id
GROUP BY u.user_id, u.last_name, u.first_name, u.middle_name
ORDER BY unique_correspondents DESC, u.user_id;

-- 31. Выбрать названия сообществ, в которых есть пользова-
--тели, сделавшие несколько публикаций в текущем месяце. Резуль-
--тат отсортировать в лексикографическом порядке.
SELECT DISTINCT c.community_name
FROM Posts p
JOIN Communities c 
    ON p.community_id = c.community_id
WHERE EXTRACT(YEAR FROM p.post_date) = EXTRACT(YEAR FROM CURRENT_DATE)
  AND EXTRACT(MONTH FROM p.post_date) = EXTRACT(MONTH FROM CURRENT_DATE)
GROUP BY c.community_name, p.user_id
HAVING COUNT(p.post_id) > 1
ORDER BY c.community_name;

	
--32. Выбрать пользователей, которые пишут сообщения
--только своим друзьям.
SELECT u.user_id,
    u.last_name,
    u.first_name,
    u.middle_name
FROM Users u
JOIN Messages m ON u.user_id = m.user_id
LEFT JOIN Friends f
    ON (m.user_id = f.user_id1 AND m.receiver_id = f.user_id2)
    OR (m.user_id = f.user_id2 AND m.receiver_id = f.user_id1)
GROUP BY u.user_id, u.last_name, u.first_name, u.middle_name
HAVING COUNT(m.message_id) = COUNT(f.user_id1);

--33. Выбрать все данные пользователей, у которых более N
--друзей.
SELECT u.*
FROM Users u
JOIN Friends f 
    ON u.user_id = f.user_id1 OR u.user_id = f.user_id2
GROUP BY 
    u.user_id, u.last_name, u.first_name, u.middle_name,
    u.date_of_birth, u.place_of_residence, u.place_of_work,
    u.phone, u.email, u.password, u.settlement_id
HAVING COUNT(*) > 5; 

--34. Выбрать название сообщества и количество участников
--сообщества. В результат включить только сообщества, названия
--которых состоят из двух или более слов и в которых более N уча-
--стников.
SELECT 
    c.community_name,
    COUNT(cm.user_id) AS member_count
FROM Communities c
JOIN CommunityMembers cm 
    ON c.community_id = cm.community_id
WHERE c.community_name LIKE '% %' -- сделать с помощью тем чтото там обрезать чтобы не попали пробелы
GROUP BY c.community_id, c.community_name
HAVING COUNT(cm.user_id) > 1   
ORDER BY c.community_name;

--35. Выбрать всех пользователей, если пользователь – участ-
--ник какого-либо сообщества, то название сообщества.
SELECT 
    u.user_id,
    u.last_name,
    u.first_name,
    u.middle_name,
    c.community_name
FROM Users u
LEFT JOIN CommunityMembers cm 
    ON u.user_id = cm.user_id
LEFT JOIN Communities c 
    ON cm.community_id = c.community_id
ORDER BY u.user_id;


--36. Выбрать всех пользователей, количество друзей пользо-
--вателя, если пользователь – участник сообщества или сообществ, то количество сообществ.
SELECT 
    u.user_id,
    u.last_name,
    u.first_name,
    u.middle_name,
    COUNT(DISTINCT CASE 
                      WHEN f.user_id1 = u.user_id THEN f.user_id2
                      WHEN f.user_id2 = u.user_id THEN f.user_id1
                  END) AS friend_count,
    COUNT(DISTINCT cm.community_id) AS community_count
FROM Users u
LEFT JOIN Friends f 
    ON u.user_id = f.user_id1 OR u.user_id = f.user_id2
LEFT JOIN CommunityMembers cm 
    ON u.user_id = cm.user_id
GROUP BY u.user_id, u.last_name, u.first_name, u.middle_name
ORDER BY u.user_id;

--37. Выбрать фамилию, имя, отчество пользователя, фами-
--лию и инициалы его друзей, тексты сообщений, названия сооб-
--ществ, членом которых он является. Результат отсортировать по
--названию сообщества в лексикографическом порядке, по фамилии
--пользователя в порядке обратном лексикографическому, по имени
--в прямом порядке, по отчеству в порядке обратном лексикографи-
--ческому. В результат должны войти все пользователи независимо
--от того, являются ли они членами сообщества или нет, есть ли у
--них друзья или нет.
SELECT 
    u.last_name,
    u.first_name,
    u.middle_name,
    f_u.last_name || ' ' ||
    LEFT(f_u.first_name, 1) || '.' ||
    CASE 
        WHEN f_u.middle_name IS NOT NULL AND f_u.middle_name <> '' 
        THEN LEFT(f_u.middle_name, 1) || '.'
        ELSE ''
    END AS friend_fio_short,
    m.message_text,
    c.community_name
FROM Users u
LEFT JOIN Friends f
    ON u.user_id = f.user_id1 OR u.user_id = f.user_id2
LEFT JOIN Users f_u
    ON f_u.user_id = 
       CASE 
           WHEN f.user_id1 = u.user_id THEN f.user_id2
           WHEN f.user_id2 = u.user_id THEN f.user_id1
       END
LEFT JOIN Messages m
    ON u.user_id = m.user_id
LEFT JOIN CommunityMembers cm
    ON u.user_id = cm.user_id

LEFT JOIN Communities c
    ON cm.community_id = c.community_id
ORDER BY 
    c.community_name ASC,
    u.last_name DESC,
    u.first_name ASC,
    u.middle_name DESC;

--38. Выбрать год и количество рожденных в этот год по вре-
--менам года. В результирующей таблице должно быть пять столб-
--цов: год и все времена года
SELECT
    EXTRACT(YEAR FROM date_of_birth) AS year,
    COUNT(CASE 
            WHEN EXTRACT(MONTH FROM date_of_birth) IN (12,1,2) THEN 1 
         END) AS winter,
    COUNT(CASE 
            WHEN EXTRACT(MONTH FROM date_of_birth) IN (3,4,5) THEN 1 
         END) AS spring,
    COUNT(CASE 
            WHEN EXTRACT(MONTH FROM date_of_birth) IN (6,7,8) THEN 1 
         END) AS summer,
    COUNT(CASE 
            WHEN EXTRACT(MONTH FROM date_of_birth) IN (9,10,11) THEN 1 
         END) AS autumn
FROM Users
GROUP BY year
ORDER BY year;


--39. Выбрать фамилию, имя, отчество пользователя, количе-
--ство сообщений, ему написанных, и количество сообщений, кото-
--рые он написал.
SELECT
    u.user_id,
    u.last_name,
    u.first_name,
    u.middle_name,
    COUNT(m_received.message_id) AS received_messages,
    COUNT(m_sent.message_id) AS sent_messages
FROM Users u
LEFT JOIN Messages m_received 
    ON u.user_id = m_received.receiver_id
LEFT JOIN Messages m_sent 
    ON u.user_id = m_sent.user_id
GROUP BY
    u.user_id, u.last_name, u.first_name, u.middle_name
ORDER BY
    u.user_id, u.last_name, u.first_name, u.middle_name;


--40. Для каждого совершеннолетнего пользователя выбрать
--среднее количество его постов в месяц. В результат включить
--только пользователей, являющихся членами какого-либо сообще-
--ства.
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.middle_name,
    ROUND(COUNT(p.post_id)*1.0 / 
	(EXTRACT(YEAR FROM MAX(p.post_date)) - EXTRACT(YEAR FROM MIN(p.post_date)) + 1) / 12, 2) AS avg_posts_per_month
FROM Users u
JOIN CommunityMembers cm ON u.user_id = cm.user_id
LEFT JOIN Posts p ON u.user_id = p.user_id
WHERE EXTRACT(YEAR FROM AGE(u.date_of_birth)) >= 18
GROUP BY u.user_id, u.first_name, u.last_name, u.middle_name
ORDER BY u.user_id;


--41. Для каждого пользователя вывести текст его последнего
--сообщения. Результат отсортировать по id_пользователя.
SELECT 
    u.user_id,
    u.last_name,
    u.first_name,
    u.middle_name,
    m.message_text AS last_message
FROM Users u
LEFT JOIN (
    SELECT 
        user_id,
        MAX(send_date) AS last_time
    FROM Messages
    GROUP BY user_id
) last_m ON u.user_id = last_m.user_id
LEFT JOIN Messages m 
    ON m.user_id = u.user_id 
    AND m.send_date = last_m.last_time
ORDER BY u.user_id;

--42. Выбрать данные о пользователях, которые еще не напи-
--сали ни одного сообщения.
SELECT * 
FROM Users u
LEFT JOIN Messages m ON u.user_id = m.user_id
WHERE m.message_id IS NULL;

SELECT *
FROM Users u
WHERE NOT EXISTS (
    SELECT 1
    FROM Messages m
    WHERE m.user_id = u.user_id
);


--43. Выбрать имя пользователя, у которого больше всего
--публикаций в одном сообществе.
SELECT -- больше или равно олл
    u.user_id,
    u.first_name,
    u.last_name,
    u.middle_name,
    p.community_id,
    COUNT(p.post_id) AS posts_in_community
FROM Users u
JOIN Posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.first_name, u.last_name, u.middle_name, p.community_id
HAVING COUNT(p.post_id) = (
    SELECT MAX(post_count)
    FROM (
        SELECT COUNT(p2.post_id) AS post_count
        FROM Users u2
        JOIN Posts p2 ON u2.user_id = p2.user_id
        GROUP BY u2.user_id, p2.community_id
    ) AS tmp
)
ORDER BY u.user_id;

SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.middle_name,
    p.community_id,
    COUNT(p.post_id) AS posts_in_community
FROM Users u
JOIN Posts p ON u.user_id = p.user_id
GROUP BY 
    u.user_id, 
    u.first_name, 
    u.last_name, 
    u.middle_name, 
    p.community_id
HAVING COUNT(p.post_id) >= ALL (
    SELECT COUNT(p2.post_id)
    FROM Users u2
    JOIN Posts p2 ON u2.user_id = p2.user_id
    GROUP BY u2.user_id, p2.community_id
)
ORDER BY u.user_id;

--44. Выбрать названия трех сообществ, в которых меньше
--всего публикаций.
SELECT c.community_name
FROM Communities c
LEFT JOIN Posts p ON c.community_id = p.community_id
GROUP BY c.community_id, c.community_name
ORDER BY COUNT(p.post_id) ASC
LIMIT 3;

--45. Выбрать тексты публикаций самого пожилого пользователя
SELECT u.last_name, u.first_name, p.post_text
FROM Posts p
JOIN Users u ON p.user_id = u.user_id
WHERE u.date_of_birth = (
    SELECT MIN(date_of_birth)
    FROM Users
);

--46. Выбрать имена пользователей, которые делали публика-
--ции, как минимум, в двух сообществах с наибольшим количест-
--вом публикаций и, как минимум, в двух сообществах с наимень-
--шим количеством публикаций.
WITH community_post_counts AS (
    SELECT
        community_id,
        COUNT(*) AS post_count
    FROM Posts
    GROUP BY community_id
)
SELECT
    u.first_name,
    u.last_name
FROM Users u
WHERE
    1<= (
        SELECT COUNT(DISTINCT p.community_id)
        FROM Posts p
        WHERE p.user_id = u.user_id
          AND p.community_id IN (
              SELECT community_id
              FROM community_post_counts
              WHERE post_count = (SELECT MAX(post_count) FROM community_post_counts)
          )
    )
    AND
     1<= (
        SELECT COUNT(DISTINCT p.community_id)
        FROM Posts p
        WHERE p.user_id = u.user_id
          AND p.community_id IN (
              SELECT community_id
              FROM community_post_counts
              WHERE post_count = (SELECT MIN(post_count) FROM community_post_counts)
          )
    );



SELECT u.first_name, u.last_name
FROM Users u
JOIN Posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.first_name, u.last_name
HAVING
    COUNT(DISTINCT CASE WHEN p.community_id IN (
        SELECT community_id FROM Posts GROUP BY community_id
        HAVING COUNT(*) = (SELECT MAX(c) FROM (SELECT COUNT(*) c FROM Posts GROUP BY community_id) t)
    ) THEN p.community_id END) >= 2
    AND
    COUNT(DISTINCT CASE WHEN p.community_id IN (
        SELECT community_id FROM Posts GROUP BY community_id
        HAVING COUNT(*) = (SELECT MIN(c) FROM (SELECT COUNT(*) c FROM Posts GROUP BY community_id) t)
    ) THEN p.community_id END) >= 2;



--47. Выбрать имя пользователя с самым коротким паролем,
--сделавшим публикации в сообществе с наибольшим количеством
--пользователей.
SELECT u.first_name, u.last_name, u.middle_name, LENGTH(u.password) AS password_length
FROM Users u
WHERE u.user_id IN (
    SELECT DISTINCT p.user_id
    FROM Posts p
    WHERE p.community_id IN (
        SELECT cm_max.community_id
        FROM CommunityMembers cm_max
        GROUP BY cm_max.community_id
        HAVING COUNT(cm_max.user_id) = (
            SELECT MAX(member_count)
            FROM (
                SELECT COUNT(cm2.user_id) AS member_count
                FROM CommunityMembers cm2
                GROUP BY cm2.community_id
            ) AS counts
        )
    )
)
ORDER BY LENGTH(u.password)
LIMIT 1;

--48. Выбрать данные о тех пользователях, которые писали
--сообщения всем своим друзьям.
SELECT u.*
FROM Users u
WHERE NOT EXISTS (
    SELECT 1
    FROM Friends f
    WHERE f.user_id1 = u.user_id
    AND NOT EXISTS (
        SELECT 1
        FROM Messages m
        WHERE m.user_id = u.user_id 
        AND m.receiver_id = f.user_id2
    )
);

-- Вариант через подсчет количества друзей и количества получателей-друзей
SELECT u.*
FROM Users u
WHERE (
    -- Количество друзей пользователя
    SELECT COUNT(*)
    FROM Friends f
    WHERE f.user_id1 = u.user_id
) = (
    -- Количество уникальных друзей, которым пользователь писал сообщения
    SELECT COUNT(DISTINCT m.receiver_id)
    FROM Messages m
    WHERE m.user_id = u.user_id
    AND m.receiver_id IN (
        SELECT f.user_id2
        FROM Friends f
        WHERE f.user_id1 = u.user_id
    )
);

--через соединение таблиц
SELECT u.user_id, u.first_name, u.last_name, u.middle_name
FROM Users u
JOIN Friends f ON u.user_id IN (f.user_id1, f.user_id2)
LEFT JOIN Messages m ON m.user_id = u.user_id 
    AND m.receiver_id = CASE 
        WHEN f.user_id1 = u.user_id THEN f.user_id2 
        ELSE f.user_id1 
    END
GROUP BY u.user_id, u.first_name, u.last_name, u.middle_name
HAVING COUNT(DISTINCT 
    CASE 
        WHEN f.user_id1 = u.user_id THEN f.user_id2 
        ELSE f.user_id1 
    END
) = COUNT(DISTINCT 
    CASE WHEN m.message_id IS NOT NULL THEN 
        CASE 
            WHEN f.user_id1 = u.user_id THEN f.user_id2 
            ELSE f.user_id1 
        END 
    END
);

-- 49. Вывести данные о сообществах, в которых нет пользователей
SELECT c.*
FROM Communities c
LEFT JOIN CommunityMembers cm ON c.community_id = cm.community_id
WHERE cm.community_id IS NULL;


SELECT c.*
FROM Communities c
WHERE NOT EXISTS (
    SELECT 1
    FROM CommunityMembers cm
    WHERE cm.community_id = c.community_id
);


SELECT c.*
FROM Communities c
WHERE c.community_id NOT IN (
    SELECT DISTINCT community_id
    FROM CommunityMembers
    WHERE community_id IS NOT NULL
);


-- 50. Выбрать данные о пользователях, которые еще не написали ни одного сообщения
SELECT u.*
FROM Users u
LEFT JOIN Messages m ON u.user_id = m.user_id
WHERE m.message_id IS NULL;

SELECT u.*
FROM Users u
WHERE NOT EXISTS (
    SELECT 1
    FROM Messages m
    WHERE m.user_id = u.user_id
);

SELECT u.*
FROM Users u
WHERE u.user_id NOT IN (
    SELECT user_id
    FROM Messages
    WHERE user_id IS NOT NULL
);



--51. Выбрать имя пользователя, который написал наибольшее
--количество сообщений.
SELECT u.first_name, u.last_name, COUNT(m.message_id) AS message_count
FROM Users u
JOIN Messages m ON u.user_id = m.user_id
GROUP BY u.user_id, u.first_name, u.last_name
HAVING COUNT(m.message_id) = (
    SELECT MAX(msg_count)
    FROM (
        SELECT COUNT(*) AS msg_count
        FROM Messages
        GROUP BY user_id
    )
);


SELECT u.first_name, u.last_name, COUNT(m.message_id) AS message_count
FROM Users u
JOIN Messages m ON u.user_id = m.user_id
GROUP BY u.user_id, u.first_name, u.last_name
HAVING COUNT(m.message_id) >= ALL (
    SELECT COUNT(*)
    FROM Messages
    GROUP BY user_id
);

-- 52. Выбрать имя пользователя, который написал самое длинное сообщение
SELECT u.first_name, u.last_name, LENGTH(m.message_text) AS message_length
FROM Users u
JOIN Messages m ON u.user_id = m.user_id
WHERE LENGTH(m.message_text) = (
    SELECT MAX(LENGTH(message_text))
    FROM Messages
);

SELECT u.first_name, u.last_name, LENGTH(m.message_text) AS message_length
FROM Users u
JOIN Messages m ON u.user_id = m.user_id
WHERE LENGTH(m.message_text) >= ALL (
    SELECT LENGTH(message_text)
    FROM Messages
);


-- 53. Выбрать фамилии, имена, отчества всех пользователей, которые обменивались сообщениями, но друзьями не являются
SELECT DISTINCT u.last_name, u.first_name, u.middle_name
FROM Users u
JOIN Messages m ON u.user_id = m.user_id OR u.user_id = m.receiver_id
LEFT JOIN Friends f ON f.user_id1 = u.user_id OR f.user_id2 = u.user_id
WHERE f.user_id1 IS NULL;

SELECT DISTINCT u.last_name, u.first_name, u.middle_name
FROM Users u
WHERE u.user_id IN (
    SELECT user_id FROM Messages
    UNION
    SELECT receiver_id FROM Messages
)
AND u.user_id NOT IN (
    SELECT user_id1 FROM Friends
    UNION
    SELECT user_id2 FROM Friends
);

-- 54. Выбрать фамилии, имена, отчества тех пользователей, 
--которые не отвечали на сообщения пользователей, не являющихся друзьями.
SELECT DISTINCT u.last_name, u.first_name, u.middle_name
FROM Users u
WHERE NOT EXISTS (
    -- Находим сообщение от не-друга, на которое пользователь не ответил
    SELECT 1
    FROM Messages m_in
    WHERE m_in.receiver_id = u.user_id
      AND NOT EXISTS (
          -- Проверяем, что отправитель НЕ друг
          SELECT 1
          FROM Friends f
          WHERE (f.user_id1 = u.user_id AND f.user_id2 = m_in.user_id)
             OR (f.user_id2 = u.user_id AND f.user_id1 = m_in.user_id)
      )
      AND NOT EXISTS (
          -- Проверяем, был ли ответ
          SELECT 1
          FROM Messages m_out
          WHERE m_out.user_id = u.user_id
            AND m_out.receiver_id = m_in.user_id
            AND m_out.send_date > m_in.send_date
      )
);


-- 55. Выбрать фамилию, имя, отчество пользователя, имеющего друзей, с которыми он не обменивался сообщениями
SELECT DISTINCT u.last_name, u.first_name, u.middle_name
FROM Users u
WHERE EXISTS (
    SELECT 1
    FROM Friends f
    WHERE f.user_id1 = u.user_id
    AND NOT EXISTS (
        SELECT 1
        FROM Messages m
        WHERE (m.user_id = u.user_id AND m.receiver_id = f.user_id2)
           OR (m.user_id = f.user_id2 AND m.receiver_id = u.user_id)
    )
);

SELECT DISTINCT u.last_name, u.first_name, u.middle_name
FROM Users u
JOIN Friends f ON f.user_id1 = u.user_id
LEFT JOIN Messages m ON (m.user_id = u.user_id AND m.receiver_id = f.user_id2)
                      OR (m.user_id = f.user_id2 AND m.receiver_id = u.user_id)
GROUP BY u.user_id, u.last_name, u.first_name, u.middle_name, f.user_id2
HAVING COUNT(m.message_id) = 0;

-- 56. Выбрать названия сообществ, тексты сообщений, тексты постов, которые содержат слова «базы данных», 
--в одном столбце. Результат отсортировать по длине.
SELECT content, LENGTH(content) AS content_length
FROM (
    -- Названия сообществ
    SELECT 'Community: ' || community_name AS content
    FROM Communities
    WHERE community_name LIKE '%базы данных%'
       OR description LIKE '%базы данных%'
    
    UNION ALL
    
    -- Тексты сообщений
    SELECT 'Message: ' || message_text AS content
    FROM Messages
    WHERE message_text LIKE '%базы данных%'
    
    UNION ALL
    
    -- Тексты постов
    SELECT 'Post: ' || post_text AS content
    FROM Posts
    WHERE post_text LIKE '%базы данных%'
) AS t
ORDER BY content_length;

--57. Выбрать название сообщества с наибольшим количест-
--вом пользователей.
SELECT c.community_name, COUNT(cm.user_id) AS member_count
FROM Communities c
JOIN CommunityMembers cm ON c.community_id = cm.community_id
GROUP BY c.community_id, c.community_name
HAVING COUNT(cm.user_id) = (
    SELECT MAX(member_count)
    FROM (
        SELECT COUNT(user_id) AS member_count
        FROM CommunityMembers
        GROUP BY community_id
    ) 
);

SELECT c.community_name, COUNT(cm.user_id) AS member_count
FROM Communities c
LEFT JOIN CommunityMembers cm ON c.community_id = cm.community_id
GROUP BY c.community_id, c.community_name
HAVING COUNT(cm.user_id) >= ALL (
    SELECT COUNT(user_id)
    FROM CommunityMembers
    GROUP BY community_id
);


--58. Выбрать все дни текущего года, в которые не делали
--публикаций.
--сделать экзистс
WITH RECURSIVE days_of_year AS (
    SELECT DATE_TRUNC('year', CURRENT_DATE)::DATE AS day_date
    UNION ALL
    SELECT (day_date + INTERVAL '1 day')::DATE
    FROM days_of_year
    WHERE day_date < DATE_TRUNC('year', CURRENT_DATE)::DATE + INTERVAL '1 year' - INTERVAL '1 day'
)
SELECT d.day_date
FROM days_of_year d
LEFT JOIN Posts p ON d.day_date = p.post_date
WHERE p.post_id IS NULL
ORDER BY d.day_date;


----------------------
SELECT d::DATE AS day_date
FROM GENERATE_SERIES(
    DATE_TRUNC('year', CURRENT_DATE)::DATE,
    DATE_TRUNC('year', CURRENT_DATE)::DATE + INTERVAL '1 year' - INTERVAL '1 day',
    '1 day'
) AS d
WHERE NOT EXISTS (
    SELECT 1
    FROM Posts p
    WHERE p.post_date = d::DATE
)
ORDER BY d;

--59. Выбрать название сообщества, фамилии, имена, отчества
--организаторов, количество участников, писавших комментарии
--или ставивших лайк публикациям сообщества, общее количество
--участников, процентное соотношение активных членов сообщест-
--ва (пишущих комментарии или делающих публикации в сообще-
--ствах) и только читающих посты, количество пользователей, яв-
--ляющихся членами какого-либо сообщества.
WITH 
-- Общее количество пользователей в любом сообществе (вычисляется один раз)
total_users AS (
    SELECT COUNT(DISTINCT user_id) AS total_users_in_any_community
    FROM CommunityMembers
),

-- Активность: комментарии
comment_activity AS (
    SELECT DISTINCT cm.community_id, cm.user_id
    FROM CommunityMembers cm
    JOIN Posts p ON cm.community_id = p.community_id
    JOIN Comments c ON p.post_id = c.post_id AND c.user_id = cm.user_id
),

-- Активность: лайки
like_activity AS (
    SELECT DISTINCT cm.community_id, cm.user_id
    FROM CommunityMembers cm
    JOIN Posts p ON cm.community_id = p.community_id
    JOIN Likes l ON p.post_id = l.post_id AND l.user_id = cm.user_id
),

-- Активность: создание постов
post_activity AS (
    SELECT DISTINCT cm.community_id, cm.user_id
    FROM CommunityMembers cm
    JOIN Posts p ON cm.community_id = p.community_id AND p.user_id = cm.user_id
),

-- Объединение активностей
all_active AS (
    SELECT community_id, user_id FROM comment_activity
    UNION
    SELECT community_id, user_id FROM like_activity
    UNION
    SELECT community_id, user_id FROM post_activity
),

-- Статистика по сообществам
community_stats AS (
    SELECT 
        c.community_id,
        c.community_name,
        u.last_name AS creator_last_name,
        u.first_name AS creator_first_name,
        u.middle_name AS creator_middle_name,
        COUNT(DISTINCT cm.user_id) AS total_members,
        COUNT(DISTINCT aa.user_id) AS active_members
    FROM Communities c
    JOIN Users u ON c.creator_user_id = u.user_id
    LEFT JOIN CommunityMembers cm ON c.community_id = cm.community_id
    LEFT JOIN all_active aa ON c.community_id = aa.community_id AND aa.user_id = cm.user_id
    GROUP BY c.community_id, c.community_name, u.last_name, u.first_name, u.middle_name
)
SELECT 
    cs.community_name,
    cs.creator_last_name,
    cs.creator_first_name,
    cs.creator_middle_name,
    cs.active_members AS active_members_count,
    cs.total_members AS total_members_count,
    ROUND(100.0 * cs.active_members / NULLIF(cs.total_members, 0), 2) AS active_percent,
    cs.total_members - cs.active_members AS readers_count,
    ROUND(100.0 * (cs.total_members - cs.active_members) / NULLIF(cs.total_members, 0), 2) AS readers_percent,
    tu.total_users_in_any_community,
    RANK() OVER (ORDER BY cs.active_members DESC) AS activity_rank
FROM community_stats cs
CROSS JOIN total_users tu
ORDER BY cs.community_name;




WITH community_activity AS (
    SELECT 
        c.community_id,
        c.community_name,
        u.last_name AS creator_last_name,
        u.first_name AS creator_first_name,
        u.middle_name AS creator_middle_name,
        COUNT(DISTINCT cm.user_id) AS total_members,
        COUNT(DISTINCT CASE 
            WHEN c2.comment_id IS NOT NULL OR l.user_id IS NOT NULL OR p2.post_id IS NOT NULL 
            THEN cm.user_id 
        END) AS active_members,
        (SELECT COUNT(DISTINCT user_id) FROM CommunityMembers) AS total_users_in_any_community
    FROM Communities c
    JOIN Users u ON c.creator_user_id = u.user_id
    LEFT JOIN CommunityMembers cm ON c.community_id = cm.community_id
    LEFT JOIN Posts p ON cm.community_id = p.community_id
    LEFT JOIN Comments c2 ON p.post_id = c2.post_id AND c2.user_id = cm.user_id
    LEFT JOIN Likes l ON p.post_id = l.post_id AND l.user_id = cm.user_id
    LEFT JOIN Posts p2 ON cm.community_id = p2.community_id AND p2.user_id = cm.user_id
    GROUP BY c.community_id, c.community_name, u.last_name, u.first_name, u.middle_name
)
SELECT 
    community_name,
    creator_last_name,
    creator_first_name,
    creator_middle_name,
    active_members AS active_members_count,
    total_members AS total_members_count,
    ROUND(100.0 * active_members / NULLIF(total_members, 0), 2) AS active_percent,
    total_members - active_members AS readers_count,
    ROUND(100.0 * (total_members - active_members) / NULLIF(total_members, 0), 2) AS readers_percent,
    total_users_in_any_community,
    RANK() OVER (ORDER BY active_members DESC) AS activity_rank
FROM community_activity
ORDER BY community_name;



SELECT d::DATE AS day_date
FROM GENERATE_SERIES(
    DATE_TRUNC('year', CURRENT_DATE)::DATE,
    DATE_TRUNC('year', CURRENT_DATE)::DATE + INTERVAL '1 year' - INTERVAL '1 day',
    '1 day'
) AS d
WHERE NOT EXISTS (
    SELECT 1
    FROM Posts p
    WHERE p.post_date = d::DATE
)
ORDER BY d;

--60. Проверить правило 6 рукопожатий 


WITH RECURSIVE 
-- 1. Все возможные пары пользователей 
all_pairs AS (
    SELECT 
        u1.user_id AS start_user,
        u2.user_id AS end_user
    FROM Users u1
    CROSS JOIN Users u2
    WHERE u1.user_id < u2.user_id  
),

-- 2. Поиск кратчайших путей между всеми парами
shortest_paths AS (
    -- Прямые друзья (расстояние = 1)
    SELECT 
        f.user_id1 AS start_user,
        f.user_id2 AS end_user,
        1 AS distance,
        ARRAY[f.user_id1, f.user_id2] AS path
    FROM Friends f
    
    UNION ALL
    
    -- Обратные связи (дружба симметрична)
    SELECT 
        f.user_id2 AS start_user,
        f.user_id1 AS end_user,
        1 AS distance,
        ARRAY[f.user_id2, f.user_id1] AS path
    FROM Friends f
    
    UNION ALL
    
    -- Рекурсивный шаг: удлиняем пути
    SELECT 
        sp.start_user,
        CASE 
            WHEN f.user_id1 = sp.end_user THEN f.user_id2
            ELSE f.user_id1
        END AS end_user,
        sp.distance + 1,
        sp.path || CASE 
            WHEN f.user_id1 = sp.end_user THEN f.user_id2
            ELSE f.user_id1
        END
    FROM shortest_paths sp
    JOIN Friends f ON sp.end_user IN (f.user_id1, f.user_id2)
    WHERE 
        sp.distance < 6  
        AND NOT (CASE 
            WHEN f.user_id1 = sp.end_user THEN f.user_id2
            ELSE f.user_id1
        END = ANY(sp.path))  
),

-- 3. Для каждой пары берём минимальное расстояние
pair_distances AS (
    SELECT 
        start_user,
        end_user,
        MIN(distance) AS min_distance
    FROM shortest_paths
    GROUP BY start_user, end_user
),

-- 4. Подсчёт количества пар с разными расстояниями
distance_stats AS (
    SELECT 
        min_distance,
        COUNT(*) AS pair_count
    FROM pair_distances
    GROUP BY min_distance
),

-- 5. Всего возможных пар
total_pairs AS (
    SELECT COUNT(*) AS total
    FROM all_pairs
),

-- 6. Пары, которые не связаны  
unconnected_pairs AS (
    SELECT COUNT(*) AS unconnected_count
    FROM all_pairs ap
    WHERE NOT EXISTS (
        SELECT 1
        FROM pair_distances pd
        WHERE pd.start_user = ap.start_user 
          AND pd.end_user = ap.end_user
    )
),

-- 7. Пары в пределах 6 рукопожатий
pairs_within_6 AS (
    SELECT COALESCE(SUM(pair_count), 0) AS pair_count
    FROM distance_stats 
    WHERE min_distance <= 6
),

-- 8. Максимальное расстояние
max_dist AS (
    SELECT MAX(min_distance) AS max_distance
    FROM pair_distances
)

-- 9. Финальный результат с выводом о соответствии правилу
SELECT 
    tp.total AS total_pairs,
    COALESCE(uc.unconnected_count, 0) AS unconnected_pairs,
    tp.total - COALESCE(uc.unconnected_count, 0) AS connected_pairs,
    p6.pair_count AS pairs_within_6_handshakes,
    
    -- Определяем, выполняется ли правило
    CASE 
        WHEN COALESCE(uc.unconnected_count, 0) > 0 THEN 'НЕ ВЫПОЛНЯЕТСЯ — есть несвязанные пары'
        WHEN p6.pair_count = tp.total THEN 'ВЫПОЛНЯЕТСЯ — все пары в пределах 6 рукопожатий'
        ELSE 'НЕ ВЫПОЛНЯЕТСЯ — есть пары с расстоянием больше 6'
    END AS rule_6_handshakes_result,
    
    md.max_distance AS max_distance_found,
    (SELECT jsonb_object_agg(min_distance, pair_count) FROM distance_stats) AS distance_distribution

FROM total_pairs tp
LEFT JOIN unconnected_pairs uc ON true
CROSS JOIN pairs_within_6 p6
CROSS JOIN max_dist md;
