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
//
//
//module Node {
//    parameters:
//        @display("i=abstract/router_vs");
//    gates:
//        inout g[];
//    connections allowunconnected:
//}
//
//channel generic_link extends ThruputMeteringChannel {
//    parameters:
//        datarate = 1Gbps;
//        delay = 1ms;
//        thruputDisplayFormat = "";
//}
//
//channel server_switch_link extends ThruputMeteringChannel {
//    parameters:
//        datarate = 1Gbps;
//        delay = 1ms;
//        thruputDisplayFormat = "u|B";
//}
//
//channel switch_switch_link extends ThruputMeteringChannel {
//    parameters:
//        datarate = 10Gbps;
//        delay = 0ms;
//        thruputDisplayFormat = "u|B";
//}
//   
//module Server extends StandardHost {
//    parameters:
//        forwarding = true;
//    @display("i=device/pc2");
//}
//
//network Network {
//    parameters:
//	int nSwitch = default(10);
//	int nServerPorts = default(3);
//	int nSwitchPorts = default(3);
//	int nServers = nServerPorts * nSwitch;
//	
//    submodules:
//        switch[nSwitch]: EtherSwitch;
//        server[nServers]: Server;
//       	configurator: Ipv4NetworkConfigurator;
//       	util: Utils{
//       	    @Class(Utils)
//       	    parameters:
//       	        int nSwitch = nSwitch;
//       	        int nServerPorts = nServerPorts;
//       	};
//    
//    connections allowunconnected:
//        for idx = 0..nServers-1{
//            server[idx].ethg++ <--> server_switch_link <--> switch[int(idx / nServerPorts)].ethg++;
//        }
//        
////        for i=0..nSwitch-1, for j=i+1..nSwitch-1{
////                server[i].ethg++ <--> server[j].ethg++ if util.adjMatrix[i][j]; 
////		}
//
////        for i = 0..n {
////            switch[i].ethg++ <--> generic_link <--> switch[(i + 1) % 6].ethg++;
////            switch[i].ethg++ <--> generic_link <--> switch[(i + 2) % 6].ethg++;
////            switch[i].ethg++ <--> generic_link <--> switch[(i + 3) % 6].ethg++;
////        }
//}
