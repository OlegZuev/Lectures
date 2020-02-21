SELECT * -- Информация о таблицах и представлениях
FROM information_schema.tables;


SELECT *
FROM information_schema.columns
WHERE table_schema = 'public';
