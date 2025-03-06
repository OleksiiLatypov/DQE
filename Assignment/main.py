import pandas as pd
import psycopg2
import json


#5. Database name, table name, file path and other constant variables ought to be stored in separate .json or .yaml file.
# Load configuration from JSON
with open("config.json", "r") as file:
    config = json.load(file)

DB_CONFIG = config["database"]
FILE_PATHS = config["file_paths"]

#Connect to PostgreSQL
def get_db_connection():
    connection_to_db = psycopg2.connect(
        dbname=DB_CONFIG["name"],
        user=DB_CONFIG["user"],
        password=DB_CONFIG["password"],
        host=DB_CONFIG["host"],
        port=DB_CONFIG["port"]
    )
    return connection_to_db

# Step 1: Create 'students' table in your PosrgreSQL database in python script. It must have id which is PK and auto incremented.
def create_students_table():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        DROP TABLE IF EXISTS students;
        CREATE TABLE students (
            id SERIAL PRIMARY KEY,
            student_name VARCHAR(100),
            first_name VARCHAR(100),
            last_name VARCHAR(100),
            gender VARCHAR(10),
            average_mark FLOAT,
            phonenumber VARCHAR(100)
        );
    """)
    
    conn.commit()
    cursor.close()
    conn.close()
    print("Table 'students' created successfully.")


# Step 2: Collect data from students.xlsx and write it into the text format file (.txt/.csv).
def process_students_data():
    df = pd.read_excel(FILE_PATHS["input_excel"])
    
    # Step 3: Remove rows where 'average mark' is missing
    df = df.dropna(subset=["average mark"])
    
    # Step 4: Separate 'student name' into 'first name' and 'second name'.
    df["first name"] = df["student name"].apply(lambda x: x.split()[0])
    df["second name"] = df["student name"].apply(lambda x: x.split()[1] if len(x.split()) > 0 else '')
    
    # Save cleaned data to CSV
    df.to_csv(FILE_PATHS["output_csv"], index=False)
    print("Cleaned data saved to CSV.")
    
    return df

# Step 5: Insert data into the 'students' table in your DB.
def insert_students_data(df):
    conn =  get_db_connection()
    cursor = conn.cursor()
    
    for _, row in df.iterrows():
        cursor.execute("""
            INSERT INTO students (student_name, first_name, last_name, gender, average_mark, phonenumber) 
            VALUES (%s, %s, %s, %s, %s, %s);
        """, (row["student name"], row["first name"], row["second name"], row["gender"], row["average mark"], row["phone number"]))
    
    conn.commit()
    cursor.close()
    conn.close()
    print("Data inserted into 'students' table.")

# Step 6:  Count number of male students with 'average mark' > 5 and female students with 'average mark' > 5 and select this data from DB.
# Write this data into DataFrame data type variable and print it.
def count_students():
    conn = get_db_connection()
    cursor = conn.cursor()
    query = """
        SELECT gender, COUNT(*) 
        FROM students 
        WHERE average_mark > 5 
        GROUP BY gender;
    """
    cursor.execute(query)
    count_result = cursor.fetchall()
    print(count_result)
    df = pd.DataFrame(count_result, columns=['gender', 'count'])
    conn.close()
    
    print("\nStudents with average mark > 5:")
    print(df)
    
    #return df

if __name__ == "__main__":
    create_students_table()
    cleaned_data = process_students_data()
    insert_students_data(cleaned_data)
    result_df = count_students()
