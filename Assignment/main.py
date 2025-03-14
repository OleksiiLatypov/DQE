import pandas as pd
import psycopg2
import json
import logging
import openpyxl


# Configure logging to log both to a file and the console
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s", 
    datefmt="%Y-%m-%d %H:%M:%S"
)

logger = logging.getLogger(__name__)

# save logs to a file
file_handler = logging.FileHandler("app.log")
file_handler.setFormatter(logging.Formatter("%(asctime)s - %(levelname)s - %(message)s"))

# print logs in console
console_handler = logging.StreamHandler()
console_handler.setFormatter(logging.Formatter("%(asctime)s - %(levelname)s - %(message)s"))

logger.addHandler(file_handler)


#5. Database name, table name, file path and other constant variables ought to be stored in separate .json or .yaml file.
# Load configuration from JSON
with open("config.json", "r") as file:
    config = json.load(file)


DB_CONFIG = config["database"]
FILE_PATHS = config["file_paths"]
TABLE_NAME = 'students'


# Connect to PostgreSQL
def get_db_connection():
    try:
        connection_to_db = psycopg2.connect(
            dbname=DB_CONFIG["db_name"],
            user=DB_CONFIG["user"],
            password=DB_CONFIG["password"],
            host=DB_CONFIG["host"],
            port=DB_CONFIG["port"]
        )
        logger.info(f"Connected to the PostgreSQL successfully on {DB_CONFIG['host']}:{DB_CONFIG['port']}.")
        return connection_to_db
    except Exception as e:
        logger.error(f"Database connection error: {e}")
        return None


#1. Create 'students' table in your PosrgreSQL database in python script. It must have id which is PK and auto incremented.
def create_students_table():
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute(f"""CREATE SCHEMA IF NOT EXISTS {DB_CONFIG["db_name"]};""")
            cursor.execute(f"""
                CREATE TABLE IF NOT EXISTS {DB_CONFIG["db_name"]}.{TABLE_NAME} (
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
    logger.info(f"Table '{TABLE_NAME}' created successfully.")


#2. Collect data from students.xlsx and write it into the text format file (.txt/.csv).
def process_students_data():
    try:
        df = pd.read_excel(FILE_PATHS["input_excel"])
        #3. Remove rows where 'average mark' is missing.
        df = df.dropna(subset=["average mark"])
        
        #4. Separate 'student name' into 'first name' and 'second name'.
        df["first name"] = df["student name"].apply(lambda x: x.split()[0])
        df["second name"] = df["student name"].apply(lambda x: x.split()[1] if len(x.split()) > 1 else '')

        #Save cleaned data to CSV
        df.to_csv(FILE_PATHS["output_csv"], index=False)
        logger.info(f"Transformed '{FILE_PATHS["input_excel"]}' saved to CSV.")
        return df
    except Exception as e:
        logger.error(f"Error processing {FILE_PATHS["input_excel"]} data: {e}")
        return None


#6. Insert data into the 'students' table in your DB.
def insert_students_data(df):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            try:
                for index, row in df.iterrows():
                    cursor.execute(f"""
                        INSERT INTO {DB_CONFIG['db_name']}.{TABLE_NAME} (student_name, first_name, last_name, gender, average_mark, phonenumber)
                        VALUES (%s, %s, %s, %s, %s, %s);
                    """, (row["student name"], row["first name"], row["second name"], row["gender"], row["average mark"], row["phone number"]))
                conn.commit()
                logger.info(f"Data from '{FILE_PATHS["output_csv"]}' inserted into '{TABLE_NAME}' table.")
            except psycopg2.Error as e:
                conn.rollback()
                logger.error(f"Error during insertion: {e}")


#7. Count number of male students with 'average mark' > 5 and female students with 'average mark' > 5 and select this data from DB. Write this data into DataFrame data type variable and print it.
def count_students():
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            try:
                cursor.execute(f"""
                    SELECT gender, COUNT(*) 
                    FROM {DB_CONFIG["db_name"]}.{TABLE_NAME}
                    WHERE average_mark > 5 
                    GROUP BY gender;
                """)
                count_result = cursor.fetchall()
                df = pd.DataFrame(count_result, columns=['gender', 'count'])
                logger.info("\nStudents with average mark > 5:")
                logger.info(f"\n{df}")
                return df
            except Exception as e:
                logger.error(f"Error occcured: {e}")
                return None


if __name__ == "__main__":
    create_students_table()
    cleaned_data = process_students_data()
    insert_students_data(cleaned_data)
    count_students()
