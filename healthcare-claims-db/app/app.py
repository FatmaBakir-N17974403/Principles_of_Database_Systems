from flask import Flask, render_template, request, redirect
import psycopg2

app = Flask(__name__)

# ---------------- DB CONNECTION ----------------
def get_db():
    try:
        conn = psycopg2.connect(
            dbname="healthcare_db",
            user="appuser",
            password="password",
            host="localhost"
        )
        return conn
    except Exception as e:
        print("DB CONNECTION ERROR:", e)
        return None


# ---------------- HOME ----------------
@app.route("/")
def home():
    return render_template("home.html")


# ---------------- PATIENTS ----------------
@app.route("/patients", methods=["GET", "POST"])
def patients():
    conn = get_db()
    if not conn:
        return "Database connection failed"

    cur = conn.cursor()

    message = ""

    if request.method == "POST":
        try:
            cur.execute("""
                INSERT INTO patients (first_name, last_name, date_of_birth, gender, state, plan_id)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (
                request.form["first_name"],
                request.form["last_name"],
                request.form["dob"],
                request.form["gender"],
                request.form["state"],
                int(request.form["plan_id"])
            ))
            conn.commit()
            message = "Patient added successfully"
        except Exception as e:
            conn.rollback()
            message = f"Error: {e}"

    cur.execute("SELECT * FROM patients")
    data = cur.fetchall()

    cur.close()
    conn.close()

    return render_template("patients.html", patients=data, message=message)


# ---------------- CLAIMS ----------------
@app.route("/claims", methods=["GET", "POST"])
def claims():
    conn = get_db()
    if not conn:
        return "Database connection failed"

    cur = conn.cursor()
    message = ""

    if request.method == "POST":
        try:
            patient_id = int(request.form["patient_id"])
            provider_id = int(request.form["provider_id"])
            batch_id = int(request.form["batch_id"])
            claim_date = request.form["claim_date"]
            amount = float(request.form["amount"])
            status = request.form["status"]

            cur.execute("""
                INSERT INTO claims (patient_id, provider_id, batch_id, claim_date, claim_amount, status)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (
                patient_id,
                provider_id,
                batch_id,
                claim_date,
                amount,
                status
            ))

            conn.commit()
            message = "Claim added successfully"

        except Exception as e:
            conn.rollback()
            message = f"Error inserting claim: {e}"

    cur.execute("SELECT * FROM claims ORDER BY claim_id DESC")
    data = cur.fetchall()

    cur.close()
    conn.close()

    return render_template("claims.html", claims=data, message=message)


# ---------------- REPORTS ----------------
@app.route("/reports")
def reports():
    conn = get_db()
    if not conn:
        return "Database connection failed"

    cur = conn.cursor()

    try:
        cur.execute("""
            SELECT 
                pr.provider_name,
                COUNT(c.claim_id),
                COALESCE(SUM(c.claim_amount), 0)
            FROM claims c
            JOIN providers pr ON c.provider_id = pr.provider_id
            GROUP BY pr.provider_name
        """)

        report = cur.fetchall()

    except Exception as e:
        report = []
        return f"Error generating report: {e}"

    finally:
        cur.close()
        conn.close()

    return render_template("reports.html", report=report)


# ---------------- RUN ----------------
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)