<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Book Your Car - KeretaGo</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

        <link rel="stylesheet" href="css/booking.css">

        <style>
            body {
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
        </style>
    </head>
    <body>
        <div class="booking-container">
            <div class="booking-header">
                <h2><i class="fas fa-car me-2"></i>Complete Your Booking</h2>
                <p>Fill in the details below to reserve your car</p>
            </div>

            <div class="car-info">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <img src="images/${car.imageUrl}" alt="Selected Car" class="car-image">
                    </div>
                    <div class="col-md-8">
                        <h4 class="mb-2">${car.make} ${car.model}</h4>
                        <p class="text-muted mb-2">Perfect for business trips and comfortable city drives</p>
                        <div class="row">
                            <div class="col-6">
                                <small class="d-block text-muted"><i class="fas fa-users me-1"></i> ${car.seats} Passengers</small>
                                <small class="d-block text-muted"><i class="fas fa-gas-pump me-1"></i> ${car.transmission}</small>
                            </div>
                            <div class="col-6">
                                <small class="d-block text-muted"><i class="fas fa-snowflake me-1"></i> Air Conditioning</small>
                                <small class="d-block text-muted"><i class="fas fa-shield-alt me-1"></i> Insurance Included</small>
                            </div>
                        </div>
                        <div class="mt-2">
                            <span class="h5 text-primary">RM ${car.dailyRate} <small class="text-muted">/day</small></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Booking Form -->
            <div class="form-container">
                <form action="booking" method="post" id="bookingForm">
                    <!-- Hidden field for car ID -->

                    <input type="hidden" name="car_id" value="${car.id}">

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="userEmail" class="form-label">Your Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="userEmail" name="user_email" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="pickupTime" class="form-label">Pickup Time <span class="text-danger">*</span></label>
                            <select class="form-select" id="pickupTime" name="pickup_time" required>
                                <option value="">Select time...</option>
                                <option value="08:00:00">8:00 AM</option>
                                <option value="09:00:00">9:00 AM</option>
                                <option value="10:00:00">10:00 AM</option>
                                <option value="11:00:00">11:00 AM</option>
                                <option value="12:00:00">12:00 PM</option>
                                <option value="13:00:00">1:00 PM</option>
                                <option value="14:00:00">2:00 PM</option>
                                <option value="15:00:00">3:00 PM</option>
                                <option value="16:00:00">4:00 PM</option>
                                <option value="17:00:00">5:00 PM</option>
                                <option value="18:00:00">6:00 PM</option>
                            </select>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Pickup Date:</label>
                            <input type="text" class="form-control" id="pickupDate" name="pickup_date" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Return Date:</label>
                            <input type="text" class="form-control" id="returnDate" name="return_date" required>
                        </div>
                    </div>

                    <!-- Summary Box -->
                    <div class="summary-box">
                        <h5><i class="fas fa-calculator me-2"></i>Booking Summary</h5>
                        <div class="row">
                            <div class="col-md-8">
                                <p class="mb-1"><strong>Pickup:</strong> <span id="summaryPickup">Please select dates</span></p>
                                <p class="mb-1"><strong>Return:</strong> <span id="summaryReturn">Please select dates</span></p>
                                <p class="mb-1"><strong>Duration:</strong> <span id="summaryDuration">- days</span></p>
                                <p class="mb-0"><strong>Rate:</strong> RM ${car.dailyRate} per day</p>
                            </div>
                            <div class="col-md-4 text-end">
                                <p class="mb-1">Total Amount:</p>
                                <div class="price-display" id="totalPrice">RM 0</div>
                            </div>
                        </div>
                    </div>

                    <div class="form-check mt-3 mb-4">
                        <input class="form-check-input" type="checkbox" id="agreeTerms" required>
                        <label class="form-check-label" for="agreeTerms">
                            I agree to the <a href="#" class="text-primary">Terms & Conditions</a> and <a href="#" class="text-primary">Privacy Policy</a>
                        </label>
                    </div>

                    <button type="submit" class="btn btn-primary btn-book">
                        <i class="fas fa-check me-2"></i>Confirm Booking
                    </button>
                </form>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <script>
            const ratePerDay = ${car.dailyRate};
        </script>
        <script>
            // Pass booked date ranges from JSP to JavaScript
            const bookedRanges = [
            <%
                for (Map<String, String> range : (List<Map<String, String>>) request.getAttribute("bookedDates")) {
                    String pickup = range.get("pickup");
                    String returnDate = range.get("return");
            %>
                {from: "<%= pickup%>", to: "<%= returnDate%>"},
            <% }%>
            ];
        </script>
        <script>
            flatpickr("#pickupDate", {
                dateFormat: "Y-m-d",
                disable: bookedRanges,
                minDate: "today",
                onChange: function (selectedDates, dateStr, instance) {
                    returnPicker.set("minDate", dateStr);
                }
            });

            const returnPicker = flatpickr("#returnDate", {
                dateFormat: "Y-m-d",
                disable: bookedRanges,
                minDate: "today"
            });
        </script>

        <script>
            // Set minimum date to today
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('pickupDate').min = today;
            document.getElementById('returnDate').min = today;

            // Calculate booking summary
            function updateSummary() {
                const pickupDate = document.getElementById('pickupDate').value;
                const returnDate = document.getElementById('returnDate').value;
                const pickupTime = document.getElementById('pickupTime').value;

                if (pickupDate && returnDate) {
                    const pickup = new Date(pickupDate);
                    const returnD = new Date(returnDate);
                    const timeDiff = returnD.getTime() - pickup.getTime();
                    const daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24));

                    if (daysDiff > 0) {
                        const rate = 80; // This would come from the database
                        const total = daysDiff * rate;

                        document.getElementById('summaryPickup').textContent = pickup.toLocaleDateString();
                        document.getElementById('summaryReturn').textContent = returnD.toLocaleDateString();
                        document.getElementById('summaryDuration').textContent = daysDiff + ' days';
                        document.getElementById('totalPrice').textContent = 'RM ' + total;
                    } else {
                        document.getElementById('summaryDuration').textContent = '- days';
                        document.getElementById('totalPrice').textContent = 'RM 0';
                    }
                }
            }

            // Update return date minimum when pickup date changes
            document.getElementById('pickupDate').addEventListener('change', function () {
                const pickupDate = this.value;
                document.getElementById('returnDate').min = pickupDate;
                updateSummary();
            });

            document.getElementById('returnDate').addEventListener('change', updateSummary);

            // Form validation
            document.getElementById('bookingForm').addEventListener('submit', function (e) {
                const pickupDate = document.getElementById('pickupDate').value;
                const returnDate = document.getElementById('returnDate').value;

                if (pickupDate && returnDate) {
                    const pickup = new Date(pickupDate);
                    const returnD = new Date(returnDate);

                    if (returnD <= pickup) {
                        e.preventDefault();
                        alert('Return date must be after pickup date');
                        return false;
                    }
                }
            });
        </script>
    </body>
</html>