#!/bin/bash

# check if there are only 2 input parameters – if it has more or less input params, script should fail with error code ‘4’
if [ "$#" -ne 2 ]; then
    echo "Error: Invalid number of input parameters."
    exit 4
fi


# Assign input parameters to variables
input_file=$1
years_to_process=$2

# check if the file exists in the given path – if not script should exit with error code ‘3’
if [ ! -f "$input_file" ]; then
    echo "Error: File does not exist."
    exit 3
fi


# check if the correct format of years input parameters (only digits and commas allowed)
if ! [[ "$years_to_process" =~ ^[0-9]{4}(,[0-9]{4})*$ ]]; then
    echo "Error: Invalid format for years. Expected format: \"2010,2011,2012\" (comma-separated years without spaces or slashes)"
    exit 5
fi


# Process the file
awk -v years="$years_to_process" '
BEGIN {
    FS = ",";
    OFS = ",";
    split(years, year_list, ",");
}

NR == 1 { next } # Remove 1st line with column names (header)
{
    year = substr($1, 1, 4);
    for (i in year_list) {
        if (year == year_list[i]) { # Keep data only for the specified period, in my case from 2010-2014
            temp = $2;
            country = $4;
            if (temp != "") {  # Remove rows with incomplete data in Temperature - (Celsius) field
                if (country == "") {  # If you have incomplete data in “Country” field – those values should be replaced to “unknown” value
                    country = "unknown";  
                }
                print temp, year, country;  # Only data from “Temperature - (Celsius)”, “Year” and “Country” fields should stay in the transformed file 
            }
            break;
        }
    }
}
' "$input_file" > temperature.csv

echo "Processing finished. Transformed data saved to temperature.csv."
