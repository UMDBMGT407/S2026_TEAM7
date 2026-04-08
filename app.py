from functools import wraps
from flask import Flask, render_template, request, redirect, url_for, session, abort, flash
from flask_mysqldb import MySQL
import MySQLdb.cursors
from datetime import datetime, timedelta, date
import calendar
from flask import jsonify
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = "replace-this-with-a-real-secret-key"
app.config["SESSION_PERMANENT"] = False

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'INSERT YOUR PASSWORD'
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
        "Monday": [],
        "Tuesday": [],
        "Wednesday": [],
        "Thursday": [],
        "Friday": [],
        "Saturday": [],
        "Sunday": []
    }

def day_key_from_date(date_value):
    if isinstance(date_value, str):
        date_value = datetime.strptime(date_value, "%Y-%m-%d")
    return date_value.strftime("%A")

def format_time_12hr(hour_value):
    hour_value = float(hour_value)
    hour = int(hour_value)
    minute = int((hour_value - hour) * 60)

    dt = datetime.strptime(f"{hour}:{minute:02d}", "%H:%M")
    return dt.strftime("%I:%M %p").lstrip("0")

def next_date_for_day(day_name):
    days = {
        "Monday": 0,
        "Tuesday": 1,
        "Wednesday": 2,
        "Thursday": 3,
        "Friday": 4,
        "Saturday": 5,
        "Sunday": 6
    }

    today = datetime.today()
    target_day = days[day_name]
    days_ahead = target_day - today.weekday()

    if days_ahead < 0:
        days_ahead += 7

    next_day = today + timedelta(days=days_ahead)
    return next_day.strftime("%Y-%m-%d")

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
        cur.execute("""
            SELECT id, first_name, last_name, name, email, username, password, role
            FROM users
            WHERE email = %s OR username = %s
            LIMIT 1
        """, (username, username))
        user = cur.fetchone()
        cur.close()

        if user and check_password_hash(user["password"], password):
            session.permanent = False
            session["user_id"] = user["id"]
            session["user_role"] = user["role"]
            session["username"] = user["username"] or user["email"]
            session["name"] = user["name"]

            if user["role"] == "admin":
                return redirect(url_for("dashboard"))
            elif user["role"] == "staff":
                return redirect(url_for("staff_scheduling_staff"))
            elif user["role"] == "customer":
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
    return render_template("index.html", user_role=session.get("user_role"))


@app.route("/online-ordering")
def online_ordering():
    return render_template("online_ordering.html", user_role=session.get("user_role"))


@app.route("/cart")
def cart():
    return render_template("cart.html", user_role=session.get("user_role"))


@app.route("/checkout")
def checkout():
    return render_template("checkout.html", user_role=session.get("user_role"))


