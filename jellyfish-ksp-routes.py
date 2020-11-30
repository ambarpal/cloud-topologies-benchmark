import numpy as np
np.random.seed(123) 

nRouter = 5
nRouterPorts = 3
nServerPorts = 2

numPortsUsed = []
for i in range(nRouter): 
	numPortsUsed.append(0)

edges = {}
for i in range(nRouter):
	edges[i] = []

port = {}
for i in range(nRouter):
	candidates = np.random.permutation(range(nRouter))
	for j in candidates:
		if j != i and \
		numPortsUsed[i] < nRouterPorts and \
		numPortsUsed[j] < nRouterPorts and \
		not (j in edges[i]):
			edges[i].append(j)
			edges[j].append(i)
			port[(i, j)] = (numPortsUsed[i], numPortsUsed[j])
			port[(j, i)] = (numPortsUsed[j], numPortsUsed[i])

			numPortsUsed[i] += 1
			numPortsUsed[j] += 1

adj = np.zeros((nRouter, nRouter))
for i in range(nRouter):
	for j in edges[i]:
		adj[i][j] = 1

print ('####################################################################')
print ('// Generated Router-Router Links')
for i in range(nRouter):
	for j in range(i + 1, nRouter):
		if adj[i][j] == 1:
			port_used = port[(i, j)]
			print ("router[{}].ethg[{}] <--> generic_link <--> router[{}].ethg[{}];".format(i, port_used[0], j, port_used[1]))

print ('// Generated Router-Server Links')
servers = {}
router = {}
sidx = 0
for ridx in range(nRouter):
	conn_servers = []
	for _ in range(nServerPorts):
		conn_servers.append(sidx)
		router[sidx] = ridx
		print ("server[{}].ethg++ <--> generic_link <--> router[{}].ethg++;".format(sidx, ridx))

		sidx += 1
	servers[ridx] = conn_servers
print ('####################################################################')

def ksp(src, dst, k):
	heap = [[0, [src]]]
	num_paths = 0
	res = []

	while (len(heap) > 0 and num_paths < k):
		heap.sort(key = lambda path: path[0])
		head = heap[0]
		heap = heap[1:]

		cost = head[0]
		path = head[1]
		last_node = path[-1]

		if last_node == dst:
			res.append(path)
			num_paths += 1

		else:
			for j in edges[last_node]:
				if not (j in path):
					newpath = path + [j]
					newcost = cost + 1
					heap.append([newcost, newpath])

	return res

# Specifying the list of servers that want to send information from one to another
demands = [(0, 5), (6, 3), (2, 1), (9, 4)]
print ('####################################################################')
print ('# Application Setup')
for (src, dst) in demands:
	print ('JellyFishRouter.server[{}].numApps = 1'.format(src))
	print ('JellyFishRouter.server[{}].app[0].typename = "TcpSessionApp"'.format(src))
	# print ('JellyFishRouter.server[{}].app[0].active = true'.format(src))
	# print ('JellyFishRouter.server[{}].app[0].localPort = -1'.format(src))
	print ('JellyFishRouter.server[{}].app[0].connectAddress = "server[{}]"'.format(src, dst))
	print ('JellyFishRouter.server[{}].app[0].tOpen = 0.2s'.format(src))
	print ('JellyFishRouter.server[{}].app[0].tSend = 0.4s'.format(src))
	print ('JellyFishRouter.server[{}].app[0].sendBytes = 10MiB'.format(src))
	# print ('JellyFishRouter.server[{}].app[0].sendScript = ""'.format(src))
	print ('JellyFishRouter.server[{}].app[0].tClose = 25s'.format(src))
	print ('JellyFishRouter.server[{}].numApps = 1'.format(dst))
	print ('JellyFishRouter.server[{}].app[0].typename = "TcpSinkApp"'.format(dst))

print ('####################################################################')

print ('####################################################################')
print ('<config>')
print ("\t<interface hosts='**' address='10.x.x.x' netmask='255.x.x.x'/>")
for (src, dst) in demands:
	paths = ksp(router[src], router[dst], 4)
	# print (paths)

	rpath = paths[np.random.randint(low=0, high=len(paths))]
	# print (rpath)
	print ('')
	for idx in range(len(rpath) - 1):
		u = rpath[idx]
		v = rpath[idx + 1]
		srcport = port[(u, v)][0]
		pline = '\t<route hosts="router[{}]" destination="server[{}]" netmask="255.255.255.255" gateway="router[{}]" interface="eth{}" metric="0"/>'
		print (pline.format(u, dst, v, srcport))
print ('</config>')
print ('####################################################################')
























