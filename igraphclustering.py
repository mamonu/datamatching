__author__ = 'bigdata'
from py2neo import Graph as pGraph
from igraph import *
import cairo
import louvain as louvain

graph = pGraph("http://localhost:7474/db/data/")
print graph

query = """
MATCH (n)-[r]->(m)
RETURN id(n)as from ,id(m) as to ,r.prob as prob
"""

data = graph.cypher.execute(query)
print data

ig = Graph.TupleList(data, weights=True)
print ig.is_simple()

part = louvain.find_partition(ig, method='Modularity', weight='weight')
layout = ig.layout_fruchterman_reingold()



visual_style = {}
visual_style["layout"] = layout
visual_style["vertex_label"] = ig.vs["name"]
visual_style["bbox"] = (3200, 3200)
visual_style["margin"] = 10
visual_style["vertex_size"] = 60
visual_style["edge_width"] = [2 + 2 * int(weight) for weight in ig.es["weight"]]
plot(part, **visual_style)




