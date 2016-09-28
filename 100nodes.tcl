# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
#set val(ifq)    CMUPriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     100                        ;# number of mobilenodes
#set val(rp)     DSR                       ;# routing protocol
set val(x)      1462                      ;# X dimension of topography
set val(y)      520                      ;# Y dimension of topography
set val(stop)   100.0                         ;# time of simulation end


set val(energymodel)	EnergyModel
set val(initialenergy)	100

set val(rp) [lindex $argv 0]
set val(errormodel) [lindex $argv 1]
set val(errorrate) [lindex $argv 2]

if { $val(rp) == "DSR" } {
set val(ifq)            CMUPriQueue
} else {
set val(ifq)            Queue/DropTail/PriQueue
}

set traceFileName $argv.tr

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open $traceFileName w]
$ns trace-all $tracefile

#Open the NAM trace file
#set namfile [open out.nam w]
#$ns namtrace-all $namfile
#$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

#===================================
#     Mobile node parameter setup
#===================================
proc UniformErr {} {
                global val
                set err [new ErrorModel]
                $err unit packet
                $err set rate_ $val(errorrate)
                return $err
        }

proc TwoStateMarkovErr {} {
    global val
    set tmp0 [new ErrorModel/Uniform 0 pkt]
    set tmp1 [new ErrorModel/Uniform $val(errorrate) pkt]
    
    # Array of states (error models)
    set m_states [list $tmp0 $tmp1]
    # Durations for each of the states, tmp, tmp1 and tmp2, respectively
    set m_periods [list 0.1 .075 ]
    # Transition state model matrix
    set m_transmx { {0.9   0.1 }
	          {0.7   0.3 } }
    set m_trunit byte
    # Use time-based transition
    set m_sttype time
    set m_nstates 2
    set m_nstart [lindex $m_states 0]
    
    set em [new ErrorModel/MultiState $m_states $m_periods $m_transmx \
                $m_trunit $m_sttype $m_nstates $m_nstart]
    return $em
}


$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON \
                 -energyModel $val(energymodel) \
             -initialEnergy $val(initialenergy) \
             -rxPower 35.28e-3 \
             -txPower 31.32e-3 \
             -idlePower 712e-6 \
             -sleepPower 144e-9 \
             -IncomingErrProc $val(errormodel)



for {set i 0} {$i < $val(nn) } { incr i } {
    set node_($i) [$ns node]
    $node_($i) set X_ [ expr 10+round(rand()*1400) ]
    $node_($i) set Y_ [ expr 10+round(rand()*4000) ]
    $node_($i) set Z_ 0.0
    $ns initial_node_pos $node_($i) 20
}

for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at [ expr 15+round(rand()*60) ] "$node_($i) setdest [ expr 10+round(rand()*480) ] [ expr 10+round(rand()*380) ] [ expr 2+round(rand()*15) ]"
    
}

 

