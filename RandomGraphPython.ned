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
import inet.common.misc.ThruputMeteringChannel;
import inet.node.ethernet.EtherSwitch;
import inet.linklayer.ieee8021d.stp.Stp;
import inet.visualizer.integrated.IntegratedCanvasVisualizer;
import inet.node.ethernet.Eth100M;
import inet.node.ethernet.Eth10M;
import inet.node.inet.Router;

//import inet.linklayer.configurator.L2NetworkConfigurator;
//import inet.linklayer.configurator.L2NodeConfigurator;
//import inet.networklayer.common.InterfaceTable;
//import inet.linklayer.contract.IMacAddressTable;

module Node {
    parameters:
        @display("i=abstract/router_vs");
    gates:
        inout g[];
    connections allowunconnected:
}

channel generic_link extends ThruputMeteringChannel {
    parameters:
        datarate = 1Gbps;
        delay = 1ms;
        thruputDisplayFormat = "u|B";
}

channel server_switch_link extends ThruputMeteringChannel {
    parameters:
        datarate = 1Gbps;
        delay = 1ms;
        thruputDisplayFormat = "";
}

channel switch_switch_link extends ThruputMeteringChannel {
    parameters:
        datarate = 10Gbps;
        delay = 0ms;
        thruputDisplayFormat = "";
}
   
module Server extends StandardHost {
    parameters:
        forwarding = true;
    @display("i=device/pc2");
}

network JellyFish {
    parameters:
	int nSwitch = default(5);
	int nServerPorts = default(2);
	int nSwitchPorts = default(3);
	int nServers = nServerPorts * nSwitch;
	
    submodules:
        switch[nSwitch]: EtherSwitch;
        server[nServers]: Server;
       	configurator: Ipv4NetworkConfigurator;
       	visualizer: IntegratedCanvasVisualizer {
            @display("p=98.8575,209.81999");
        }
    
    connections allowunconnected:
        for idx = 0..nServers-1{
            server[idx].ethg++ <--> Eth100M <--> switch[int(idx / nServerPorts)].ethg++;
        }

        // ------------------------------------------- PASTE HERE FOR SWITCH CONFIG --------------------------------------------
        // Run generate_jellyfish_topology.py
        // ------------------------------------------- PASTE HERE FOR SWITCH CONFIG -------------------------------------------- 
        switch[0].ethg++ <--> generic_link <--> switch[1].ethg++;
        switch[0].ethg++ <--> generic_link <--> switch[2].ethg++;
        switch[0].ethg++ <--> generic_link <--> switch[3].ethg++;
        switch[1].ethg++ <--> generic_link <--> switch[2].ethg++;
        switch[1].ethg++ <--> generic_link <--> switch[4].ethg++;
        switch[2].ethg++ <--> generic_link <--> switch[4].ethg++;
        switch[3].ethg++ <--> generic_link <--> switch[4].ethg++;
}

network JellyFishRouter {
    parameters:
	int nRouter = default(5);
	int nServerPorts = default(2);
	int nRouterPorts = default(3);
	int nServers = nServerPorts * nRouter;
	
    submodules:
		router[nRouter]: Router;
        server[nServers]: Server;
       	configurator: Ipv4NetworkConfigurator;
       	visualizer: IntegratedCanvasVisualizer {
            @display("p=98.8575,209.81999");
        }
    
    connections allowunconnected:
        for idx = 0..nServers-1{
            server[idx].ethg++ <--> Eth100M <--> router[int(idx / nServerPorts)].ethg++;
        }

        // ------------------------------------------- PASTE HERE FOR ROUTER CONFIG --------------------------------------------
        // Run generate_jellyfish_router.py
        // ------------------------------------------- PASTE HERE FOR ROUTER CONFIG -------------------------------------------- 
        router[0].ethg++ <--> generic_link <--> router[1].ethg++;
        router[0].ethg++ <--> generic_link <--> router[3].ethg++;
        router[0].ethg++ <--> generic_link <--> router[4].ethg++;
        router[1].ethg++ <--> generic_link <--> router[3].ethg++;
        router[1].ethg++ <--> generic_link <--> router[4].ethg++;
        router[2].ethg++ <--> generic_link <--> router[3].ethg++;
        router[2].ethg++ <--> generic_link <--> router[4].ethg++;
}