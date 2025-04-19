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

# 4. Process the CSV file
# Remove the header, filter years from 2010 to 2014, select relevant columns, clean data
# Use awk for data processing

# First, add the header to the output file, then process the data
echo "Country,Year,Temperature" > temperature.csv

# Process the CSV file using awk
awk -F, 'BEGIN {OFS=","}
    # Skip header
    NR > 1 {
        # Extract the year from the date (first part of the dt column)
        year = substr($1, 1, 4)
        
        # Filter for years 2010-2014
        if (year >= 2010 && year <= 2014) {
            # Handle missing data in "Temperature" or "Year"
            if ($2 != "" && $1 != "" && $4 != "") {
                # Replace missing country with "unknown"
                country = ($4 == "") ? "unknown" : $4
                # Print the relevant fields: Country, Year, Temperature
                print country, year, $2
            }
        }
    }
' "$input_file" >> temperature.csv

# 5. Output a success message
echo "Data transformation complete. Output saved to 'temperature.csv'."
