#!/bin/bash
#########################################
progress_1 ( ) {
	b=''
	i=0
	while [ $i -le  100 ]
    	do
		    printf "$1:[%-50s]%d%%\r" $b $i
			    sleep 0.06
				    i=`expr 2 + $i`        
					    b=#$b
					done
					echo
			}
#progress_1 soft_name
progress_2 ( ) {
for ((i=1;i<=100;i++))
	do
		sleep 0.05
		echo $i |dialog --title "Copy" --gauge "files" 6 70 0
	done
               }
#progress_2 
progress_3 ( ) {
i=0
while [ $i -lt 100 ]
   do
	   for j in '-' '\\' '|' '/'
	        do
	              printf "intel testing : %s\r" $j
	                sleep 0.1
	                ((i++))
	         done
		done
	            }
#progress_3 
#########################################
progress_1 intall  apache
#progress_2  apache
#progress_3
