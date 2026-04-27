-- =============================================================================
-- Рекурсивный CTE — пример валидации графа квеста (PostgreSQL)
-- Подставьте реальные имена таблиц/полей из data_modeling/schema.sql
-- =============================================================================
-- Задачи, которые можно решать рекурсией:
--   • достижимость узлов из стартового;
--   • поиск цикла (DFS);
--   • проверка, что все обязательные шаги на пути от старта.
-- =============================================================================

-- Пример: узлы, достижимые из стартового шага квеста :quest_id
-- Требуются: quests.start_step_id, quest_edges(from_step_id, to_step_id), quest_steps

/*
WITH RECURSIVE reachable AS (
    -- База: стартовый шаг квеста
    SELECT qs.step_id,
           q.quest_id
    FROM quests q
    JOIN quest_steps qs ON qs.step_id = q.start_step_id
    WHERE q.quest_id = :quest_id

    UNION

    -- Рекурсия: все шаги, куда есть переход из уже достигнутых
    SELECT e.to_step_id,
           r.quest_id
    FROM reachable r
    JOIN quest_edges e
      ON e.from_step_id = r.step_id
     AND e.quest_id = r.quest_id
)
SELECT DISTINCT step_id
FROM reachable;
*/

-- Пример: обнаружение цикла направленным обходом (упрощённая идея —
-- для продакшена уточните семантику «цикл запрещён / разрешён»).

/*
WITH RECURSIVE walk AS (
    SELECT e.from_step_id,
           e.to_step_id,
           ARRAY[e.from_step_id, e.to_step_id] AS path
    FROM quest_edges e
    WHERE e.quest_id = :quest_id
      AND e.from_step_id = (SELECT start_step_id FROM quests WHERE quest_id = :quest_id)

    UNION ALL

    SELECT e.from_step_id,
           e.to_step_id,
           w.path || e.to_step_id
    FROM walk w
    JOIN quest_edges e
      ON e.from_step_id = w.to_step_id
     AND e.quest_id = :quest_id
    WHERE NOT e.to_step_id = ANY (w.path)
)
SELECT TRUE AS cycle_found
FROM walk w
JOIN quest_edges e ON e.from_step_id = w.to_step_id AND e.to_step_id = ANY (w.path)
LIMIT 1;
*/

-- Раскомментируйте и адаптируйте один из блоков после создания реальных таблиц.

SELECT 'Define tables in data_modeling/schema.sql, then uncomment CTE examples above.' AS hint;
