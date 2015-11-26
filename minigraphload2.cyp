//# Timing info DB-2000x2000

CREATE INDEX ON :Person(person_ID)

//# Added 1 index, statement executed in 1662 ms.


USING PERIODIC COMMIT 1000 LOAD CSV WITH HEADERS FROM "file:///home/bigdata/data/datalinkagesprint2.csv" 
AS row MERGE (a:Person { person_ID: row.person_id , source:"a"}) RETURN (a)


//# Added 1936 labels, created 1936 nodes, set 3872 properties, returned 70136 rows in 15508 ms


USING PERIODIC COMMIT 1000 LOAD CSV WITH HEADERS FROM "file:///home/bigdata/data/datalinkagesprint2.csv" 
AS row MERGE (b:Person { person_ID: row.Person_ID2 , source:"b"}) RETURN (b)

//# Added 1938 labels, created 1938 nodes, set 3876 properties, returned 70136 rows in 9104 ms, displaying first 1000 rows.

USING PERIODIC COMMIT 1000 LOAD CSV WITH HEADERS FROM "file:///home/bigdata/data/datalinkagesprint2.csv" AS row 
MATCH (a:Person { person_ID: row.person_id, source:"a"}) 
SET  a.forename = row.forename_1,a.surname = row.surname_1, a.dob_1 = row.dob_1 ,a.sex_1= row.sex_1, a.pcode_1 = row.pcode_1 , a.pcode_1 = row.pcode_1,a.pcd =row.pcode_dist_1


//# Set 945343 properties, statement executed in 16729 ms.

USING PERIODIC COMMIT 1000 LOAD CSV WITH HEADERS FROM "file:///home/bigdata/data/datalinkagesprint2.csv" AS row 
MATCH (b:Person { person_ID: row.Person_ID2, source:"b"}) 
SET  b.forename = row.forename_2,b.surname = row.surname_2, b.dob_2 = row.dob_2 ,b.sex_2= row.sex_2, b.pcode_2 = row.pcode_2 , b.pcode_2 = row.pcode_2,b.pcd =row.pcode_dist_2


//#Set 490952 properties, statement executed in 8765 ms.


USING PERIODIC COMMIT 1000 LOAD CSV WITH HEADERS FROM "file:///home/bigdata/data/datalinkagesprint2.csv" AS row 
MATCH (a:Person),(b:Person)
WHERE a.person_ID = row.person_id AND a.source="a" AND b.person_ID = row.Person_ID2 AND b.source="b"
CREATE (a)-[:MATCHPROB {prob: toFloat(row.round_prob), match:toInt( row.true_matches ),primary:toInt(row.primary_pair)}]->(b)

//#Set 210408 properties, created 70136 relationships, statement executed in 14639 ms.
