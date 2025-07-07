<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Booking</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
            .booking-card {
                margin-bottom: 20px;
            }

            .modal-backdrop {
                z-index: 0;
            }
        </style>
    </head>

    <body>
        <div class="container mt-5">
            <h2 class="mb-4 text-center">My Bookings</h2>
            <div id="bookingList"></div>
        </div>

        <!-- Modal for entering user phone or email -->
        <div class="modal fade" id="authModal" tabindex="-1" role="dialog" aria-labelledby="authModalLabel"
             aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="authModalLabel">My Bookings</h5>
                    </div>
                    <div class="modal-body">
                        <form id="authForm">
                            <div class="form-group">
                                <label for="searchInput">Enter Email</label>
                                <input type="text" class="form-control" id="searchInput" required>
                            </div>
                            <button type="submit" class="btn btn-primary btn-block">Search</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Wait for DOM to load
            document.addEventListener("DOMContentLoaded", () => {
                // Show auth modal
                $('#authModal').modal({backdrop: 'static', keyboard: false});
                $('#authModal').modal('show');

                document.getElementById("authForm").addEventListener("submit", function (e) {
                    e.preventDefault();
                    const keyword = document.getElementById("searchInput").value.trim().toLowerCase();

                    let bookings = JSON.parse(localStorage.getItem("bookings")) || [];
                    let filtered = bookings.filter(b => b.phone.toLowerCase() === keyword || b.email.toLowerCase() === keyword);

                    $('#authModal').modal('hide');
                    displayBookings(filtered);
                });

                function displayBookings(bookings) {
                    const list = document.getElementById("bookingList");
                    list.innerHTML = "";

                    if (bookings.length === 0) {
                        list.innerHTML = '<div class="alert alert-warning">No bookings found for the provided contact.</div>';
                        return;
                    }

                    bookings.forEach(b => {
                        const card = document.createElement("div");
                        card.className = "card booking-card";
                        card.innerHTML = `
                            <div class="card-body">
                                <h5 class="card-title">${b.car}</h5>
                                <p class="card-text">Name: ${b.name}</p>
                                <p class="card-text">Phone: ${b.phone}</p>
                                <p class="card-text">Email: ${b.email}</p>
                                <p class="card-text">Pickup Date: ${b.pickupDate}</p>
                                <p class="card-text">Return Date: ${b.returnDate}</p>
                                <p class="card-text">Price per Day: RM ${b.pricePerDay}</p>
                                <p class="card-text font-weight-bold">Total: RM ${b.total}</p>
                            </div>
                        `;
                        list.appendChild(card);
                    });
                }
            });
        </script>

        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>

</html>
