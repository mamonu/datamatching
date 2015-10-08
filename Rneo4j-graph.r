library (igraph)
library(RNeo4j)
library(networkD3)



graph = startGraph("http://localhost:7474/db/data/")

#query = "MATCH (n)-[r]-(b) RETURN id(n), n.person_ID,r.prob,id(b)"


query = "
MATCH (n)-[r]->(m)
RETURN ID(n) as from , ID(m) as to 
"

#, r.prob as weight 

otherquery = "
MATCH (n)
RETURN DISTINCT ID(n) as nodeid , n.person_ID as personID , n.source as set_AB
"

edgelist<-cypher(graph, query)
nodelist<-cypher(graph, otherquery)

edgeDF <-data.frame(edgelist)

nodeDF <-data.frame(nodelist)


simpleNetwork(edgeDF)
