BEGIN {
    size=1e6
    for( i=0;i<size;++i) { 
	sendTime[i]=0.0
    }
    recvdSize=0
    recvdTime=0
}

{
	# Trace line format: normal
	if ($1 == "s" || $1 == "r") {
	    #print $6
		event = $1
		time = $2
		pkt_id = $6
		pkt_size = $8
		level = $4
	
	# Trace line format: new
		
	# Store packets send time
	if (level == "AGT" && event == "s" && pkt_id<size) {
		sendTime[pkt_id] = time
	}

	# Store packets arrival time
	if (level == "AGT"  && event == "r" && pkt_id<size) {
	    recvdSize += pkt_size
	    recvdTime += time-sendTime[pkt_id]

	}
	}
}

END {
    printf("%.4f",(1.0*recvdSize)/recvdTime);
}

function abs(value) {
	if (value < 0) value = 0-value
	return value
}
