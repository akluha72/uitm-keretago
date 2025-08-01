<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
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
                        <li class="nav-item active"><a href="/keretaGo/index" class="nav-link">Home</a></li>
                        <!-- <li class="nav-item"><a href="/keretago/pricing.jsp" class="nav-link">Pricing</a></li>-->
                        <li class="nav-item"><a href="/keretaGo/car.jsp" class="nav-link">Cars</a></li>
                        <li class="nav-item"><a href="/keretaGo/contact.jsp" class="nav-link">Contact</a></li>
                        <li class="nav-item"><a href="/keretaGo/my-booking.jsp" class="nav-link">My Booking</a></li>
                    </ul>
                </div>
            </div>
        </nav>


        <div class="hero-wrap ftco-degree-bg" style="background-image: url('images/bg_1.jpg');"
             data-stellar-background-ratio="0.5">
            <div class="overlay"></div>
            <div class="container">
                <div class="row no-gutters slider-text justify-content-start align-items-center justify-content-center">
                    <div class="col-lg-8 ftco-animate">
                        <div class="text w-100 text-center mb-md-5 pb-md-5">
                            <h1 class="mb-4">Simple & Fast Car Rental in Malaysia</h1>
                            <p style="font-size: 18px;">Whether you're heading back to your hometown or exploring the city,
                                we make car
                                rental easy, affordable, and hassle-free — just the way Malaysians like it.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <section class="ftco-section ftco-no-pt bg-light">
            <div class="container">
                <div class="row no-gutters">
                    <div class="col-md-12 featured-top">
                        <div class="row no-gutters">
                            <div class="col-md-4 d-flex align-items-center">
                                <form action="car.jsp" method="get" class="request-form ftco-animate bg-primary">
                                    <h2>Make your trip</h2>

                                    <div class="form-group">
                                        <label for="pickkup_location" class="label">Pick-up location</label>
                                        <input type="text" class="form-control" name="pickup_location" placeholder="City, Airport, Station, etc">
                                    </div>

                                    <div class="form-group">
                                        <label for="dropoff_location" class="label">Drop-off location</label>
                                        <input type="text" class="form-control" name="dropoff_location" placeholder="City, Airport, Station, etc">
                                    </div>

                                    <div class="d-flex">
                                        <div class="form-group mr-2">
                                            <label for="pickup_date" class="label">Pick-up date</label>
                                            <input type="date" class="form-control" name="pickup-date">
                                        </div>
                                        <div class="form-group ml-2">
                                            <label for="dropoff_date" class="label">Drop-off date</label>
                                            <input type="date" class="form-control" name="dropoff-date">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="pickup_time" class="label">Pick-up time</label>
                                        <input type="time" class="form-control" name="pickup_time">
                                    </div>

                                    <div class="form-group">
                                        <input type="submit" value="Rent A Car Now" class="btn btn-secondary py-3 px-4">
                                    </div>
                                </form>

                            </div>
                            <div class="col-md-8 d-flex align-items-center">
                                <div class="services-wrap rounded-right w-100">
                                    <h3 class="heading-section mb-4">Better Way to Rent Your Perfect Cars</h3>
                                    <div class="row d-flex mb-4">
                                        <div class="col-md-4 d-flex align-self-stretch ftco-animate">
                                            <div class="services w-100 text-center">
                                                <div class="icon d-flex align-items-center justify-content-center"><span
                                                        class="flaticon-route"></span></div>
                                                <div class="text w-100">
                                                    <h3 class="heading mb-2">Choose Your Pickup Location</h3>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4 d-flex align-self-stretch ftco-animate">
                                            <div class="services w-100 text-center">
                                                <div class="icon d-flex align-items-center justify-content-center"><span
                                                        class="flaticon-handshake"></span></div>
                                                <div class="text w-100">
                                                    <h3 class="heading mb-2">Select the Best Deal</h3>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4 d-flex align-self-stretch ftco-animate">
                                            <div class="services w-100 text-center">
                                                <div class="icon d-flex align-items-center justify-content-center"><span
                                                        class="flaticon-rent"></span></div>
                                                <div class="text w-100">
                                                    <h3 class="heading mb-2">Reserve Your Rental Car</h3>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <p><a href="/keretaGo/car.jsp" class="btn btn-primary py-3 px-4">Reserve Your Perfect Car</a></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
        </section>


