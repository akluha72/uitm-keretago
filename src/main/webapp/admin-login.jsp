<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- admin-login.jsp -->
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>KeretaGO (admin)</title>

        <link rel="icon" type="image/svg+xml" href="/vite.svg" />
        <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/open-iconic-bootstrap.min.css">
        <link rel="stylesheet" href="css/animate.css">
        <link rel="stylesheet" href="css/owl.carousel.min.css">
        <link rel="stylesheet" href="css/owl.theme.default.min.css">
        <link rel="stylesheet" href="css/magnific-popup.css">
        <link rel="stylesheet" href="css/ionicons.min.css">
        <link rel="stylesheet" href="css/bootstrap-datepicker.css">
        <link rel="stylesheet" href="css/jquery.timepicker.css">
        <link rel="stylesheet" href="css/flaticon.css">
        <link rel="stylesheet" href="css/icomoon.css">
        <link rel="stylesheet" href="css/admin.css">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <div class="login-box">
            <h2>Admin Login</h2>
            <form method="post" action="admin-login">
                <input type="text" placeholder="Username" name="email" class="form-control mb-3" required>
                <input type="password" placeholder="Password" name="password" class="form-control mb-3" required>
                <input type="submit" value="Login">
                <p style="color:red">${error}</p>
            </form>
        </div>
    </body>
</html>
