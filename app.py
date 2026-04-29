from functools import wraps
from flask import Flask, render_template, request, redirect, url_for, session, abort, flash
from flask_mysqldb import MySQL
import MySQLdb.cursors
from datetime import datetime, timedelta, date
import calendar
from flask import jsonify
from werkzeug.security import generate_password_hash
from werkzeug.security import generate_password_hash, check_password_hash
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)
app.secret_key = "replace-this-with-a-real-secret-key"
app.config["SESSION_PERMANENT"] = False

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'Brilextj$7890'
app.config['MYSQL_DB'] = 'greene_turtle_db'
mysql = MySQL(app)


# ========================
# ROLE HELPERS
# ========================
def role_required(*roles):
    def wrapper(fn):
        @wraps(fn)
        def decorated_view(*args, **kwargs):
            user_role = session.get("user_role")
            if not user_role or user_role not in roles:
                return abort(403)
            return fn(*args, **kwargs)
        return decorated_view
    return wrapper
    

def empty_week_dict():
    return {
        "mon": [],
        "tue": [],
        "wed": [],
        "thu": [],
        "fri": [],
        "sat": [],
        "sun": []
    }
def format_time_12hr(hour_float):
    hour = int(hour_float)
    minute = int((hour_float - hour) * 60)

    suffix = "AM"
    if hour >= 12:
        suffix = "PM"

    if hour > 12:
        hour -= 12
    if hour == 0:
        hour = 12

    return f"{hour}:{minute:02d} {suffix}"

def day_key_from_date(some_date):
    weekday_index = some_date.weekday()  # Monday = 0, Sunday = 6

    day_keys = {
        0: "mon",
        1: "tue",
        2: "wed",
        3: "thu",
        4: "fri",
        5: "sat",
        6: "sun"
    }

    return day_keys[weekday_index]

def next_date_for_day(day_code):
    day_map = {
        "mon": 0,
        "tue": 1,
        "wed": 2,
        "thu": 3,
        "fri": 4,
        "sat": 5,
        "sun": 6
    }

    if day_code not in day_map:
        raise ValueError(f"Invalid day code: {day_code}")

    today = date.today()
    target_day = day_map[day_code]
    days_ahead = target_day - today.weekday()

    if days_ahead < 0:
        days_ahead += 7

    return today + timedelta(days=days_ahead)

def date_for_day_in_week(week_start, day_code):
    day_map = {
        "mon": 0,
        "tue": 1,
        "wed": 2,
        "thu": 3,
        "fri": 4,
        "sat": 5,
        "sun": 6
    }

    return week_start + timedelta(days=day_map[day_code])
# ========================
# AUTH ROUTES
# ========================
@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form.get("username", "").strip().lower()
        password = request.form.get("password", "").strip()

        if not username or not password:
            return render_template(
                "login.html",
                error="Please enter both a username and password.",
                user_role=session.get("user_role")
            )

        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        # First check staff/admin users table
        cur.execute("""
            SELECT id, first_name, last_name, name, email, username, password, role
            FROM users
            WHERE email = %s OR username = %s
            LIMIT 1
        """, (username, username))
        user = cur.fetchone()

        if user and check_password_hash(user["password"], password):
            cur.close()
            session.permanent = False
            session["user_id"] = user["id"]
            session["user_role"] = user["role"]
            session["username"] = user["username"] or user["email"]
            session["name"] = user["name"]

            if user["role"] == "admin":
                return redirect(url_for("dashboard"))
            elif user["role"] == "staff":
                return redirect(url_for("staff_scheduling_staff"))

        # If not found in users, check members table for customers
        cur.execute("""
            SELECT member_id, first_name, last_name, email, username, password
            FROM members
            WHERE email = %s OR username = %s
            LIMIT 1
        """, (username, username))
        member = cur.fetchone()
        cur.close()

        if member and check_password_hash(member["password"], password):
            session.permanent = False
            session["member_id"] = member["member_id"]
            session["user_role"] = "customer"
            session["username"] = member["username"] or member["email"]
            session["name"] = f"{member['first_name']} {member['last_name']}"
            return redirect(url_for("home"))

        return render_template(
            "login.html",
            error="Invalid username or password.",
            user_role=session.get("user_role")
        )

    return render_template("login.html", user_role=session.get("user_role"))
    

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))


