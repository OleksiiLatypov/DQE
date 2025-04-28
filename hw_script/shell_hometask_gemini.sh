#!/bin/bash

# Script name: shell_hometask_<variant_number>.sh
# Description: This script processes a CSV file, filters data based on year,
#              and transforms it for use with Hive and Spark.

# Input parameters:
#   1: Path to the original CSV file.
#   2: List of years to process (e.g., "2010,2011,2012,2013,2014").

# Output:
#   A new CSV file named "temperature.csv" in the current directory.

# Function to print usage instructions
usage() {
  echo "Usage: $0 <input_file_path> <years_to_process>"
  echo "  <input_file_path>: Path to the input CSV file."
  echo "  <years_to_process>: Comma-separated list of years to process (e.g., \"2010,2011,2012,2013,2014\")."
  exit 1
}

# Check the number of input parameters
if [ "$#" -ne 2 ]; then
  echo "Error: Incorrect number of arguments. Expected 2, got $#."
  usage
  exit 4
fi

# Assign input parameters to variables
input_file="$1"
years_string="$2"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Error: Input file '$input_file' not found."
  exit 3
fi

# Convert the comma-separated years string into an array
IFS=',' read -ra years <<< "$years_string"

# Output file
output_file="temperature.csv"

# Remove the output file if it already exists
if [ -f "$output_file" ]; then
  rm "$output_file"
fi

# Process the input file, skipping the header, filtering by year,
# selecting columns, handling nulls, and writing to the output file.
tail -n +2 "$input_file" |  # Skip the header row
while IFS=',' read -r dt temperature _ _ country; do
  # Extract the year from the 'dt' column
  year=$(echo "$dt" | cut -d'-' -f1)

  # Check if the year is in the array of years to process
  year_match=0
  for y in "${years[@]}"; do
    if [ "$year" -eq "$y" ]; then
      year_match=1
      break
    fi
  done

  # If the year is not in the list, skip to the next iteration
  if [ "$year_match" -eq 0 ]; then
    continue
  fi

  # Handle null temperature values
  if [ -z "$temperature" ]; then
    continue # Skip row if temperature is missing
  fi

  # Handle null year
   if [ -z "$year" ]; then
     continue  # Skip row if year is missing
   fi

  # Handle null country values
  if [ -z "$country" ]; then
    country="unknown"
  fi

  # Append the processed row to the output file
  echo "$temperature,$year,$country" >> "$output_file"
done

echo "Processed data written to $output_file"
exit 0
