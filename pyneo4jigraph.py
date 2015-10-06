from py2neo import Graph as pGraph
from igraph import Graph as iGraph

graph = pGraph("http://localhost:7474/db/data/")
print graph

query = """
MATCH (n)-[r]->(m)
WHERE r.prob>0.8
RETURN n.person_ID,m.person_ID,r.prob
"""

data = graph.cypher.execute(query)
print data

ig=iGraph.TupleList(data,weights=True)


print ig
