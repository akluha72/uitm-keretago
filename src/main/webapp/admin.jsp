<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <div class="container-fluid mt-4">
            <div class="admin-panel" id="adminPanel">
                <div class="row mb-4 align-items-center">
                    <div class="col">
                        <h2 class="text-dark mb-0">Welcome, Admin</h2>
                        <p class="text-muted">Dashboard overview for your car rental system</p>
                    </div>
                    <div class="col-auto">
                        <a href="admin-logout" class="btn btn-danger" ><span> <i class="fas fa-sign-out-alt"></i></span>Logout</a>
                    </div>
                </div>

                <!-- Navigation Tabs -->
                <div class="row mb-3">
                    <div class="col-12">
                        <ul class="nav nav-tabs" id="adminTabs" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link active" id="dashboard-tab" data-toggle="tab" href="#dashboard"
                                   role="tab">
                                    <i class="fas fa-tachometer-alt mr-2"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="cars-tab" data-toggle="tab" href="#cars" role="tab">
                                    <i class="fas fa-car mr-2"></i>Car Management
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" id="bookings-tab" data-toggle="tab" href="#bookings" role="tab">
                                    <i class="fas fa-calendar-check mr-2"></i>Booking Management
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>


                <!-- Tab Content -->
                <div class="tab-content" id="adminTabContent">
                    <!-- Dashboard Tab -->
                    <div class="tab-pane fade show active" id="dashboard" role="tabpanel">
                        <!-- Metrics Cards Row -->
                        <div class="row mb-4">
                            <!-- Total Cars Available -->
                            <div class="col-lg-4 col-md-6 mb-3">
                                <div class="card metric-card card-cars h-100">
                                    <div class="card-body d-flex align-items-center">
                                        <div class="mr-3">
                                            <i class="fas fa-car metric-icon text-success"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <h3 class="metric-number text-success">${totalCars}</h3>
                                            <p class="metric-label">Total Cars Available</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-4 col-md-6 mb-3">
                                <div class="card metric-card card-bookings h-100">
                                    <div class="card-body d-flex align-items-center">
                                        <div class="mr-3">
                                            <i class="fas fa-calendar-check metric-icon text-primary"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <h3 class="metric-number text-primary">${totalBookings}</h3>
                                            <p class="metric-label">Total Bookings</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4 col-md-6 mb-3">
                                <div class="card metric-card card-weekly h-100">
                                    <div class="card-body d-flex align-items-center">
                                        <div class="mr-3">
                                            <i class="fas fa-chart-line metric-icon text-warning"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <h3 class="metric-number text-warning">${weeklyBookings}</h3>
                                            <p class="metric-label">Bookings This Week</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Car Management Tab -->
                    <div class="tab-pane fade" id="cars" role="tabpanel">
                        <!-- Car Management Header -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h4>Car Management</h4>
                            </div>
                            <div class="col-md-6 text-right">
                                <button class="btn btn-success" data-toggle="modal" data-target="#carModal" onclick="openCarModal()">
                                    <i class="fas fa-plus mr-2"></i>Add New Car
                                </button>
                            </div>
                        </div>

                        <!-- Cars Table -->
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>Image</th>
                                                <th>Make/Model</th>
                                                <th>Year</th>
                                                <th>License Plate</th>
                                                <th>Daily Rate</th>
                                                <th>Mileage</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="carsTableBody">
                                            <%
                                                List<model.Car> carList = (List<model.Car>) request.getAttribute("carList");
                                                if (carList != null) {
                                                    for (model.Car car : carList) {
                                            %>
                                            <tr>
                                                <td>
                                                    <img 
                                                        src="<%= car.getImageUrl() != null ? "images/" + car.getImageUrl() : "https://placehold.co/60x40"%>" 
                                                        class="img-thumbnail" 
                                                        width="80" 
                                                        height="60">
                                                </td>

                                                <td><strong><%= car.getMake()%> <%= car.getModel()%></strong></td>
                                                <td><%= car.getYearMade()%></td>
                                                <td><%= car.getLicensePlate()%></td>
                                                <td>$<%= car.getDailyRate()%>/day</td>
                                                <td><%= car.getMileage()%> km</td>
                                                <td>
                                                    <% if ("available".equalsIgnoreCase(car.getStatus())) { %>
                                                    <span class="badge badge-success">Available</span>
                                                    <% } else if ("rented".equalsIgnoreCase(car.getStatus())) { %>
                                                    <span class="badge badge-warning">Rented</span>
                                                    <% } else {%>
                                                    <span class="badge badge-secondary"><%= car.getStatus()%></span>
                                                    <% }%>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary" onclick="editCar(<%= car.getId()%>)"><i class="fas fa-edit"></i></button>
                                                    <button class="btn btn-sm btn-outline-danger" onclick="deleteCar(<%= car.getId()%>)"><i class="fas fa-trash"></i></button>
                                                </td>
                                            </tr>
                                            <%
                                                }
                                            } else {
                                            %>
                                            <tr><td colspan="8">No cars found.</td></tr>
                                            <% }%>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Booking Management Tab -->
                    <div class="tab-pane fade" id="bookings" role="tabpanel">
                        <!-- Booking Management Header -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <h4>Booking Management</h4>
                            </div>
                            <div class="col-md-6 text-right">
                                <button class="btn btn-success" data-toggle="modal" data-target="#bookingModal"
                                        onclick="openBookingModal()">
                                    <i class="fas fa-plus mr-2"></i>New Booking
                                </button>
                            </div>
                        </div>

                        <!-- Bookings Table -->
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>Booking ID</th>
                                                <th>Customer</th>
                                                <th>Car</th>
                                                <th>Start Date</th>
                                                <th>End Date</th>
                                                <th>Duration</th>
                                                <th>Total Amount</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="bookingsTableBody">
                                            <tr>
                                                <td><strong>#BK001</strong></td>
                                                <td>
                                                    <div>John Smith</div>
                                                    <small class="text-muted">john@email.com</small>
                                                </td>
                                                <td>Toyota Camry<br><small class="text-muted">ABC-1234</small></td>
                                                <td>2025-06-01</td>
                                                <td>2025-06-05</td>
                                                <td>4 days</td>
                                                <td>$180.00</td>
                                                <td><span class="badge badge-warning">Active</span></td>
                                                <td>
                                                    <div class="btn-group btn-group-sm">
                                                        <button class="btn btn-outline-primary" onclick="editBooking('BK001')" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <button class="btn btn-outline-success" onclick="completeBooking('BK001')"
                                                                title="Complete">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                        <button class="btn btn-outline-danger" onclick="cancelBooking('BK001')"
                                                                title="Cancel">
                                                            <i class="fas fa-times"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>#BK002</strong></td>
                                                <td>
                                                    <div>Sarah Johnson</div>
                                                    <small class="text-muted">sarah@email.com</small>
                                                </td>
                                                <td>Honda Civic<br><small class="text-muted">XYZ-5678</small></td>
                                                <td>2025-05-28</td>
                                                <td>2025-05-30</td>
                                                <td>2 days</td>
                                                <td>$80.00</td>
                                                <td><span class="badge badge-success">Completed</span></td>
                                                <td>
                                                    <div class="btn-group btn-group-sm">
                                                        <button class="btn btn-outline-info" onclick="viewBooking('BK002')"
                                                                title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-outline-secondary" onclick="printInvoice('BK002')"
                                                                title="Print Invoice">
                                                            <i class="fas fa-print"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr class="table-danger">
                                                <td><strong>#BK003</strong></td>
                                                <td>
                                                    <div>Mike Wilson</div>
                                                    <small class="text-muted">mike@email.com</small>
                                                </td>
                                                <td>BMW X5<br><small class="text-muted">DEF-9012</small></td>
                                                <td>2025-05-25</td>
                                                <td class="text-danger"><strong>2025-05-30</strong></td>
                                                <td>5 days</td>
                                                <td>$300.00</td>
                                                <td><span class="badge badge-danger">Overdue</span></td>
                                                <td>
                                                    <div class="btn-group btn-group-sm">
                                                        <button class="btn btn-outline-warning" onclick="contactCustomer('BK003')"
                                                                title="Contact Customer">
                                                            <i class="fas fa-phone"></i>
                                                        </button>
                                                        <button class="btn btn-outline-success" onclick="markReturned('BK003')"
                                                                title="Mark as Returned">
                                                            <i class="fas fa-check-circle"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Booking Statistics -->
                        <div class="row mt-4">
                            <div class="col-md-3">
                                <div class="card border-left-primary">
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col">
                                                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                                    Active Bookings</div>
                                                <div class="h5 mb-0 font-weight-bold text-gray-800">8</div>
                                            </div>
                                            <div class="col-auto">
                                                <i class="fas fa-calendar-check fa-2x text-gray-300"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card border-left-warning">
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col">
                                                <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Due
                                                    Today</div>
                                                <div class="h5 mb-0 font-weight-bold text-gray-800">3</div>
                                            </div>
                                            <div class="col-auto">
                                                <i class="fas fa-calendar-day fa-2x text-gray-300"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card border-left-danger">
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col">
                                                <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">
                                                    Overdue</div>
                                                <div class="h5 mb-0 font-weight-bold text-gray-800">1</div>
                                            </div>
                                            <div class="col-auto">
                                                <i class="fas fa-exclamation-triangle fa-2x text-gray-300"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card border-left-success">
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col">
                                                <div class="text-xs font-weight-bold text-success text-uppercase mb-1">This
                                                    Month Revenue</div>
                                                <div class="h5 mb-0 font-weight-bold text-gray-800">$2,340</div>
                                            </div>
                                            <div class="col-auto">
                                                <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <!-- Car Modal -->
            <div class="modal fade" id="carModal" tabindex="-1" role="dialog">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="carModalTitle">Add New Car</h5>
                            <button type="button" class="close" data-dismiss="modal">
                                <span>&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <form id="carForm">
                                <div class="row">
                                    <!-- Basic Information -->
                                    <div class="col-md-6">
                                        <h6 class="text-muted mb-3">Basic Information</h6>
                                        <div class="form-group">
                                            <label>Make *</label>
                                            <input type="text" class="form-control" id="carMake" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Model *</label>
                                            <input type="text" class="form-control" id="carModel" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Year *</label>
                                            <input type="number" class="form-control" id="carYear" min="2000" max="2025"
                                                   required>
                                        </div>
                                        <div class="form-group">
                                            <label>License Plate *</label>
                                            <input type="text" class="form-control" id="carLicense" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Daily Rate ($) *</label>
                                            <input type="number" class="form-control" id="carRate" min="0" step="0.01" required>
                                        </div>
                                    </div>

                                    <!-- Technical Specifications -->
                                    <div class="col-md-6">
                                        <h6 class="text-muted mb-3">Technical Specifications</h6>
                                        <div class="form-group">
                                            <label>Mileage (km)</label>
                                            <input type="number" class="form-control" id="carMileage" min="0">
                                        </div>
                                        <div class="form-group">
                                            <label>Transmission</label>
                                            <select class="form-control" id="carTransmission">
                                                <option value="automatic">Automatic</option>
                                                <option value="manual">Manual</option>
                                                <option value="cvt">CVT</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>Number of Seats</label>
                                            <select class="form-control" id="carSeats">
                                                <option value="2">2 Seats</option>
                                                <option value="4">4 Seats</option>
                                                <option value="5">5 Seats</option>
                                                <option value="7">7 Seats</option>
                                                <option value="8">8 Seats</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>Luggage Capacity</label>
                                            <select class="form-control" id="carLuggage">
                                                <option value="1">Small (1-2 bags)</option>
                                                <option value="2">Medium (3-4 bags)</option>
                                                <option value="3">Large (5+ bags)</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>Fuel Type</label>
                                            <select class="form-control" id="carFuel">
                                                <option value="petrol">Petrol</option>
                                                <option value="diesel">Diesel</option>
                                                <option value="hybrid">Hybrid</option>
                                                <option value="electric">Electric</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Status -->
                                <div class="row mt-3">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Status</label>
                                            <select class="form-control" id="carStatus">
                                                <option value="available">Available</option>
                                                <option value="booked">Booked</option>
                                                <option value="maintenance">Under Maintenance</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                            <button type="button" class="btn btn-success" onclick="saveCar()">Save Car</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Booking Modal -->
            <div class="modal fade" id="bookingModal" tabindex="-1" role="dialog">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="bookingModalTitle">New Booking</h5>
                            <button type="button" class="close" data-dismiss="modal">
                                <span>&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <form id="bookingForm">
                                <div class="row">
                                    <!-- Customer Information -->
                                    <div class="col-md-6">
                                        <h6 class="text-muted mb-3">Customer Information</h6>
                                        <div class="form-group">
                                            <label>Customer Name *</label>
                                            <input type="text" class="form-control" id="customerName" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Email *</label>
                                            <input type="email" class="form-control" id="customerEmail" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Phone *</label>
                                            <input type="tel" class="form-control" id="customerPhone" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Driver's License</label>
                                            <input type="text" class="form-control" id="customerLicense">
                                        </div>
                                        <div class="form-group">
                                            <label>Address</label>
                                            <textarea class="form-control" id="customerAddress" rows="2"></textarea>
                                        </div>
                                    </div>

                                    <!-- Booking Details -->
                                    <div class="col-md-6">
                                        <h6 class="text-muted mb-3">Booking Details</h6>
                                        <div class="form-group">
                                            <label>Select Car *</label>
                                            <select class="form-control" id="bookingCar" required>
                                                <option value="">Choose a car...</option>
                                                <option value="1">Toyota Camry (ABC-1234) - $45/day</option>
                                                <option value="2">Honda Civic (XYZ-5678) - $40/day</option>
                                                <option value="3">BMW X5 (DEF-9012) - $75/day</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>Start Date *</label>
                                            <input type="date" class="form-control" id="bookingStartDate" required>
                                        </div>
                                        <div class="form-group">
                                            <label>End Date *</label>
                                            <input type="date" class="form-control" id="bookingEndDate" required>
                                        </div>
                                        <div class="form-group">
                                            <label>Pickup Time</label>
                                            <input type="time" class="form-control" id="pickupTime" value="09:00">
                                        </div>
                                        <div class="form-group">
                                            <label>Return Time</label>
                                            <input type="time" class="form-control" id="returnTime" value="17:00">
                                        </div>
                                    </div>
                                </div>

                                <!-- Pricing Information -->
                                <div class="row mt-3">
                                    <div class="col-12">
                                        <h6 class="text-muted mb-3">Pricing & Payment</h6>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Daily Rate ($)</label>
                                            <input type="number" class="form-control" id="dailyRate" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label>Number of Days</label>
                                            <input type="number" class="form-control" id="numberOfDays" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label>Subtotal ($)</label>
                                            <input type="number" class="form-control" id="subtotal" readonly>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Tax ($)</label>
                                            <input type="number" class="form-control" id="tax" readonly>
                                        </div>
                                        <div class="form-group">
                                            <label>Additional Fees ($)</label>
                                            <input type="number" class="form-control" id="additionalFees" min="0" step="0.01"
                                                   value="0">
                                        </div>
                                        <div class="form-group">
                                            <label><strong>Total Amount ($)</strong></label>
                                            <input type="number" class="form-control font-weight-bold" id="totalAmount"
                                                   readonly>
                                        </div>
                                    </div>
                                </div>

                                <!-- Payment & Status -->
                                <div class="row mt-3">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Payment Status</label>
                                            <select class="form-control" id="paymentStatus">
                                                <option value="pending">Pending</option>
                                                <option value="partial">Partial Payment</option>
                                                <option value="paid">Fully Paid</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>Amount Paid ($)</label>
                                            <input type="number" class="form-control" id="amountPaid" min="0" step="0.01"
                                                   value="0">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Booking Status</label>
                                            <select class="form-control" id="bookingStatus">
                                                <option value="pending">Pending</option>
                                                <option value="confirmed">Confirmed</option>
                                                <option value="active">Active</option>
                                                <option value="completed">Completed</option>
                                                <option value="cancelled">Cancelled</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>Special Notes</label>
                                            <textarea class="form-control" id="specialNotes" rows="2"
                                                      placeholder="Any special requirements or notes..."></textarea>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                            <button type="button" class="btn btn-success" onclick="saveBooking()">Save Booking</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Booking Details View Modal -->
            <div class="modal fade" id="bookingDetailsModal" tabindex="-1" role="dialog">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Booking Details</h5>
                            <button type="button" class="close" data-dismiss="modal">
                                <span>&times;</span>
                            </button>
                        </div>
                        <div class="modal-body" id="bookingDetailsContent">
                            <!-- Booking details will be populated here -->
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            <button type="button" class="btn btn-primary" onclick="printBookingDetails()">Print</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Cancel Booking Modal -->
            <div class="modal fade" id="cancelBookingModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Cancel Booking</h5>
                            <button type="button" class="close" data-dismiss="modal">
                                <span>&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to cancel this booking?</p>
                            <div class="form-group">
                                <label>Cancellation Reason</label>
                                <textarea class="form-control" id="cancellationReason" rows="3"
                                          placeholder="Please provide a reason for cancellation..."></textarea>
                            </div>
                            <div class="form-group">
                                <div class="custom-control custom-checkbox">
                                    <input type="checkbox" class="custom-control-input" id="processRefund">
                                    <label class="custom-control-label" for="processRefund">Process refund if applicable</label>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Keep Booking</button>
                            <button type="button" class="btn btn-danger" onclick="confirmCancelBooking()">Cancel
                                Booking</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Confirm Delete</h5>
                            <button type="button" class="close" data-dismiss="modal">
                                <span>&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to delete this car? This action cannot be undone.</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                            <button type="button" class="btn btn-danger" onclick="confirmDelete()">Delete</button>
                        </div>
                    </div>
                </div>
            </div>



            <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/4.6.2/js/bootstrap.bundle.min.js"></script>
            <script src="packages/jquery.min.js"></script>
            <script src="packages/jquery-migrate-3.0.1.min.js"></script>
            <script src="packages/popper.min.js"></script>
            <script src="packages/bootstrap.min.js"></script>
            <script src="packages/jquery.easing.1.3.js"></script>
            <script src="packages/jquery.waypoints.min.js"></script>
            <script src="packages/jquery.stellar.min.js"></script>
            <script src="packages/owl.carousel.min.js"></script>
            <script src="packages/jquery.magnific-popup.min.js"></script>
            <script src="packages/aos.js"></script>
            <script src="packages/jquery.animateNumber.min.js"></script>
            <script src="packages/bootstrap-datepicker.js"></script>
            <script src="packages/jquery.timepicker.min.js"></script>
            <script src="packages/scrollax.min.js"></script>

            <script src="src/main.js"></script>
            <script src="src/customjs/admin.js"></script>
            <script src="src/editCar.js"></script>

            <!-- booking management scripts -->
            <script>
                                function calculateBookingTotal() {
                                    const startDateVal = $('#bookingStartDate').val();
                                    const endDateVal = $('#bookingEndDate').val();
                                    const carSelect = $('#bookingCar');
                                    const selectedOption = carSelect.find('option:selected');

                                    if (startDateVal && endDateVal && selectedOption.val()) {
                                        const startDate = new Date(startDateVal);
                                        const endDate = new Date(endDateVal);

                                        // Check if end date is before start date
                                        if (endDate < startDate) {
                                            alert('End date cannot be earlier than start date.');
                                            return;
                                        }

                                        const days = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24)) || 1;

                                        // Extract rate from selected option text, assuming format like "Car Model - $100/day"
                                        const rateText = selectedOption.text();
                                        const rateMatch = rateText.match(/\$(\d+(\.\d+)?)/);

                                        if (!rateMatch) {
                                            alert('Could not determine the daily rate from selected car option.');
                                            return;
                                        }

                                        const rate = parseFloat(rateMatch[1]);
                                        const subtotal = days * rate;
                                        const tax = subtotal * 0.1; // 10% tax
                                        const additionalFees = parseFloat($('#additionalFees').val()) || 0;
                                        const total = subtotal + tax + additionalFees;

                                        // Update fields
                                        $('#numberOfDays').val(days);
                                        $('#dailyRate').val(rate.toFixed(2));
                                        $('#subtotal').val(subtotal.toFixed(2));
                                        $('#tax').val(tax.toFixed(2));
                                        $('#totalAmount').val(total.toFixed(2));
                                    }
                                }

                                // Auto-calculate booking totals on change
                                $(document).ready(function () {
                                    $('#bookingStartDate, #bookingEndDate, #bookingCar, #additionalFees').on('change', function () {
                                        calculateBookingTotal();
                                    });

                                    // Optional: Trigger once on load if values are pre-filled
                                    calculateBookingTotal();
                                });
            </script>

    </body>
</html>
