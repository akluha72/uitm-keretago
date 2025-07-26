// Clean JavaScript with proper separation between full edit and status-only edit
document.addEventListener("DOMContentLoaded", function () {
    const pickupDateInput = document.getElementById("bookingStartDate");
    const returnDateInput = document.getElementById("bookingEndDate");
    const carSelect = document.getElementById("bookingCar");
    let isEditMode = false;
    let originalCarId = null;

    async function fetchAvailableCars(excludeBookingId = null) {
        const startDate = pickupDateInput.value;
        const endDate = returnDateInput.value;

        if (!startDate || !endDate || new Date(startDate) > new Date(endDate)) {
            carSelect.innerHTML = '<option value="">Choose a car...</option>';
            return;
        }

        try {
            let url = `./available-cars?startDate=${startDate}&endDate=${endDate}`;
            if (excludeBookingId) {
                url += `&excludeBookingId=${excludeBookingId}`;
            }

            const res = await fetch(url);
            const cars = await res.json();

            carSelect.innerHTML = '<option value="">Choose a car...</option>';

            if (cars.length === 0) {
                carSelect.innerHTML += '<option disabled>No available cars for selected dates</option>';
                return;
            }

            cars.forEach(car => {
                const option = document.createElement("option");
                option.value = car.id;
                option.textContent = `${car.make} ${car.model} (${car.licensePlate}) - RM${car.dailyRate.toFixed(2)}/day`;
                option.dataset.dailyRate = car.dailyRate;
                carSelect.appendChild(option);
            });

            // If in edit mode and original car should be selected
            if (isEditMode && originalCarId) {
                carSelect.value = originalCarId;
                const selectedOption = carSelect.options[carSelect.selectedIndex];
                if (selectedOption && selectedOption.dataset.dailyRate) {
                    document.getElementById("dailyRate").value = parseFloat(selectedOption.dataset.dailyRate).toFixed(2);
                }
            }
        } catch (error) {
            console.error("Fetch failed:", error);
            carSelect.innerHTML = '<option disabled>Error loading cars</option>';
    }
    }

    function calculateTotal() {
        const rate = parseFloat(document.getElementById("dailyRate").value) || 0;
        const start = new Date(pickupDateInput.value);
        const end = new Date(returnDateInput.value);

        if (!isNaN(start) && !isNaN(end) && rate > 0) {
            let days = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
            days = days > 0 ? days : 1;

            const subtotal = rate * days;
            const tax = subtotal * 0.06;
            const total = subtotal + tax;

            document.getElementById("numberOfDays").value = days;
            document.getElementById("subtotal").value = subtotal.toFixed(2);
            document.getElementById("tax").value = tax.toFixed(2);
            document.getElementById("totalAmount").value = total.toFixed(2);
        }
    }

    // Event listeners for the main booking form
    if (pickupDateInput && returnDateInput && carSelect) {
        pickupDateInput.addEventListener("change", () => {
            const excludeId = isEditMode ? document.getElementById("bookingId").value : null;
            fetchAvailableCars(excludeId);
            calculateTotal();
        });

        returnDateInput.addEventListener("change", () => {
            const excludeId = isEditMode ? document.getElementById("bookingId").value : null;
            fetchAvailableCars(excludeId);
            calculateTotal();
        });

        carSelect.addEventListener("change", function () {
            const selected = carSelect.options[carSelect.selectedIndex];
            const rate = selected.dataset.dailyRate || 0;
            document.getElementById("dailyRate").value = parseFloat(rate).toFixed(2);
            calculateTotal();
        });
    }


    // Function to open NEW booking modal
    window.openNewBookingModal = function () {
        console.log('Opening NEW booking modal');
        isEditMode = false;
        originalCarId = null;

        // Reset modal title and button text
        document.getElementById("bookingModalTitle").textContent = "New Booking";
        document.getElementById("saveBookingBtn").textContent = "Save Booking";

        // Reset form completely
        document.getElementById("bookingForm").reset();
        document.getElementById("bookingId").value = "";
        document.getElementById("bookingStatus").value = "active";

        // Reset car dropdown
        carSelect.innerHTML = '<option value="">Choose a car...</option>';

        // Clear calculation fields
        document.getElementById("dailyRate").value = "";
        document.getElementById("numberOfDays").value = "";
        document.getElementById("subtotal").value = "";
        document.getElementById("totalAmount").value = "";

        // Show the main booking modal
        $('#bookingModal').modal('show');
    };

    // Function for FULL EDIT (if you want to enable this later)
    window.editFullBooking = function (bookingId) {
        console.log('Opening FULL EDIT booking modal for ID:', bookingId);
        isEditMode = true;

        document.getElementById("bookingModalTitle").textContent = "Edit Booking";
        document.getElementById("saveBookingBtn").textContent = "Update Booking";

        // Fetch booking details
        fetch(`./get-booking?id=${bookingId}`)
                .then(response => response.json())
                .then(booking => {
                    // Populate form with existing data
                    document.getElementById("bookingId").value = booking.id;
                    document.getElementById("customerEmail").value = booking.userEmail;
                    document.getElementById("bookingStartDate").value = booking.pickupDate;
                    document.getElementById("bookingEndDate").value = booking.returnDate;
                    document.getElementById("bookingStatus").value = booking.status;

                    originalCarId = booking.carId;

                    // Fetch available cars (excluding current booking)
                    fetchAvailableCars(bookingId).then(() => {
                        // Add current car to options if not already there
                        let carExists = false;
                        for (let option of carSelect.options) {
                            if (option.value == originalCarId) {
                                carExists = true;
                                break;
                            }
                        }

                        if (!carExists && booking.carDetails) {
                            const currentCarOption = document.createElement("option");
                            currentCarOption.value = originalCarId;
                            currentCarOption.textContent = `${booking.carDetails.make} ${booking.carDetails.model} (${booking.carDetails.licensePlate}) - RM${booking.carDetails.dailyRate.toFixed(2)}/day`;
                            currentCarOption.dataset.dailyRate = booking.carDetails.dailyRate;
                            carSelect.appendChild(currentCarOption);
                        }

                        carSelect.value = originalCarId;
                        document.getElementById("dailyRate").value = booking.carDetails.dailyRate.toFixed(2);
                        calculateTotal();
                    });

                    $('#bookingModal').modal('show');
                })
                .catch(error => {
                    console.error("Error fetching booking:", error);
                    alert("Error loading booking details");
                });
    };
});


