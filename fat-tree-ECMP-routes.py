import sys 
import random
import numpy as np

np.random.seed(123)

'''Network parameters as stated in NED file.'''
k = 4 
assert(k%2==0) #k should be even
num_edgeSwitches_perPod = int(k/2)
num_aggSwitches_perPod = int(k/2)
num_servers_perEdge = int(k/2)

total_num_aggSwitches = k*num_aggSwitches_perPod
total_num_edgeSwitches = k*num_edgeSwitches_perPod
total_num_servers = num_servers_perEdge*total_num_edgeSwitches
total_num_coreSwitches = int(pow(int(k/2), 2))

num_switchGates = k #All switches have k-gates.


demand_type = "rand_perm" #Type of demand pairs: rand_perm, 


'''Network class containing mapping of network.'''
class Network_Mapping: 
	def __init__(self):
		#Intitialize to empty list so it's easy to create mapping
		self.server_edge = dict([(i, []) for i in range(total_num_servers)])
		self.edge_agg = dict([(i, []) for i in range(total_num_edgeSwitches)])
		self.agg_core = dict([(i, []) for i in range(total_num_aggSwitches)])
		self.edge_server = dict([(i, []) for i in range(total_num_edgeSwitches)])
		self.agg_edge = dict([(i, []) for i in range(total_num_aggSwitches)])
		self.core_agg = dict([(i, []) for i in range(total_num_coreSwitches)])
		
		#indexing how the layers are coonnected 
		self.labels = ["servers", "edgeSwitches", "aggSwitches", "coreSwitches"]
		self.num_nodes = [total_num_servers, total_num_edgeSwitches, total_num_aggSwitches,
							total_num_coreSwitches]
		self.connections = [[self.server_edge], [self.edge_agg, self.edge_server], 
					[self.agg_core, self.agg_edge], [self.core_agg]]
		self.connection_indices = [[1], [2, 0], [3, 1], [2]] #[Upper layer, lower layer]
		# print (self.server_edge)


	'''Creates 3 dicts of lists, server_edge, edge_agg, agg_core. Each 
	having the indices of the connections between the corresponding layers.
	Format: server_edge[<server_number>] = [(<edge index>, <out_port of server>)]
			edge_server[<edge server index>] = [(<server index>, <out_port of edge>)]
	'''
	def create_network_mapping(self): 
		for pod in range(k): 
			#Server edge connections
			for edge in range(num_edgeSwitches_perPod): 
				for host in range(num_servers_perEdge):
					ix_serv = pod*num_edgeSwitches_perPod*num_servers_perEdge + edge*num_servers_perEdge + host
					port_serv = 0
					ix_edge = pod*num_edgeSwitches_perPod + edge
					port_edge = host
					
					self.server_edge[ix_serv] += [(ix_edge, port_serv)]
					self.edge_server[ix_edge] += [(ix_serv, port_edge)]
		
			#Edge Agg connections 
			for edge in range(num_edgeSwitches_perPod):
				for agg in range(num_aggSwitches_perPod):
					ix_edge = pod*num_edgeSwitches_perPod + edge
					port_edge = num_servers_perEdge + agg
					ix_agg = pod*num_aggSwitches_perPod + agg
					port_agg = edge

					self.edge_agg[ix_edge] += [(ix_agg, port_edge)]
					self.agg_edge[ix_agg] += [(ix_edge, port_agg)]
		
			#Agg Core connections
			for agg in range(num_aggSwitches_perPod):
				for c in range(int(num_switchGates/2)):
					ix_agg = pod*num_aggSwitches_perPod + agg
					port_agg = num_edgeSwitches_perPod + c
					ix_core = agg*(int(k/2)) + c
					port_core = pod

					self.agg_core[ix_agg] += [(ix_core, port_agg)]
					self.core_agg[ix_core] += [(ix_agg, port_core)]



# '''Output is dict such that <core id>: [(<server id, output port to edge>), 
# (<edge id>, <output port to agg>), (<agg id>, <output port to core>)]'''
# def find_routes_to_cores(nmap, src_serv_id):	
# 	core_routes = dict([(i, []) for i in range(total_num_coreSwitches)])

# 	for edge_info in nmap.server_edge[src_serv_id]: 
# 		edge_id, srv_edge_port = edge_info 
# 		for agg_info in nmap.edge_agg[edge_id]:  
# 			agg_id, edge_agg_port = agg_info
# 			for core_info in nmap.agg_core[agg_id]: 
# 				core_id, agg_core_port = core_info 

# 				srv_label = (nmap.labels[0] + "[%d]"%src_serv_id, srv_edge_port)
# 				edge_label = (nmap.labels[1] + "[%d]"%edge_id, edge_agg_port)
# 				agg_label = (nmap.labels[2]+ "[%d]"%agg_id, agg_core_port)
				