# ========================
# CUSTOMER PAGES
# ========================
@app.route("/")
def home():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        SELECT
            p.promotion_id,
            p.promotion_name,
            p.promotion_type,
            p.description,
            p.discount,
            p.start_time,
            p.end_time,
            GROUP_CONCAT(mi.name ORDER BY mi.name SEPARATOR ', ') AS promo_items
        FROM promotion_calendar pc
        JOIN promotions p
            ON pc.promotion_id = p.promotion_id
        LEFT JOIN promotion_items pi
            ON p.promotion_id = pi.promotion_id
        LEFT JOIN menu_items mi
            ON pi.menu_item_id = mi.menu_item_id
        WHERE pc.date = CURDATE()
          AND (p.start_time IS NULL OR CURTIME() >= p.start_time)
          AND (p.end_time IS NULL OR CURTIME() <= p.end_time)
        GROUP BY
            p.promotion_id,
            p.promotion_name,
            p.promotion_type,
            p.description,
            p.discount,
            p.start_time,
            p.end_time
        ORDER BY p.promotion_name
    """)

    current_promos = cur.fetchall()
    cur.close()

    return render_template(
        "index.html",
        user_role=session.get("user_role"),
        current_promos=current_promos
    )



@app.route("/online-ordering")
def online_ordering():
    return render_template("online_ordering.html", user_role=session.get("user_role"))


@app.route("/cart")
def cart():
    return render_template("cart.html", user_role=session.get("user_role"))


@app.route("/checkout")
def checkout():
    return render_template(
        "checkout.html",
        user_role=session.get("user_role"),
        paypal_client_id=os.getenv("PAYPAL_CLIENT_ID")
    )

@app.route("/submit-order", methods=["POST"])
def submit_order():
    data = request.get_json()

    cart = data.get("cart", [])
    payment_method = data.get("payment_method", "Credit Card")

    if not cart:
        return jsonify({"success": False, "message": "Cart is empty."}), 400

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    try:
        now = datetime.now()

        # Insert into orders table
        cur.execute("""
            INSERT INTO orders (TransactionDate, TransactionTime, PaymentMethod)
            VALUES (%s, %s, %s)
        """, (
            now.date(),
            now.strftime("%H:%M:%S"),
            payment_method
        ))

        order_id = cur.lastrowid

        # Insert each cart item into order_items table
        for item in cart:
            menu_item_id = item.get("menu_item_id")
            quantity = item.get("quantity", 1)

            if not menu_item_id:
                mysql.connection.rollback()
                return jsonify({
                    "success": False,
                    "message": "A cart item is missing menu_item_id."
                }), 400

            cur.execute("""
                INSERT INTO order_items (OrderID, menu_item_id, Quantity)
                VALUES (%s, %s, %s)
            """, (order_id, menu_item_id, quantity))

        mysql.connection.commit()

        return jsonify({
            "success": True,
            "message": "Order placed successfully.",
            "order_id": order_id
        })

    except Exception as e:
        mysql.connection.rollback()
        return jsonify({
            "success": False,
            "message": f"Error saving order: {str(e)}"
        }), 500

    finally:
        cur.close()
        
@app.route("/event-inquiry", methods=["GET", "POST"])
def event_inquiry():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        SELECT DATE(preferred_datetime) AS booked_date
        FROM event_inquiries
        WHERE inquiry_status = 'approved'
    """)
    booked_date_rows = cur.fetchall()
    booked_dates = [str(row["booked_date"]) for row in booked_date_rows if row["booked_date"]]

    if request.method == "POST":
        full_name = request.form.get("fullName", "").strip()
        organization = request.form.get("organization", "").strip()
        guests = request.form.get("guests", "").strip()
        email = request.form.get("email", "").strip()
        phone = request.form.get("phone", "").strip()
        preferred_datetime = request.form.get("preferredDateTime", "").strip()
        event_description = request.form.get("eventDescription", "").strip()
        catering_package = request.form.get("cateringPackage", "").strip()

        if not all([
            full_name,
            organization,
            guests,
            email,
            phone,
            preferred_datetime,
            event_description,
            catering_package
        ]):
            cur.close()
            return render_template(
                "event_inquiry.html",
                user_role=session.get("user_role"),
                booked_dates=booked_dates,
                message="Please fill out all required fields."
            )

        requested_date = preferred_datetime.split("T")[0] if preferred_datetime else None

        if requested_date in booked_dates:
            cur.close()
            return render_template(
                "event_inquiry.html",
                user_role=session.get("user_role"),
                booked_dates=booked_dates,
                message="That date is already booked. Please choose another day."
            )

        cur.execute("""
            INSERT INTO event_inquiries
            (full_name, organization, guests, email, phone, preferred_datetime, event_description, catering_package, inquiry_status)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            full_name,
            organization,
            guests,
            email,
            phone,
            preferred_datetime,
            event_description,
            catering_package,
            "pending"
        ))

        mysql.connection.commit()
        cur.close()

        return render_template(
            "event_inquiry.html",
            user_role=session.get("user_role"),
            booked_dates=booked_dates,
            message="Your inquiry has been submitted successfully."
        )

    cur.close()
    return render_template(
        "event_inquiry.html",
        user_role=session.get("user_role"),
        booked_dates=booked_dates,
        message=None
    )
    

@app.route("/become-a-member", methods=["GET", "POST"])
def become_a_member():
    if request.method == "POST":
        first_name = request.form.get("firstName", "").strip()
        last_name = request.form.get("lastName", "").strip()
        birthday = request.form.get("birthday", "").strip()
        email = request.form.get("email", "").strip().lower()
        phone = request.form.get("phone", "").strip()
        preferred_channel = request.form.get("preferredChannel", "").strip()
        username = request.form.get("username", "").strip().lower()
        password = request.form.get("password", "").strip()
        promo_opt_in = 1 if request.form.get("promoOptIn") else 0

        if not all([first_name, last_name, birthday, email, phone, preferred_channel, username, password]) or not promo_opt_in:
            return render_template(
                "become_a_member.html",
                user_role=session.get("user_role"),
                message="Please fill out all required fields and agree to receive promotions and updates."
            )

        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        cur.execute("""
            SELECT member_id
            FROM members
            WHERE email = %s OR username = %s
            LIMIT 1
        """, (email, username))
        existing_member = cur.fetchone()

        cur.execute("""
            SELECT id
            FROM users
            WHERE email = %s OR username = %s
            LIMIT 1
        """, (email, username))
        existing_user = cur.fetchone()

        if existing_member or existing_user:
            cur.close()
            return render_template(
                "become_a_member.html",
                user_role=session.get("user_role"),
                message="Account already made. Please sign in instead."
            )

        hashed_password = generate_password_hash(password)

        cur.execute("""
            INSERT INTO members
            (first_name, last_name, date_of_birth, email, phone, preferred_channel, username, password, promo_opt_in)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            first_name,
            last_name,
            birthday,
            email,
            phone,
            preferred_channel,
            username,
            hashed_password,
            promo_opt_in
        ))
        mysql.connection.commit()
        cur.close()

        return render_template(
            "become_a_member.html",
            user_role=session.get("user_role"),
            message="Account created successfully."
        )

    return render_template("become_a_member.html", user_role=session.get("user_role"))



# ========================
# STAFF PAGES
# ========================
@app.route("/staff-scheduling-staff")
@role_required("staff", "admin")
def staff_scheduling_staff():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("SELECT DISTINCT name FROM users WHERE role IN ('staff', 'admin') AND active_status = 'active'")
    staff_members = [row["name"] for row in cur.fetchall()]
    cur.execute("""
        SELECT u.name, s.role, s.date, s.start_hour, s.end_hour, s.color
        FROM schedule s
        JOIN users u ON s.user_id = u.id
    """)
    schedule_events = [
        {
            'date':  str(row["date"]),
            'name': row["name"],
            'role': row["role"],
            'start': float(row["start_hour"]),
            'end':   float(row["end_hour"]),
            'color': row["color"]
        }
        for row in cur.fetchall()
    ]
    cur.close()
   
    template = "staff_scheduling_admin.html" if session.get("user_role") == "admin" else "staff_scheduling_staff.html"
    return render_template(template, staff_members=staff_members,
                           schedule_events=schedule_events,
                           user_role=session.get("user_role"))


