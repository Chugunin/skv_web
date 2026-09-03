-- One-time data migration after adding directions.icon and directions.sort_order.
-- Safe to re-run: only fills missing values for the six current Journal directions.

UPDATE directions
SET icon = CASE title
  WHEN 'Восприятие' THEN '◉'
  WHEN 'Мышление' THEN '⌁'
  WHEN 'Эмоции' THEN '♡'
  WHEN 'Отношения' THEN '♧'
  WHEN 'Личность' THEN '♙'
  WHEN 'Качество жизни' THEN '✦'
  ELSE icon
END
WHERE icon IS NULL OR BTRIM(icon) = '';

UPDATE directions
SET sort_order = CASE title
  WHEN 'Восприятие' THEN 1
  WHEN 'Мышление' THEN 2
  WHEN 'Эмоции' THEN 3
  WHEN 'Отношения' THEN 4
  WHEN 'Личность' THEN 5
  WHEN 'Качество жизни' THEN 6
  ELSE sort_order
END
WHERE sort_order IS NULL;