# 				core_routes[core_id] = [srv_label, edge_label, agg_label]
# 	return core_routes


# '''Output is dict such that <core id>: [(<core id, output port to agg>), 
# (<agg id>, <output port to edge>), (<edge id>, <output port to dst>)]'''
# def find_routes_coreToDst(nmap, core_id, dst_serv_id): 
# 	core_routes = dict([(i, []) for i in range(total_num_coreSwitches)])	

# 	for core_id in total_num_coreSwitches: 
# 		for 

'''Finds a random route between src and dst servers. 
Outputs a route e.g. [(servers[<src id>], <output port>), ....]'''
def find_random_route(nmap, src_srv_id, dst_srv_id):
	frontier = set({(0, src_srv_id)})
	visited = dict([((0, src_srv_id), (0, src_srv_id))]) #visited (<layer id>, <node id>): (<prev layer id>, <prev node id>) 

	temp = []
	for l in range(4): 
		for i in range(nmap.num_nodes[l]): temp += [((l, i), sys.maxsize)]
	curr_distances = dict(temp)
	curr_distances[(0, src_srv_id)] = 0 
	
	while (len(frontier) > 0): 
		frontier_dists = map(lambda n: curr_distances[n], frontier)
		curr_min = min(frontier_dists)
		frontier_withMin = set(filter(lambda n: curr_distances[n] == curr_min, frontier))
		

		(layer_id, node_id) = random.choice(list(frontier_withMin))
		adj_layer_maps = nmap.connections[layer_id]
		adj_layer_ids = nmap.connection_indices[layer_id]
		
		for l in range(len(adj_layer_ids)): 
			[adj_ids, out_ports] = list(zip(*adj_layer_maps[l][node_id])) #unzip ids and ports
			adj_frontier = [(adj_layer_ids[l], n) for n in adj_ids]

			adj_frontier = set(filter(lambda n: not (n in visited), adj_frontier))

			for n in adj_frontier: 
				visited[n] = (layer_id, node_id)
				curr_distances[n] = curr_min + 1
			frontier = frontier.union(adj_frontier)
		
		frontier.remove((layer_id, node_id))
		
	assert (len(visited) == sum(nmap.num_nodes)) #double check

	#Stitch up the path from visited
	route = []
	curr_node = (0, dst_srv_id)

	while curr_node != (0, src_srv_id): 
		next_node = visited[curr_node]
		
		i = (nmap.connection_indices[next_node[0]]).index(curr_node[0])
		nextToCurrLayer_map = nmap.connections[next_node[0]][i]
		p = list(filter(lambda n : n[0] == curr_node[1], nextToCurrLayer_map[next_node[1]]))[0]
		route = [(nmap.labels[next_node[0]] + "[%d]"%next_node[1], p[1])] + route
		curr_node = next_node

	return route


# '''Outputs a list of routes:  [[(string of <node name>, <port number>), ...], ...]. 
# 	E.g. [(edgeSwitch[0], 1), ...]. Can only be used on server as destination!
# 	visited = set of (layer_i, node_i)'''
# def find_routes(nmap, src, dst_srv_i, visited, curr_min_dist):
# 	(src_layer_i, src_node_i) = src
# 	if src_node_i == dst_srv_i:
# 		print ("enter 1")
# 		return ([[]], 0)
# 	else: #Need to search
# 		temp_routes = []
# 		temp_min_dist = sys.maxsize
# 		routes = []
# 		for l in range(len(nmap.connections[src_layer_i])): #For each layer adjacent to curr
# 			layer_connections = nmap.connections[src_layer_i][l] 
# 			[nextHop_ixs, output_ports] = list(zip(*layer_connections[src_node_i])) #unzip ids and ports
			
# 			for hop_i in range(len(nextHop_ixs)): #Dijkstra's
# 				temp_l, temp_id = nmap.connection_indices[src_layer_i][l], nextHop_ixs[hop_i]
# 				if (temp_l, temp_id) not in visited:
# 					visited.add((temp_l, temp_id))
# 					(temp_routes, temp_min_dist) = find_routes(nmap, 
# 						(nmap.connection_indices[src_layer_i][l], nextHop_ixs[hop_i]), dst_srv_i, visited, curr_min_dist)
				
# 					curr_hop_label = (nmap.labels[src_layer_i] + "[%d]"%src_node_i, output_ports[hop_i])
				
# 					routes += [[curr_hop_label]+r for r in temp_routes]
# 					temp_min_dist += 1
# 		return (routes, temp_min_dist)


'''curr, dest and next_hop are names of modules (e.g. "servers[i]") 
and output_port is the output port int'''
def write_route_xml(f, curr, dest, next_hop, output_port):
	f.write("	<route hosts=\"%s\" destination=\"%s\" netmask=\"255.255.255.255\" gateway=\"%s\" interface=\"eth%d\" metric=\"0\"/>\n" 
			% (curr, dest, next_hop, output_port))



