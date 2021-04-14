#!/bin/bash

select city in Tokyo London "Los Angeles" Moscow Dubai Manchester "New York" Paris Bangalore Johannesburg Istanbul Milan "Abu Dhabi" Pune Nairobi Berlin Karachi Madrid; do
        case "$city" in
            Tokyo) 
                country="Japan" ;;
            London|Manchester)
                country="United Kingdom" ;;
            "Los Angeles"|"New York")
                country="United States" ;;
            Moscow)
                country=Russia ;;
            Dubai|"Abu Dhabi")
                country="United Arab Emirates" ;;
            Paris)
                country="France" ;;
            Bangalore|Pune)
                country="India" ;;
            Johannesburg)
                country="South Africa" ;;
            Istanbul)
                country="Turkey" ;;
            Milan)
                country="Italy" ;;
            Nairobi)
                country="Kenya" ;;
            Berlin)
                country="Germany" ;;
            Karachi)
                country="Pakistan" ;;
            Madrid)
                country="Spain" ;;
        esac
        echo "$city is in $country"
        break
done