#!/bin/bash

# 1. Check if there are exactly 2 input parameters
if [ "$#" -ne 2 ]; then
    echo "Error: You must provide exactly two parameters (file path and years list)."
    exit 4
fi

# 2. Extract input parameters
input_file="$1"
years="$2"

# 3. Check if the file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File does not exist at the specified path."
    exit 3
fi

# 4. Convert years list into an array
IFS=',' read -ra FILTER_YEARS <<< "$years"

# 5. Process the CSV file
# Remove the header, filter years based on the list, select relevant columns, clean data
# Use awk for data processing

# First, add the header to the output file, then process the data
echo "Country,Year,Temperature" > temperature.csv

# Process the CSV file using awk
awk -F"\t" 'BEGIN {OFS=","}
    # Skip header
    NR > 1 {
        # Extract the year from the date (first part of the dt column)
        year = substr($1, 1, 4)
        
        # Check if the year is in the provided list of years
        year_found = 0
        for (i in years_array) {
            if (year == years_array[i]) {
                year_found = 1
                break
            }
        }

        # If the year is in the list and the necessary fields are not empty, process the data
        if (year_found && $2 != "NaN" && $1 != "" && $2 != "") {
            # Handle missing country data and use "unknown" if necessary
            country = ($4 == "") ? "unknown" : $4
            # Print the relevant fields: Country, Year, Temperature
            print country, year, $2
        }
    }
' "$input_file" >> temperature.csv

# 6. Output a success message
count=$(($(wc -l < temperature.csv) - 1))
echo "Data transformation complete. $count rows saved to 'temperature.csv'."
