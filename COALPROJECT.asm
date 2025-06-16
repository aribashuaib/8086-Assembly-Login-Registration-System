ORG 100h

MOV AH, 09
MOV DX, OFFSET msg_welcome
INT 21h

MOV AH, 09
MOV DX, OFFSET msg_check_reg
INT 21h

; Read Y/N input
MOV AH, 1
INT 21h
CMP AL, 'Y'
JE login_process
CMP AL, 'y'
JE login_process
JMP register_process

; ----------------- REGISTER -----------------
register_process:
MOV AH, 09
MOV DX, OFFSET msg_role
INT 21h
MOV AH, 1
INT 21h
MOV reg_role, AL

MOV AH, 09
MOV DX, OFFSET msg_user_reg
INT 21h

MOV SI, OFFSET input_user
MOV CX, 0
read_user_reg:
    MOV AH, 1
    INT 21h
    CMP AL, 13
    JE done_user_reg
    MOV [SI], AL
    INC SI
    INC CX
    CMP CX, 5
    JL read_user_reg
done_user_reg:
    MOV BYTE PTR [SI], 0

read_pass_again:
MOV AH, 09
MOV DX, OFFSET msg_pass_reg
INT 21h

MOV SI, OFFSET input_pass
MOV CX, 0
MOV DI, 0  ; digit flag
MOV BX, 0  ; upper flag
read_pass_reg:
    MOV AH, 1
    INT 21h
    CMP AL, 13
    JE done_pass_reg
    MOV [SI], AL
    ; check digit
    CMP AL, '0'
    JB not_digit
    CMP AL, '9'
    JA not_digit
    MOV DI, 1
not_digit:
    ; check uppercase
    CMP AL, 'A'
    JB not_upper
    CMP AL, 'Z'
    JA not_upper
    MOV BX, 1
not_upper:
    INC SI
    INC CX
    CMP CX, 5
    JL read_pass_reg
done_pass_reg:
    MOV BYTE PTR [SI], 0

    ; check weak password
    CMP DI, 0
    JE weak_pass
    CMP BX, 0
    JE weak_pass

MOV AH, 09
MOV DX, OFFSET msg_reg_success
INT 21h
MOV login_from_reg, 1
JMP login_process

weak_pass:
MOV AH, 09
MOV DX, OFFSET msg_weak
INT 21h
JMP read_pass_again

; ----------------- LOGIN -----------------
login_process:
MOV CX, 3 ; 3 attempts
login_try:
MOV AH, 09
MOV DX, OFFSET msg_user
INT 21h

MOV SI, OFFSET temp_user
MOV BX, 0
read_user:
    MOV AH, 1
    INT 21h
    CMP AL, 13
    JE done_user
    MOV [SI], AL
    INC SI
    INC BX
    CMP BX, 5
    JL read_user
done_user:
    MOV BYTE PTR [SI], 0

MOV AH, 09
MOV DX, OFFSET msg_pass
INT 21h

MOV SI, OFFSET temp_pass
MOV BX, 0
read_pass:
    MOV AH, 1
    INT 21h
    CMP AL, 13
    JE done_pass
    MOV [SI], AL
    INC SI
    INC BX
    CMP BX, 5
    JL read_pass
done_pass:
    MOV BYTE PTR [SI], 0

; compare username
MOV SI, OFFSET temp_user
MOV DI, OFFSET input_user
compare_user:
    MOV AL, [SI]
    MOV BL, [DI]
    CMP AL, BL
    JNE try_hardcoded
    CMP AL, 0
    JE check_pass
    INC SI
    INC DI
    JMP compare_user

check_pass:
MOV login_from_reg, 1
MOV SI, OFFSET temp_pass
MOV DI, OFFSET input_pass
compare_pass:
    MOV AL, [SI]
    MOV BL, [DI]
    CMP AL, BL
    JNE try_hardcoded
    CMP AL, 0
    JE login_success
    INC SI
    INC DI
    JMP compare_pass

; ----------------- Check Hardcoded -----------------
try_hardcoded:
MOV SI, OFFSET temp_user
MOV DI, OFFSET hard_user
compare_user2:
    MOV AL, [SI]
    MOV BL, [DI]
    CMP AL, BL
    JNE wrong
    CMP AL, 0
    JE check_pass2
    INC SI
    INC DI
    JMP compare_user2

check_pass2:
MOV login_from_reg, 0
MOV SI, OFFSET temp_pass
MOV DI, OFFSET hard_pass
compare_pass2:
    MOV AL, [SI]
    MOV BL, [DI]
    CMP AL, BL
    JNE wrong
    CMP AL, 0
    JE login_success
    INC SI
    INC DI
    JMP compare_pass2