@app.route("/event-inquiry", methods=["GET", "POST"])
def event_inquiry():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        SELECT DATE(booked_datetime) AS booked_date
        FROM booked_events
    """)
    booked_date_rows = cur.fetchall()
    booked_dates = [str(row["booked_date"]) for row in booked_date_rows if row["booked_date"]]

    if request.method == "POST":
        full_name          = request.form.get("fullName", "").strip()
        organization       = request.form.get("organization", "").strip()
        guests             = request.form.get("guests", "").strip()
        email              = request.form.get("email", "").strip()
        phone              = request.form.get("phone", "").strip()
        preferred_datetime = request.form.get("preferredDateTime", "").strip()
        event_description  = request.form.get("eventDescription", "").strip()
        catering_package   = request.form.get("cateringPackage", "").strip()

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
        """, (full_name, organization, guests, email, phone,
              preferred_datetime, event_description, catering_package, "pending"))
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
        first_name        = request.form.get("firstName", "").strip()
        last_name         = request.form.get("lastName", "").strip()
        birthday          = request.form.get("birthday", "").strip()
        email             = request.form.get("email", "").strip()
        phone             = request.form.get("phone", "").strip()
        preferred_channel = request.form.get("preferredChannel", "").strip()
        username          = request.form.get("username", "").strip()
        password          = request.form.get("password", "").strip()
        promo_opt_in      = 1 if request.form.get("promoOptIn") else 0

        if not all([first_name, last_name, birthday, email, phone, preferred_channel, username, password]):
            return render_template(
                "become_a_member.html",
                user_role=session.get("user_role"),
                message="Please fill out all required fields."
            )

        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.execute("""
            INSERT INTO members
            (first_name, last_name, date_of_birth, email, phone, preferred_channel, username, password, promo_opt_in)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (first_name, last_name, birthday, email, phone,
              preferred_channel, username, password, promo_opt_in))
        mysql.connection.commit()
        cur.close()

        return render_template(
            "become_a_member.html",
            user_role=session.get("user_role"),
            message="Account created successfully."
        )

    return render_template("become_a_member.html", user_role=session.get("user_role"))


@app.route("/loyalty-status")
def loyalty_status():
    user_role = session.get("user_role")
    username  = session.get("username")

    if not user_role or not username:
        return render_template(
            "loyalty_status.html",
            user_role=user_role,
            logged_in=False,
            customer_view=False
        )

    if user_role != "customer":
        return render_template(
            "loyalty_status.html",
            user_role=user_role,
            logged_in=True,
            customer_view=False,
            message="Loyalty status is only available for customer accounts."
        )

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("SELECT first_name, points FROM members WHERE username = %s", (username,))
    member = cur.fetchone()
    cur.close()

    points            = member["points"]
    redeemable_credit = points / 100

    return render_template(
        "loyalty_status.html",
        user_role=user_role,
        logged_in=True,
        customer_view=True,
        first_name=member["first_name"],
        points=points,
        redeemable_credit=redeemable_credit
    )


# ========================
# STAFF PAGES
# ========================
@app.route("/staff-scheduling-staff")
@role_required("staff", "admin")
def staff_scheduling_staff():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("SELECT DISTINCT name FROM users WHERE role IN ('staff', 'admin')")
    staff_members = [row["name"] for row in cur.fetchall()]
    cur.execute("SELECT date, role, start_hour, end_hour, color FROM schedule")
    schedule_events = [
        {
            'date':  str(row["date"]),
            'role': row["role"],
            'start': float(row["start_hour"]),
            'end':   float(row["end_hour"]),
            'color': row["color"]
        }
        for row in cur.fetchall()
    ]
    cur.close()
    # Admins see admin navbar, staff see staff navbar
    template = "staff_scheduling_admin.html" if session.get("user_role") == "admin" else "staff_scheduling_staff.html"
    return render_template(template, staff_members=staff_members,
                           schedule_events=schedule_events,
                           user_role=session.get("user_role"))


@app.route("/event-details")
@role_required("staff", "admin")
def event_details_staff():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("SELECT id, type, name, email, guests, date, time, description FROM events")
    event_rows = cur.fetchall()
    events = []
    for row in event_rows:
        cur.execute("""
            SELECT u.name FROM users u
            JOIN event_staff es ON u.id = es.user_id
            WHERE es.event_id = %s
        """, (row["id"],))
        staff = [s["name"] for s in cur.fetchall()]
        events.append({
            'id':          row["id"],
            'type':        row["type"],
            'name':        row["name"],
            'email':       row["email"],
            'guests':      row["guests"],
            'date':        str(row["date"]),
            'time':        row["time"],
            'description': row["description"],
            'staff':       staff
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
        " s.role, e.type AS event"
        " FROM schedule s"
        " LEFT JOIN events e ON s.event_id = e.id"
        " WHERE s.user_id = %s AND s.date >= CURDATE()"
        " ORDER BY s.date ASC",
        (session.get("user_id"),)
    )
    rows = cur.fetchall()
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
                           user_role=session.get("user_role"))


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
    return render_template("menu.html", user_role=session.get("user_role"))
@app.route("/remove-seasonal-item", methods=["POST"])
@role_required("admin")
def remove_seasonal_item():
    item_name = request.form.get("item_name", "").strip()

    if not item_name:
        return jsonify({"success": False, "message": "Missing item name."}), 400

    cur = mysql.connection.cursor()
    cur.execute("""
        UPDATE menu_items
        SET category = 'regular'
        WHERE name = %s
    """, (item_name,))
    mysql.connection.commit()

    affected_rows = cur.rowcount
    cur.close()

    if affected_rows == 0:
        return jsonify({"success": False, "message": f"No item found for {item_name}."}), 404

    return jsonify({"success": True})


@app.route("/menu-adjustments")
@role_required("admin")
def menu_adjustments():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        SELECT menu_item_id, name, category, price
        FROM menu_items
        ORDER BY category, name
    """)

    menu_items = cur.fetchall()
    cur.close()

    return render_template(
        "menu_adjustments.html",
        menu_items=menu_items,
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
        INSERT INTO menu_items (name, category, price)
        VALUES (%s, %s, %s)
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
        DELETE FROM menu_items
        WHERE menu_item_id = %s
    """, (menu_item_id,))

    mysql.connection.commit()
    cur.close()

    return redirect(url_for("menu_adjustments"))


# Orders
@app.route("/orders-and-sales")
@role_required("admin")
def orders_and_sales():
    return render_template("orders_and_sales.html", user_role=session.get("user_role"))


@app.route("/inventory")
@role_required("admin")
def inventory():
    return render_template("inventory.html", user_role=session.get("user_role"))

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
        WHERE SupplierName LIKE %s
    """, (f"%{supplier_search}%",))

    suppliers = cur.fetchall()

    message = None

    if suppliers:
        message = "Supplier(s) found. Availability recorded (simulated)."
    else:
        message = "No suppliers found."

    cur.close()

    return render_template(
        "inventory.html",
        user_role=session.get("user_role"),
        suppliers=suppliers,
        message=message
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


@app.route("/event-approve/<int:inquiry_id>")
@role_required("admin")
def approve_event(inquiry_id):
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("SELECT preferred_datetime FROM event_inquiries WHERE inquiry_id = %s", (inquiry_id,))
    inquiry = cur.fetchone()
    if inquiry:
        cur.execute("""
            INSERT INTO booked_events (inquiry_id, booked_datetime)
            VALUES (%s, %s)
        """, (inquiry_id, inquiry["preferred_datetime"]))
        cur.execute("""
            UPDATE event_inquiries SET inquiry_status = 'approved'
            WHERE inquiry_id = %s
        """, (inquiry_id,))
    mysql.connection.commit()
    cur.close()
    return redirect(url_for("events"))


@app.route("/event-reject/<int:inquiry_id>")
@role_required("admin")
def reject_event(inquiry_id):
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        UPDATE event_inquiries SET inquiry_status = 'rejected'
        WHERE inquiry_id = %s
    """, (inquiry_id,))
    mysql.connection.commit()
    cur.close()
    return redirect(url_for("events"))


# LOYALTY PROGRAM
@app.route("/loyalty-program")
@role_required("admin")
def loyalty_program():
    return render_template("loyalty_program.html", member=None, status_tier="")


@app.route("/loyalty-program/search", methods=["POST"])
@role_required("admin")
def loyalty_program_search():
    member_id = request.form["member_id"]

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        SELECT member_id, customer_id, customer_name, phone, email,
               date_of_birth, join_date, points
        FROM loyalty_program
        WHERE member_id = %s
    """, (member_id,))
    member = cur.fetchone()
    cur.close()

    if not member:
        flash("No loyalty member found with that ID.")
        return redirect(url_for("loyalty_program"))

    points = member["points"] if member["points"] is not None else 0

    if points >= 1000:
        status_tier = "Gold"
    elif points >= 500:
        status_tier = "Silver"
    else:
        status_tier = "Bronze"

    return render_template("loyalty_program.html", member=member, status_tier=status_tier)


