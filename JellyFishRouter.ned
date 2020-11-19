////
//// This program is free software: you can redistribute it and/or modify
//// it under the terms of the GNU Lesser General Public License as published by
//// the Free Software Foundation, either version 3 of the License, or
//// (at your option) any later version.
//// 
//// This program is distributed in the hope that it will be useful,
//// but WITHOUT ANY WARRANTY; without even the implied warranty of
//// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//// GNU Lesser General Public License for more details.
//// 
//// You should have received a copy of the GNU Lesser General Public License
//// along with this program.  If not, see http://www.gnu.org/licenses/.
//// 
//import inet.applications.tcpapp.TcpEchoApp;
//import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
//import inet.node.inet.StandardHost;
//import ned.DatarateChannel;
//import inet.common.misc.ThruputMeteringChannel;
//import inet.node.ethernet.EtherSwitch;
//import inet.linklayer.ieee8021d.stp.Stp;
//import inet.visualizer.integrated.IntegratedCanvasVisualizer;
//import inet.networklayer.node.Router;
//
//network JellyFishRouter
//{
//    parameters:
//	int nSwitch = default(10);
//	int nServerPorts = default(2);
//	int nSwitchPorts = default(3);
//	int nServers = nServerPorts * nSwitch;
//	
//    submodules:
//        switch[nSwitch]: EtherSwitch;
//        server[nServers]: Server;
//       	configurator: Ipv4NetworkConfigurator;
//       	router[nSwitch]: Router;
////       	spanningTree: Stp;
////       	visualizer: IntegratedCanvasVisualizer {
////            @display("p=98.8575,209.81999");
////        }
//    
//    connections allowunconnected:
//        for idx = 0..nServers-1{
//            server[idx].ethg++ <--> server_switch_link <--> switch[int(idx / nServerPorts)].ethg++;
//        }
//
//        for idx = 0..nSwitch-1{
//            switch[idx].ethg++ <--> generic_link <--> router[idx].ethg++;
//        }
//        
//        // Run generate_jellyfish_topology.py
//        router[0].ethg++ <--> generic_link <--> router[1].ethg++;
//        router[0].ethg++ <--> generic_link <--> router[4].ethg++;
//        router[0].ethg++ <--> generic_link <--> router[8].ethg++;
//        router[1].ethg++ <--> generic_link <--> router[4].ethg++;
//        router[1].ethg++ <--> generic_link <--> router[9].ethg++;
//        router[2].ethg++ <--> generic_link <--> router[3].ethg++;
//        router[2].ethg++ <--> generic_link <--> router[7].ethg++;
//        router[2].ethg++ <--> generic_link <--> router[9].ethg++;
//        router[3].ethg++ <--> generic_link <--> router[5].ethg++;
//        router[3].ethg++ <--> generic_link <--> router[7].ethg++;
//        router[4].ethg++ <--> generic_link <--> router[7].ethg++;
//        router[5].ethg++ <--> generic_link <--> router[6].ethg++;
//        router[5].ethg++ <--> generic_link <--> router[8].ethg++;
//        router[6].ethg++ <--> generic_link <--> router[8].ethg++;
//        router[6].ethg++ <--> generic_link <--> router[9].ethg++;
//
//}