wrong:
DEC CX
CMP CX, 0
JE login_fail
JMP login_try

login_success:
MOV AH, 09
MOV AL, login_from_reg
CMP AL, 1
JE check_role
MOV DX, OFFSET msg_user_login
JMP user_dashboard

check_role:
CMP reg_role, 'A'
JE show_admin
CMP reg_role, 'a'
JE show_admin
MOV DX, OFFSET msg_user_login
JMP user_dashboard

show_admin:
MOV DX, OFFSET msg_admin_login
INT 21h

admin_menu:
MOV AH, 09
MOV DX, OFFSET msg_admin_tasks
INT 21h
MOV AH, 09
MOV DX, OFFSET msg_choice
INT 21h
MOV AH, 1
INT 21h
CMP AL, '1'
JE admin_view_users
CMP AL, '2'
JE admin_delete_user
CMP AL, '3'
JE admin_view_roles
CMP AL, '4'
JE exit
JMP admin_menu

admin_view_users:
MOV AH, 09
MOV DX, OFFSET msg_admin_view_users
INT 21h
JMP admin_menu

admin_delete_user:
MOV AH, 09
MOV DX, OFFSET msg_admin_delete_user
INT 21h
JMP admin_menu

admin_view_roles:
MOV AH, 09
MOV DX, OFFSET msg_admin_view_roles
INT 21h
JMP admin_menu

user_dashboard:
INT 21h
MOV AH, 09
MOV DX, OFFSET msg_user_tasks
INT 21h

user_menu:
MOV AH, 09
MOV DX, OFFSET msg_choice
INT 21h
MOV AH, 1
INT 21h
CMP AL, '1'
JE user_view_profile
CMP AL, '2'
JE user_edit_info
CMP AL, '3'
JE user_browse_content
CMP AL, '4'
JE exit
JMP user_menu

user_view_profile:
MOV AH, 09
MOV DX, OFFSET msg_user_view_profile
INT 21h
JMP user_menu

user_edit_info:
MOV AH, 09
MOV DX, OFFSET msg_user_edit_info
INT 21h
JMP user_menu

user_browse_content:
MOV AH, 09
MOV DX, OFFSET msg_user_browse_content
INT 21h
JMP user_menu

login_fail:
MOV AH, 09
MOV DX, OFFSET msg_fail
INT 21h

exit:
MOV AH, 4Ch
INT 21h

msg_welcome DB 13,10, 'Welcome to the Login System $'
msg_check_reg DB 13,10, 'Are you already registered? (Y/N): $'
msg_role DB 13,10, 'Are you an Admin or User? (A/U): $'
msg_user DB 13,10,'Enter Username: $'
msg_pass DB 13,10,'Enter Password: $'
msg_user_reg DB 13,10,'Register Username: $'
msg_pass_reg DB 13,10,'Register Password: $'
msg_reg_success DB 13,10,'Registration Successful! Please login below.$'
msg_success DB 13,10,'Login Successful!$'
msg_fail DB 13,10,'Login Failed! No attempts left.$'
msg_weak DB 13,10,'Weak password! Must include 1 digit and 1 uppercase.$'
msg_admin_login DB 13,10,'Login Successful! Welcome Admin.$'
msg_user_login DB 13,10,'Login Successful! Welcome User.$'
msg_admin_tasks DB 13,10,'[Admin Panel]\n1. View Users\n2. Delete User\n3. View Roles\n4. Exit$'
msg_user_tasks DB 13,10,'[User Dashboard]\n1. View Profile\n2. Edit Info\n3. Browse Content\n4. Exit$'
msg_choice DB 13,10,'Enter your choice: $'
msg_admin_view_users DB 13,10,'[Admin] Registered users: user1, user2, user3 $'
msg_admin_delete_user DB 13,10,'[Admin] Delete User feature (not implemented) $'
msg_admin_view_roles DB 13,10,'[Admin] Roles: user1 - U, user2 - A $'
msg_user_view_profile DB 13,10,'[User] Profile: Username: user1 | Role: U $'
msg_user_edit_info DB 13,10,'[User] Edit Info (not implemented) $'
msg_user_browse_content DB 13,10,'[User] Browsing content... $'

input_user DB 6 DUP(0)
input_pass DB 6 DUP(0)
temp_user DB 6 DUP(0)
temp_pass DB 6 DUP(0)
reg_role DB ?
login_from_reg DB 0

hard_user DB 'ADMIN',0
hard_pass DB '1234A',0

END