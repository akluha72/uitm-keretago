<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Book Your Car - KeretaGo</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .booking-container {
                max-width: 900px;
                margin: 2rem auto;
                background: white;
                border-radius: 15px;
                box-shadow: 0 15px 35px rgba(0,0,0,0.1);
                overflow: hidden;
            }

            .booking-header {
                background: linear-gradient(45deg, #2c3e50, #3498db);
                color: white;
                padding: 2rem;
                text-align: center;
            }

            .booking-header h2 {
                margin-bottom: 0.5rem;
                font-weight: 600;
            }

            .car-info {
                background: #f8f9fa;
                padding: 1.5rem;
                border-bottom: 1px solid #dee2e6;
            }

            .car-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-radius: 10px;
            }

            .form-container {
                padding: 2rem;
            }

            .form-control, .form-select {
                border-radius: 8px;
                border: 2px solid #e9ecef;
                padding: 0.75rem 1rem;
                transition: all 0.3s ease;
            }

            .form-control:focus, .form-select:focus {
                border-color: #3498db;
                box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.15);
            }

            .btn-book {
                background: linear-gradient(45deg, #3498db, #2980b9);
                border: none;
                padding: 1rem 2rem;
                font-size: 1.1rem;
                font-weight: 600;
                border-radius: 8px;
                width: 100%;
                transition: all 0.3s ease;
            }

            .btn-book:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(52, 152, 219, 0.3);
            }

            .summary-box {
                background: #e8f4f8;
                border: 2px solid #3498db;
                border-radius: 10px;
                padding: 1.5rem;
                margin-top: 1.5rem;
            }

            .price-display {
                font-size: 1.5rem;
                font-weight: 700;
                color: #27ae60;
            }

            @media (max-width: 768px) {
                .booking-container {
                    margin: 1rem;
                }

                .form-container {
                    padding: 1.5rem;
                }
            }
        </style>
    </head>
    <body>
        <div class="booking-container">
            <!-- Header -->
            <div class="booking-header">
                <h2><i class="fas fa-car me-2"></i>Complete Your Booking</h2>
                <p>Fill in the details below to reserve your car</p>
            </div>

            <!-- Car Information (This would be populated from database based on carId) -->
            <div class="car-info">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <img src="https://images.unsplash.com/photo-1549924231-f129b911e442?w=400&h=200&fit=crop&crop=center" alt="Selected Car" class="car-image">
                    </div>
                    <div class="col-md-8">
                        <h4 class="mb-2">Premium Sedan</h4>
                        <p class="text-muted mb-2">Perfect for business trips and comfortable city drives</p>
                        <div class="row">
                            <div class="col-6">
                                <small class="d-block text-muted"><i class="fas fa-users me-1"></i> 5 Passengers</small>
                                <small class="d-block text-muted"><i class="fas fa-gas-pump me-1"></i> Automatic</small>
                            </div>
                            <div class="col-6">
                                <small class="d-block text-muted"><i class="fas fa-snowflake me-1"></i> Air Conditioning</small>
                                <small class="d-block text-muted"><i class="fas fa-shield-alt me-1"></i> Insurance Included</small>
                            </div>
                        </div>
                        <div class="mt-2">
                            <span class="h5 text-primary">RM 80 <small class="text-muted">/day</small></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Booking Form -->
            <div class="form-container">
                <form action="booking" method="post" id="bookingForm">
                    <!-- Hidden field for car ID -->
                    <input type="hidden" name="car_id" value="<%= request.getParameter("carId")%>">

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
                            <label for="pickupDate" class="form-label">Pickup Date <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" id="pickupDate" name="pickup_date" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="returnDate" class="form-label">Return Date <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" id="returnDate" name="return_date" required>
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
                                <p class="mb-0"><strong>Rate:</strong> RM 80 per day</p>
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