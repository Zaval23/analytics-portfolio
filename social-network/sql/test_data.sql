-- Тестовые данные для БД «Социальная сеть»
TRUNCATE TABLE Messages CASCADE;
TRUNCATE TABLE Likes CASCADE;
TRUNCATE TABLE Comments CASCADE;
TRUNCATE TABLE Posts CASCADE;
TRUNCATE TABLE CommunityMembers CASCADE;
TRUNCATE TABLE Communities CASCADE;
TRUNCATE TABLE Friends CASCADE;
TRUNCATE TABLE UserInterests CASCADE;
TRUNCATE TABLE Users CASCADE;
TRUNCATE TABLE Settlements CASCADE;
TRUNCATE TABLE SettlementTypes CASCADE;
TRUNCATE TABLE Countries CASCADE;
TRUNCATE TABLE Interests CASCADE;
TRUNCATE TABLE UserStatus CASCADE;
TRUNCATE TABLE FriendshipStatus CASCADE;
TRUNCATE TABLE MediaFiles CASCADE;
TRUNCATE TABLE MessageReadStatus CASCADE;

-- Countries 
INSERT INTO Countries (country_name) VALUES
('Россия'), ('США'), ('Германия'), ('Франция'), ('Италия'),
('Китай'), ('Япония'), ('Испания'), ('Канада'), ('Бразилия');

-- SettlementTypes 
INSERT INTO SettlementTypes (settlement_type_name) VALUES
('Город'), ('Село'), ('Деревня'), ('Станица'), ('Посёлок'),
('ПГТ'), ('Мегаполис'), ('Хутор'), ('Аул'), ('Микрорайон');

-- Settlements 
INSERT INTO Settlements (settlement_name, country_id, settlement_type_id) VALUES
('Москва', (SELECT country_id FROM Countries WHERE country_name='Россия'),
           (SELECT settlement_type_id FROM SettlementTypes WHERE settlement_type_name='Город')),
('Нью-Йорк', (SELECT country_id FROM Countries WHERE country_name='США'),
             (SELECT settlement_type_id FROM SettlementTypes WHERE settlement_type_name='Мегаполис')),
('Берлин', (SELECT country_id FROM Countries WHERE country_name='Германия'),
           (SELECT settlement_type_id FROM SettlementTypes WHERE settlement_type_name='Город')),
('Париж', (SELECT country_id FROM Countries WHERE country_name='Франция'),
           (SELECT settlement_type_id FROM SettlementTypes WHERE settlement_type_name='Город')),
('Рим', (SELECT country_id FROM Countries WHERE country_name='Италия'),
         (SELECT settlement_type_id FROM SettlementTypes WHERE settlement_type_name='Город')),
('Пекин', (SELECT country_id FROM Countries WHERE country_name='Китай'),
          (SELECT settlement_type_id FROM SettlementTypes WHERE settlement_type_name='Город')),
('Токио', (SELECT country_id FROM Countries WHERE country_name='Япония'),
          (SELECT settlement_type_id FROM SettlementTypes WHERE settlement_type_name='Город')),
('Сочи', (SELECT country_id FROM Countries WHERE country_name='Россия'),
          (SELECT settlement_type_id FROM SettlementTypes WHERE settlement_type_name='Город')),
('Лос-Анджелес', (SELECT country_id FROM Countries WHERE country_name='США'),
                  (SELECT settlement_type_id FROM SettlementTypes WHERE settlement_type_name='Мегаполис')),
('Милан', (SELECT country_id FROM Countries WHERE country_name='Италия'),
           (SELECT settlement_type_id FROM SettlementTypes WHERE settlement_type_name='Город'));

