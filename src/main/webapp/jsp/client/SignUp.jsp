<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - KS.Studio</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Poppins:wght@300;400;500;600;700&family=Josefin+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root { --primary-color: #2f5d50; --accent-color: #d4a574; }
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #2f5d50 0%, #1a3a32 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .signup-container {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            width: 100%;
            max-width: 500px;
        }
        .signup-header {
            background: var(--primary-color);
            color: #fff;
            padding: 30px;
            text-align: center;
        }
        .signup-header h1 {
            font-family: 'Josefin Sans', sans-serif;
            font-size: 1.8rem;
            margin-bottom: 5px;
        }
        .signup-body { padding: 30px; }
        .form-group { margin-bottom: 18px; }
        .form-group label {
            font-family: 'Poppins', sans-serif;
            font-weight: 500;
            color: #333;
            margin-bottom: 6px;
            display: block;
            font-size: 0.9rem;
        }
        .form-control {
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            padding: 10px 15px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(47, 93, 80, 0.1);
        }
        .btn-signup {
            background: var(--primary-color);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-size: 1rem;
            font-weight: 600;
            width: 100%;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
        }
        .btn-signup:hover {
            background: #234a40;
            transform: translateY(-2px);
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
        }
        .login-link a {
            color: var(--primary-color);
            font-weight: 600;
            text-decoration: none;
        }
        .alert { border-radius: 10px; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="signup-container">
        <div class="signup-header">
            <h1><i class="bi bi-camera"></i> KS.STUDIO</h1>
            <p>Create your account</p>
        </div>
        
        <div class="signup-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/SignUpController" method="post">
                <div class="form-group">
                    <label for="name">Full Name *</label>
                    <input type="text" class="form-control" id="name" name="name" placeholder="Enter your full name" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email Address *</label>
                    <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                </div>
                
                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" class="form-control" id="phone" name="phone" placeholder="Enter your phone number">
                </div>
                
                <div class="form-group">
                    <label for="address">Address</label>
                    <input type="text" class="form-control" id="address" name="address" placeholder="Enter your address">
                </div>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="password">Password *</label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Min 6 characters" required minlength="6">
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="confirmPassword">Confirm Password *</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required>
                        </div>
                    </div>
                </div>
                
                <button type="submit" class="btn-signup">Create Account</button>
            </form>
            
            <div class="login-link">
                <p>Already have an account? <a href="${pageContext.request.contextPath}/jsp/client/SignIn.jsp">Sign In</a></p>
            </div>
        </div>
    </div>
</body>
</html>
