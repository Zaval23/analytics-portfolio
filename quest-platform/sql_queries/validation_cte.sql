-- Рекурсивный CTE — пример валидации графа квеста (PostgreSQL)
-- Задачи, которые можно решить рекурсией:
--   • достижимость узлов из стартового;
--   • поиск цикла (DFS);
--   • проверка, что все обязательные шаги на пути от старта.
WITH RECURSIVE reachable_vertices AS (
    -- Стартовая вершина
    SELECT 
        id AS vertex_id,
        ARRAY[id] AS path,
        0 AS depth
    FROM vertices
    WHERE id = 'start_vertex'  -- заменяется на реалбный ID
      AND quest_fk = 1
    
    UNION ALL
    
    -- Рекурсивный обход по ребрам
    SELECT 
        e.vertice_2_fk,
        rv.path || e.vertice_2_fk,
        rv.depth + 1
    FROM edges e
    JOIN reachable_vertices rv ON e.vertice_1_fk = rv.vertex_id
    WHERE e.quest_fk = 1
      AND NOT (e.vertice_2_fk = ANY(rv.path))
      AND rv.depth < 50
)
-- Находим недостижимые вершины
SELECT 
    v.id AS unreachable_vertex,
    v.text
FROM vertices v
WHERE v.quest_fk = 1
  AND v.id NOT IN (SELECT vertex_id FROM reachable_vertices);