@app.route("/event-details")
@role_required("staff", "admin")
def event_details_staff():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        SELECT
            inquiry_id,
            organization,
            full_name,
            email,
            guests,
            preferred_datetime,
            event_description,
            catering_package,
            inquiry_status
        FROM event_inquiries
        WHERE inquiry_status IN ('approved', 'completed')
        ORDER BY preferred_datetime ASC
    """)
    event_rows = cur.fetchall()

    events = []
    for row in event_rows:
        cur.execute("""
            SELECT u.name
            FROM users u
            JOIN event_staff es ON u.id = es.user_id
            WHERE es.event_id = %s
            ORDER BY u.name
        """, (row["inquiry_id"],))
        staff = [s["name"] for s in cur.fetchall()]

        preferred_datetime = row["preferred_datetime"]
        events.append({
            'id': row["inquiry_id"],
            'inquiry_id': row["inquiry_id"],
            'type': row["organization"] or "Private Event",
            'organization': row["organization"],
            'full_name': row["full_name"],
            'name': row["full_name"],
            'email': row["email"],
            'guests': row["guests"],
            'preferred_datetime': preferred_datetime,
            'date': preferred_datetime.strftime("%Y-%m-%d") if preferred_datetime else "",
            'time': preferred_datetime.strftime("%I:%M %p") if preferred_datetime else "",
            'description': row["event_description"],
            'event_description': row["event_description"],
            'package': row["catering_package"],
            'catering_package': row["catering_package"],
            'status': row["inquiry_status"],
            'inquiry_status': row["inquiry_status"],
            'staff': staff
        })

    cur.close()
    # Admins see admin navbar, staff see staff navbar
    template = "event_details_admin.html" if session.get("user_role") == "admin" else "event_details_staff.html"
    return render_template(template, events=events, user_role=session.get("user_role"))

@app.route("/staff-shift")
@role_required("staff", "admin")
def staff_shift():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute(
        "SELECT s.id, s.date, s.start_hour AS startH, s.end_hour AS endH,"
        " s.role, COALESCE(ei.organization, ei.full_name) AS event"
        " FROM schedule s"
        " LEFT JOIN event_inquiries ei ON s.event_id = ei.inquiry_id"
        " WHERE s.user_id = %s AND s.date >= CURDATE()"
        " ORDER BY s.date ASC",
        (session.get("user_id"),)
    )
    rows = cur.fetchall()
    cur.execute("""
        SELECT day_of_week, start_time, end_time
        FROM staff_availability
        WHERE user_id = %s
    """, (session.get("user_id"),))

    saved_availability = [
        {
            "day_of_week": row["day_of_week"],
            "start_time": str(row["start_time"]),
            "end_time": str(row["end_time"])
        }
        for row in cur.fetchall()
    ]
    cur.close()
 
    scheduled_shifts = [
        {
            'id':    row["id"],
            'date':  str(row["date"]),
            'startH': float(row["startH"]),
            'endH':   float(row["endH"]),
            'role':  row["role"],
            'event': row["event"] or "General"
        }
        for row in rows
    ]
 
    return render_template("staff_shift.html", scheduled_shifts=scheduled_shifts,
                       saved_availability=saved_availability,
                       user_role=session.get("user_role"))

@app.route("/save-availability", methods=["POST"])
@role_required("staff", "admin")
def save_availability():
    data = request.get_json()
    user_id = session.get("user_id")
    

    if not data or not user_id:
        return jsonify({"success": False}), 400

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("DELETE FROM staff_availability WHERE user_id = %s", (user_id,))

    for slot in data:
        cur.execute("""
            INSERT INTO staff_availability (user_id, day_of_week, start_time, end_time, is_unavailable)
            VALUES (%s, %s, %s, %s, %s)
        """, (user_id, slot["day_of_week"], slot["start_time"], slot["end_time"], 0))

    mysql.connection.commit()
    cur.close()
    return jsonify({"success": True})

@app.route("/submit-shift-request", methods=["POST"])
@role_required("staff", "admin")
def submit_shift_request():
    data = request.get_json()
    user_id = session.get("user_id")

    request_type = data.get("request_type")
    shift_id = data.get("shift_id")
    notes = data.get("notes", "")

    if request_type == "time":
        new_date = data.get("new_date", "")
        new_start = data.get("new_start", "")
        new_end = data.get("new_end", "")
        notes = f"New date: {new_date} | Start: {new_start} | End: {new_end} | Note: {notes}"
    elif request_type == "role":
        new_role = data.get("new_role", "")
        notes = f"New role: {new_role} | Note: {notes}"

    if not request_type or not user_id:
        return jsonify({"success": False}), 400

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        INSERT INTO shift_requests (shift_id, staff_id, request_type, request_note, request_status)
        VALUES (%s, %s, %s, %s, 'pending')
    """, (shift_id or None, user_id, request_type, notes))
    mysql.connection.commit()
    cur.close()

    return jsonify({"success": True})

# ========================
# ADMIN PAGES
# ========================
@app.route("/dashboard")
@role_required("admin")
def dashboard():
    return render_template("dashboard.html", user_role=session.get("user_role"))


# Menu
@app.route("/menu")
@role_required("admin")
def menu():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

      # Top selling items
    cur.execute("""
        SELECT 
            mi.name,
            COALESCE(SUM(oi.Quantity), 0) AS total_sold
        FROM menu_items mi
        LEFT JOIN order_items oi
            ON mi.menu_item_id = oi.menu_item_id
        WHERE mi.active_status = 'active'
        GROUP BY mi.name
        ORDER BY total_sold DESC, mi.name ASC
        LIMIT 4
    """)
    top_selling_items = cur.fetchall()

    # Bottom selling items
    cur.execute("""
        SELECT 
            mi.name,
            COALESCE(SUM(oi.Quantity), 0) AS total_sold
        FROM menu_items mi
        LEFT JOIN order_items oi
            ON mi.menu_item_id = oi.menu_item_id
        WHERE mi.active_status = 'active'
        GROUP BY mi.name
        ORDER BY total_sold ASC, mi.name ASC
        LIMIT 4
    """)
    bottom_selling_items = cur.fetchall()

    # Seasonal items + sales
    cur.execute("""
        SELECT 
            mi.menu_item_id,
            mi.name,
            COALESCE(SUM(oi.Quantity), 0) AS total_sold
        FROM menu_items mi
        LEFT JOIN order_items oi
            ON mi.menu_item_id = oi.menu_item_id
        WHERE mi.active_status = 'active'
          AND mi.category = 'Seasonal'
        GROUP BY mi.menu_item_id, mi.name
        ORDER BY mi.name ASC
    """)
    seasonal_items = cur.fetchall()

    # Payment type frequency
    cur.execute("""
        SELECT PaymentMethod, COUNT(*) AS payment_count
        FROM orders
        WHERE PaymentMethod IN ('Credit Card', 'Debit Card', 'Cash', 'Mobile Pay')
        GROUP BY PaymentMethod
    """)
    payment_rows = cur.fetchall()

    payment_frequency = {
        "Credit Card": 0,
        "Debit Card": 0,
        "Cash": 0,
        "Mobile Pay": 0
    }

    for row in payment_rows:
        payment_frequency[row["PaymentMethod"]] = row["payment_count"]
    # Average Order Value
    cur.execute("""
        SELECT COALESCE(AVG(OrderPrice), 0) AS avg_order_value
        FROM orders
    """)
    avg_order_value = float(cur.fetchone()["avg_order_value"] or 0)

    cur.execute("""
    SELECT 
            mi.category,
            COUNT(*) AS total_orders
        FROM order_items oi, menu_items mi
        WHERE oi.menu_item_id = mi.menu_item_id
        GROUP BY mi.category
        ORDER BY mi.category
    """)

    chart_data = cur.fetchall()

    labels = [row["category"] for row in chart_data]
    values = [row["total_orders"] for row in chart_data]
    cur.close()

    return render_template(
    "menu.html",
    labels=labels,
    values=values,
    top_selling_items=top_selling_items,
    bottom_selling_items=bottom_selling_items,
    payment_frequency=payment_frequency,
    avg_order_value=avg_order_value,
    seasonal_items=seasonal_items
    )

@app.route("/remove-seasonal-item", methods=["POST"])
@role_required("admin")
def remove_seasonal_item():
    item_name = request.form.get("item_name", "").strip()

    if not item_name:
        return jsonify({"success": False, "message": "Missing item name."}), 400

    cur = mysql.connection.cursor()
    
    cur.execute("""
        UPDATE menu_items
        SET active_status = 'inactive'
        WHERE name = %s
    """, (item_name,))
    
    mysql.connection.commit()

    affected_rows = cur.rowcount
    cur.close()

    if affected_rows == 0:
        return jsonify({"success": False, "message": f"No item found for {item_name}."}), 404

    return jsonify({"success": True, "message": f"{item_name} marked as inactive."})
