from functools import wraps
from flask import Flask, render_template, request, redirect, url_for, session, abort

app = Flask(__name__)
app.secret_key = "replace-this-with-a-real-secret-key"


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

        # TEMP PLACEHOLDER LOGIC
        if username.endswith("@gtstaff.com"):
            session["user_role"] = "staff"
            session["username"] = username
            return redirect(url_for("staff_page"))

        elif username.endswith("@gtadmin.com"):
            session["user_role"] = "admin"
            session["username"] = username
            return redirect(url_for("admin_page"))

        else:
            session["user_role"] = "customer"
            session["username"] = username
            return redirect(url_for("home"))

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
    cur = mysql.connection.cursor()

    # Pull booked dates from the booked_events table
    cur.execute("""
        SELECT DATE(booked_datetime) AS booked_date
        FROM booked_events
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

        # Check if selected date is already booked
        requested_date = preferred_datetime.split("T")[0] if preferred_datetime else None

        if requested_date in booked_dates:
            cur.close()
            return render_template(
                "event_inquiry.html",
                user_role=session.get("user_role"),
                booked_dates=booked_dates,
                message="That date is already booked. Please choose another day."
            )

        # Save as a pending inquiry
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
        email = request.form.get("email", "").strip()
        phone = request.form.get("phone", "").strip()
        preferred_channel = request.form.get("preferredChannel", "").strip()
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "").strip()
        promo_opt_in = 1 if request.form.get("promoOptIn") else 0

        # basic validation
        if not all([first_name, last_name, birthday, email, phone, preferred_channel, username, password]):
            return render_template(
                "become_a_member.html",
                user_role=session.get("user_role"),
                message="Please fill out all required fields."
            )

        cur = mysql.connection.cursor()
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
            password,
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



@app.route("/loyalty-status")
def loyalty_status():
    user_role = session.get("user_role")
    username = session.get("username")

    # Not logged in
    if not user_role or not username:
        return render_template(
            "loyalty_status.html",
            user_role=user_role,
            logged_in=False,
            customer_view=False
        )

    # Staff/admin should not see customer loyalty info
    if user_role != "customer":
        return render_template(
            "loyalty_status.html",
            user_role=user_role,
            logged_in=True,
            customer_view=False,
            message="Loyalty status is only available for customer accounts."
        )

    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT first_name, points
        FROM members
        WHERE username = %s
    """, (username,))
    member = cur.fetchone()
    cur.close()

    points = member["points"]
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
# STAFF / ADMIN PAGES
# ========================
@app.route("/staff-page")
@role_required("staff", "admin")
def staff_page():
    return render_template("staff_page.html", user_role=session.get("user_role"))


@app.route("/admin-page")
@role_required("admin")
def admin_page():
    return render_template("admin_dashboard.html", user_role=session.get("user_role"))
@app.route("/orders-and-sales")
@role_required("admin")
def orders_and_sales():
    return render_template("orders_and_sales.html", user_role=session.get("user_role"))


@app.route("/inventory")
@role_required("admin")
def inventory():
    return render_template("inventory.html", user_role=session.get("user_role"))


@app.route("/menu")
@role_required("admin")
def menu():
    return render_template("menu.html", user_role=session.get("user_role"))


@app.route("/menu-adjustments")
@role_required("admin")
def menu_adjustments():
    return render_template("menu_adjustments.html", user_role=session.get("user_role"))

@app.route("/loyalty-program")
@role_required("admin")
def loyalty_program():
    return render_template("loyalty_program.html", user_role=session.get("user_role"))


@app.route("/staff-scheduling-admin")
@role_required("admin")
def staff_scheduling_admin():
    return render_template("staff_scheduling_admin.html", user_role=session.get("user_role"))


@app.route("/shift-management")
@role_required("admin")
def shift_management():
    return render_template("shift_management.html", user_role=session.get("user_role"))

@app.route("/edit-promos")
@role_required("admin")
def edit_promos():
   return render_template("edit_promos.html", user_role=session.get("user_role"))

@app.route("/view-promos")
@role_required("admin")
def view_promos():
   return render_template("view_promos.html", user_role=session.get("user_role"))

@app.route("/events-admin")
@role_required("admin")
def events_admin():
   return render_template("events.html", user_role=session.get("user_role"))




if __name__ == "__main__":
    app.run(debug=True)
