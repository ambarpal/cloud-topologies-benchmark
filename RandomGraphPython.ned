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
//        datarate = 10Mbps;
//        delay = 1ms;
        datarate = 1Gbps;
        delay = 0.1us;
        thruputDisplayFormat = "u|B";
//  	@statistic[throughput](source="sumPerDuration(packetBits(messageSent))"; record=last?; unit=Mbps);
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
	
	@statistic[throughput](source=liveThroughput(server[5].app[0].packetReceived)/1000000; record=figure; targetFigure=panel.throughput; checkSignals=false);
	@figure[panel](type=panel; pos=1.5,0.1);
	@figure[panel.throughput](type=linearGauge; pos=250,50; size=250,30; minValue=0; maxValue=54; tickSize=6; label="Application level throughput [Mbps]");
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
	int nRouter = default(16);
	int nRouterPorts = default(3);
	int nServerPorts = default(1);
	int nServers = nServerPorts * nRouter;
	
    submodules:
		router[nRouter]: Router{
		   gates:
                ethg[nRouterPorts + nServerPorts];
		};
        server[nServers]: Server;
       	configurator: Ipv4NetworkConfigurator;
       	visualizer: IntegratedCanvasVisualizer {
            @display("p=98.8575,209.81999");
        }
    
    connections allowunconnected:
        // ------------------------------------------- PASTE HERE FOR ROUTER CONFIG --------------------------------------------
        // Run generate_jellyfish_router.py
        // ------------------------------------------- PASTE HERE FOR ROUTER CONFIG -------------------------------------------- 
//// Generated Router-Router Links
//router[0].ethg[0] <--> generic_link <--> router[1].ethg[0];
//router[0].ethg[1] <--> generic_link <--> router[3].ethg[0];
//router[0].ethg[2] <--> generic_link <--> router[4].ethg[0];
//router[1].ethg[2] <--> generic_link <--> router[2].ethg[0];
//router[1].ethg[1] <--> generic_link <--> router[4].ethg[1];
//router[2].ethg[1] <--> generic_link <--> router[3].ethg[1];
//router[2].ethg[2] <--> generic_link <--> router[4].ethg[2];
//// Generated Router-Server Links
//server[0].ethg++ <--> generic_link <--> router[0].ethg++;
//server[1].ethg++ <--> generic_link <--> router[0].ethg++;
//server[2].ethg++ <--> generic_link <--> router[1].ethg++;
//server[3].ethg++ <--> generic_link <--> router[1].ethg++;
//server[4].ethg++ <--> generic_link <--> router[2].ethg++;
//server[5].ethg++ <--> generic_link <--> router[2].ethg++;
//server[6].ethg++ <--> generic_link <--> router[3].ethg++;
//server[7].ethg++ <--> generic_link <--> router[3].ethg++;
//server[8].ethg++ <--> generic_link <--> router[4].ethg++;
//server[9].ethg++ <--> generic_link <--> router[4].ethg++;
// Generated Router-Router Links
router[0].ethg[2] <--> generic_link <--> router[4].ethg[0];
router[0].ethg[0] <--> generic_link <--> router[7].ethg[0];
router[0].ethg[1] <--> generic_link <--> router[10].ethg[0];
router[1].ethg[1] <--> generic_link <--> router[5].ethg[0];
router[1].ethg[0] <--> generic_link <--> router[6].ethg[0];
router[1].ethg[2] <--> generic_link <--> router[7].ethg[1];
router[2].ethg[2] <--> generic_link <--> router[11].ethg[0];
router[2].ethg[1] <--> generic_link <--> router[12].ethg[0];
router[2].ethg[0] <--> generic_link <--> router[13].ethg[0];
router[3].ethg[1] <--> generic_link <--> router[11].ethg[1];
router[3].ethg[0] <--> generic_link <--> router[12].ethg[1];
router[3].ethg[2] <--> generic_link <--> router[15].ethg[0];
router[4].ethg[2] <--> generic_link <--> router[12].ethg[2];
router[4].ethg[1] <--> generic_link <--> router[15].ethg[1];
router[5].ethg[1] <--> generic_link <--> router[11].ethg[2];
router[5].ethg[2] <--> generic_link <--> router[14].ethg[0];
router[6].ethg[1] <--> generic_link <--> router[8].ethg[0];
router[6].ethg[2] <--> generic_link <--> router[10].ethg[1];
router[7].ethg[2] <--> generic_link <--> router[8].ethg[1];
router[8].ethg[2] <--> generic_link <--> router[10].ethg[2];
router[9].ethg[2] <--> generic_link <--> router[13].ethg[1];
router[9].ethg[0] <--> generic_link <--> router[14].ethg[1];
router[9].ethg[1] <--> generic_link <--> router[15].ethg[2];
router[13].ethg[2] <--> generic_link <--> router[14].ethg[2];
// Generated Router-Server Links
server[0].ethg++ <--> generic_link <--> router[0].ethg++;
server[1].ethg++ <--> generic_link <--> router[1].ethg++;
server[2].ethg++ <--> generic_link <--> router[2].ethg++;
server[3].ethg++ <--> generic_link <--> router[3].ethg++;
server[4].ethg++ <--> generic_link <--> router[4].ethg++;
server[5].ethg++ <--> generic_link <--> router[5].ethg++;
server[6].ethg++ <--> generic_link <--> router[6].ethg++;
server[7].ethg++ <--> generic_link <--> router[7].ethg++;
server[8].ethg++ <--> generic_link <--> router[8].ethg++;
server[9].ethg++ <--> generic_link <--> router[9].ethg++;
server[10].ethg++ <--> generic_link <--> router[10].ethg++;
server[11].ethg++ <--> generic_link <--> router[11].ethg++;
server[12].ethg++ <--> generic_link <--> router[12].ethg++;
server[13].ethg++ <--> generic_link <--> router[13].ethg++;
server[14].ethg++ <--> generic_link <--> router[14].ethg++;
server[15].ethg++ <--> generic_link <--> router[15].ethg++;
}