<!--        <section class="ftco-section ftco-no-pt bg-light">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-12 heading-section text-center ftco-animate mb-5">
                        <span class="subheading">What we offer</span>
                        <h2 class="mb-2">Featured Vehicles</h2>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <c:if test="${empty carList}">
                            <p style="color: red;">carList is empty or not set!</p>
                        </c:if>

                        <div class="carousel-car owl-carousel">
                            <c:forEach var="car" items="${carList}">
                                <div class="item">
                                    <div class="car-wrap rounded ftco-animate">
                                        <div class="img rounded d-flex align-items-end"
                                             style="background-image: url(images/${car.imageUrl});">
                                        </div>
                                        <div class="text">
                                            <h2 class="mb-0"><a href="#">${car.model}</a></h2>
                                            <div class="d-flex mb-3">
                                                <span class="cat">${car.make}</span>
                                                <p class="price ml-auto">RM${car.dailyRate} <span>/day</span></p>
                                            </div>
                                            <p class="d-flex mb-0 d-block">
                                                <a href="car-single.jsp?id=${car.id}" class="btn btn-primary py-2 mr-1">Book now</a>
                                                <a href="car-single.jsp?id=${car.id}" class="btn btn-secondary py-2 ml-1">Details</a>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </section>-->

        <section class="ftco-section ftco-about">
            <div class="container">
                <div class="row no-gutters">
                    <div class="col-md-6 p-md-5 img img-2 d-flex justify-content-center align-items-center"
                         style="background-image: url(images/about.jpg);">
                    </div>
                    <div class="col-md-6 wrap-about ftco-animate">
                        <div class="heading-section heading-section-white pl-md-5">
                            <span class="subheading">About us</span>
                            <h2 class="mb-4">Welcome to keretaGo</h2>

                            <p>A small river named Duden flows by their place and supplies it with the necessary regelialia.
                                It is a
                                paradisematic country, in which roasted parts of sentences fly into your mouth.</p>
                            <p>On her way she met a copy. The copy warned the Little Blind Text, that where it came from it
                                would have
                                been rewritten a thousand times and everything that was left from its origin would be the
                                word "and" and
                                the Little Blind Text should turn around and return to its own, safe country. A small river
                                named Duden
                                flows by their place and supplies it with the necessary regelialia. It is a paradisematic
                                country, in
                                which roasted parts of sentences fly into your mouth.</p>
                            <p><a href="#" class="btn btn-primary py-3 px-4">Search Vehicle</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="ftco-section">
            <div class="container">
                <div class="row justify-content-center mb-5">
                    <div class="col-md-7 text-center heading-section ftco-animate">
                        <span class="subheading">Services</span>
                        <h2 class="mb-3">Our Latest Services</h2>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <div class="services services-2 w-100 text-center">
                            <div class="icon d-flex align-items-center justify-content-center"><span
                                    class="flaticon-wedding-car"></span></div>
                            <div class="text w-100">
                                <h3 class="heading mb-2">Wedding Ceremony</h3>
                                <p>A small river named Duden flows by their place and supplies it with the necessary
                                    regelialia.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="services services-2 w-100 text-center">
                            <div class="icon d-flex align-items-center justify-content-center"><span
                                    class="flaticon-transportation"></span></div>
                            <div class="text w-100">
                                <h3 class="heading mb-2">City Transfer</h3>
                                <p>A small river named Duden flows by their place and supplies it with the necessary
                                    regelialia.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="services services-2 w-100 text-center">
                            <div class="icon d-flex align-items-center justify-content-center"><span
                                    class="flaticon-car"></span></div>
                            <div class="text w-100">
                                <h3 class="heading mb-2">Airport Transfer</h3>
                                <p>A small river named Duden flows by their place and supplies it with the necessary
                                    regelialia.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="services services-2 w-100 text-center">
                            <div class="icon d-flex align-items-center justify-content-center"><span
                                    class="flaticon-transportation"></span></div>
                            <div class="text w-100">
                                <h3 class="heading mb-2">Whole City Tour</h3>
                                <p>A small river named Duden flows by their place and supplies it with the necessary
                                    regelialia.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