# PIE CHART 
@app.route("/menu-category-pie")
@role_required("admin")
def menu_category_pie():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        SELECT mi.category, COUNT(*) AS total_orders
        FROM order_items oi, menu_items mi
        WHERE oi.menu_item_id = mi.menu_item_id
        GROUP BY mi.category
    """)
    
    chart_data = cur.fetchall()
    cur.close()

    labels = [row["category"] for row in chart_data]
    values = [row["total_orders"] for row in chart_data]

    return render_template("menu_category_pie.html", labels=labels, values=values)
@app.route("/menu-adjustments")
@role_required("admin")
def menu_adjustments():
    status_filter = request.args.get("status", "active").strip().lower()

    if status_filter not in ["active", "inactive", "all"]:
        status_filter = "active"

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    if status_filter == "all":
        cur.execute("""
            SELECT menu_item_id, name, category, price, active_status
            FROM menu_items
            ORDER BY category, name
        """)
    else:
        cur.execute("""
            SELECT menu_item_id, name, category, price, active_status
            FROM menu_items
            WHERE active_status = %s
            ORDER BY category, name
        """, (status_filter,))

    menu_items = cur.fetchall()
    cur.close()

    return render_template(
        "menu_adjustments.html",
        menu_items=menu_items,
        status_filter=status_filter,
        user_role=session.get("user_role")
    )
    
@app.route("/menu-adjustments/add", methods=["POST"])
@role_required("admin")
def add_menu_item():
    name = request.form.get("name", "").strip()
    category = request.form.get("category", "").strip()
    price = request.form.get("price", "").strip()

    if not name or not category or not price:
        return redirect(url_for("menu_adjustments"))

    try:
        price = float(price)
    except ValueError:
        return redirect(url_for("menu_adjustments"))

    cur = mysql.connection.cursor()

    cur.execute("""
        INSERT INTO menu_items (name, category, price, active_status)
        VALUES (%s, %s, %s, 'active')
    """, (name, category, price))

    mysql.connection.commit()
    cur.close()

    return redirect(url_for("menu_adjustments"))
    
@app.route("/menu-adjustments/edit/<int:menu_item_id>", methods=["POST"])
@role_required("admin")
def edit_menu_item(menu_item_id):
    name = request.form.get("name")
    category = request.form.get("category")
    price = request.form.get("price")

    cur = mysql.connection.cursor()

    cur.execute("""
        UPDATE menu_items
        SET name=%s, category=%s, price=%s
        WHERE menu_item_id=%s
    """, (name, category, price, menu_item_id))

    mysql.connection.commit()
    cur.close()

    return redirect(url_for("menu_adjustments"))


@app.route("/menu-adjustments/delete/<int:menu_item_id>", methods=["POST"])
@role_required("admin")
def delete_menu_item(menu_item_id):
    cur = mysql.connection.cursor()

    cur.execute("""
        UPDATE menu_items
        SET active_status = 'inactive'
        WHERE menu_item_id = %s
    """, (menu_item_id,))

    mysql.connection.commit()
    cur.close()

    return redirect(url_for("menu_adjustments"))
@app.route("/menu-adjustments/reactivate/<int:menu_item_id>", methods=["POST"])
@role_required("admin")
def reactivate_menu_item(menu_item_id):
    cur = mysql.connection.cursor()

    cur.execute("""
        UPDATE menu_items
        SET active_status = 'active'
        WHERE menu_item_id = %s
    """, (menu_item_id,))

    mysql.connection.commit()
    cur.close()

    return redirect(url_for("menu_adjustments", status="inactive"))


@app.route("/orders-and-sales")
@role_required("admin")
def orders_and_sales():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    # latest week in orders table
    cur.execute("""
        SELECT YEARWEEK(MAX(TransactionDate), 1) AS latest_week
        FROM orders
    """)
    latest_week_result = cur.fetchone()
    latest_week = latest_week_result["latest_week"]

    # latest month in orders table
    cur.execute("""
        SELECT
            YEAR(MAX(TransactionDate)) AS latest_year,
            MONTH(MAX(TransactionDate)) AS latest_month
        FROM orders
    """)
    latest_month_result = cur.fetchone()
    latest_year = latest_month_result["latest_year"]
    latest_month = latest_month_result["latest_month"]

    if latest_week is None or latest_year is None or latest_month is None:
        cur.close()
        return render_template(
            "orders_and_sales.html",
            user_role=session.get("user_role"),
            weekly_orders=0,
            last_week_orders=0,
            order_difference=0,
            weekly_sales=0,
            last_week_sales=0,
            weekly_sales_difference=0,
            monthly_sales=0,
            last_month_sales=0,
            monthly_sales_difference=0
        )

    # weekly orders
    cur.execute("""
        SELECT COUNT(*) AS weekly_orders
        FROM orders
        WHERE YEARWEEK(TransactionDate, 1) = %s
    """, (latest_week,))
    weekly_orders = cur.fetchone()["weekly_orders"]

    cur.execute("""
        SELECT COUNT(*) AS last_week_orders
        FROM orders
        WHERE YEARWEEK(TransactionDate, 1) = %s
    """, (latest_week - 1,))
    last_week_orders = cur.fetchone()["last_week_orders"]

    order_difference = weekly_orders - last_week_orders

    # weekly sales
    cur.execute("""
        SELECT COALESCE(SUM(OrderPrice), 0) AS weekly_sales
        FROM orders
        WHERE YEARWEEK(TransactionDate, 1) = %s
    """, (latest_week,))
    weekly_sales = float(cur.fetchone()["weekly_sales"] or 0)

    cur.execute("""
        SELECT COALESCE(SUM(OrderPrice), 0) AS last_week_sales
        FROM orders
        WHERE YEARWEEK(TransactionDate, 1) = %s
    """, (latest_week - 1,))
    last_week_sales = float(cur.fetchone()["last_week_sales"] or 0)

    weekly_sales_difference = weekly_sales - last_week_sales

    # monthly sales
    cur.execute("""
        SELECT COALESCE(SUM(OrderPrice), 0) AS monthly_sales
        FROM orders
        WHERE YEAR(TransactionDate) = %s
          AND MONTH(TransactionDate) = %s
    """, (latest_year, latest_month))
    monthly_sales = float(cur.fetchone()["monthly_sales"] or 0)

    # previous month logic
    if latest_month == 1:
        prev_month = 12
        prev_month_year = latest_year - 1
    else:
        prev_month = latest_month - 1
        prev_month_year = latest_year

    cur.execute("""
        SELECT COALESCE(SUM(OrderPrice), 0) AS last_month_sales
        FROM orders
        WHERE YEAR(TransactionDate) = %s
          AND MONTH(TransactionDate) = %s
    """, (prev_month_year, prev_month))
    last_month_sales = float(cur.fetchone()["last_month_sales"] or 0)

    monthly_sales_difference = monthly_sales - last_month_sales

    cur.close()

    return render_template(
        "orders_and_sales.html",
        user_role=session.get("user_role"),
        weekly_orders=weekly_orders,
        last_week_orders=last_week_orders,
        order_difference=order_difference,
        weekly_sales=weekly_sales,
        last_week_sales=last_week_sales,
        weekly_sales_difference=weekly_sales_difference,
        monthly_sales=monthly_sales,
        last_month_sales=last_month_sales,
        monthly_sales_difference=monthly_sales_difference
    )



@app.route("/inventory")
@role_required("admin")
def inventory():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
# PIE CHART DATA: group by StorageType
    cur.execute("""
        SELECT 
            IFNULL(StorageType, 'Other') AS category,
            SUM(CurrentStock) AS total_stock
        FROM inventory
        WHERE status = 'active'
        GROUP BY StorageType
    """)
    category_data = cur.fetchall()

    inventory_category_labels = [row["category"] for row in category_data]
    inventory_category_values = [float(row["total_stock"]) for row in category_data]
    cur.execute("""
        SELECT SupplierID, SupplierName, SupplierCity, SupplierState, SupplierZipCode, SupplierSpecialty
        FROM suppliers
        ORDER BY SupplierName
    """)
    suppliers = cur.fetchall()

    cur.execute("""
        SELECT
            i.InventoryName,
            COALESCE(SUM(oi.Quantity), 0) AS total_ordered
        FROM inventory i
        LEFT JOIN order_items oi
            ON i.InventoryID = oi.menu_item_id
        WHERE i.status = 'active'
        GROUP BY i.InventoryID, i.InventoryName
        ORDER BY total_ordered DESC, i.InventoryName ASC
        LIMIT 5
    """)
    top_ordered_items = cur.fetchall()

    # delivery status based on supplier availability submissions in the past 2 days
    cur.execute("""
        SELECT COUNT(*) AS recent_orders
        FROM supplier_availability
        WHERE selected_date >= CURDATE() - INTERVAL 2 DAY
    """)
    recent_orders = cur.fetchone()["recent_orders"]

    delivery_status = "In-Progress" if recent_orders > 0 else "NO ORDER"

    cur.execute("""
        SELECT 
            IFNULL(StorageType, 'Other') AS category,
            SUM(CurrentStock) AS total_stock
        FROM inventory
        WHERE status = 'active'
        GROUP BY StorageType
    """)

    category_data = cur.fetchall()

    inventory_category_labels = [row["category"] for row in category_data]
    inventory_category_values = [float(row["total_stock"]) for row in category_data]
    cur.close()

    return render_template(
        "inventory.html",
        inventory_category_labels=inventory_category_labels,
        inventory_category_values=inventory_category_values,
        user_role=session.get("user_role"),
        suppliers=suppliers,
        matched_suppliers=[],
        message=None,
        top_ordered_items=top_ordered_items,
        delivery_status=delivery_status
    )
@app.route("/submit-supplier-availability", methods=["POST"])
@role_required("admin")
def submit_supplier_availability():
    supplier_search = request.form.get("supplier-search", "").strip()
    date_availability = request.form.get("date-availability", "").strip()
    time_availability = request.form.get("time-availability", "").strip()

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        SELECT SupplierID, SupplierName, SupplierCity, SupplierState, SupplierZipCode, SupplierSpecialty
        FROM suppliers
        ORDER BY SupplierName
    """)
    all_suppliers = cur.fetchall()

    matched_suppliers = []

    if supplier_search:
        cur.execute("""
            SELECT SupplierID, SupplierName, SupplierCity, SupplierState, SupplierZipCode, SupplierSpecialty
            FROM suppliers
            WHERE SupplierID = %s
        """, (supplier_search,))
        matched_suppliers = cur.fetchall()

    if matched_suppliers and date_availability and time_availability:
        cur.execute("""
            INSERT INTO supplier_availability (SupplierID, selected_date, selected_time)
            VALUES (%s, %s, %s)
        """, (supplier_search, date_availability, time_availability))
        mysql.connection.commit()
        message = "Supplier availability submitted successfully."
    elif matched_suppliers:
        message = "Please select both a date and time."
    else:
        message = "No suppliers found."

    cur.execute("""
        SELECT
            i.InventoryName,
            COALESCE(SUM(oi.Quantity), 0) AS total_ordered
        FROM inventory i
        LEFT JOIN order_items oi
            ON i.InventoryID = oi.menu_item_id
        WHERE i.status = 'active'
        GROUP BY i.InventoryID, i.InventoryName
        ORDER BY total_ordered DESC, i.InventoryName ASC
        LIMIT 5
    """)
    top_ordered_items = cur.fetchall()

    cur.execute("""
        SELECT COUNT(*) AS recent_orders
        FROM supplier_availability
        WHERE selected_date >= CURDATE() - INTERVAL 2 DAY
    """)
    recent_orders = cur.fetchone()["recent_orders"]

    delivery_status = "In-Progress" if recent_orders > 0 else "NO ORDER"

    cur.execute("""
        SELECT 
            IFNULL(StorageType, 'Other') AS category,
            SUM(CurrentStock) AS total_stock
        FROM inventory
        WHERE status = 'active'
        GROUP BY StorageType
    """)
    category_data = cur.fetchall()

    inventory_category_labels = [row["category"] for row in category_data]
    inventory_category_values = [float(row["total_stock"]) for row in category_data]

    cur.close()

    return render_template(
        "inventory.html",
        inventory_category_labels=inventory_category_labels,
        inventory_category_values=inventory_category_values,
        user_role=session.get("user_role"),
        suppliers=all_suppliers,
        matched_suppliers=matched_suppliers,
        message=message,
        top_ordered_items=top_ordered_items,
        delivery_status=delivery_status
    )
