<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Booking"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>My Booking</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

        <style>
            .booking-card { margin-bottom: 20px; }
            .modal-backdrop { z-index: 0; }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <a href="http://localhost:8080/keretaGo/car.jsp" class="btn btn-secondary">
                    <i class="fa-solid fa-arrow-left me-2"></i>
                    Back to Cars List
                </a>
                <h2 class="mb-0 text-center flex-grow-1">My Bookings</h2>
                <div style="width: 150px;"></div> <!-- Spacer to balance layout -->
            </div>

            <form action="my-booking" method="get" class="mb-4">
                <div class="form-group row justify-content-center">
                    <div class="col-md-6">
                        <input type="email" name="email" class="form-control" placeholder="Enter your email to view bookings" required>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary btn-block">Search</button>
                    </div>
                </div>
            </form>

            <div id="bookingList">
                <%
                    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
                    if (bookings != null && !bookings.isEmpty()) {
                        for (Booking b : bookings) {
                %>
                <div class="card booking-card">
                    <div class="card-body">
                        <h5 class="card-title"><%= b.getCarName()%> - <%= b.getBrand()%></h5>
                        <p class="card-text">Pickup Date: <%= b.getPickupDate()%></p>
                        <p class="card-text">Return Date: <%= b.getReturnDate()%></p>
                        <p class="card-text">Status: <%= b.getStatus()%></p>
                        <p class="card-text">Price per Day: RM <%= b.getPricePerDay()%></p>
                        <p class="card-text font-weight-bold">Total: RM <%= b.getPricePerDay() * ((b.getReturnDate().getTime() - b.getPickupDate().getTime()) / (1000 * 60 * 60 * 24))%></p>
                        <p class="card-text text-muted">Created At: <%= b.getCreatedAt()%></p>
                    </div>
                </div>
                <%
                    }
                } else if (request.getParameter("email") != null) {
                %>
                <div class="alert alert-warning">No bookings found for the provided email.</div>
                <% }%>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>