// Function to edit ONLY STATUS (this is what your edit button should call)
function editBooking(bookingId) {
    console.log('Opening STATUS EDIT modal for ID:', bookingId);

    // Fetch booking details
    fetch(`./get-booking?id=${bookingId}`)
            .then(response => response.json())
            .then(booking => {
                // Set booking ID in status modal
                document.getElementById("editBookingId").value = booking.id;

                // Populate disabled input fields
                document.getElementById("displayCustomerEmailInput").value = booking.userEmail;
                document.getElementById("displayCarInfoInput").value =
                        `${booking.carDetails.make} ${booking.carDetails.model} (${booking.carDetails.licensePlate})`;
                document.getElementById("displayPickupDateInput").value = booking.pickupDate;
                document.getElementById("displayReturnDateInput").value = booking.returnDate;

                // Set current status (the only editable field)
                document.getElementById("editBookingStatus").value = booking.status;

                // Clear notes
//                document.getElementById("statusNotes").value = "";

                // Show STATUS modal (not the main booking modal)
                $('#statusEditModal').modal('show');
            })
            .catch(error => {
                console.error("Error fetching booking:", error);
                alert("Error loading booking details");
            });
}

// Function to update booking status
function updateBookingStatus() {
    const bookingId = document.getElementById("editBookingId").value;
    const newStatus = document.getElementById("editBookingStatus").value;

    if (!newStatus) {
        alert("Please select a status.");
        return;
    }

    const formData = new URLSearchParams();
    formData.append("booking_id", bookingId);
    formData.append("status", newStatus);

    fetch("update-booking", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: formData.toString(),
    })
            .then(response => {
                if (response.ok) {
                    $('#statusEditModal').modal('hide');
                    alert("Booking status updated successfully.");
                    location.reload();
                } else {
                    return response.text().then(text => {
                        throw new Error(text || "Failed to update status.");
                    });
                }
            })
            .catch(error => {
                console.error("Status update error:", error);
                alert("Error updating status: " + error.message);
            });
}

function deleteBooking(bookingId) {
    // Show confirmation dialog
    if (!confirm("Are you sure you want to delete this booking? This action cannot be undone.")) {
        return;
    }

    // Create form data
    const formData = new URLSearchParams();
    formData.append("booking_id", bookingId);

    // Send delete request
    fetch("delete-booking", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: formData.toString(),
    })
            .then(response => {
                if (response.ok) {
                    alert("Booking deleted successfully.");
                    location.reload(); // Refresh the page to update the booking list
                } else {
                    return response.text().then(text => {
                        throw new Error(text || "Failed to delete booking.");
                    });
                }
            })
            .catch(error => {
                console.error("Delete booking error:", error);
                alert("Error deleting booking: " + error.message);
            });
}

function saveBooking() {
    const bookingId = document.getElementById("bookingId").value;
    const carId = document.getElementById("bookingCar").value;
    const email = document.getElementById("customerEmail").value.trim();
    const pickupDate = document.getElementById("bookingStartDate").value;
    const returnDate = document.getElementById("bookingEndDate").value;
    const status = document.getElementById("bookingStatus").value;

    if (!carId || !email || !pickupDate || !returnDate) {
        alert("Please fill in all required fields.");
        return;
    }

    const formData = new URLSearchParams();
    formData.append("car_id", carId);
    formData.append("user_email", email);
    formData.append("pickup_date", pickupDate);
    formData.append("return_date", returnDate);
    formData.append("status", status);

    // Add booking ID for edit mode
    if (bookingId) {
        formData.append("booking_id", bookingId);
    }

    const url = bookingId ? "update-booking" : "admin-booking";

    fetch(url, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: formData.toString(),
    })
            .then(response => {
                if (response.ok) {
                    $('#bookingModal').modal('hide');
                    const message = bookingId ? "Booking updated successfully." : "Booking created successfully.";
                    alert(message);
                    location.reload();
                } else {
                    return response.text().then(text => {
                        throw new Error(text || "Failed to save booking.");
                    });
                }
            })
            .catch(error => {
                console.error("Booking error:", error);
                alert("Error saving booking: " + error.message);
            });
}