import numpy as np
nSwitch = 5
nSwitchPorts = 3

numPortsUsed = []
for i in range(nSwitch): 
	numPortsUsed.append(0)

edges = {}

for i in range(nSwitch):
	edges[i] = []

for i in range(nSwitch):
	candidates = np.random.permutation(range(nSwitch))
	for j in candidates:
		if j != i and numPortsUsed[i] < nSwitchPorts and numPortsUsed[j] < nSwitchPorts and not (j in edges[i]):
			edges[i].append(j)
			edges[j].append(i)
			numPortsUsed[i] += 1
			numPortsUsed[j] += 1

adj = np.zeros((nSwitch, nSwitch))
for i in range(nSwitch):
	for j in edges[i]:
		adj[i][j] = 1

for i in range(nSwitch):
	for j in range(i + 1, nSwitch):
		if adj[i][j] == 1:
			print ("switch[{}].ethg++ <--> generic_link <--> switch[{}].ethg++;".format(i, j))




