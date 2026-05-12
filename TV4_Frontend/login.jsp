<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng nhập hệ thống</title>
    <style>
        body {
            margin: 0; padding: 0; display: flex;
            justify-content: center; align-items: center;
            height: 100vh; background-color: #f0f2f5;
            font-family: Arial, sans-serif;
        }
        .login-card {
            background: white; padding: 30px;
            border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            width: 350px; text-align: center;
        }
        h2 { color: #333; margin-bottom: 20px; }
        input {
            width: 100%; padding: 12px; margin: 10px 0;
            border: 1px solid #ccc; border-radius: 5px;
            box-sizing: border-box;
        }
        button {
            width: 100%; padding: 12px;
            background-color: #007bff; border: none;
            border-radius: 5px; color: white;
            font-size: 16px; cursor: pointer; margin-top: 10px;
        }
        button:hover { background-color: #0056b3; }
        .error { color: red; font-size: 14px; margin-bottom: 10px; }
        .register-link { margin-top: 15px; font-size: 14px; color: #555; }
        .register-link a { color: #007bff; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>
    <div class="login-card">
        <h2>Đăng nhập</h2>
        <div class="error">${error}</div> 
        <form action="LoginServlet" method="POST">
            <input type="text" name="user" placeholder="Username" required>
            <input type="password" name="pass" placeholder="Password" required>
            <button type="submit">Đăng nhập</button>
        </form>
        
        <!-- Dòng mới thêm vào theo yêu cầu của bạn -->
        <div class="register-link">
            Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay tại đây</a>
        </div>
    </div>
</body>
</html>