@app.route("/inventory-adjustments")
@role_required("admin")
def inventory_adjustments():
    return render_template("inventory_adjustments.html", user_role=session.get("user_role"))


# Events (admin inquiry management)
@app.route("/events")
@role_required("admin")
def events():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        SELECT COUNT(*) AS total FROM event_inquiries
        WHERE inquiry_status = 'pending'
    """)
    count = cur.fetchone()["total"]

    cur.execute("""
        SELECT * FROM event_inquiries
        WHERE inquiry_status = 'pending'
        ORDER BY created_at ASC
        LIMIT 1
    """)
    inquiry = cur.fetchone()
    cur.close()

    return render_template("events.html", inquiry=inquiry, count=count,
                           index=0, user_role=session.get("user_role"))


@app.route("/events/view/<int:index>")
@role_required("admin")
def view_event(index):
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        SELECT * FROM event_inquiries
        WHERE inquiry_status = 'pending'
        ORDER BY created_at ASC
    """)
    inquiries = cur.fetchall()
    cur.close()

    if not inquiries:
        return render_template("events.html", inquiry=None, count=0,
                               index=0, user_role=session.get("user_role"))

    index = max(0, min(index, len(inquiries) - 1))
    return render_template("events.html", inquiry=inquiries[index],
                           count=len(inquiries), index=index,
                           user_role=session.get("user_role"))


# Promos
@app.route("/admin/promos", methods=["GET"])
@role_required("admin")
def edit_promos():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        SELECT menu_item_id, name
        FROM menu_items
        ORDER BY name
    """)
    menu_items = cur.fetchall()

    cur.close()
    return render_template(
        "edit_promos.html",
        menu_items=menu_items,
        user_role=session.get("user_role")
    )


@app.route("/admin/promos/add", methods=["POST"])
@role_required("admin")
def add_promotion():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    try:
        promotion_name = (request.form.get("promotion_name") or "").strip()
        promotion_type = (request.form.get("promotion_type") or "").strip() or None
        description = (request.form.get("description") or "").strip() or None

        discount_raw = (request.form.get("discount") or "").strip()
        discount = float(discount_raw) if discount_raw else None

        start_date_raw = request.form.get("start_date") or None
        end_date_raw = request.form.get("end_date") or None
        start_time = request.form.get("start_time") or None
        end_time = request.form.get("end_time") or None
        recurring = request.form.get("recurring") or None

        menu_item_ids = request.form.getlist("menu_item_ids")
        if not menu_item_ids:
            one_item = request.form.get("menu_item_ids")
            if one_item:
                menu_item_ids = [one_item]

        if not promotion_name:
            return redirect(url_for("edit_promos"))

        cur.execute("""
            INSERT INTO promotions
            (promotion_name, promotion_type, description, discount,
             start_date, end_date, start_time, end_time, recurring_day)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            promotion_name,
            promotion_type,
            description,
            discount,
            start_date_raw,
            end_date_raw,
            start_time,
            end_time,
            recurring
        ))

        promotion_id = cur.lastrowid

        for item_id in menu_item_ids:
            cur.execute("""
                INSERT INTO promotion_items (promotion_id, menu_item_id)
                VALUES (%s, %s)
            """, (promotion_id, item_id))

        # Auto-add to calendar if date range exists.
        # Rule:
        # - no recurring day -> every day in range
        # - recurring day selected -> only matching weekday(s) in range
        if start_date_raw and end_date_raw:
            start_date = datetime.strptime(start_date_raw, "%Y-%m-%d").date()
            end_date = datetime.strptime(end_date_raw, "%Y-%m-%d").date()

            if end_date >= start_date:
                weekday_map = {
                    "Monday": 0,
                    "Tuesday": 1,
                    "Wednesday": 2,
                    "Thursday": 3,
                    "Friday": 4,
                    "Saturday": 5,
                    "Sunday": 6,
                }

                recurring_weekday = weekday_map.get(recurring) if recurring else None
                current_date = start_date

                while current_date <= end_date:
                    should_add = False

                    if recurring_weekday is None:
                        should_add = True
                    elif current_date.weekday() == recurring_weekday:
                        should_add = True

                    if should_add:
                        cur.execute("""
                            INSERT IGNORE INTO promotion_calendar (promotion_id, date)
                            VALUES (%s, %s)
                        """, (promotion_id, current_date))

                    current_date += timedelta(days=1)

        mysql.connection.commit()

    except Exception as e:
        mysql.connection.rollback()
        print("ERROR ADDING PROMO:", e)
        return redirect(url_for("edit_promos"))

    finally:
        cur.close()

    flash("Promotion successfully created", "success")
    return redirect(url_for("edit_promos"))


