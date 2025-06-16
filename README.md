# 8086-Assembly-Login-Registration-System
# Basic Authentication System in 8086 Assembly

This project is a **simple login and registration system** implemented in **8086 Assembly language** using **Emu8086**. It demonstrates user interaction via the keyboard and screen, simulates role-based login (Admin/User), validates weak passwords, and restricts access based on login attempts.

## 📌 Features

- Welcome prompt with registration check (Y/N)
- **New User Registration**:
  - Choose role: Admin or User
  - Enter username (max 5 characters)
  - Enter password (must contain at least **1 digit** and **1 uppercase** letter)
- **Login Process**:
  - Accepts credentials (username/password)
  - Compares with both **registered** and **hardcoded** values
  - Allows **3 login attempts**
- **Role-Based Dashboards**:
  - Admin Panel: View Users, Delete User (not implemented), View Roles
  - User Dashboard: View Profile, Edit Info (not implemented), Browse Content

## 🛠 Requirements

- **Emu8086** (or any other 8086-compatible assembler/emulator)

## 📂 File Structure

- `login.asm` – Main source file containing the entire authentication system code.
- `README.md` – Project documentation.

## 🔑 Hardcoded Credentials (for testing)

| Username | Password |
|----------|----------|
| ADMIN    | 1234A    |

## 📥 How to Run

1. Open `login.asm` in **Emu8086**.
2. Compile and run the program.
3. Follow on-screen instructions for registration or login.

## 🔐 Password Rules

- Password must include at least:
  - **One digit** (0-9)
  - **One uppercase letter** (A-Z)
- Minimum length: **5 characters**
- Weak passwords will be rejected during registration.

## 📸 Preview (Console)

```text
Welcome to the Login System
Are you already registered? (Y/N):
...
Login Successful! Welcome User.