<!--        <section class="ftco-section ftco-intro" style="background-image: url(images/bg_3.jpg);">
            <div class="overlay"></div>
            <div class="container">
                <div class="row justify-content-end">
                    <div class="col-md-6 heading-section heading-section-white ftco-animate">
                        <h2 class="mb-3">Do You Want To Earn With Us? So Don't Be Late.</h2>
                        <a href="#" class="btn btn-primary btn-lg">Become A Driver</a>
                    </div>
                </div>
            </div>
        </section>-->


        <section class="ftco-section testimony-section bg-light">
            <div class="container">
                <div class="row justify-content-center mb-5">
                    <div class="col-md-7 text-center heading-section ftco-animate">
                        <span class="subheading">Testimonial</span>
                        <h2 class="mb-3">Happy Clients</h2>
                    </div>
                </div>
                <div class="row ftco-animate">
                    <div class="col-md-12">
                        <div class="carousel-testimony owl-carousel ftco-owl">
                            <div class="item">
                                <div class="testimony-wrap rounded text-center py-4 pb-5">
                                    <div class="user-img mb-2" style="background-image: url(images/person_1.jpg)">
                                    </div>
                                    <div class="text pt-4">
                                        <p class="mb-4">Far far away, behind the word mountains, far from the countries
                                            Vokalia and
                                            Consonantia, there live the blind texts.</p>
                                        <p class="name">Roger Scott</p>
                                        <span class="position">Marketing Manager</span>
                                    </div>
                                </div>
                            </div>
                            <div class="item">
                                <div class="testimony-wrap rounded text-center py-4 pb-5">
                                    <div class="user-img mb-2" style="background-image: url(images/person_2.jpg)">
                                    </div>
                                    <div class="text pt-4">
                                        <p class="mb-4">Far far away, behind the word mountains, far from the countries
                                            Vokalia and
                                            Consonantia, there live the blind texts.</p>
                                        <p class="name">Roger Scott</p>
                                        <span class="position">Interface Designer</span>
                                    </div>
                                </div>
                            </div>
                            <div class="item">
                                <div class="testimony-wrap rounded text-center py-4 pb-5">
                                    <div class="user-img mb-2" style="background-image: url(images/person_3.jpg)">
                                    </div>
                                    <div class="text pt-4">
                                        <p class="mb-4">Far far away, behind the word mountains, far from the countries
                                            Vokalia and
                                            Consonantia, there live the blind texts.</p>
                                        <p class="name">Roger Scott</p>
                                        <span class="position">UI Designer</span>
                                    </div>
                                </div>
                            </div>
                            <div class="item">
                                <div class="testimony-wrap rounded text-center py-4 pb-5">
                                    <div class="user-img mb-2" style="background-image: url(images/person_1.jpg)">
                                    </div>
                                    <div class="text pt-4">
                                        <p class="mb-4">Far far away, behind the word mountains, far from the countries
                                            Vokalia and
                                            Consonantia, there live the blind texts.</p>
                                        <p class="name">Roger Scott</p>
                                        <span class="position">Web Developer</span>
                                    </div>
                                </div>
                            </div>
                            <div class="item">
                                <div class="testimony-wrap rounded text-center py-4 pb-5">
                                    <div class="user-img mb-2" style="background-image: url(images/person_1.jpg)">
                                    </div>
                                    <div class="text pt-4">
                                        <p class="mb-4">Far far away, behind the word mountains, far from the countries
                                            Vokalia and
                                            Consonantia, there live the blind texts.</p>
                                        <p class="name">Roger Scott</p>
                                        <span class="position">System Analyst</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="ftco-counter ftco-section img bg-light" id="section-counter">
            <div class="overlay"></div>
            <div class="container">
                <div class="row">
                    <div class="col-md-6 col-lg-3 justify-content-center counter-wrap ftco-animate">
                        <div class="block-18">
                            <div class="text text-border d-flex align-items-center">
                                <strong class="number" data-number="60">0</strong>
                                <span>Year <br>Experienced</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3 justify-content-center counter-wrap ftco-animate">
                        <div class="block-18">
                            <div class="text text-border d-flex align-items-center">
                                <strong class="number" data-number="1090">0</strong>
                                <span>Total <br>Cars</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3 justify-content-center counter-wrap ftco-animate">
                        <div class="block-18">
                            <div class="text text-border d-flex align-items-center">
                                <strong class="number" data-number="2590">0</strong>
                                <span>Happy <br>Customers</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3 justify-content-center counter-wrap ftco-animate">
                        <div class="block-18">
                            <div class="text d-flex align-items-center">
                                <strong class="number" data-number="67">0</strong>
                                <span>Total <br>Branches</span>
                            </div>
                        </div>
                    </div>
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
                            <i class="icon-heart color-danger" aria-hidden="true"></i> by <a href="https://colorlib.com"
                                                                                             target="_blank">Colorlib</a>
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

<!--    <script>
                                $(document).ready(function () {
                                    $('.carousel-car').owlCarousel({
                                        loop: true,
                                        margin: 30,
                                        nav: true,
                                        items: 3,
                                        autoplay: true,
                                        autoplayTimeout: 4000
                                    });
                                });
    </script>-->
</html>