@app.route("/view-promos")
@role_required("admin")
def view_promos():
    status_filter = request.args.get("status", "active").strip().lower()

    if status_filter not in ["active", "inactive"]:
        status_filter = "active"

    month = request.args.get("month", type=int)
    year = request.args.get("year", type=int)

    today = datetime.today()
    if not month:
        month = today.month
    if not year:
        year = today.year

    first_weekday, dim = calendar.monthrange(year, month)

    prev_month = month - 1
    prev_year = year
    next_month = month + 1
    next_year = year

    if month == 1:
        prev_month = 12
        prev_year = year - 1

    if month == 12:
        next_month = 1
        next_year = year + 1

    month_names = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    # ✅ FIXED: calendar query WITH filter
    if status_filter == "inactive":
        cur.execute("""
            SELECT
                pc.date,
                p.promotion_id,
                p.promotion_name
            FROM promotion_calendar pc
            JOIN promotions p
                ON pc.promotion_id = p.promotion_id
            WHERE MONTH(pc.date) = %s
              AND YEAR(pc.date) = %s
              AND p.end_date < CURDATE()
            ORDER BY pc.date, p.promotion_name
        """, (month, year))
    else:
        cur.execute("""
            SELECT
                pc.date,
                p.promotion_id,
                p.promotion_name
            FROM promotion_calendar pc
            JOIN promotions p
                ON pc.promotion_id = p.promotion_id
            WHERE MONTH(pc.date) = %s
              AND YEAR(pc.date) = %s
              AND (p.end_date IS NULL OR p.end_date >= CURDATE())
            ORDER BY pc.date, p.promotion_name
        """, (month, year))

    rows = cur.fetchall()

    # ✅ FIXED: dropdown promotions WITH filter
    if status_filter == "inactive":
        cur.execute("""
            SELECT promotion_id, promotion_name
            FROM promotions
            WHERE end_date < CURDATE()
            ORDER BY promotion_name
        """)
    else:
        cur.execute("""
            SELECT promotion_id, promotion_name
            FROM promotions
            WHERE end_date IS NULL OR end_date >= CURDATE()
            ORDER BY promotion_name
        """)

    promotions = cur.fetchall()
    cur.close()

    calendar_data = {}
    for row in rows:
        day = row["date"].day
        if day not in calendar_data:
            calendar_data[day] = []

        calendar_data[day].append({
            "id": row["promotion_id"],
            "name": row["promotion_name"],
            "date": row["date"]
        })

    return render_template(
        "view_promos.html",
        calendar_data=calendar_data,
        promotions=promotions,
        month=month,
        year=year,
        dim=dim,
        first_weekday=first_weekday,
        prev_month=prev_month,
        prev_year=prev_year,
        next_month=next_month,
        next_year=next_year,
        month_names=month_names,
        status_filter=status_filter,
        user_role=session.get("user_role")
    )

@app.route("/promo/<int:promo_id>")
@role_required("admin")
def promo_details(promo_id):
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        SELECT
            promotion_id,
            promotion_name,
            promotion_type,
            description,
            discount,
            start_date,
            end_date,
            start_time,
            end_time,
            recurring_day
        FROM promotions
        WHERE promotion_id = %s
    """, (promo_id,))
    promo = cur.fetchone()

    cur.close()

    if not promo:
        return jsonify({"error": "Promo not found"}), 404

    # 🔥 FIX: convert date/time fields to strings
    for key in ["start_date", "end_date"]:
        if promo[key]:
            promo[key] = promo[key].strftime("%Y-%m-%d")

    for key in ["start_time", "end_time"]:
        if promo[key]:
            promo[key] = str(promo[key])

    return jsonify(promo)


@app.route("/delete-promo/<int:promo_id>")
@role_required("admin")
def delete_promo(promo_id):
    date = request.args.get("date")
    month = request.args.get("month")
    year = request.args.get("year")

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        DELETE FROM promotion_calendar
        WHERE promotion_id = %s
          AND date = %s
    """, (promo_id, date))

    mysql.connection.commit()
    cur.close()

    return redirect(url_for("view_promos", month=month, year=year))

@app.route("/add-promo-to-calendar", methods=["POST"])
@role_required("admin")
def add_promo_to_calendar():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    try:
        promotion_id = request.form.get("promotion_id")
        start_date = datetime.strptime(request.form.get("start_date"), "%Y-%m-%d").date()
        end_date = datetime.strptime(request.form.get("end_date"), "%Y-%m-%d").date()

        # use recurring day from this page if entered
        recurring = request.form.get("recurring") or None

        if not promotion_id:
            return redirect(url_for("view_promos"))

        if end_date < start_date:
            return redirect(url_for(
                "view_promos",
                month=start_date.month,
                year=start_date.year
            ))

        # if no recurring day was chosen on the page, fall back to the promo's saved recurring_day
        if not recurring:
            cur.execute("""
                SELECT recurring_day
                FROM promotions
                WHERE promotion_id = %s
            """, (promotion_id,))
            promo = cur.fetchone()

            if not promo:
                return redirect(url_for("view_promos"))

            recurring = promo["recurring_day"]

        weekday_map = {
            "Monday": 0,
            "Tuesday": 1,
            "Wednesday": 2,
            "Thursday": 3,
            "Friday": 4,
            "Saturday": 5,
            "Sunday": 6,
        }

        recurring_weekday = weekday_map.get(recurring) if recurring else None

        current_date = start_date
        while current_date <= end_date:
            should_add = False

            # no recurring day -> every day in range
            if recurring_weekday is None:
                should_add = True
            # recurring day selected -> only matching weekday in range
            elif current_date.weekday() == recurring_weekday:
                should_add = True

            if should_add:
                cur.execute("""
                    INSERT IGNORE INTO promotion_calendar (promotion_id, date)
                    VALUES (%s, %s)
                """, (promotion_id, current_date))

            current_date += timedelta(days=1)

        mysql.connection.commit()

        flash("Promotion successfully added to calendar", "success")

        return redirect(url_for(
            "view_promos",
            month=start_date.month,
            year=start_date.year
        ))

    except Exception as e:
        mysql.connection.rollback()
        print("ERROR ADDING TO CALENDAR:", e)
        return redirect(url_for("view_promos"))

    finally:
        cur.close()

