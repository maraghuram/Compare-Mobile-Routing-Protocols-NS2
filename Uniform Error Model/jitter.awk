BEGIN {
    maxPktId=0
    size=1e6
    for( i=0;i<size;++i) { 
	sendTime[i]=recvTime[i]=0.0
    }

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
		pkt_seqmo[pkt_id] = pkt_
	}

	# Store packets arrival time
	if (level == "AGT"  && event == "r" && pkt_id<size) {
	        recvTime[pkt_id] = time
		if(pkt_id>maxPktId){
		    maxPktId=pkt_id
		}

	}
	}
}

END {


    jitter1 = jitter2 = tmp_recv = 0
    prev_time = delay = prev_delay = processed = 0
    prev_delay = -1
    for (i=0; processed<maxPktId; i++) {
	if(recvTime[i] != 0) {
	    tmp_recv++
	    if(prev_time != 0) {
		delay = recvTime[i] - prev_time
		e2eDelay = recvTime[i] - sendTime[i]
		if(delay < 0) delay = 0
		if(prev_delay != -1) {
		    jitter1 += abs(e2eDelay - prev_e2eDelay)
		    jitter2 += abs(delay-prev_delay)
		}
		prev_delay = delay
		prev_e2eDelay = e2eDelay
	    }
	    prev_time = recvTime[i]
	}
	processed++
    }
    printf("%.4f",jitter1*1000/tmp_recv);
}

function abs(value) {
	if (value < 0) value = 0-value
	return value
}