'''For a list of src<->dst matches, which is a permutation of the ids, 
we write a random route using find_random_route() between the pairs of servers'''
def write_ECMP_routes(f, net_map, demand_perm):
	assert (len(demand_perm) == total_num_servers)
	for i in range(total_num_servers): 
		route = find_random_route(net_map, i, demand_perm[i])
		for h in range(len(route)-1): 
			dst_label = "servers[%d]"%demand_perm[i]
			write_route_xml(f, route[h][0], dst_label, route[h+1][0], route[h][1])

'''Given a set of demands, calculates ECMP routes and writes to xml file'''
def create_routes_file(demand_perm):
	f  = open("routes_fat_tree_k=%d_%s.xml"%(k, demand_type), "w+") 
	f.write("<config>\n")
	f.write("	<interface hosts='**' address='10.x.x.x' netmask='255.x.x.x'/>\n")

	net_map = Network_Mapping()
	net_map.create_network_mapping()

	write_ECMP_routes(f, net_map, demand_perm)
	f.write("</config>")
	f.close()









###############################################################
#INI File Stuff
###############################################################
def create_ini_file(demand_perm): 
	f  = open("basic_fat_tree_k=%d_%s.ini"%(k, demand_type), "w+") 
	for i in range(len(demand_perm)): 
		line = ('''**.servers[%d].numApps = 2
		**.servers[%d].app[0].typename = "TcpSessionApp"
		**.servers[%d].app[0].active = true
		**.servers[%d].app[0].localPort = -1
		**.servers[%d].app[0].connectAddress = "servers[%d]"
		**.servers[%d].app[0].connectPort = 1000
		**.servers[%d].app[0].sendBytes = 1MiB
		**.servers[%d].app[0].tClose = -1s

		**.servers[%d].app[1].typename = "TcpSinkApp"
		**.servers[%d].app[1].localPort = 1000\n''' % 
		(i, i, i, i, i, demand_perm[i], i, i, i, demand_perm[i], demand_perm[i]))

		f.write(line)
	f.close()












#MAIN STUFF 
#####################################################
'''Creates a demand matrix in terms of demadn_type'''
def create_demand_perm(): 
	if demand_type == "rand_perm": 
		return np.random.permutation(total_num_servers)



def main(): 
	demand_perm = create_demand_perm()
	create_ini_file(demand_perm) 
	create_routes_file(demand_perm)
	

# main()

ini_file_header = '''[General]
network = Basic_fat_tree


**.edgeSwitches[*].queueType = "DropTailQueue"
**.edgeSwitches[*].queue.frameCapacity = 25

**.aggSwitches[*].queueType = "DropTailQueue"
**.aggSwitches[*].queue.frameCapacity = 25

**.coreSwitches[*].queueType = "DropTailQueue"
**.coreSwitches[*].queue.frameCapacity = 25

# Configurator settings
*.configurator.dumpAddresses = true
*.configurator.dumpTopology = true
*.configurator.dumpLinks = true
*.configurator.dumpRoutes = true
*.configurator.config = xmldoc("routes_fat_tree_k=4_rand_perm.xml")

# Routing settings
*.*.ipv4.arp.typename = "GlobalArp"
*.*.ipv4.routingTable.netmaskRoutes = ""

#Visualizer settings
*.visualizer.interfaceTableVisualizer.displayInterfaceTables = true
*.visualizer.interfaceTableVisualizer.nodeFilter = "not (*switch* or *Switch* or *AP*)"

#Recording settings
record-eventlog=false
debug-on-errors = false
**.cmdenv-log-level = off

cmdenv-express-mode = true
cmdenv-performance-display = true

 **.statistic-recording=true
**.tcpApp[*].rcvdPk:vector(packetBytes).vector-recording = true
**.tcpApp[*].rcvdPk:sum(packetBytes).scalar-recording = true
**.tcpApp[*].rcvdPk:count.scalar-recording = true
**.coreSwitches[*].**.dropPk:count.scalar-recording = true
**.coreSwitches[*].**.rcvdPk:count.scalar-recording = true
**.aggSwitches[*].**.dropPk:count.scalar-recording = true
**.aggSwitches[*].**.rcvdPk:count.scalar-recording = true
**.edgeSwitches.**.dropPk:count.scalar-recording = true
**.edgeSwitches.**.rcvdPk:count.scalar-recording = true
**.servers[*].**.dropPk:count.scalar-recording = true
**.servers[*].**.rcvdPk:count.scalar-recording = true
**.servers[*].**.rcvdPk:sum(packetBytes).scalar-recording = true
**.servers[*].**.dropPk:sum(packetBytes).scalar-recording = true
#
#**.scalar-recording=false
#**.vector-recording=false
#**.bin-recording=false

**.channel.throughput.result-recording-modes=all'''