from datetime import datetime


# =========================
# SHIFT MANAGEMENT PAGE
# =========================
@app.route("/shift-management", methods=["GET"])
@role_required("admin")
def shift_management():
    selected_staff_id = request.args.get("selected_staff_id", type=int)

    week_start_raw = request.args.get("week_start")

    if week_start_raw:
        try:
            week_start_date = datetime.strptime(week_start_raw, "%Y-%m-%d").date()
        except ValueError:
            today = date.today()
            week_start_date = today - timedelta(days=today.weekday())
    else:
        today = date.today()
        week_start_date = today - timedelta(days=today.weekday())

    week_end_date = week_start_date + timedelta(days=6)
    prev_week_start = week_start_date - timedelta(days=7)
    next_week_start = week_start_date + timedelta(days=7)

    week_label = f"Week of {week_start_date.strftime('%b %d, %Y')} - {week_end_date.strftime('%b %d, %Y')}"

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        SELECT id, name, email, role
        FROM users
        WHERE role IN ('staff', 'admin') AND active_status = 'active'
        ORDER BY name
    """)
    users = cur.fetchall()

    cur.execute("""
        SELECT id, user_id, date, role, start_hour, end_hour, color
        FROM schedule
        WHERE date BETWEEN %s AND %s
        ORDER BY date, start_hour
    """, (week_start_date, week_end_date))
    schedule_rows = cur.fetchall()

    staff_lookup = {}

    for user in users:
        staff_lookup[user["id"]] = {
            "id": user["id"],
            "name": user["name"],
            "employee_code": f"EMP{user['id']:03d}",
            "role": user["role"].title(),
            "status": "Active",
            "hours": 0,
            "availability": empty_week_dict(),
            "shifts": empty_week_dict()
        }

    for row in schedule_rows:
        user_id = row["user_id"]

        if user_id not in staff_lookup:
            continue

        day_key = day_key_from_date(row["date"])

        start = float(row["start_hour"])
        end = float(row["end_hour"])

        start_text = format_time_12hr(start)
        end_text = format_time_12hr(end)

        staff_lookup[user_id]["shifts"][day_key].append({
            "shift_id": row["id"],
            "text": f"{row['role']}: {start_text} - {end_text}"
        })

        staff_lookup[user_id]["hours"] += (end - start)

    for staff in staff_lookup.values():
        staff["hours"] = round(staff["hours"], 1)

    cur.execute("""
        SELECT user_id, day_of_week, start_time, end_time
        FROM staff_availability
        ORDER BY user_id
    """)

    for row in cur.fetchall():
        uid = row["user_id"]

        if uid in staff_lookup:
            day = row["day_of_week"]
            start = str(row["start_time"])
            end = str(row["end_time"])

            if day in staff_lookup[uid]["availability"]:
                staff_lookup[uid]["availability"][day].append(
                    f"{start[:5]}–{end[:5]}"
                )

    staff_data = list(staff_lookup.values())

    cur.execute("""
        SELECT sr.request_id, sr.request_type, sr.request_note, 
               sr.request_status, sr.created_at, u.name AS staff_name
        FROM shift_requests sr
        JOIN users u ON sr.staff_id = u.id
        WHERE sr.request_status = 'pending'
        ORDER BY sr.created_at DESC
    """)
    shift_request_rows = cur.fetchall()

    shift_requests = [
        {
            "id": row["request_id"],
            "staff_name": row["staff_name"],
            "request_type": row["request_type"],
            "text": f"{row['request_type'].title()} request: {row['request_note'] or 'No details provided'}",
            "status": row["request_status"]
        }
        for row in shift_request_rows
    ]

    cur.close()

    return render_template(
        "shift_management.html",
        staff_data=staff_data,
        shift_requests=shift_requests,
        selected_staff_id=selected_staff_id,
        week_start=week_start_date.strftime("%Y-%m-%d"),
        prev_week_start=prev_week_start.strftime("%Y-%m-%d"),
        next_week_start=next_week_start.strftime("%Y-%m-%d"),
        week_label=week_label
    )

# =========================
# UPDATE SHIFT REQUEST
# =========================
@app.route("/update-shift-request", methods=["POST"])
@role_required("admin")
def update_shift_request():
    request_id = request.form.get("request_id")
    request_status = request.form.get("request_status")

    if not request_id or request_status not in ["accepted", "declined"]:
        flash("Invalid shift request update.")
        return redirect(url_for("shift_management"))

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        UPDATE shift_requests
        SET request_status = %s
        WHERE request_id = %s
    """, (request_status, request_id))

    mysql.connection.commit()
    cur.close()

    flash(f"Shift request {request_status}.")
    return redirect(url_for("shift_management"))

# =========================
# ADD SHIFT
# =========================
@app.route("/add-shift", methods=["POST"])
@role_required("admin")
def add_shift():
    user_id = request.form.get("user_id")
    role = request.form.get("role")
    shift_day = request.form.get("shift_day")
    start_time = request.form.get("start_time")
    end_time = request.form.get("end_time")
    selected_staff_id = request.form.get("selected_staff_id") or user_id
    week_start_raw = request.form.get("week_start")

    if not user_id or not role or not shift_day or not start_time or not end_time:
        flash("Missing shift info")
        return redirect(url_for("shift_management", selected_staff_id=selected_staff_id))

    valid_days = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]

    if shift_day not in valid_days:
        flash("Invalid day selected")
        return redirect(url_for("shift_management", selected_staff_id=selected_staff_id))

    try:
        if week_start_raw:
            week_start_date = datetime.strptime(week_start_raw, "%Y-%m-%d").date()
        else:
            today = date.today()
            week_start_date = today - timedelta(days=today.weekday())

        shift_date = date_for_day_in_week(week_start_date, shift_day)

    except Exception as e:
        print("DAY ERROR:", e)
        flash("Problem finding the selected day")
        return redirect(url_for("shift_management", selected_staff_id=selected_staff_id))

    try:
        start_dt = datetime.strptime(start_time, "%H:%M")
        end_dt = datetime.strptime(end_time, "%H:%M")

        start_hour = start_dt.hour + start_dt.minute / 60
        end_hour = end_dt.hour + end_dt.minute / 60

    except Exception as e:
        print("TIME ERROR:", e)
        flash("Invalid time format")
        return redirect(url_for(
            "shift_management",
            selected_staff_id=selected_staff_id,
            week_start=week_start_date.strftime("%Y-%m-%d")
        ))

    if end_hour <= start_hour:
        flash("End time must be after start time")
        return redirect(url_for(
            "shift_management",
            selected_staff_id=selected_staff_id,
            week_start=week_start_date.strftime("%Y-%m-%d")
        ))

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        INSERT INTO schedule (user_id, role, date, start_hour, end_hour, color)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (user_id, role, shift_date, start_hour, end_hour, "#204631"))

    mysql.connection.commit()
    cur.close()

    flash("Shift added successfully")

    return redirect(url_for(
        "shift_management",
        selected_staff_id=selected_staff_id,
        week_start=week_start_date.strftime("%Y-%m-%d")
    ))

