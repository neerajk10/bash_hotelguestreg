#!/bin/bash
clear
touch Guest.txt #creating the DB file if it does not exist

AutoNumber()
{
            local gno=0
	    
            for j in `cat Guest.txt`
            do
                        gno=$(echo "$j" | cut -d "," -f 1)
            done
            if [ $gno -ne 0 ]
            then
                        gno=`expr $gno + 1`
            else
                        gno=1
            fi
            echo $gno
}

Insert()
{
            clear
            #autoselect the Sr. no
            gno=$( AutoNumber )
	    field_error=0
            echo "Sr. number: $gno"

            #name field
            echo "Enter guest Name: \c"
	    read guest_name
	    re_name='[0-9!@#\$%\^&*()]' #to check presence of number or special characters in name
	    if [[ "$guest_name" =~ $re_name ]]
	    then
		field_error=1
	    else 
            	no_of_chars=`echo -n $guest_name | wc -c` 
	    	test $no_of_chars -le 5 && field_error=1 	    
	    fi
	    #phone field
	    echo "Enter guest Phone Number: \c"
            read guest_phone          
	        	    
            re_phone='^[0-9]+$'
            temp_phone=$guest_phone #divide operations will be performed on this
            i=0 #count of digits
            if [[ "$guest_phone" =~ "$re_phone" ]]; #checking
            then
		no_of_digits=`echo -n $guest_phone | wc -c`	
                test $no_of_digits -le 9 && field_error=2 #if phone is not 10 digit
            fi

            #count of guests field
            echo "Number of guests : \c"
            read guest_count
            if [[ $guest_count  =~ ^[0-9]+$ ]] #checking if guest_count is numerical
            then
                   if [ $(($guest_count/10)) -ne 0 ]
                    then
                        field_error=3 #if count is not one digit
                    fi
            fi

            #suite field
            echo "Choose Suite type: \c"
            echo
            echo "1. Regular "
            echo "2. Semi-Deluxe"
            echo "3. Deluxe"
            echo "4. VIP"

            read suite_choice
            case $suite_choice in
                    1) guest_suite=Regular ;;
                    2) guest_suite=Semi_Deluxe ;;
                    3) guest_suite=Deluxe ;;
                    4) guest_suite=VIP ;;
                    *) echo "wrong choice";;
            esac
	    
	    echo "Enter room number "  
	    read guest_room
	    re_room='^[0-9]+$'          #checking for numeric value
	    if [[ "$guest_room" =~ $re_room ]]
	    then
		no_of_digits=`echo -n $guest_room | wc -c`
	    	test $no_of_digits -le 2 && field_error=21
		test $no_of_digits -ge 5 && field_error=21 #room should be 3 or 4 digit number only
	    else
		field_error=21
	    fi


            #check in time field
            echo "Check-in Time : DATE/TIME -> XX-XX-XXXX/X:XXam/pm"
            read guest_check_in
            re_guestcheckin='^[0-9][0-9](-)[0-9][0-9](-)[0-9][0-9][0-9][0-9]\/[0-9][0-9]:[0-9][0-9][aAPp][Mm]$'
            if [[ $guest_check_in =~ $re_guestcheckin ]]
            then
                echo #do nothing
            else
                field_error=4 #wrong value of check-in time
	    fi

            #check out time field
            echo "Check-out Time : DATE/TIME -> XX-XX-XXXX/X:XXam/pm"
            read guest_check_out
            re_guestcheckout='^[0-9][0-9](-)[0-9][0-9](-)[0-9][0-9][0-9][0-9]\/[0-9][0-9]:[0-9][0-9][aAPp][Mm]$'
            if [[ $guest_check_out =~ $re_guestcheckout ]]
            then
                echo #do nothing
            else
                field_error=5 #wrong value of check-in time
            fi

            #check values of all fields
            case $field_error in

                    0)
                             echo "$gno,$guest_name,$guest_phone,$guest_count,$guest_suite,$guest_room,$guest_check_in,$guest_check_out,true" >> Guest.txt
                             echo "                 Inserted Sucessfully                        ";;
                    1)  echo "Insert unsucessfull "
			echo "please enter a valid name" ;;
                    2)  echo "Insert unsucessfull "
			echo "please enter a valid 10 digit phone number field" ;;
		    21)  echo "Insert unsucessfull "
			echo "please enter a valid room number " ;;
                    3)  echo "Insert unsucessfull "
			echo "please enter a valid count of guests" ;;
                    4)  echo "Insert unsucessfull "
			echo "please enter a valid time " ;;
                    5)  echo "Insert unsucessfull "
			echo "please enter a valid time" ;;
                    *)  echo
            esac
            
}

