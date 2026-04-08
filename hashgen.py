from werkzeug.security import generate_password_hash

print("John Smith:")
print(generate_password_hash("john123"))

print("\nGrace Pat:")
print(generate_password_hash("grace123"))

print("\nAlyssa Chen:")
print(generate_password_hash("alyssa123"))

print("\nMatt Johnson:")
print(generate_password_hash("matt123"))