# =========================
# DELETE SHIFT
# =========================
@app.route("/delete-shift", methods=["POST"])
@role_required("admin")
def delete_shift():
    shift_id = request.form.get("shift_id")
    selected_staff_id = request.form.get("selected_staff_id")
    week_start = request.form.get("week_start")

    if not shift_id:
        flash("Missing shift ID")
        return redirect(url_for("shift_management"))

    cur = mysql.connection.cursor()

    cur.execute("DELETE FROM schedule WHERE id = %s", (shift_id,))
    mysql.connection.commit()
    cur.close()

    flash("Shift deleted successfully")

    return redirect(url_for(
        "shift_management",
        selected_staff_id=selected_staff_id,
        week_start=week_start
    ))

# =========================
# STAFF SCHEDULING ADMIN
# =========================
@app.route("/staff-scheduling-admin")
@role_required("admin")
def staff_scheduling_admin():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        SELECT name
        FROM users
        WHERE role IN ('staff', 'admin') AND active_status = 'active'
        ORDER BY name
    """)
    staff_members = [row["name"] for row in cur.fetchall()]

    cur.execute("""
        SELECT u.name, s.role, s.date, s.start_hour, s.end_hour, s.color
        FROM schedule s
        JOIN users u ON s.user_id = u.id
        ORDER BY s.date, s.start_hour
    """)
    rows = cur.fetchall()

    schedule_events = []

    for row in rows:
        schedule_events.append({
            "date": row["date"].strftime("%Y-%m-%d"),
            "staff_name": row["name"],
            "role": row["role"],
            "start": float(row["start_hour"]),
            "end": float(row["end_hour"]),
            "color": row["color"]
        })

    cur.close()

    return render_template(
        "staff_scheduling_admin.html",
        staff_members=staff_members,
        schedule_events=schedule_events
    )


@app.route("/event-details-admin")
@role_required("admin")
def event_details_admin():
    status_filter = request.args.get("status", "active").strip().lower()

    if status_filter not in ["active", "past"]:
        status_filter = "active"

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    if status_filter == "past":
        cur.execute("""
            SELECT *
            FROM event_inquiries
            WHERE inquiry_status = 'completed'
            ORDER BY preferred_datetime DESC
        """)
    else:
        cur.execute("""
            SELECT *
            FROM event_inquiries
            WHERE inquiry_status = 'approved'
            ORDER BY preferred_datetime ASC
        """)

    events = cur.fetchall()
    cur.close()

    return render_template(
        "event_details_admin.html",
        events=events,
        status_filter=status_filter,
        user_role=session.get("user_role")
    )

@app.route("/event-approve/<int:inquiry_id>", methods=["POST"])
@role_required("admin")
def approve_event(inquiry_id):
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        UPDATE event_inquiries
        SET inquiry_status = 'approved'
        WHERE inquiry_id = %s
    """, (inquiry_id,))
    mysql.connection.commit()
    cur.close()

    flash("Event was successfully accepted", "success")
    return redirect(url_for("events"))


@app.route("/event-reject/<int:inquiry_id>", methods=["POST"])
@role_required("admin")
def reject_event(inquiry_id):
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        UPDATE event_inquiries
        SET inquiry_status = 'denied'
        WHERE inquiry_id = %s
    """, (inquiry_id,))
    mysql.connection.commit()
    cur.close()

    flash("Event was successfully rejected", "danger")
    return redirect(url_for("events"))

@app.route("/event-complete/<int:inquiry_id>", methods=["POST"])
@role_required("admin")
def event_complete(inquiry_id):
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        UPDATE event_inquiries
        SET inquiry_status = 'completed'
        WHERE inquiry_id = %s
    """, (inquiry_id,))
    mysql.connection.commit()
    cur.close()

    flash("Event was completed successfully", "success")
    return redirect(url_for("event_details_admin"))

# =========================
# ADD NEW USER PAGE
# =========================
@app.route("/add-new-user", methods=["GET", "POST"])
@role_required("admin")
def add_new_user():

    if request.method == "POST":
        first_name = request.form.get("first_name", "").strip()
        last_name = request.form.get("last_name", "").strip()
        role = request.form.get("role", "").strip().lower()

        if not first_name or not last_name or role not in ["staff", "admin"]:
            flash("Please enter first name, last name, and a valid role.", "danger")
            return redirect(url_for("add_new_user"))

        full_name = f"{first_name} {last_name}"
        domain = "gtstaff.com" if role == "staff" else "gtadmin.com"

        first = first_name.lower()
        last = last_name.lower()

        cursor = mysql.connection.cursor()

        username = f"{first}@{domain}"
        email = username
        temp_password = f"{first}123"

        cursor.execute(
            "SELECT id FROM users WHERE username = %s OR email = %s",
            (username, email)
        )
        existing_user = cursor.fetchone()

        if existing_user:
            username = f"{first}{last}@{domain}"
            email = username
            temp_password = f"{first}{last}123"

            cursor.execute(
                "SELECT id FROM users WHERE username = %s OR email = %s",
                (username, email)
            )
            existing_user = cursor.fetchone()

            if existing_user:
                flash("User already exists with this name. Try a different name.", "danger")
                cursor.close()
                return redirect(url_for("add_new_user"))

        hashed_password = generate_password_hash(temp_password)

        cursor.execute("""
            INSERT INTO users (
                first_name,
                last_name,
                name,
                email,
                username,
                password,
                role,
                active_status
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            first_name,
            last_name,
            full_name,
            email,
            username,
            hashed_password,
            role,
            "active"
        ))

        mysql.connection.commit()
        cursor.close()

        flash(
            f"New {role} account created. Username: {username} | Temp Password: {temp_password}",
            "success"
        )

        return redirect(url_for("add_new_user"))

    status_filter = request.args.get("status", "active").strip().lower()

    if status_filter not in ["active", "inactive", "all"]:
        status_filter = "active"

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cursor.execute("""
        SELECT username, name
        FROM users
        WHERE active_status = 'active'
          AND role IN ('staff', 'admin')
        ORDER BY name
    """)
    users = cursor.fetchall()

    if status_filter == "all":
        cursor.execute("""
            SELECT id, first_name, last_name, role, active_status
            FROM users
            WHERE role IN ('staff', 'admin')
            ORDER BY active_status, last_name, first_name
        """)
    else:
        cursor.execute("""
            SELECT id, first_name, last_name, role, active_status
            FROM users
            WHERE active_status = %s
              AND role IN ('staff', 'admin')
            ORDER BY last_name, first_name
        """, (status_filter,))

    filtered_users = cursor.fetchall()
    cursor.close()

    return render_template(
        "add_new_user.html",
        user_role=session.get("user_role"),
        users=users,
        filtered_users=filtered_users,
        status_filter=status_filter
    )


# =========================
# MARK USER INACTIVE
# =========================
@app.route("/delete-user", methods=["POST"])
@role_required("admin")
def delete_user():
    username = request.form.get("username", "").strip()

    if not username:
        flash("Please select a user.", "danger")
        return redirect(url_for("add_new_user"))

    cursor = mysql.connection.cursor()

    cursor.execute("""
        SELECT id
        FROM users
        WHERE username = %s
          AND active_status = 'active'
    """, (username,))
    existing_user = cursor.fetchone()

    if not existing_user:
        flash("User not found or already inactive.", "danger")
        cursor.close()
        return redirect(url_for("add_new_user"))

    cursor.execute("""
        UPDATE users
        SET active_status = 'inactive'
        WHERE username = %s
    """, (username,))

    mysql.connection.commit()
    cursor.close()

    flash(f"User '{username}' marked as inactive.", "success")
    return redirect(url_for("add_new_user"))

if __name__ == "__main__":
    app.run(debug=True)
