
CREATE INDEX ON :PersonB(person_ID)
CREATE INDEX ON :PersonA(person_ID)


USING PERIODIC COMMIT 1000 LOAD CSV WITH HEADERS FROM "file:///home/bigdata/data/outputv11.csv" AS row 
MERGE (a:PersonA { person_ID: row.person_id1 }) RETURN (a)


USING PERIODIC COMMIT 1000 LOAD CSV WITH HEADERS FROM "file:///home/bigdata/data/outputv11.csv" AS row 
MERGE (b:PersonB { person_ID: row.Person_ID2 }) RETURN (b)


USING PERIODIC COMMIT 100
LOAD CSV 
WITH HEADERS FROM "file:///home/bigdata/data/outputv11.csv" AS row
MATCH (a:PersonA),(b:PersonB)
WHERE a.person_ID = row.person_id1 AND b.person_ID = row.Person_ID2
CREATE (a)-[:MATCHPROB {prob: toFloat(row.round_prob)}]->(b)




USING PERIODIC COMMIT 1000
LOAD CSV 
WITH HEADERS FROM "file:///home/bigdata/data/outputv11.csv" AS row
MATCH (a:PersonA { person_ID: row.person_id1})
SET a.synth_ID = row.synth1_ID, a.forename = row.forename_1,a.surname = row.surname_1, a.dd = row.dob_day_1,a.mm = row.dob_mon_1,a.yy = row.dob_year_1 ,a.source="a"


LOAD CSV 
WITH HEADERS FROM "file:///home/bigdata/data/outputv11.csv" AS row
MATCH (b:PersonB { person_ID: row.Person_ID2})
SET b.synth_ID = row.synth2_ID, b.forename = row.forename_2,b.surname = row.surname_2, b.dd = row.dob_day_2,b.mm = row.dob_mon_2,b.yy = row.dob_year_2 ,b.source="b"




//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------//


CREATE INDEX ON :Person(person_ID)

USING PERIODIC COMMIT 1000 LOAD CSV WITH HEADERS FROM "file:///home/bigdata/data/outputv11.csv" AS row 
MERGE (a:Person { person_ID: row.person_id1 , source:"a"}) RETURN (a)


USING PERIODIC COMMIT 1000 LOAD CSV WITH HEADERS FROM "file:///home/bigdata/data/outputv11.csv" AS row 
MERGE (b:Person { person_ID: row.Person_ID2, source:"b" }) RETURN (b)



USING PERIODIC COMMIT 1000
LOAD CSV 
WITH HEADERS FROM "file:///home/bigdata/data/outputv11.csv" AS row
MATCH (a:Person { person_ID: row.person_id1, source:"a" })
SET a.synth_ID = row.synth1_ID, a.forename = row.forename_1,a.surname = row.surname_1, a.dob = row.dob_1 ,a.sex_1= row.sex_1, a.pcode_1=row.pcode_1


USING PERIODIC COMMIT 1000
LOAD CSV 
WITH HEADERS FROM "file:///home/bigdata/data/outputv11.csv" AS row
MATCH (b:Person { person_ID: row.Person_ID2, source:"b" })
SET b.synth_ID = row.synth2_ID, b.forename = row.forename_2,b.surname = row.surname_2, b.dd = row.dob_day_2,b.mm = row.dob_mon_2,b.yy = row.dob_year_2,b.sex_2 = row.sex_2, b.pcode_2=row.pcode_2



USING PERIODIC COMMIT 100
LOAD CSV 
WITH HEADERS FROM "file:///home/bigdata/data/outputv11.csv" AS row
MATCH (a:Person),(b:Person)
WHERE a.person_ID = row.person_id1 AND a.source="a" AND b.person_ID = row.Person_ID2 AND b.source="b"
CREATE (a)-[:MATCHPROB {prob: toFloat(row.round_prob)}]->(b)

//------------------------------------------------------------------------------------------------------

//Graph Theory: degree centrality
match (n:Person)-[r:MATCHPROB]-(m:Person) return count(r) as DegreeCentralityScore,id(n),n order by DegreeCentralityScore desc limit 10;


//Graph Theory: betweenness centrality
MATCH p=allShortestPaths((source:Person)-[:MATCHPROB*]-(target:Person))
WHERE id(source) < id(target) and length(p) > 1
UNWIND nodes(p)[1..-1] as n
RETURN id(n),n, count(*) as BetweennessCentralityScore
ORDER BY BetweennessCentralityScore DESC

//Graph Theory: finding potential triadic closures
MATCH path1=(p1:Person)-[:MATCHPROB*2..2]-(p2:Person)
where not((p1)-[:MATCHPROB]-(p2))
return path1
limit 50;

//Graph Theory: calculate the pagerank
UNWIND range(1,10) AS round
MATCH (n:Person)
WHERE rand() < 0.1 // 10% probability
MATCH (n:Person)-[:MATCHPROB*..10]->(m:Person)
SET m.rank = coalesce(m.rank,0) + 1;

//Show the PageRank
match (n:Person)
where n.rank is not null
return n.last_name, n.rank
order by n.rank desc;

//remove the rank
match (n:Person) 
remove n.rank;



