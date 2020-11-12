import numpy as np
nRouter = 5
nRouterPorts = 3

numPortsUsed = []
for i in range(nRouter): 
	numPortsUsed.append(0)

edges = {}

for i in range(nRouter):
	edges[i] = []

for i in range(nRouter):
	candidates = np.random.permutation(range(nRouter))
	for j in candidates:
		if j != i and numPortsUsed[i] < nRouterPorts and numPortsUsed[j] < nRouterPorts and not (j in edges[i]):
			edges[i].append(j)
			edges[j].append(i)
			numPortsUsed[i] += 1
			numPortsUsed[j] += 1

adj = np.zeros((nRouter, nRouter))
for i in range(nRouter):
	for j in edges[i]:
		adj[i][j] = 1

for i in range(nRouter):
	for j in range(i + 1, nRouter):
		if adj[i][j] == 1:
			print ("router[{}].ethg++ <--> generic_link <--> router[{}].ethg++;".format(i, j))




