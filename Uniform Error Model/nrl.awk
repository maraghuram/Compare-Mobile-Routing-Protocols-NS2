BEGIN {
       recvdNum = 0
       sendNum = 0
  }
   
  {

      if($1 != "N" ) {

             event = $1
             time = $2
             node_id = $3
             pkt_size = $8
             level = $4
   
  # Store start time
	     if (level == "RTR" && event == "s" ) {
		 sendNum += 1
	     }
   
  # Update total received packets' size and store packets arrival time
	     if (level == "RTR" && event == "r" ) {
		 recvdNum += 1
	     }
      }
  }
  END {
      printf("%.4f",(1.0*recvdNum)/sendNum)
  }