@app.route("/loyalty-program/update", methods=["POST"])
@role_required("admin")
def loyalty_program_update():
    member_id = request.form["member_id"]
    customer_name = request.form["customer_name"]
    phone = request.form["phone"]
    email = request.form["email"]

    cur = mysql.connection.cursor()
    cur.execute("""
        UPDATE loyalty_program
        SET customer_name = %s,
            phone = %s,
            email = %s
        WHERE member_id = %s
    """, (customer_name, phone, email, member_id))
    mysql.connection.commit()
    cur.close()

    flash("Loyalty member updated successfully.")
    return redirect(url_for("loyalty_program_search"), code=307)


@app.route("/loyalty-program/delete", methods=["POST"])
@role_required("admin")
def loyalty_program_delete():
    member_id = request.form["member_id"]

    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM loyalty_program WHERE member_id = %s", (member_id,))
    mysql.connection.commit()
    cur.close()

    flash("Loyalty member deleted successfully.")
    return redirect(url_for("loyalty_program"))


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

    return redirect(url_for("view_promos"))


@app.route("/view-promos")
@role_required("admin")
def view_promos():
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
        ORDER BY pc.date, p.promotion_name
    """, (month, year))
    rows = cur.fetchall()

    cur.execute("""
        SELECT promotion_id, promotion_name
        FROM promotions
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

        # redirect to the month where the promotion starts
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