Display()
{
            clear
            echo "__________________________________________________"
            echo "                               Guest List "
            echo "__________________________________________________"
            echo "__________________________________________________"
            echo -e "#Sr.no \t NAME          \t\t PHONE NUMBER \t COUNT \t SUITE TYPE \t ROOM no. \t CHECK IN \t         CHECK OUT"
	    empty=1
            for j in `cat Guest.txt`
            do	
			empty=0
                        gno=$(echo "$j" | cut -d "," -f 1)
                        guest_name=$(echo "$j" | cut -d "," -f 2)
                        guest_phone=$(echo "$j" | cut -d "," -f 3)
                        guest_count=$(echo "$j" | cut -d "," -f 4)
                        guest_suite=$(echo "$j" | cut -d "," -f 5)
			guest_room=$(echo "$j" | cut -d "," -f 6)
                        guest_check_in=$(echo "$j" | cut -d "," -f 7)
                        guest_check_out=$(echo "$j" | cut -d "," -f 8)
                        tfval=$(echo "$j" | cut -d "," -f 9)
                        if [[ "$tfval" = "true" ]]
                        then
                                  echo "___________________________________________"
                                  echo -e "$gno \t $guest_name \t\t $guest_phone \t $guest_count \t $guest_suite \t $guest_room \t $guest_check_in \t$guest_check_out"
                        fi
            done
	    if [ $empty -eq 1 ]
	    then 
		echo "NO RECORDS "
	    fi
            echo "__________________________________________________"
}

Search()
{
            clear

            echo "Enter Guest Name: \c"
            read name

            echo "__________________________________________________"
            echo "                 Guest Details                       "
            echo "__________________________________________________"
            flag=0
            for j in `cat Guest.txt`
            do
                        gno=$(echo "$j" | cut -d "," -f 1)
                        guest_name=$(echo "$j" | cut -d "," -f 2)
                        guest_phone=$(echo "$j" | cut -d "," -f 3)
                        guest_count=$(echo "$j" | cut -d "," -f 4)
                        guest_suite=$(echo "$j" | cut -d "," -f 5)
		        guest_room=$(echo "$j" | cut -d "," -f 6)
                        guest_check_in=$(echo "$j" | cut -d "," -f 7)
                        guest_check_out=$(echo "$j" | cut -d "," -f 8)
                        tfval=$(echo "$j" | cut -d "," -f 9)


                        if [ "$name" = "$guest_name" ]
                        then
                                    flag=1 #found matching record
                                    echo "  Sr no : $gno \t      Name : $guest_name"
                                    echo "                     Phone : $guest_phone"
                                    echo
                                    echo "                     Count : $guest_count"
                                    echo "                Suite Type : $guest_suite"
                                    echo "                   Room No.: $guest_room"
                                    echo "             Check-in Time : $guest_check_in"
                                    echo "            Check-out Time : $guest_check_out"
                                    break
                        fi

            done
            if [ $flag = 0 ]
            then
                 echo "               No Record Found              "
            fi

}

Update()
{
            clear
            echo "Enter Guest Name \c"
            read name
            found=0
            for j in `cat Guest.txt`
            do
                        gno=$(echo "$j" | cut -d "," -f 1)
                        guest_name=$(echo "$j" | cut -d "," -f 2)
                        guest_phone=$(echo "$j" | cut -d "," -f 3)
                        guest_count=$(echo "$j" | cut -d "," -f 4)
                        guest_suite=$(echo "$j" | cut -d "," -f 5)
			guest_room=$(echo "$j" | cut -d "," -f 6)
                        guest_check_in=$(echo "$j" | cut -d "," -f 7)
                        guest_check_out=$(echo "$j" | cut -d "," -f 8)
			
                        if [ "$name" = "$guest_name" ]
                        then
                                    found=1
				    echo "What do you want to change ? "
				    echo "1. Phone number"
				    echo "2. New total members"
				    echo "3. Room "
                                    echo "Enter your choice : "
                                    read c 
				    case $c in 
					1)	echo "Enter New Phone Number : "
						read new_phone
                                    		guest_phone=$new_phone ;;
					2)
                                    		echo "Enter new total members : "
                                    		read new_count
                                    		guest_count=$new_count ;;
					3)
				    		echo "Enter new room"
				    		read new_room
				    		guest_room=$new_room ;;
					*) 	echo "wrong choice "
				    esac
				    
                                    line=$(echo "$gno,$guest_name,$guest_phone,$guest_count,$guest_suite,$guest_room,$guest_check_in,$guest_check_out,true")
                                   				    
				    temp=`cat Guest.txt`				   
				    
                                    d=$(echo "$temp" | sed -e "s%$j%$line%g" )
				    
                                    echo $d > Guest.txt

                                    echo "                 Updated Sucessfully                           "
                        fi
            done
            if [ $found -eq 0 ]
            then
                echo "Record not found"
            fi
}




while [ true ]
do
echo " _______________________________"
echo " 1. Insert  "
echo " 2. Update  "
echo " 3. Display "
echo " 4. Search  "
echo " 5. Exit    "
echo " _______________________________"
echo "Enter Choice: \c"
read ch

case $ch in

            1) Insert ;;
            2) Update ;;
            3) Display ;;
            4) Search ;;
            5) break;;
            *) echo " Wrong Choice "
esac
done
