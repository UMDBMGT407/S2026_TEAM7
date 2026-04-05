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


@app.route("/event-inquiry")
def event_inquiry():
    return render_template("event_inquiry.html", user_role=session.get("user_role"))


@app.route("/become-a-member")
def become_a_member():
    return render_template("become_a_member.html", user_role=session.get("user_role"))


@app.route("/loyalty-status")
def loyalty_status():
    return render_template("loyalty_status.html", user_role=session.get("user_role"))


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


if __name__ == "__main__":
    app.run(debug=True)
