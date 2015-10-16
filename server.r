library(shiny)
library (igraph)
library(RNeo4j)
library(networkD3)
library(htmlwidgets)
library(jsonlite)



graph = startGraph("http://localhost:7474/db/data/")
#query = "MATCH (n)-[r]-(b) RETURN id(n), n.person_ID,r.prob,id(b)"
query = "
MATCH (n)-[r]->(m)
WHERE r.prob>0.7 AND r.prob<0.98
RETURN ID(n) as from , ID(m) as to ,r.prob as weight 
"

#, r.prob as weight 

otherquery = "
MATCH (n)
RETURN DISTINCT ID(n) as nodeid , n.person_ID as personID , n.source as set_AB , 
n.forename as fname , n.surname as surname
"

edgelist<-cypher(graph, query)
nodelist<-cypher(graph, otherquery)
edgeDF <-data.frame(edgelist)

edgeDF$from <- (edgeDF$from - 1319)
edgeDF$to <- (edgeDF$to - 1319)

nodeDF <-data.frame(nodelist)
nodeDF$nodeid <- (nodeDF$nodeid - 1319)

nodeDF$set_AB <- factor(nodeDF$set_AB) 
nodeDF$nodesize=7



shinyServer(function(input, output) {
  
  
  
  
  MyClickScript <- 
    '      d3.select(this).select("circle").transition()
  .duration(750)
  .attr("r", 80);
  
  alert("You clicked " + d.name + " which is in row " +
  + (d.index + 1) +  " of your original R data frame");
  
  '
  output$force <- renderForceNetwork({
  
  forceNetwork ( Links = edgeDF , Nodes = nodeDF,
                 Source = "from", Target = "to" ,
                 Value = "weight", NodeID = "personID",Group = "set_AB" , 
                 
                 linkDistance = JS('function(d) {', 'return Math.sqrt(d.value)*5 ;', '}'),
                 
                 linkWidth = JS("function(d) { return Math.sqrt(d.value); }"),  charge=- 300,
                 
                 radiusCalculation = JS("(d.nodesize)+6"),legend = T,
                 opacity = input$opacity , zoom = T, bounded = F, clickAction = MyClickScript)
  })

  
  
  
  output$mytable <- DT::renderDataTable({
    DT::datatable(nodeDF[drop = FALSE])
  })
  
  
  
  
  
  
})
