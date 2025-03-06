import pandas as pd
import psycopg2
import json

# Load configuration from JSON
with open("config.json", "r") as file:
    config = json.load(file)

DB_CONFIG = config["database"]
FILE_PATHS = config["file_paths"]

# Connect to PostgreSQL
# def get_db_connection():
#     return psycopg2.connect(
#         dbname=DB_CONFIG["name"],
#         user=DB_CONFIG["user"],
#         password=DB_CONFIG["password"],
#         host=DB_CONFIG["host"],
#         port=DB_CONFIG["port"]
#     )

# Step 1: Create 'students' table
def create_students_table():
    conn = psycopg2.connect(
        dbname=DB_CONFIG["name"],
        user=DB_CONFIG["user"],
        password=DB_CONFIG["password"],
        host=DB_CONFIG["host"],
        port=DB_CONFIG["port"]
    )
    cursor = conn.cursor()

    cursor.execute("""
        DROP TABLE IF EXISTS students;
        CREATE TABLE students (
            id SERIAL PRIMARY KEY,
            first_name VARCHAR(100),
            last_name VARCHAR(100),
            gender VARCHAR(10),
            average_mark FLOAT
        );
    """)
    
    conn.commit()
    cursor.close()
    conn.close()
    print("Table 'students' created successfully.")


# Step 2: Read and clean data from Excel
def process_students_data():
    df = pd.read_excel(FILE_PATHS["input_excel"])
    
    # Step 3: Remove rows where 'average mark' is missing
    df = df.dropna(subset=["average mark"])
    
    # Step 4: Split 'student name' into 'first_name' and 'last_name'
    df[["first_name", "last_name"]] = df["student name"].str.split(" ", n=1, expand=True)
    
    # Keep only required columns
    df = df[["first_name", "last_name", "gender", "average mark"]]
    
    # Save cleaned data to CSV
    df.to_csv(FILE_PATHS["output_csv"], index=False)
    print("Cleaned data saved to CSV.")
    
    return df

# Step 5: Insert data into PostgreSQL
def insert_students_data(df):
    conn = psycopg2.connect(
        dbname=DB_CONFIG["name"],
        user=DB_CONFIG["user"],
        password=DB_CONFIG["password"],
        host=DB_CONFIG["host"],
        port=DB_CONFIG["port"]
    )
    cursor = conn.cursor()
    
    for _, row in df.iterrows():
        cursor.execute("""
            INSERT INTO students (first_name, last_name, gender, average_mark) 
            VALUES (%s, %s, %s, %s);
        """, (row["first_name"], row["last_name"], row["gender"], row["average mark"]))
    
    conn.commit()
    cursor.close()
    conn.close()
    print("Data inserted into 'students' table.")

# Step 6: Query male and female students with average mark > 5
def count_students():
    conn = psycopg2.connect(
        dbname=DB_CONFIG["name"],
        user=DB_CONFIG["user"],
        password=DB_CONFIG["password"],
        host=DB_CONFIG["host"],
        port=DB_CONFIG["port"]
    )
    query = """
        SELECT gender, COUNT(*) 
        FROM students 
        WHERE average_mark > 5 
        GROUP BY gender;
    """
    
    df = pd.read_sql(query, conn)
    conn.close()
    
    print("\nStudents with average mark > 5:")
    print(df)
    
    return df

if __name__ == "__main__":
    create_students_table()
    cleaned_data = process_students_data()
    insert_students_data(cleaned_data)
    result_df = count_students()
