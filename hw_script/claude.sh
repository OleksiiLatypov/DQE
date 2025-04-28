#!/bin/bash

# 1. Check if there are exactly 2 input parameters
if [ "$#" -ne 2 ]; then
    echo "Error: You must provide exactly two parameters (file path and years list)."
    exit 4
fi

# 2. Extract input parameters
input_file="$1"
years_param="$2"

# 3. Check if the file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File does not exist at the specified path."
    exit 3
fi

# 4. Convert the years parameter to a format usable in awk
# Replace commas with pipe symbols for regex OR condition
years_regex=$(echo "$years_param" | sed 's/,/|/g')

# Process the CSV file using awk
tail -n +2 "$input_file" | awk -F, -v years="$years_regex" 'BEGIN {OFS=","}
{
    # Extract the year from the date
    year = substr($1, 2, 4)
    
    # Check if the year matches any in our list
    if (year ~ years) {
        # Only process if temperature and year data exist
        if ($2 != "" && year != "") {
            # Handle country field - replace empty with "unknown"
            if ($4 == "" || $4 == "\"\"") {
                country = "\"unknown\""
            } else {
                country = $4
            }
            
            # Print the relevant fields: Temperature, Year, Country
            print $2, year, country
        }
    }
}' > temperature.csv

# 5. Output a success message
echo "CLAUDE Data transformation complete. Output saved to 'temperature.csv'."