#===================================
#        Agents Definition        
#===================================
#
# nodes: 100, max conn: 30, send rate: 0.25, seed: 123.9
#
#
# 2 connecting to 3 at time 150.94958439979217
#
set udp_(0) [new Agent/UDP]
$ns attach-agent $node_(2) $udp_(0)
set null_(0) [new Agent/Null]
$ns attach-agent $node_(3) $null_(0)
set cbr_(0) [new Application/Traffic/CBR]
$cbr_(0) set packetSize_ 512
$cbr_(0) set interval_ 0.25
$cbr_(0) set random_ 1
$cbr_(0) set maxpkts_ 10000
$cbr_(0) attach-agent $udp_(0)
$ns connect $udp_(0) $null_(0)
$ns at 150.94958439979217 "$cbr_(0) start"
#
# 7 connecting to 8 at time 104.41353926640635
#
set udp_(1) [new Agent/UDP]
$ns attach-agent $node_(7) $udp_(1)
set null_(1) [new Agent/Null]
$ns attach-agent $node_(8) $null_(1)
set cbr_(1) [new Application/Traffic/CBR]
$cbr_(1) set packetSize_ 512
$cbr_(1) set interval_ 0.25
$cbr_(1) set random_ 1
$cbr_(1) set maxpkts_ 10000
$cbr_(1) attach-agent $udp_(1)
$ns connect $udp_(1) $null_(1)
$ns at 104.41353926640635 "$cbr_(1) start"
#
# 7 connecting to 9 at time 3.0008520944979287
#
set udp_(2) [new Agent/UDP]
$ns attach-agent $node_(7) $udp_(2)
set null_(2) [new Agent/Null]
$ns attach-agent $node_(9) $null_(2)
set cbr_(2) [new Application/Traffic/CBR]
$cbr_(2) set packetSize_ 512
$cbr_(2) set interval_ 0.25
$cbr_(2) set random_ 1
$cbr_(2) set maxpkts_ 10000
$cbr_(2) attach-agent $udp_(2)
$ns connect $udp_(2) $null_(2)
$ns at 3.0008520944979287 "$cbr_(2) start"
#
# 8 connecting to 9 at time 34.091995076319201
#
set udp_(3) [new Agent/UDP]
$ns attach-agent $node_(8) $udp_(3)
set null_(3) [new Agent/Null]
$ns attach-agent $node_(9) $null_(3)
set cbr_(3) [new Application/Traffic/CBR]
$cbr_(3) set packetSize_ 512
$cbr_(3) set interval_ 0.25
$cbr_(3) set random_ 1
$cbr_(3) set maxpkts_ 10000
$cbr_(3) attach-agent $udp_(3)
$ns connect $udp_(3) $null_(3)
$ns at 34.091995076319201 "$cbr_(3) start"
#
# 8 connecting to 10 at time 47.367118460762839
#
set udp_(4) [new Agent/UDP]
$ns attach-agent $node_(8) $udp_(4)
set null_(4) [new Agent/Null]
$ns attach-agent $node_(10) $null_(4)
set cbr_(4) [new Application/Traffic/CBR]
$cbr_(4) set packetSize_ 512
$cbr_(4) set interval_ 0.25
$cbr_(4) set random_ 1
$cbr_(4) set maxpkts_ 10000
$cbr_(4) attach-agent $udp_(4)
$ns connect $udp_(4) $null_(4)
$ns at 47.367118460762839 "$cbr_(4) start"
#
# 9 connecting to 10 at time 179.61023429390519
#
set udp_(5) [new Agent/UDP]
$ns attach-agent $node_(9) $udp_(5)
set null_(5) [new Agent/Null]
$ns attach-agent $node_(10) $null_(5)
set cbr_(5) [new Application/Traffic/CBR]
$cbr_(5) set packetSize_ 512
$cbr_(5) set interval_ 0.25
$cbr_(5) set random_ 1
$cbr_(5) set maxpkts_ 10000
$cbr_(5) attach-agent $udp_(5)
$ns connect $udp_(5) $null_(5)
$ns at 179.61023429390519 "$cbr_(5) start"
#
# 10 connecting to 11 at time 19.745908714712556
#
set udp_(6) [new Agent/UDP]
$ns attach-agent $node_(10) $udp_(6)
set null_(6) [new Agent/Null]
$ns attach-agent $node_(11) $null_(6)
set cbr_(6) [new Application/Traffic/CBR]
$cbr_(6) set packetSize_ 512
$cbr_(6) set interval_ 0.25
$cbr_(6) set random_ 1
$cbr_(6) set maxpkts_ 10000
$cbr_(6) attach-agent $udp_(6)
$ns connect $udp_(6) $null_(6)
$ns at 19.745908714712556 "$cbr_(6) start"
#
# 11 connecting to 12 at time 104.23329121630327
#
set udp_(7) [new Agent/UDP]
$ns attach-agent $node_(11) $udp_(7)
set null_(7) [new Agent/Null]
$ns attach-agent $node_(12) $null_(7)
set cbr_(7) [new Application/Traffic/CBR]
$cbr_(7) set packetSize_ 512
$cbr_(7) set interval_ 0.25
$cbr_(7) set random_ 1
$cbr_(7) set maxpkts_ 10000
$cbr_(7) attach-agent $udp_(7)
$ns connect $udp_(7) $null_(7)
$ns at 104.23329121630327 "$cbr_(7) start"
#
# 13 connecting to 14 at time 134.04061622640148
#
set udp_(8) [new Agent/UDP]
$ns attach-agent $node_(13) $udp_(8)
set null_(8) [new Agent/Null]
$ns attach-agent $node_(14) $null_(8)
set cbr_(8) [new Application/Traffic/CBR]
$cbr_(8) set packetSize_ 512
$cbr_(8) set interval_ 0.25
$cbr_(8) set random_ 1
$cbr_(8) set maxpkts_ 10000
$cbr_(8) attach-agent $udp_(8)
$ns connect $udp_(8) $null_(8)
$ns at 134.04061622640148 "$cbr_(8) start"
#
# 13 connecting to 15 at time 48.288532946393147
#
set udp_(9) [new Agent/UDP]
$ns attach-agent $node_(13) $udp_(9)
set null_(9) [new Agent/Null]
$ns attach-agent $node_(15) $null_(9)
set cbr_(9) [new Application/Traffic/CBR]
$cbr_(9) set packetSize_ 512
$cbr_(9) set interval_ 0.25
$cbr_(9) set random_ 1
$cbr_(9) set maxpkts_ 10000
$cbr_(9) attach-agent $udp_(9)
$ns connect $udp_(9) $null_(9)
$ns at 48.288532946393147 "$cbr_(9) start"
#
# 14 connecting to 15 at time 59.791650166638036
#
set udp_(10) [new Agent/UDP]
$ns attach-agent $node_(14) $udp_(10)
set null_(10) [new Agent/Null]
$ns attach-agent $node_(15) $null_(10)
set cbr_(10) [new Application/Traffic/CBR]
$cbr_(10) set packetSize_ 512
$cbr_(10) set interval_ 0.25
$cbr_(10) set random_ 1
$cbr_(10) set maxpkts_ 10000
$cbr_(10) attach-agent $udp_(10)
$ns connect $udp_(10) $null_(10)
$ns at 59.791650166638036 "$cbr_(10) start"
#
# 14 connecting to 16 at time 27.667579104969082
#
set udp_(11) [new Agent/UDP]
$ns attach-agent $node_(14) $udp_(11)
set null_(11) [new Agent/Null]
$ns attach-agent $node_(16) $null_(11)
set cbr_(11) [new Application/Traffic/CBR]
$cbr_(11) set packetSize_ 512
$cbr_(11) set interval_ 0.25
$cbr_(11) set random_ 1
$cbr_(11) set maxpkts_ 10000
$cbr_(11) attach-agent $udp_(11)
$ns connect $udp_(11) $null_(11)
$ns at 27.667579104969082 "$cbr_(11) start"
#
# 17 connecting to 18 at time 120.66138298281533
#
set udp_(12) [new Agent/UDP]
$ns attach-agent $node_(17) $udp_(12)
set null_(12) [new Agent/Null]
$ns attach-agent $node_(18) $null_(12)
set cbr_(12) [new Application/Traffic/CBR]
$cbr_(12) set packetSize_ 512
$cbr_(12) set interval_ 0.25
$cbr_(12) set random_ 1
$cbr_(12) set maxpkts_ 10000
$cbr_(12) attach-agent $udp_(12)
$ns connect $udp_(12) $null_(12)
$ns at 120.66138298281533 "$cbr_(12) start"
#
# 18 connecting to 19 at time 56.45341029225542
#
set udp_(13) [new Agent/UDP]
$ns attach-agent $node_(18) $udp_(13)
set null_(13) [new Agent/Null]
$ns attach-agent $node_(19) $null_(13)
set cbr_(13) [new Application/Traffic/CBR]
$cbr_(13) set packetSize_ 512
$cbr_(13) set interval_ 0.25
$cbr_(13) set random_ 1
$cbr_(13) set maxpkts_ 10000
$cbr_(13) attach-agent $udp_(13)
$ns connect $udp_(13) $null_(13)
$ns at 56.45341029225542 "$cbr_(13) start"
#
# 19 connecting to 20 at time 55.407279457620938
#
set udp_(14) [new Agent/UDP]
$ns attach-agent $node_(19) $udp_(14)
set null_(14) [new Agent/Null]
$ns attach-agent $node_(20) $null_(14)
set cbr_(14) [new Application/Traffic/CBR]
$cbr_(14) set packetSize_ 512
$cbr_(14) set interval_ 0.25
$cbr_(14) set random_ 1
$cbr_(14) set maxpkts_ 10000
$cbr_(14) attach-agent $udp_(14)
$ns connect $udp_(14) $null_(14)
$ns at 55.407279457620938 "$cbr_(14) start"
#
# 19 connecting to 21 at time 158.09652168215089
#
set udp_(15) [new Agent/UDP]
$ns attach-agent $node_(19) $udp_(15)
set null_(15) [new Agent/Null]
$ns attach-agent $node_(21) $null_(15)
set cbr_(15) [new Application/Traffic/CBR]
$cbr_(15) set packetSize_ 512
$cbr_(15) set interval_ 0.25
$cbr_(15) set random_ 1
$cbr_(15) set maxpkts_ 10000
$cbr_(15) attach-agent $udp_(15)
$ns connect $udp_(15) $null_(15)
$ns at 158.09652168215089 "$cbr_(15) start"
#
# 21 connecting to 22 at time 8.1838916093967349
#
set udp_(16) [new Agent/UDP]
$ns attach-agent $node_(21) $udp_(16)
set null_(16) [new Agent/Null]
$ns attach-agent $node_(22) $null_(16)
set cbr_(16) [new Application/Traffic/CBR]
$cbr_(16) set packetSize_ 512
$cbr_(16) set interval_ 0.25
$cbr_(16) set random_ 1
$cbr_(16) set maxpkts_ 10000
$cbr_(16) attach-agent $udp_(16)
$ns connect $udp_(16) $null_(16)
$ns at 8.1838916093967349 "$cbr_(16) start"
#
# 24 connecting to 25 at time 140.3296774534181
#
set udp_(17) [new Agent/UDP]
$ns attach-agent $node_(24) $udp_(17)
set null_(17) [new Agent/Null]
$ns attach-agent $node_(25) $null_(17)
set cbr_(17) [new Application/Traffic/CBR]
$cbr_(17) set packetSize_ 512
$cbr_(17) set interval_ 0.25
$cbr_(17) set random_ 1
$cbr_(17) set maxpkts_ 10000
$cbr_(17) attach-agent $udp_(17)
$ns connect $udp_(17) $null_(17)
$ns at 140.3296774534181 "$cbr_(17) start"
#
# 31 connecting to 32 at time 168.54647095713133
#
set udp_(18) [new Agent/UDP]
$ns attach-agent $node_(31) $udp_(18)
set null_(18) [new Agent/Null]
$ns attach-agent $node_(32) $null_(18)
set cbr_(18) [new Application/Traffic/CBR]
$cbr_(18) set packetSize_ 512
$cbr_(18) set interval_ 0.25
$cbr_(18) set random_ 1
$cbr_(18) set maxpkts_ 10000
$cbr_(18) attach-agent $udp_(18)
$ns connect $udp_(18) $null_(18)
$ns at 168.54647095713133 "$cbr_(18) start"
#
# 33 connecting to 34 at time 36.680332057494823
#
set udp_(19) [new Agent/UDP]
$ns attach-agent $node_(33) $udp_(19)
set null_(19) [new Agent/Null]
$ns attach-agent $node_(34) $null_(19)
set cbr_(19) [new Application/Traffic/CBR]
$cbr_(19) set packetSize_ 512
$cbr_(19) set interval_ 0.25
$cbr_(19) set random_ 1
$cbr_(19) set maxpkts_ 10000
$cbr_(19) attach-agent $udp_(19)
$ns connect $udp_(19) $null_(19)
$ns at 36.680332057494823 "$cbr_(19) start"
#
# 33 connecting to 35 at time 44.095333164602209
#
set udp_(20) [new Agent/UDP]
$ns attach-agent $node_(33) $udp_(20)
set null_(20) [new Agent/Null]
$ns attach-agent $node_(35) $null_(20)
set cbr_(20) [new Application/Traffic/CBR]
$cbr_(20) set packetSize_ 512
$cbr_(20) set interval_ 0.25
$cbr_(20) set random_ 1
$cbr_(20) set maxpkts_ 10000
$cbr_(20) attach-agent $udp_(20)
$ns connect $udp_(20) $null_(20)
$ns at 44.095333164602209 "$cbr_(20) start"
#
# 37 connecting to 38 at time 99.554667761341989
#
set udp_(21) [new Agent/UDP]
$ns attach-agent $node_(37) $udp_(21)
set null_(21) [new Agent/Null]
$ns attach-agent $node_(38) $null_(21)
set cbr_(21) [new Application/Traffic/CBR]
$cbr_(21) set packetSize_ 512
$cbr_(21) set interval_ 0.25
$cbr_(21) set random_ 1
$cbr_(21) set maxpkts_ 10000
$cbr_(21) attach-agent $udp_(21)
$ns connect $udp_(21) $null_(21)
$ns at 99.554667761341989 "$cbr_(21) start"
#
# 37 connecting to 39 at time 82.478167806974682
#
set udp_(22) [new Agent/UDP]
$ns attach-agent $node_(37) $udp_(22)
set null_(22) [new Agent/Null]
$ns attach-agent $node_(39) $null_(22)
set cbr_(22) [new Application/Traffic/CBR]
$cbr_(22) set packetSize_ 512
$cbr_(22) set interval_ 0.25
$cbr_(22) set random_ 1
$cbr_(22) set maxpkts_ 10000
$cbr_(22) attach-agent $udp_(22)
$ns connect $udp_(22) $null_(22)
$ns at 82.478167806974682 "$cbr_(22) start"
#
# 41 connecting to 42 at time 8.7437392066902202
#
set udp_(23) [new Agent/UDP]
$ns attach-agent $node_(41) $udp_(23)
set null_(23) [new Agent/Null]
$ns attach-agent $node_(42) $null_(23)
set cbr_(23) [new Application/Traffic/CBR]
$cbr_(23) set packetSize_ 512
$cbr_(23) set interval_ 0.25
$cbr_(23) set random_ 1
$cbr_(23) set maxpkts_ 10000
$cbr_(23) attach-agent $udp_(23)
$ns connect $udp_(23) $null_(23)
$ns at 8.7437392066902202 "$cbr_(23) start"
#
# 41 connecting to 43 at time 42.559560464024344
#
set udp_(24) [new Agent/UDP]
$ns attach-agent $node_(41) $udp_(24)
set null_(24) [new Agent/Null]
$ns attach-agent $node_(43) $null_(24)
set cbr_(24) [new Application/Traffic/CBR]
$cbr_(24) set packetSize_ 512
$cbr_(24) set interval_ 0.25
$cbr_(24) set random_ 1
$cbr_(24) set maxpkts_ 10000
$cbr_(24) attach-agent $udp_(24)
$ns connect $udp_(24) $null_(24)
$ns at 42.559560464024344 "$cbr_(24) start"
#
# 45 connecting to 46 at time 74.902350164438772
#
set udp_(25) [new Agent/UDP]
$ns attach-agent $node_(45) $udp_(25)
set null_(25) [new Agent/Null]
$ns attach-agent $node_(46) $null_(25)
set cbr_(25) [new Application/Traffic/CBR]
$cbr_(25) set packetSize_ 512
$cbr_(25) set interval_ 0.25
$cbr_(25) set random_ 1
$cbr_(25) set maxpkts_ 10000
$cbr_(25) attach-agent $udp_(25)
$ns connect $udp_(25) $null_(25)
$ns at 74.902350164438772 "$cbr_(25) start"
#
# 46 connecting to 47 at time 152.69143960098336
#
set udp_(26) [new Agent/UDP]
$ns attach-agent $node_(46) $udp_(26)
set null_(26) [new Agent/Null]
$ns attach-agent $node_(47) $null_(26)
set cbr_(26) [new Application/Traffic/CBR]
$cbr_(26) set packetSize_ 512
$cbr_(26) set interval_ 0.25
$cbr_(26) set random_ 1
$cbr_(26) set maxpkts_ 10000
$cbr_(26) attach-agent $udp_(26)
$ns connect $udp_(26) $null_(26)
$ns at 152.69143960098336 "$cbr_(26) start"
#
# 46 connecting to 48 at time 30.748249632654829
#
set udp_(27) [new Agent/UDP]
$ns attach-agent $node_(46) $udp_(27)
set null_(27) [new Agent/Null]
$ns attach-agent $node_(48) $null_(27)
set cbr_(27) [new Application/Traffic/CBR]
$cbr_(27) set packetSize_ 512
$cbr_(27) set interval_ 0.25
$cbr_(27) set random_ 1
$cbr_(27) set maxpkts_ 10000
$cbr_(27) attach-agent $udp_(27)
$ns connect $udp_(27) $null_(27)
$ns at 30.748249632654829 "$cbr_(27) start"
#
# 48 connecting to 49 at time 104.57617148970074
#
set udp_(28) [new Agent/UDP]
$ns attach-agent $node_(48) $udp_(28)
set null_(28) [new Agent/Null]
$ns attach-agent $node_(49) $null_(28)
set cbr_(28) [new Application/Traffic/CBR]
$cbr_(28) set packetSize_ 512
$cbr_(28) set interval_ 0.25
$cbr_(28) set random_ 1
$cbr_(28) set maxpkts_ 10000
$cbr_(28) attach-agent $udp_(28)
$ns connect $udp_(28) $null_(28)
$ns at 104.57617148970074 "$cbr_(28) start"
#
# 50 connecting to 51 at time 116.53220794933485
#
set udp_(29) [new Agent/UDP]
$ns attach-agent $node_(50) $udp_(29)
set null_(29) [new Agent/Null]
$ns attach-agent $node_(51) $null_(29)
set cbr_(29) [new Application/Traffic/CBR]
$cbr_(29) set packetSize_ 512
$cbr_(29) set interval_ 0.25
$cbr_(29) set random_ 1
$cbr_(29) set maxpkts_ 10000
$cbr_(29) attach-agent $udp_(29)
$ns connect $udp_(29) $null_(29)
$ns at 116.53220794933485 "$cbr_(29) start"
#
#Total sources/connections: 21/30
#
#===================================
#        Applications Definition        
#===================================

#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile
    $ns flush-trace
    close $tracefile
    #exec nam out.nam &
    exit 0
}

for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset"
}
#$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
