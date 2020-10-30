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

//
// TODO auto-generated type
//
import inet.applications.tcpapp.TcpEchoApp;
import inet.applications.tcpapp.TcpEchoAppThread;
import inet.common.misc.NetAnimTrace;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.networklayer.configurator.ipv4.Ipv4FlatNetworkConfigurator;
import inet.node.ethernet.EtherSwitch;
import inet.node.inet.StandardHost;
import ned.DatarateChannel;

network Basic_fat_tree
{
    parameters:
        int k = 4; //k-ary fat-tree 

        int num_edgeSwitches_perPod = (k/2);
        int num_aggSwitches_perPod = (k/2);
        int num_servers_perEdge = k/2;

        int total_num_aggSwitches = k*num_aggSwitches_perPod;
        int total_num_edgeSwitches = k*num_edgeSwitches_perPod;
        int total_num_servers = num_servers_perEdge*total_num_edgeSwitches;
        int total_num_coreSwitches = pow(k/2, 2);

        int num_switchGates = k; //All switches have k-gates.

        @display("bgb=738,422");
    types: // Have to update datarate and delay!
        channel ServerEdgeChannel extends DatarateChannel
        {
            datarate = 10Gbps;
            delay = 1us;
        }

        channel EdgeAggChannel extends DatarateChannel
        {
             datarate = 10Gbps;
            delay = 1us;
        }
        channel AggCoreChannel extends DatarateChannel
        {
             datarate = 10Gbps;
            delay = 1us;
        }
    submodules:
        configurator: Ipv4NetworkConfigurator;
        servers[total_num_servers]: StandardHost {
            parameters:
                @display("i=device/pc2");
        }

        edgeSwitches[total_num_edgeSwitches]: EtherSwitch {
            gates:
                ethg[num_switchGates]; // first num_servers_perEdge gates used for hosts
        }

        aggSwitches[total_num_aggSwitches]: EtherSwitch {
            gates:
                ethg[num_switchGates]; // first num_aggSwitches_perPod gates used for edge connections
        }

        coreSwitches[total_num_coreSwitches]: EtherSwitch {
            gates:
                ethg[num_switchGates];
        }

    connections allowunconnected:
        //Server edge connections
        for pod=0..k-1, for edge=0..num_edgeSwitches_perPod-1, for host=0..num_servers_perEdge-1 {
            edgeSwitches[pod*num_edgeSwitches_perPod + edge].ethg[host] <--> ServerEdgeChannel 
            <--> servers[pod*num_edgeSwitches_perPod*num_servers_perEdge + edge*num_servers_perEdge + host].ethg++;
        }

        //Edge Agg connections 
        for pod=0..k-1, for edge=0..num_edgeSwitches_perPod-1, for agg=0..aggSwitches_perPod-1 {
            edgeSwitches[pod*num_edgeSwitches_perPod + edge].ethg[num_servers_perEdge + agg] <--> EdgeAggChannel 
            <--> aggSwitches[pod*num_aggSwitches_perPod + agg].ethg[edge];
        }
		
		//Agg Core connections
		for pod=0..k-1, for agg=0..num_aggSwitches_perPod-1, for c = 0..num_switchGates-1 {
		    aggSwitches[pod*num_aggSwitches_perPod + agg].ethg[num_edgeSwitches_perPod + c] <--> AggCoreChannel
		    <--> coreSwitches[agg*(k/2) + c].ethg[pod];
		}
}
