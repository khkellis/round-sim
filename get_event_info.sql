 DELIMITER $$
 DROP PROCEDURE IF EXISTS get_person_times$$
 CREATE PROCEDURE get_person_times(IN nombre VARCHAR(255),IN eventChoice VARCHAR(255))
 BEGIN

 SELECT V FROM
	(SELECT
		personName,

		CASE X.which
		WHEn '1' THEN value1
		WHEn '2' THEN value2
		WHEn '3' THEN value3
		WHEn '4' THEN value4
		WHEn '5' THEN value5
		END as V

	FROM
	   results
	   CROSS JOIN 
		(SELECT '1' which
		UNION SELECT '2' which
		UNION SELECT '3' which
		UNION SELECT '4' which
		UNION SELECT '5' which) X
		WHERE eventId = eventChoice
		AND competitionId LIKE '%2019'
		LIMIT 1000000000) AS sub
	WHERE personName = nombre
    AND WHERE V > 0;
/*DROP TABLE IF EXISTS temp_holder;
CREATE TABLE temp_holder(
	times INT
);
INSERT INTO temp_holder
	 SELECT V FROM
	(SELECT
		personName,

		CASE X.which
		WHEn '1' THEN value1
		WHEn '2' THEN value2
		WHEn '3' THEN value3
		WHEn '4' THEN value4
		WHEn '5' THEN value5
		END as V

	FROM
	   results
	   CROSS JOIN 
		(SELECT '1' which
		UNION SELECT '2' which
		UNION SELECT '3' which
		UNION SELECT '4' which
		UNION SELECT '5' which) X
		WHERE eventId = eventChoice
		AND competitionId LIKE '%2019'
		LIMIT 10000000) AS sub
	WHERE personName = nombre
	;
SELECT * FROM temp_holder;*/
 END$$