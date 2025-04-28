#!/bin/bash

# Validate input parameters
if [ "$#" -ne 2 ]; then
  echo "Error: Exactly 2 input parameters are required." >&2
  exit 4
fi

input_file="$1"
years_list="$2"

if [ ! -f "$input_file" ]; then
  echo "Error: Input file does not exist." >&2
  exit 3
fi

output_file="temperature.csv"

# Normalize NaN to blanks and run awk
awk -v years="$years_list" '
BEGIN {
  FS = "[,\t]"; OFS = ",";
  split(years, year_array, ",");
  for (i in year_array) valid_years[year_array[i]] = 1;
}
NR == 1 { next } # skip header
{
  # Normalize NaNs
  for (i = 1; i <= NF; i++) {
    if ($i == "NaN") $i = "";
  }

  year = substr($1, 1, 4);
  if (year in valid_years && $2 != "" && $3 != "") {
    country = ($4 == "" || $4 == "\"\"") ? "unknown" : $4;
    print $2, year, country;
  }
}
' "$input_file" > "$output_file"

echo "Transformed file saved as $output_file"
