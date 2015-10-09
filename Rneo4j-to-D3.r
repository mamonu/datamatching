library (igraph)
library(RNeo4j)
library(networkD3)
library(htmlwidgets)

#g <- read.graph("~/scripts/out.graphml",format = "graphml")
#wc <- walktrap.community(g)
#fc <- fastgreedy.community(g)
#eb <- edge.betweenness.community(g)




graph = startGraph("http://localhost:7474/db/data/")

#query = "MATCH (n)-[r]-(b) RETURN id(n), n.person_ID,r.prob,id(b)"


query = "
MATCH (n)-[r]->(m)
RETURN ID(n) as from , ID(m) as to ,r.prob as weight 
"

#, r.prob as weight 

otherquery = "
MATCH (n)
RETURN DISTINCT ID(n) as nodeid , n.person_ID as personID , n.source as set_AB 
"

edgelist<-cypher(graph, query)
nodelist<-cypher(graph, otherquery)

edgeDF <-data.frame(edgelist)

edgeDF$from <- (edgeDF$from - 1319)
edgeDF$to <- (edgeDF$to - 1319)


nodeDF <-data.frame(nodelist)
nodeDF$nodeid <- (nodeDF$nodeid - 1319)

nodeDF$set_AB <- factor(nodeDF$set_AB) 
nodeDF$nodesize=4

# simpleNetwork(edgeDF,
#                linkColour = "red",nodeClickColour = "#E34A33", opacity = 0.5, zoom = FALSE)
# 
# 

# 
# MyClickScript <-
#   '
# alert("You clicked " + d.name + " which is in row " +
# (d.index + 1) +  " of your original R data frame");
# '


MyClickScript <- 
  '      d3.select(this).select("circle").transition()
.duration(750)
.attr("r", 30)'




forceNetwork ( Links = edgeDF , Nodes = nodeDF,
               Source = "from", Target = "to" ,
               Value = "weight", NodeID = "personID",Group = "set_AB" ,Nodesize="nodesize",
              
               linkDistance = JS('function(d) {', 'return Math.sqrt(d.value)*50 ;', '}'),
                
               linkWidth = JS("function(d) { return Math.sqrt(d.value)*3; }"), 
               radiusCalculation = JS("(d.nodesize)+6"),legend = T,
               opacity = 1, zoom = T, bounded = F, clickAction = MyClickScript)


