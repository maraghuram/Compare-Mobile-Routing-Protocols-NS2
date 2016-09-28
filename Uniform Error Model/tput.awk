BEGIN {
       recvdSize = 0
       startTime = 400
       stopTime = 0
  }
   
  {

      if($1 != "N" ) {

             event = $1
             time = $2
             node_id = $3
             pkt_size = $8
             level = $4
   
  # Store start time
  if (level == "AGT" && event == "s" ) {
    if (time < startTime) {
             startTime = time
             }
       }
   
  # Update total received packets' size and store packets arrival time
  if (level == "AGT" && event == "r" ) {
       if (time > stopTime) {
             stopTime = time
             }
       # Rip off the header
       hdr_size = 0
       pkt_size -= hdr_size
       # Store received packet's size
       recvdSize += pkt_size
       }
  }
  }
  END {
       printf("%.4f",(recvdSize/(stopTime-startTime))*(8/1000))
  }
