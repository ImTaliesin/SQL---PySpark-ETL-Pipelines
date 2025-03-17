import os
import pandas as pd
import glob
from pathlib import Path


def convert_parquet_to_csv(base_dir, output_dir):
    """
    Convert all parquet files in a directory structure to CSV

    Parameters:
    base_dir (str): Base directory containing the parquet files
    output_dir (str): Output directory for the CSV files
    """
    # Get all parquet files from the directory and subdirectories
    parquet_files = glob.glob(os.path.join(base_dir, "**", "*.parquet"), recursive=True)

    if not parquet_files:
        print(f"No parquet files found in {base_dir}")
        # Try to find files with no extension that might be parquet
        parquet_files = []
        for root, dirs, files in os.walk(base_dir):
            for file in files:
                file_path = os.path.join(root, file)
                if not os.path.splitext(file)[1] and not file.startswith("."):
                    try:
                        # Try to read as parquet
                        df = pd.read_parquet(file_path)
                        parquet_files.append(file_path)
                    except:
                        continue

    print(f"Found {len(parquet_files)} parquet files")

    # Convert each parquet file to CSV
    for parquet_file in parquet_files:
        try:
            # Read the parquet file
            df = pd.read_parquet(parquet_file)

            # Get the month from the directory path
            month_dir = os.path.basename(os.path.dirname(parquet_file))

            # Create output filename with month in the name
            output_filename = f"green_taxi_{month_dir}.csv"
            csv_file = os.path.join(output_dir, output_filename)

            # Write to CSV
            df.to_csv(csv_file, index=False)
            print(f"Converted: {parquet_file} → {csv_file}")
        except Exception as e:
            print(f"Error converting {parquet_file}: {e}")


if __name__ == "__main__":
    # Base directory containing parquet files
    base_dir = r"C:\Users\brenn\Desktop\nyc-taxi-data\gold\trip_data_green"

    # Output directory for CSV files
    output_dir = r"C:\Users\brenn\Desktop"

    # Ensure output directory exists
    os.makedirs(output_dir, exist_ok=True)

    # Process all months for year 2020
    for month in range(1, 13):
        month_dir = os.path.join(base_dir, f"year=2020", f"month={month:02d}")
        if os.path.exists(month_dir):
            print(f"Processing {month_dir}")
            convert_parquet_to_csv(month_dir, output_dir)
        else:
            print(f"Directory not found: {month_dir}")