-- Users 
INSERT INTO Users (first_name, last_name, middle_name, date_of_birth, place_of_residence, place_of_work, phone, email, password, settlement_id) VALUES
('Иван','Иванов','Иванович','1999-03-15','Москва','ВГУ','111-111','ivanov@mail.ru','pass1',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Москва')),
('Петр','Петров','Петрович','1997-07-22','Москва','МГУ','222-222','petrov@mail.ru','pass2',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Москва')),
('Сидор','Сидоров','Сидорович','2000-01-10','Берлин','Google','333-333','sidorov@mail.ru','pass3',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Берлин')),
('Анна','Смирнова','Игоревна','1993-12-01','Париж','Sorbonne','444-444','smirnova@mail.ru','pass4',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Париж')),
('Мария','Кузнецова','Алексеевна','1990-05-05','Токио','Sony','555-555','kuznetsova@mail.ru','pass5',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Токио')),
('Дмитрий','Федоров','Николаевич','2002-09-09','Нью-Йорк','Columbia','666-666','fedorov@mail.ru','pass6',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Нью-Йорк')),
('Ольга','Васильева','Сергеевна','1985-11-30','Пекин','Tsinghua','777-777','vasilieva@mail.ru','pass7',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Пекин')),
('Кирилл','Новиков','Александрович','1995-04-10','Сочи','РГУ','888-888','novikov@mail.ru','pass8',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Сочи')),
('Елена','Орлова','Владимировна','2003-03-20','Лос-Анджелес','UCLA','999-999','orlova@mail.ru','pass9',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Лос-Анджелес')),
('Алекс','Зайцев','Павлович','2010-04-05','Милан','Polimi','101-010','zaitsev@mail.ru','pass10',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Милан'));

-- Interests 
INSERT INTO Interests (interest_name, interest_description) VALUES
('Футбол','Игра в футбол'),
('Музыка','Прослушивание музыки'),
('Программирование','Кодинг и ИТ'),
('Путешествия','Поездки'),
('Живопись','Рисование'),
('Фотография','Фотоискусство'),
('История','Наука о прошлом'),
('Кино','Просмотр фильмов'),
('Книги','Чтение литературы'),
('Игры','Видеоигры и настолки');

-- UserInterests 
INSERT INTO UserInterests (user_id, interest_id, additional_info) VALUES
((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'),
 (SELECT interest_id FROM Interests WHERE interest_name='Футбол'),'Играет за ВГУ'),
((SELECT user_id FROM Users WHERE email='petrov@mail.ru'),
 (SELECT interest_id FROM Interests WHERE interest_name='Музыка'),'Любит рок'),
((SELECT user_id FROM Users WHERE email='sidorov@mail.ru'),
 (SELECT interest_id FROM Interests WHERE interest_name='Программирование'),'Python-разработчик'),
((SELECT user_id FROM Users WHERE email='smirnova@mail.ru'),
 (SELECT interest_id FROM Interests WHERE interest_name='Путешествия'),'Посетила 10 стран'),
((SELECT user_id FROM Users WHERE email='kuznetsova@mail.ru'),
 (SELECT interest_id FROM Interests WHERE interest_name='Живопись'),'Художник-любитель'),
((SELECT user_id FROM Users WHERE email='fedorov@mail.ru'),
 (SELECT interest_id FROM Interests WHERE interest_name='Фотография'),'Фотограф'),
((SELECT user_id FROM Users WHERE email='vasilieva@mail.ru'),
 (SELECT interest_id FROM Interests WHERE interest_name='История'),'Историк'),
((SELECT user_id FROM Users WHERE email='novikov@mail.ru'),
 (SELECT interest_id FROM Interests WHERE interest_name='Кино'),'Коллекционирует постеры'),
((SELECT user_id FROM Users WHERE email='orlova@mail.ru'),
 (SELECT interest_id FROM Interests WHERE interest_name='Книги'),'Любит фантастику'),
((SELECT user_id FROM Users WHERE email='zaitsev@mail.ru'),
 (SELECT interest_id FROM Interests WHERE interest_name='Игры'),'Киберспорт');

-- UserStatus 
INSERT INTO UserStatus (status_name) VALUES
('Онлайн'),('Оффлайн'),('Занят'),('Не беспокоить'),('На работе'),
('В отпуске'),('Учёба'),('В походе'),('На звонке'),('Ремонт');

-- FriendshipStatus 
INSERT INTO FriendshipStatus (friendship_status_name) VALUES
('Заявка'),('Принята'),('Отклонена'),('В чёрном списке'),('Удалена'),
('Близкие друзья'),('Лучшие друзья'),('Подписка'),('Заблокирован'),('В ожидании');

-- Friends 
INSERT INTO Friends (user_id1, user_id2, friendship_date) VALUES
((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'),
 (SELECT user_id FROM Users WHERE email='petrov@mail.ru'),'2023-01-01'),
((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'),
 (SELECT user_id FROM Users WHERE email='sidorov@mail.ru'),'2023-01-05'),
((SELECT user_id FROM Users WHERE email='petrov@mail.ru'),
 (SELECT user_id FROM Users WHERE email='sidorov@mail.ru'),'2023-02-10'),
((SELECT user_id FROM Users WHERE email='sidorov@mail.ru'),
 (SELECT user_id FROM Users WHERE email='smirnova@mail.ru'),'2023-02-12'),
((SELECT user_id FROM Users WHERE email='smirnova@mail.ru'),
 (SELECT user_id FROM Users WHERE email='kuznetsova@mail.ru'),'2023-03-01'),
((SELECT user_id FROM Users WHERE email='kuznetsova@mail.ru'),
 (SELECT user_id FROM Users WHERE email='fedorov@mail.ru'),'2023-04-01'),
((SELECT user_id FROM Users WHERE email='fedorov@mail.ru'),
 (SELECT user_id FROM Users WHERE email='vasilieva@mail.ru'),'2023-05-01'),
((SELECT user_id FROM Users WHERE email='vasilieva@mail.ru'),
 (SELECT user_id FROM Users WHERE email='novikov@mail.ru'),'2023-06-15'),
((SELECT user_id FROM Users WHERE email='novikov@mail.ru'),
 (SELECT user_id FROM Users WHERE email='orlova@mail.ru'),'2023-07-21'),
((SELECT user_id FROM Users WHERE email='orlova@mail.ru'),
 (SELECT user_id FROM Users WHERE email='ivanov@mail.ru'),'2023-08-10');

-- Communities 
INSERT INTO Communities (community_name, creator_user_id, description, organizers_info, posts_info) VALUES
('Футбол ВГУ', (SELECT user_id FROM Users WHERE email='ivanov@mail.ru'),'Сообщество любителей футбола','Оргкомитет ВГУ','Новости о футболе'),
('Музыканты', (SELECT user_id FROM Users WHERE email='petrov@mail.ru'),'Сообщество музыкантов','Оргкомитет МГУ','Концерты'),
('Python Devs', (SELECT user_id FROM Users WHERE email='sidorov@mail.ru'),NULL,'IT оргкомитет','Программы'),
('Travel Club', (SELECT user_id FROM Users WHERE email='smirnova@mail.ru'),'Путешественники','Оргкомитет Париж','Фотоотчёты'),
('Art Zone', (SELECT user_id FROM Users WHERE email='kuznetsova@mail.ru'),'Художники','Оргкомитет Токио','Выставки'),
('ФотоФанаты', (SELECT user_id FROM Users WHERE email='fedorov@mail.ru'),'Фотографы','Оргкомитет Нью-Йорк','Фото'),
('Историки', (SELECT user_id FROM Users WHERE email='vasilieva@mail.ru'),'Учёные-историки','Оргкомитет Пекин','Статьи'),
('КиноКлуб', (SELECT user_id FROM Users WHERE email='novikov@mail.ru'),'Клуб любителей кино','Оргкомитет Сочи','Обсуждения фильмов'),
('Книжный_клуб', (SELECT user_id FROM Users WHERE email='orlova@mail.ru'),'Книжные встречи','Оргкомитет LA','Рецензии'),
('ИгроМаньяки', (SELECT user_id FROM Users WHERE email='zaitsev@mail.ru'),NULL,'Оргкомитет Милан','Онлайн турниры');

-- CommunityMembers 
INSERT INTO CommunityMembers (user_id, community_id, join_date) VALUES
((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Футбол ВГУ'),'2023-01-01'),
((SELECT user_id FROM Users WHERE email='petrov@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Музыканты'),'2023-02-01'),
((SELECT user_id FROM Users WHERE email='sidorov@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Python Devs'),'2023-03-01'),
((SELECT user_id FROM Users WHERE email='smirnova@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Travel Club'),'2023-04-01'),
((SELECT user_id FROM Users WHERE email='kuznetsova@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Art Zone'),'2023-05-01'),
((SELECT user_id FROM Users WHERE email='fedorov@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='ФотоФанаты'),'2023-06-01'),
((SELECT user_id FROM Users WHERE email='vasilieva@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Историки'),'2023-07-01'),
((SELECT user_id FROM Users WHERE email='novikov@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='КиноКлуб'),'2023-06-16'),
((SELECT user_id FROM Users WHERE email='orlova@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Книжный_клуб'),'2023-07-21'),
((SELECT user_id FROM Users WHERE email='zaitsev@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='ИгроМаньяки'),'2023-08-22');

-- MediaFiles
INSERT INTO MediaFiles (media_file_url) VALUES
('url1'),('url2'),('url3'),('url4'),('url5'),
('url6'),('url7'),('url8'),('url9'),('url10');

-- Posts
INSERT INTO Posts (user_id, community_id, post_text, post_date) VALUES
((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Футбол ВГУ'),
 'Сегодня матч ВГУ – ПММ 50 лет','2025-09-05'),
((SELECT user_id FROM Users WHERE email='petrov@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Музыканты'),
 'Концерт группы Queen','2025-09-10'),
((SELECT user_id FROM Users WHERE email='sidorov@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Python Devs'),
 'Код на Python: print("Hello")','2025-08-15'),
((SELECT user_id FROM Users WHERE email='smirnova@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Travel Club'),
 'Фото из Италии - путешествие','2025-09-20'),
((SELECT user_id FROM Users WHERE email='kuznetsova@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Art Zone'),
 'Выставка живописи % современного искусства','2025-09-21'),
((SELECT user_id FROM Users WHERE email='fedorov@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='ФотоФанаты'),
 'Фотоотчет ПММ 50 лет','2025-09-25'),
((SELECT user_id FROM Users WHERE email='vasilieva@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Историки'),
 'Статья по истории 1812 года','2025-07-07'),
((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Футбол ВГУ'),
 'Анонс: утренняя тренировка ВГУ на стадионе','2025-10-02'),
((SELECT user_id FROM Users WHERE email='novikov@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='КиноКлуб'),
 'Новая выставка - современное%искусство & дизайн','2025-09-28'),
((SELECT user_id FROM Users WHERE email='petrov@mail.ru'),
 (SELECT community_id FROM Communities WHERE community_name='Музыканты'),
 'Памятное событие: ПММ 50 лет & торжество','2025-10-05');

-- Comments
INSERT INTO Comments (user_id, post_id, media_file_id, comment_text, comment_date, parent_comment_id) VALUES
((SELECT user_id FROM Users WHERE email='petrov@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Сегодня матч ВГУ%'),NULL,'Круто!','2025-09-06',NULL),
((SELECT user_id FROM Users WHERE email='sidorov@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Сегодня матч ВГУ%'),NULL,'Когда матч?','2025-09-07',
 (SELECT comment_id FROM Comments WHERE comment_text='Круто!')),
((SELECT user_id FROM Users WHERE email='smirnova@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Концерт группы Queen%'),NULL,'Я тоже иду','2025-09-11',NULL),
((SELECT user_id FROM Users WHERE email='kuznetsova@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Код на Python%'),
 (SELECT media_file_id FROM MediaFiles WHERE media_file_url='url3'),'print(123','2025-08-16',NULL),
((SELECT user_id FROM Users WHERE email='fedorov@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Фото из Италии%'),NULL,'Красиво!','2025-09-21',NULL),
((SELECT user_id FROM Users WHERE email='vasilieva@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Выставка живописи%'),
 (SELECT media_file_id FROM MediaFiles WHERE media_file_url='url5'),'Современно','2025-09-22',NULL),
((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Фотоотчет ПММ%'),NULL,'Отличные фото','2025-09-26',NULL),
((SELECT user_id FROM Users WHERE email='orlova@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Новая выставка%'),NULL,'Класс! Обязательно схожу.','2025-09-29',NULL),
((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Памятное событие%'),NULL,'Буду на юбилее ПММ','2025-10-06',NULL),
((SELECT user_id FROM Users WHERE email='novikov@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Анонс: утренняя тренировка%'),
 (SELECT media_file_id FROM MediaFiles WHERE media_file_url='url8'),'Отличная новость, приходите!','2025-10-03',NULL);

-- Likes
INSERT INTO Likes (user_id, post_id, like_date) VALUES
((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Сегодня матч ВГУ%'),'2025-09-06'),
((SELECT user_id FROM Users WHERE email='petrov@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Сегодня матч ВГУ%'),'2025-09-06'),
((SELECT user_id FROM Users WHERE email='sidorov@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Концерт группы Queen%'),'2025-09-11'),
((SELECT user_id FROM Users WHERE email='smirnova@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Код на Python%'),'2025-08-16'),
((SELECT user_id FROM Users WHERE email='kuznetsova@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Фото из Италии%'),'2025-09-22'),
((SELECT user_id FROM Users WHERE email='fedorov@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Выставка живописи%'),'2025-09-23'),
((SELECT user_id FROM Users WHERE email='vasilieva@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Фотоотчет ПММ%'),'2025-09-26'),
((SELECT user_id FROM Users WHERE email='novikov@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Новая выставка%'),'2025-09-29'),
((SELECT user_id FROM Users WHERE email='orlova@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Памятное событие%'),'2025-10-06'),
((SELECT user_id FROM Users WHERE email='zaitsev@mail.ru'),
 (SELECT post_id FROM Posts WHERE post_text LIKE 'Анонс: утренняя тренировка%'),'2025-10-03');

-- Messages
INSERT INTO Messages (user_id, message_text, send_date, media_file_id) VALUES
((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'),'Привет, как дела?','2025-09-01',NULL),
((SELECT user_id FROM Users WHERE email='petrov@mail.ru'),'Все хорошо!','2025-09-02',NULL),
((SELECT user_id FROM Users WHERE email='sidorov@mail.ru'),'Код скинул','2025-09-03',
 (SELECT media_file_id FROM MediaFiles WHERE media_file_url='url3')),
((SELECT user_id FROM Users WHERE email='smirnova@mail.ru'),'Скоро отпуск','2025-09-04',NULL),
((SELECT user_id FROM Users WHERE email='kuznetsova@mail.ru'),'% скидка на билеты','2025-09-05',NULL),
((SELECT user_id FROM Users WHERE email='fedorov@mail.ru'),'Фотки с отпуска','2025-09-06',
 (SELECT media_file_id FROM MediaFiles WHERE media_file_url='url6')),
((SELECT user_id FROM Users WHERE email='vasilieva@mail.ru'),'Историческая справка','2025-09-07',NULL),
((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'),'Привет, Елена! Как насчёт встречи?','2025-09-30',NULL),
((SELECT user_id FROM Users WHERE email='orlova@mail.ru'),'Привет, Иван! Давай на выходных.','2025-10-01',NULL),
((SELECT user_id FROM Users WHERE email='novikov@mail.ru'),'Завтра идём смотреть фильм?','2025-09-27',
 (SELECT media_file_id FROM MediaFiles WHERE media_file_url='url8'));

-- =====================================================
-- ДОПОЛНИТЕЛЬНЫЕ ТЕСТОВЫЕ ДАННЫЕ ДЛЯ ВСЕХ ЗАПРОСОВ (1-60)
-- =====================================================

-- 1. ДОБАВЛЯЕМ НОВЫЕ СООБЩЕСТВА 
INSERT INTO Communities (community_name, creator_user_id, description, organizers_info, posts_info) VALUES
('Top_Community_1', (SELECT user_id FROM Users WHERE email='ivanov@mail.ru'), 'Самое активное сообщество', 'Иван Иванов', 'Посты о спорте'),
('Top_Community_2', (SELECT user_id FROM Users WHERE email='petrov@mail.ru'), 'Второе по активности', 'Петр Петров', 'Музыка и культура'),
('Middle_Community', (SELECT user_id FROM Users WHERE email='sidorov@mail.ru'), 'Средняя активность', 'Сидор Сидоров', NULL),
('Low_Community_1', (SELECT user_id FROM Users WHERE email='smirnova@mail.ru'), NULL, 'Анна Смирнова', 'Редкие посты'),
('Low_Community_2', (SELECT user_id FROM Users WHERE email='kuznetsova@mail.ru'), 'Очень малоактивное', 'Мария Кузнецова', NULL),
('Empty_Community', (SELECT user_id FROM Users WHERE email='fedorov@mail.ru'), 'Пустое сообщество без участников', 'Дмитрий Федоров', 'Нет постов');

-- 2. ДОБАВЛЯЕМ ТЕСТОВЫХ ПОЛЬЗОВАТЕЛЕЙ
INSERT INTO Users (first_name, last_name, middle_name, date_of_birth, place_of_residence,
                   place_of_work, phone, email, password, settlement_id) VALUES
('Анна', 'Успешная', 'Ивановна', '1995-01-15', 'Москва', 'Яндекс', '+7-999-111-01', 'anna.success@test.ru', 'anna123',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Москва')),
('Борис', 'Топовый', 'Петрович', '1995-02-20', 'Москва', 'VK', '+7-999-222-02', 'boris.top@test.ru', 'boris123',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Москва')),
('Виктор', 'Скрытный', 'Сидорович', '1995-03-25', 'Москва', '2ГИС', '+7-999-333-03', 'victor.low@test.ru', 'victor123',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Москва')),
('Нет', 'Друзей', 'Нетович', '2000-01-01', 'Москва', 'Нет', '000-000-00', 'no.friends@test.ru', 'nofriends',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Москва')),
('Елена', 'БезДрузей', 'Алексеевна', '1996-04-10', 'СПб', 'Тинькофф', '+7-999-444-04', 'elena.no.friends@test.ru', 'elena123',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Москва'));

-- 3. ДОБАВЛЯЕМ УЧАСТНИКОВ В СООБЩЕСТВА
INSERT INTO CommunityMembers (user_id, community_id, join_date)
SELECT u.user_id, c.community_id, CURRENT_DATE
FROM Users u
CROSS JOIN Communities c
WHERE c.community_name IN ('Top_Community_1', 'Top_Community_2', 'Middle_Community', 'Low_Community_1', 'Low_Community_2')
  AND u.email IN ('anna.success@test.ru', 'boris.top@test.ru', 'victor.low@test.ru', 'ivanov@mail.ru', 'petrov@mail.ru', 'sidorov@mail.ru')
ON CONFLICT (user_id, community_id) DO NOTHING;

INSERT INTO CommunityMembers (user_id, community_id, join_date)
SELECT u.user_id, c.community_id, CURRENT_DATE
FROM Users u
CROSS JOIN Communities c
WHERE c.community_name IN ('Top_Community_1', 'Top_Community_2', 'Middle_Community', 'Low_Community_1', 'Low_Community_2')
  AND u.email IN ('kuznetsova@mail.ru', 'fedorov@mail.ru', 'vasilieva@mail.ru', 'novikov@mail.ru', 'orlova@mail.ru')
ON CONFLICT (user_id, community_id) DO NOTHING;

-- 4. ПОСТЫ ДЛЯ ТОП-СООБЩЕСТВ 
INSERT INTO Posts (user_id, community_id, post_text, post_date)
SELECT u.user_id, c.community_id, 'Пост про базы данных в ' || c.community_name || ' от ' || u.first_name, '2025-10-01'::date
FROM Users u, Communities c
WHERE c.community_name = 'Top_Community_1'
  AND u.user_id IN ((SELECT user_id FROM Users WHERE email='anna.success@test.ru'),
                    (SELECT user_id FROM Users WHERE email='boris.top@test.ru'),
                    (SELECT user_id FROM Users WHERE email='ivanov@mail.ru'))
UNION ALL
SELECT u.user_id, c.community_id, 'Еще один пост про базы данных в ' || c.community_name, '2025-10-02'::date
FROM Users u, Communities c
WHERE c.community_name = 'Top_Community_2'
  AND u.user_id IN ((SELECT user_id FROM Users WHERE email='anna.success@test.ru'),
                    (SELECT user_id FROM Users WHERE email='boris.top@test.ru'),
                    (SELECT user_id FROM Users WHERE email='petrov@mail.ru'));

-- 5. ПОСТЫ ДЛЯ LOW-СООБЩЕСТВ
INSERT INTO Posts (user_id, community_id, post_text, post_date)
VALUES
((SELECT user_id FROM Users WHERE email='anna.success@test.ru'), (SELECT community_id FROM Communities WHERE community_name='Low_Community_1'), 'Редкий пост от Анны', '2025-10-03'::date),
((SELECT user_id FROM Users WHERE email='anna.success@test.ru'), (SELECT community_id FROM Communities WHERE community_name='Low_Community_2'), 'Еще один редкий пост', '2025-10-04'::date),
((SELECT user_id FROM Users WHERE email='victor.low@test.ru'), (SELECT community_id FROM Communities WHERE community_name='Low_Community_1'), 'Пост от Виктора', '2025-10-03'::date),
((SELECT user_id FROM Users WHERE email='victor.low@test.ru'), (SELECT community_id FROM Communities WHERE community_name='Low_Community_2'), 'Пост от Виктора 2', '2025-10-04'::date);

-- 6. ДОБАВЛЯЕМ КОММЕНТАРИИ 
INSERT INTO Comments (user_id, post_id, comment_text, comment_date, parent_comment_id)
SELECT 
    (SELECT user_id FROM Users WHERE email='anna.success@test.ru'),
    post_id,
    'Отличный пост!',
    '2025-10-02'::date,
    NULL
FROM Posts 
WHERE community_id = (SELECT community_id FROM Communities WHERE community_name='Top_Community_1') 
LIMIT 1;

INSERT INTO Comments (user_id, post_id, comment_text, comment_date, parent_comment_id)
SELECT 
    (SELECT user_id FROM Users WHERE email='boris.top@test.ru'),
    post_id,
    'Согласен!',
    '2025-10-03'::date,
    NULL
FROM Posts 
WHERE community_id = (SELECT community_id FROM Communities WHERE community_name='Top_Community_2') 
LIMIT 1;

-- 7. ДОБАВЛЯЕМ ЛАЙКИ 
INSERT INTO Likes (user_id, post_id, like_date)
SELECT 
    (SELECT user_id FROM Users WHERE email='ivanov@mail.ru'),
    post_id,
    '2025-10-02'::date
FROM Posts 
WHERE community_id = (SELECT community_id FROM Communities WHERE community_name='Top_Community_1') 
LIMIT 1;

INSERT INTO Likes (user_id, post_id, like_date)
SELECT 
    (SELECT user_id FROM Users WHERE email='petrov@mail.ru'),
    post_id,
    '2025-10-03'::date
FROM Posts 
WHERE community_id = (SELECT community_id FROM Communities WHERE community_name='Top_Community_2') 
LIMIT 1;

-- 8. СООБЩЕНИЯ МЕЖДУ ПОЛЬЗОВАТЕЛЯМИ
INSERT INTO Messages (user_id, receiver_id, message_text, send_date, media_file_id) VALUES
((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'), (SELECT user_id FROM Users WHERE email='petrov@mail.ru'), 'Привет, Петр!', '2025-10-01'::date, NULL),
((SELECT user_id FROM Users WHERE email='petrov@mail.ru'), (SELECT user_id FROM Users WHERE email='ivanov@mail.ru'), 'Привет, Иван!', '2025-10-02'::date, NULL),
((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'), (SELECT user_id FROM Users WHERE email='sidorov@mail.ru'), 'Привет, Сидор!', '2025-10-03'::date, NULL),
((SELECT user_id FROM Users WHERE email='sidorov@mail.ru'), (SELECT user_id FROM Users WHERE email='ivanov@mail.ru'), 'Привет, Иван!', '2025-10-04'::date, NULL),
((SELECT user_id FROM Users WHERE email='anna.success@test.ru'), (SELECT user_id FROM Users WHERE email='boris.top@test.ru'), 'Привет, Борис!', '2025-10-05'::date, NULL),
((SELECT user_id FROM Users WHERE email='boris.top@test.ru'), (SELECT user_id FROM Users WHERE email='anna.success@test.ru'), 'Привет, Анна!', '2025-10-06'::date, NULL),
((SELECT user_id FROM Users WHERE email='victor.low@test.ru'), (SELECT user_id FROM Users WHERE email='anna.success@test.ru'), 'Привет, Анна!', '2025-10-07'::date, NULL);

-- 9. ДОБАВЛЯЕМ ДРУЗЕЙ 
INSERT INTO Friends (user_id1, user_id2, friendship_date)
SELECT * FROM (VALUES
    ((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'), (SELECT user_id FROM Users WHERE email='petrov@mail.ru'), '2025-01-10'::date),
    ((SELECT user_id FROM Users WHERE email='ivanov@mail.ru'), (SELECT user_id FROM Users WHERE email='sidorov@mail.ru'), '2025-01-15'::date),
    ((SELECT user_id FROM Users WHERE email='petrov@mail.ru'), (SELECT user_id FROM Users WHERE email='sidorov@mail.ru'), '2025-02-01'::date),
    ((SELECT user_id FROM Users WHERE email='boris.top@test.ru'), (SELECT user_id FROM Users WHERE email='anna.success@test.ru'), '2025-03-01'::date),
    ((SELECT user_id FROM Users WHERE email='victor.low@test.ru'), (SELECT user_id FROM Users WHERE email='anna.success@test.ru'), '2025-03-05'::date)
) AS v(u1, u2, d)
WHERE NOT EXISTS (
    SELECT 1 FROM Friends f 
    WHERE (f.user_id1 = v.u1 AND f.user_id2 = v.u2)
       OR (f.user_id1 = v.u2 AND f.user_id2 = v.u1)
);
-- 10. ДОБАВЛЯЕМ ИНТЕРЕСЫ ДЛЯ НОВЫХ ПОЛЬЗОВАТЕЛЕЙ
INSERT INTO UserInterests (user_id, interest_id, additional_info) VALUES
((SELECT user_id FROM Users WHERE email='anna.success@test.ru'), (SELECT interest_id FROM Interests WHERE interest_name='Футбол'), 'Любит спорт'),
((SELECT user_id FROM Users WHERE email='boris.top@test.ru'), (SELECT interest_id FROM Interests WHERE interest_name='Музыка'), 'Рок-музыкант'),
((SELECT user_id FROM Users WHERE email='victor.low@test.ru'), (SELECT interest_id FROM Interests WHERE interest_name='Кино'), 'Киноман');

-- 11. ДОБАВЛЯЕМ ПОЛЬЗОВАТЕЛЯ ДЛЯ ТЕСТА "ПОЛНЫХ ТЕЗОК" 
INSERT INTO Users (first_name, last_name, middle_name, date_of_birth, place_of_residence,
                   place_of_work, phone, email, password, settlement_id) VALUES
('Иван', 'Иванов', 'Иванович', '2005-03-15', 'СПб', 'ИТМО', '111-222-333', 'ivanov2@mail.ru', 'pass_ivan',
 (SELECT settlement_id FROM Settlements WHERE settlement_name='Москва'));



--доп данные

-- 1. Удаляем старые тестовые сообщества (если есть)
DELETE FROM Communities WHERE community_name IN ('Top_News', 'Top_Sports', 'Flop_Old', 'Flop_Empty');

-- 2. Добавляем сообщества
INSERT INTO Communities (community_name, creator_user_id, description, organizers_info, posts_info) VALUES
('Top_News', (SELECT user_id FROM Users WHERE email='ivanov@mail.ru'), 'Главные новости', 'Редакция', 'Ежедневные обновления'),
('Top_Sports', (SELECT user_id FROM Users WHERE email='petrov@mail.ru'), 'Спортивные события', 'Спорт-редакция', 'Матчи и трансляции'),
('Flop_Old', (SELECT user_id FROM Users WHERE email='sidorov@mail.ru'), 'Заброшенное сообщество', NULL, NULL),
('Flop_Empty', (SELECT user_id FROM Users WHERE email='smirnova@mail.ru'), 'Почти пустое', NULL, 'Редкие посты');

-- 3. Добавляем пользователя Анну (если ещё нет)
INSERT INTO Users (first_name, last_name, middle_name, date_of_birth, place_of_residence,
                   place_of_work, phone, email, password, settlement_id)
SELECT 'Анна', 'Успешная', 'Ивановна', '1995-01-15', 'Москва', 'Яндекс', '+7-999-111-01', 'anna.success@test.ru', 'anna123',
       (SELECT settlement_id FROM Settlements WHERE settlement_name='Москва')
WHERE NOT EXISTS (SELECT 1 FROM Users WHERE email='anna.success@test.ru');

-- 4. Добавляем ПО 6 ПОСТОВ в топ-сообщества (через прямые INSERT)
-- Top_News: 6 постов
INSERT INTO Posts (user_id, community_id, post_text, post_date)
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Top_News'),
    'Пост от ' || u.first_name || ' в Top_News',
    '2025-04-01'::date
FROM Users u
WHERE u.email = 'anna.success@test.ru'
UNION ALL
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Top_News'),
    'Пост от ' || u.first_name || ' в Top_News',
    '2025-04-02'::date
FROM Users u
WHERE u.email = 'ivanov@mail.ru'
UNION ALL
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Top_News'),
    'Пост от ' || u.first_name || ' в Top_News',
    '2025-04-03'::date
FROM Users u
WHERE u.email = 'petrov@mail.ru'
UNION ALL
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Top_News'),
    'Пост от ' || u.first_name || ' в Top_News',
    '2025-04-04'::date
FROM Users u
WHERE u.email = 'sidorov@mail.ru'
UNION ALL
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Top_News'),
    'Пост от ' || u.first_name || ' в Top_News',
    '2025-04-05'::date
FROM Users u
WHERE u.email = 'boris.top@test.ru'
UNION ALL
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Top_News'),
    'Пост от ' || u.first_name || ' в Top_News',
    '2025-04-06'::date
FROM Users u
WHERE u.email = 'kuznetsova@mail.ru';

-- Top_Sports: 6 постов
INSERT INTO Posts (user_id, community_id, post_text, post_date)
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Top_Sports'),
    'Пост от ' || u.first_name || ' в Top_Sports',
    '2025-04-01'::date
FROM Users u
WHERE u.email = 'anna.success@test.ru'
UNION ALL
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Top_Sports'),
    'Пост от ' || u.first_name || ' в Top_Sports',
    '2025-04-02'::date
FROM Users u
WHERE u.email = 'ivanov@mail.ru'
UNION ALL
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Top_Sports'),
    'Пост от ' || u.first_name || ' в Top_Sports',
    '2025-04-03'::date
FROM Users u
WHERE u.email = 'petrov@mail.ru'
UNION ALL
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Top_Sports'),
    'Пост от ' || u.first_name || ' в Top_Sports',
    '2025-04-04'::date
FROM Users u
WHERE u.email = 'boris.top@test.ru'
UNION ALL
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Top_Sports'),
    'Пост от ' || u.first_name || ' в Top_Sports',
    '2025-04-05'::date
FROM Users u
WHERE u.email = 'fedorov@mail.ru'
UNION ALL
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Top_Sports'),
    'Пост от ' || u.first_name || ' в Top_Sports',
    '2025-04-06'::date
FROM Users u
WHERE u.email = 'vasilieva@mail.ru';

-- 5. Добавляем посты Анны во флоп-сообщества
INSERT INTO Posts (user_id, community_id, post_text, post_date)
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Flop_Old'),
    'Редкий пост от Анны в Flop_Old',
    '2024-01-01'::date
FROM Users u
WHERE u.email = 'anna.success@test.ru'
UNION ALL
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Flop_Empty'),
    'Редкий пост от Анны в Flop_Empty',
    '2024-01-02'::date
FROM Users u
WHERE u.email = 'anna.success@test.ru';

-- 6. Добавляем дополнительные посты во флоп-сообщества (чтобы MIN = 2)
INSERT INTO Posts (user_id, community_id, post_text, post_date)
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Flop_Old'),
    'Пост от Виктора в Flop_Old',
    '2024-06-01'::date
FROM Users u
WHERE u.email = 'victor.low@test.ru'
UNION ALL
SELECT 
    u.user_id,
    (SELECT community_id FROM Communities WHERE community_name='Flop_Empty'),
    'Пост от Виктора в Flop_Empty',
    '2024-06-02'::date
FROM Users u
WHERE u.email = 'victor.low@test.ru';

-- 7. Добавляем пользователя для контраста (только в топах)
INSERT INTO Users (first_name, last_name, middle_name, date_of_birth, place_of_residence,
                   place_of_work, phone, email, password, settlement_id)
SELECT 'Дмитрий', 'Только_Топ', 'Алексеевич', '1995-05-05', 'Москва', 'ИТ', '+7-999-555-05', 'dmitry@test.ru', 'dmitry123',
       (SELECT settlement_id FROM Settlements WHERE settlement_name='Москва')
WHERE NOT EXISTS (SELECT 1 FROM Users WHERE email='dmitry@test.ru');

-- Дмитрий пишет только в топ-сообщества
INSERT INTO Posts (user_id, community_id, post_text, post_date)
SELECT 
    (SELECT user_id FROM Users WHERE email='dmitry@test.ru'),
    community_id,
    'Пост от Дмитрия в ' || community_name,
    '2025-04-10'::date
FROM Communities 
WHERE community_name IN ('Top_News', 'Top_Sports');
