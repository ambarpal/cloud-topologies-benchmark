## Benchmarking Cloud Computing Topologies

This is the repository for our course project for the Cloud Computing course JHU CS 601.619 Fall 20. This repository is maintained by @ambarpal and  @akrishn94

The following steps create the jellyfish topology for switches:
1. Set `nSwitch` and `nServerPorts` identically in `generate_jellyfish_topology.py` and `RandomGraphPython.ned`.
2. Run `python generate_jellyfish_topology.py` to generate the random graph topology. 
3. Paste the generated topology at the location marked `PASTE HERE FOR SWITCH CONFIG` in `RandomGraphPython.ned`.
4. Run `randomgraph.ini` and select the `JellyFishSwitch` configuration.

The following steps create the jellyfish topology for routers:
1. Set `nRouter` and `nRouterPorts` identically in `generate_jellyfish_router.py` and `RandomGraphPython.ned`.
2. Run `python generate_jellyfish_router.py` to generate the random graph topology. 
3. Paste the generated topology at the location marked `PASTE HERE FOR ROUTER CONFIG` in `RandomGraphPython.ned`.
4. Run `randomgraph.ini` and select the `JellyFishRouter` configuration.

The following steps create the FatTree topology:
1. Run `basic_fat_tree.ini`.