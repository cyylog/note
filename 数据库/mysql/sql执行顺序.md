```mysql
SELECT
DISTINCT <select_list>
FROM <left_table>
<join_type> JOIN <right_table>
ON <join_condition>
WHERE 
GROUP BY
HAVING
ORDER BY
LIMIT
```

执行顺序：

```mysql
FROM
ON
JOIN
WHERE
GROUP BY
HAVING
SELECT
DISTINCT
ORDER BY
LIMIT
```

