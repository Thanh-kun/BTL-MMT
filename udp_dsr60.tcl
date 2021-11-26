# Network and Communication, ICTU, 08/2017
# dsr.tcl
# A 30-node example for ad-hoc simulation with DSR
# Define options_
set val(chan) Channel/WirelessChannel ;    # channel type
set val(prop) Propagation/TwoRayGround ;   # radio-propagation model
set val(netif) Phy/WirelessPhy ;           # network interface type
set val(mac) Mac/802_11 ;                  # MAC type
set val(ifq) CMUPriQueue ;     		# interface queue type:Queue/DropTail/PriQueue if routing protocol is not DSR
set val(ll) LL ;                           # link layer type
set val(ant) Antenna/OmniAntenna ;         # antenna model
set val(ifqlen) 50 ;                       # max packet in ifq
set val(nn) 60 ;                          # number of mobilenodes
set val(rp) DSR ;                         # routing protocol
set val(x) 500 ;			   # X dimens_ion of topography
set val(y) 500 ;			   # Y dimens_ion of topography
set val(stop) 200 ;			   # time of simulation end
set val(cp)		"hc60cbr.tcl";
set val(sc)		"node60.tcl";

set ns_ [new Simulator]
set tracefd [open udp_dsrhc60.tr w]

$ns_ trace-all $tracefd

set namtrace [open udp_dsrhc60.nam w]

$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

# Create God
set god_ [create-god $val(nn)]

#

#
# configure the nodes
$ns_ node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace ON

for {set i 0} {$i < $val(nn) } { incr i } {
set node_($i) [$ns_ node]
# Bring Nodes to God's Attention
    $god_ new_node $node_($i)
}
source $val(sc)

source $val(cp)

# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
$ns_ at $val(stop) "$node_($i) reset";
}
# ending the simulation
$ns_ at $val(stop) "stop"
$ns_ at 200.1 "puts \"end simulation\" ; $ns_ halt"
proc stop {} {
global ns_ tracefd namtrace
$ns_ flush-trace
close $tracefd
close $namtrace
}
$ns_ run
