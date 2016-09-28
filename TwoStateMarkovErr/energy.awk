BEGIN {
    
    size=100;
    initEnergy=100;
    energy_left[size] = initenergy;			
    i=0;
    #total_energy_consumed = 0.000000;
    total=0;
    n=0;
}

{
    state		= 	$1;
    time 		= 	$3;
    
# For energy consumption statistics see trace file
    node_num	= 	$5;
    energy_level 	= 	$7;
    
    
# To Calculate Average Energy Consumption
    
    if(state == "N") {
	energy_left[node_num]=energy_level;
	
    }
}    
END {
    for(i=0;i<size;i++) {
	total=total+energy_left[i];
    }
    printf("%.4f", total/size);
    

}
