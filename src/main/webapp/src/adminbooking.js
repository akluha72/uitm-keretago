document.addEventListener("DOMContentLoaded", function () {
    const pickupDateInput = document.getElementById("bookingStartDate");
    const returnDateInput = document.getElementById("bookingEndDate");
    const carSelect = document.getElementById("bookingCar");

    async function fetchAvailableCars() {
        const startDate = pickupDateInput.value;
        const endDate = returnDateInput.value;

        if (!startDate || !endDate || new Date(startDate) > new Date(endDate)) {
            carSelect.innerHTML = '<option value="">Choose a car...</option>';
            return;
        }
        
        console.log(startDate);
        console.log(endDate);

        try {
            const res = await fetch(`./available-cars?startDate=${startDate}&endDate=${endDate}`);
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

    // Trigger fetching on date changes
    pickupDateInput.addEventListener("change", () => {
        fetchAvailableCars();
        calculateTotal();
    });

    returnDateInput.addEventListener("change", () => {
        fetchAvailableCars();
        calculateTotal();
    });

    // When user selects a car, update daily rate and recalculate
    carSelect.addEventListener("change", function () {
        const selected = carSelect.options[carSelect.selectedIndex];
        const rate = selected.dataset.dailyRate || 0;
        document.getElementById("dailyRate").value = parseFloat(rate).toFixed(2);
        calculateTotal();
    });
});


function saveBooking() {
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

    console.log(formData);
    fetch("admin-booking", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: formData.toString(),
    })
            .then(response => {
                if (response.ok) {
                    $('#bookingModal').modal('hide');
                    alert("Booking created successfully.");
                    location.reload(); // Refresh to show the new booking
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


