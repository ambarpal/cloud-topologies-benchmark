//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 
import inet.applications.tcpapp.TcpEchoApp;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.inet.StandardHost;
import ned.DatarateChannel;

module Node {
    parameters:
        @display("i=abstract/router_vs");
    gates:
        inout g[];
    connections allowunconnected:
}

channel client_client_link extends DatarateChannel {
    parameters:
        int cost = default(1);
        datarate = 10Mbps;
        delay = 1ms;
}

channel client_server_link extends DatarateChannel {
    parameters:
        int cost = default(1);
        datarate = 100Mbps;
        delay = 0.1ms;
}
   
module Client extends StandardHost {
    parameters:
        forwarding = true;
}

network Network {
    parameters:
	int n; // = default(5);
	double connectedness = default(0.4); 

    submodules:
        node[n]: Client;
        server: StandardHost{
            @display("i=device/pc2");
        }; 
       	configurator: Ipv4NetworkConfigurator;
    
    connections:
        for i = 0..n-1, for j = i+1..n-1 {
			node[i].pppg++ <--> client_client_link <--> node[j].pppg++ if uniform(0,1)<connectedness;
        }
        for i = 0..n-1 {
            node[i].pppg++ <--> client_server_link <--> server.pppg++ if uniform(0,1) < 0.6; 
        }
}
