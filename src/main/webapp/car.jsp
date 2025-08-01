<%@ page import="java.util.*, model.Car, dao.CarDAO" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    CarDAO carDAO = new CarDAO();
    List<Car> carList = carDAO.getAllCars();
    request.setAttribute("carList", carList);
%>


<%
    String pickupDateStr = request.getParameter("pickup-date");
    String dropoffDateStr = request.getParameter("dropoff-date");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    java.sql.Date pickupDate = null;
    java.sql.Date dropoffDate = null;

    if (pickupDateStr != null && dropoffDateStr != null) {
        pickupDate = java.sql.Date.valueOf(pickupDateStr);
        dropoffDate = java.sql.Date.valueOf(dropoffDateStr);
    }

    CarDAO dao = new CarDAO();

    if (pickupDate != null && dropoffDate != null) {
        carList = dao.getAvailableCarsBetween(pickupDate, dropoffDate);
    } else {
        carList = dao.getAllCars();
    }

    request.setAttribute("carList", carList);
%>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>KeretaGO</title>

        <link rel="icon" type="image/svg+xml" href="/vite.svg" />
        <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="css/open-iconic-bootstrap.min.css">
        <link rel="stylesheet" href="css/animate.css">

        <link rel="stylesheet" href="css/owl.carousel.min.css">
        <link rel="stylesheet" href="css/owl.theme.default.min.css">
        <link rel="stylesheet" href="css/magnific-popup.css">
        <link rel="stylesheet" href="css/aos.css">

        <link rel="stylesheet" href="css/ionicons.min.css">

        <link rel="stylesheet" href="css/bootstrap-datepicker.css">
        <link rel="stylesheet" href="css/jquery.timepicker.css">


        <link rel="stylesheet" href="css/flaticon.css">
        <link rel="stylesheet" href="css/icomoon.css">
        <link rel="stylesheet" href="css/style.css">

        <style>
            .unavailable-overlay {
                position: absolute;
                top: 0;
                left: 0;
                background: rgba(0,0,0,0.6);
                color: white;
                width: 100%;
                height: 100%;
                z-index: 2;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                border-radius: 10px;
            }

            .car-wrap {
                position: relative;
            }

            .car-wrap img,
            .car-wrap .img {
                filter: grayscale(0%);
            }

            .car-wrap.unavailable .img {
                filter: grayscale(70%);
            }
        </style>
    </head>


    <body>
        <nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
            <div class="container">
                <a class="navbar-brand" href="/keretaGo/index">kereta<span style="text-transform: capitalize;">GO</span></a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav"
                        aria-controls="ftco-nav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="oi oi-menu"></span> Menu
                </button>

                <div class="collapse navbar-collapse" id="ftco-nav">
                    <ul class="navbar-nav ml-auto">
                        <li class="nav-item "><a href="/keretaGo/index" class="nav-link">Home</a></li>
                        <!--<li class="nav-item"><a href="/keretago/pricing.jsp" class="nav-link">Pricing</a></li>-->
                        <li class="nav-item active"><a href="/keretaGo/car.jsp" class="nav-link">Cars</a></li>
                        <li class="nav-item"><a href="/keretaGo/contact.jsp" class="nav-link">Contact</a></li>
                        <li class="nav-item"><a href="/keretaGo/my-booking.jsp" class="nav-link">My Booking</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <section class="hero-wrap hero-wrap-2 js-fullheight" style="background-image: url('images/bg_3.jpg');"
                 data-stellar-background-ratio="0.5">
            <div class="overlay"></div>
            <div class="container">
                <div class="row no-gutters slider-text js-fullheight align-items-end justify-content-start">
                    <div class="col-md-9 ftco-animate pb-5">
                        <p class="breadcrumbs"><span class="mr-2"><a href="index.html">Home <i
                                        class="ion-ios-arrow-forward"></i></a></span> <span>Cars <i
                                    class="ion-ios-arrow-forward"></i></span></p>
                        <h1 class="mb-3 bread">Choose Your Car</h1>
                    </div>
                </div>
            </div>
        </section>


        <section class="ftco-section bg-light">
            <div class="container my-4">
                <!-- Display Selected Dates (Disabled Inputs) -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <label for="pickup-date" class="form-label">Pickup Date</label>
                        <input type="date" id="pickup-date" name="pickup-date" 
                               class="form-control" value="${param['pickup-date']}" disabled />
                    </div>
                    <div class="col-md-6">
                        <label for="dropoff-date" class="form-label">Dropoff Date</label>
                        <input type="date" id="dropoff-date" name="dropoff-date" 
                               class="form-control" value="${param['dropoff-date']}" disabled />
                    </div>
                </div>

                <!-- Car Listings -->
                <div class="row">
                    <c:choose>
                        <c:when test="${empty carList}">
                            <!-- No available cars message -->
                            <div class="col-12 text-center">
                                <div class="alert alert-warning" role="alert">
                                    🚫 Sorry, no cars are available for the selected dates. Please try different dates.
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="car" items="${carList}">
                                <div class="col-md-4 mb-4">
                                    <div class="car-wrap rounded shadow-sm">
                                        <div class="img rounded d-flex align-items-end"
                                             style="background-image: url(images/${car.imageUrl}); height: 200px; background-size: cover;">
                                        </div>
                                        <div class="text p-3">
                                            <h2 class="mb-1">
                                                <a href="car-single.jsp?id=${car.id}">${car.model}</a>
                                            </h2>
                                            <div class="d-flex justify-content-between mb-2">
                                                <span class="cat text-muted">${car.make}</span>
                                                <p class="price font-weight-bold">RM${car.dailyRate} <span class="text-muted">/day</span></p>
                                            </div>
                                            <p class="d-flex justify-content-end mb-0">
                                                <a href="booking-page?carId=${car.id}" class="btn btn-primary btn-sm">Book now</a>
                                                <!--<a href="car-single.jsp?id=${car.id}" class="btn btn-outline-secondary btn-sm">Details</a>-->
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>


        <footer class="ftco-footer ftco-bg-dark ftco-section">
            <div class="container">
                <div class="row mb-5">
                    <div class="col-md">
                        <div class="ftco-footer-widget mb-4">
                            <h2 class="ftco-heading-2"><a href="#" class="logo">Car<span>book</span></a></h2>
                            <p>Far far away, behind the word mountains, far from the countries Vokalia and Consonantia,
                                there live the
                                blind texts.</p>
                            <ul class="ftco-footer-social list-unstyled float-md-left float-lft mt-5">
                                <li class="ftco-animate"><a href="#"><span class="icon-twitter"></span></a></li>
                                <li class="ftco-animate"><a href="#"><span class="icon-facebook"></span></a></li>
                                <li class="ftco-animate"><a href="#"><span class="icon-instagram"></span></a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-md">
                        <div class="ftco-footer-widget mb-4 ml-md-5">
                            <h2 class="ftco-heading-2">Information</h2>
                            <ul class="list-unstyled">
                                <li><a href="#" class="py-2 d-block">About</a></li>
                                <li><a href="#" class="py-2 d-block">Services</a></li>
                                <li><a href="#" class="py-2 d-block">Term and Conditions</a></li>
                                <li><a href="#" class="py-2 d-block">Best Price Guarantee</a></li>
                                <li><a href="#" class="py-2 d-block">Privacy &amp; Cookies Policy</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-md">
                        <div class="ftco-footer-widget mb-4">
                            <h2 class="ftco-heading-2">Customer Support</h2>
                            <ul class="list-unstyled">
                                <li><a href="#" class="py-2 d-block">FAQ</a></li>
                                <li><a href="#" class="py-2 d-block">Payment Option</a></li>
                                <li><a href="#" class="py-2 d-block">Booking Tips</a></li>
                                <li><a href="#" class="py-2 d-block">How it works</a></li>
                                <li><a href="#" class="py-2 d-block">Contact Us</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-md">
                        <div class="ftco-footer-widget mb-4">
                            <h2 class="ftco-heading-2">Have a Questions?</h2>
                            <div class="block-23 mb-3">
                                <ul>
                                    <li><span class="icon icon-map-marker"></span><span class="text">203 Fake St. Mountain
                                            View, San
                                            Francisco, California, USA</span></li>
                                    <li><a href="#"><span class="icon icon-phone"></span><span class="text">+2 392 3929
                                                210</span></a></li>
                                    <li><a href="#"><span class="icon icon-envelope"></span><span
                                                class="text">info@yourdomain.com</span></a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12 text-center">

                        <p><!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                            Copyright &copy;
                            <script>document.write(new Date().getFullYear());</script> All rights reserved | This template
                            is made with
                            <i class="icon-heart color-danger" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
                            <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                        </p>
                    </div>
                </div>
            </div>
        </footer>
        <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px">
            <circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee" />
            <circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10"
                    stroke="#F96D00" />
            </svg>
        </div>


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
        <script src="src/customjs/car.js"></script>
    </body>

</html>