# =========================
# SHIFT MANAGEMENT PAGE
# =========================
@app.route("/shift-management", methods=["GET"])
def shift_management():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    # GET USERS
    cur.execute("""
        SELECT id, name, email, role
        FROM users
        WHERE role IN ('staff', 'admin')
        ORDER BY name
    """)
    users = cur.fetchall()

    # GET SCHEDULE
    cur.execute("""
        SELECT id, user_id, date, start_hour, end_hour, color
        FROM schedule
        ORDER BY date
    """)
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
            "text": f"{start_text} - {end_text}"
        })

        staff_lookup[user_id]["hours"] += (end - start)

    for staff in staff_lookup.values():
        for day in staff["shifts"]:
            if staff["shifts"][day]:
                staff["availability"][day] = [s["text"] for s in staff["shifts"][day]]
            else:
                staff["availability"][day] = ["Unavailable"]

        staff["hours"] = round(staff["hours"], 1)

    staff_data = list(staff_lookup.values())

    shift_requests = []

    cur.close()

    return render_template(
        "shift_management.html",
        staff_data=staff_data,
        shift_requests=shift_requests
    )


# =========================
# ADD SHIFT
# =========================

@app.route("/add-shift", methods=["POST"])
def add_shift():
    user_id = request.form.get("user_id")
    role = request.form.get("role")
    shift_day = request.form.get("shift_day")
    start_time = request.form.get("start_time")
    end_time = request.form.get("end_time")

    if not user_id or not role or not shift_day or not start_time or not end_time:
        flash("Missing shift info")
        return redirect(url_for("shift_management"))

    try:
        shift_date = next_date_for_day(shift_day)

        start_hour = int(start_time.split(":")[0]) + int(start_time.split(":")[1]) / 60
        end_hour = int(end_time.split(":")[0]) + int(end_time.split(":")[1]) / 60
    except:
        flash("Invalid time format")
        return redirect(url_for("shift_management"))

    if end_hour <= start_hour:
        flash("End must be after start")
        return redirect(url_for("shift_management"))

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        INSERT INTO schedule (user_id, role, date, start_hour, end_hour, color)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (user_id, role, shift_date, start_hour, end_hour, "#204631"))

    mysql.connection.commit()
    cur.close()

    flash("Shift added")
    return redirect(url_for("shift_management"))


# =========================
# DELETE SHIFT
# =========================

@app.route("/delete-shift", methods=["POST"])
def delete_shift():
    shift_id = request.form.get("shift_id")

    if not shift_id:
        flash("Missing shift ID")
        return redirect(url_for("shift_management"))

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("DELETE FROM schedule WHERE id = %s", (shift_id,))
    mysql.connection.commit()

    cur.close()

    flash("Shift deleted")
    return redirect(url_for("shift_management"))


# =========================
# UPDATE REQUEST (OPTIONAL)
# =========================

@app.route("/update-shift-request", methods=["POST"])
def update_shift_request():
    request_id = request.form.get("request_id")
    request_status = request.form.get("request_status")

    if not request_id:
        return redirect(url_for("shift_management"))

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        UPDATE shift_requests
        SET request_status = %s
        WHERE request_id = %s
    """, (request_status, request_id))

    mysql.connection.commit()
    cur.close()

    return redirect(url_for("shift_management"))

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
        WHERE role IN ('staff', 'admin')
        ORDER BY name
    """)
    staff_members = [row["name"] for row in cur.fetchall()]

    cur.execute("""
        SELECT u.name, s.date, s.start_hour, s.end_hour, s.color
        FROM schedule s
        JOIN users u ON s.user_id = u.id
        ORDER BY s.date, s.start_hour
    """)
    rows = cur.fetchall()

    schedule_events = []

    for row in rows:
        schedule_events.append({
            "date": row["date"].strftime("%Y-%m-%d"),
            "title": row["name"],
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
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        SELECT
            b.event_id,
            b.booked_datetime,
            e.inquiry_id,
            e.full_name,
            e.organization,
            e.email,
            e.phone,
            e.guests,
            e.event_description,
            e.catering_package,
            e.inquiry_status
        FROM booked_events b
        JOIN event_inquiries e
            ON b.inquiry_id = e.inquiry_id
        ORDER BY b.booked_datetime ASC
    """)

    events = cur.fetchall()
    cur.close()

    return render_template(
        "event_details_admin.html",
        events=events,
        user_role=session.get("user_role")
    )

@app.route("/event-complete/<int:event_id>")
@role_required("admin")
def complete_event(event_id):
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cur.execute("""
        DELETE FROM booked_events
        WHERE event_id = %s
    """, (event_id,))

    mysql.connection.commit()
    cur.close()

    return redirect(url_for("event_details_admin"))

if __name__ == "__main__":
    app.run(debug=True)
