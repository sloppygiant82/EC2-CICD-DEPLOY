from flask import Flask, send_from_directory
import os
import pymysql

app = Flask(__name__, static_folder="frontend")


def get_db_connection():
    return pymysql.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS"),
        database="appdb"
    )


# 🔹 Frontend
@app.route("/")
def frontend():
    return send_from_directory("frontend", "index.html")


# 🔹 Backend API (with DB)
@app.route("/api")
def backend():
    conn = None
    try:
        conn = get_db_connection()
        with conn.cursor() as cursor:
            cursor.execute("SELECT NOW()")
            result = cursor.fetchone()
        return f"DB Connected! Time: {result}"
    except Exception as e:
        return f"DB Error: {str(e)}"
    finally:
        if conn:
            conn.close()


# 🔹 Health check
@app.route("/health")
def health():
    return "OK"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)