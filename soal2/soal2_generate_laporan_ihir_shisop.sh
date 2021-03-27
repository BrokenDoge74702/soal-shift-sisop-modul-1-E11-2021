#!/bin/bash

awk -F '\t' '
BEGIN{
    	Corp = 0;
    	Cons = 0;
    	Home = 0;
    	Central = 0;
    	East = 0;
    	West = 0;
    	South = 0;
}
(NR>1){
	RowID = $1;
	DateOrder = $3;
   	CustoName = $7;
    	Segment = $8;
    	City = $10;
    	Region = $13;
    	Sale = $18;
    	Profit = $21;
    
	#A
    	ProfitPercent = Profit/(Profit - Sale)*100;
    	if(ProfitPercent >= MaxProfit)
    	{
		MaxID = RowID;
		MaxProfit = ProfitPercent;
        
    	}
	#B
	if(substr($3,7) == "17" && City == "Albuquerque"){
		Nama[CustoName] = 1;
	}
	#c
	if(Segment == "Corporate"){
		Corp++;
	}
	else if(Segment == "Consumer"){
		Cons++;
	}
	else if(Segment == "Home Office"){
		Home++;
	}
	#D
	if(Region == "West"){
		West += Profit;
	}
	else if(Region == "East"){
		East += Profit;
	}
	else if(Region == "South"){
		South += Profit;
	}
	else if(Region == "Central"){
		Central+= Profit;
	}
}
END{
	#E
	printf "Transaksi terakhir dengan profit percentage terbesar yaitu " MaxID " dengan persentase " MaxProfit "%.\n\n";
	printf "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:\n";
	
	for(i in Nama){
		printf "%s\n",i;
	}
	#C
	if(Corp>Cons){
		SegCMin = "Consumer";
		MinSeg = Cons;
	}
	else if(Cons>Home){
		SegCMin = "Home Office ";
		MinSeg = Home;
	}
	else if(Home > Corp ){
		SegCMin = "Corporate";
		MinSeg = Corp;
	}

	printf "\nTipe segmen customer yang penjualannya paling sedikit adalah " SegCMin " dengan " MinSeg " transaksi.\n\n";
	
	if(West < South){
		MinReg = West;
		RegName = "West";
	}
	else if(East < Central){
		MinReg = East;
		RegName = "East";
	}
	else if (South < East){
		MinReg = South;
		RegName = "South";
	}
	else if(Central < West){
		MinReg = Central;
		RegName "Central";
	}
	
	printf "Wilayah bagian(region) yang memiliki total keuntungan (profit) paling sedikit adalah " RegName " dengan total keuntungan " MinReg "\n";
}
' Laporan-TokoShiSop.tsv > hasil.txt 

