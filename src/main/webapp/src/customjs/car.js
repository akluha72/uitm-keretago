
document.addEventListener('DOMContentLoaded', function () {
    let selectedCar = {};

    // Open Modal on Button Click
    document.querySelectorAll(".book-btn").forEach(button => {
        button.addEventListener("click", () => {
            const name = button.getAttribute("data-name");
            const price = parseInt(button.getAttribute("data-price"));
            const image = button.getAttribute("data-image");

            selectedCar = { name, price, image };

            document.getElementById("carNameTitle").innerText = `Book ${name}`;
            document.getElementById("pricePerDay").innerText = price;
            document.getElementById("pickupDate").value = "";
            document.getElementById("returnDate").value = "";
            document.getElementById("totalPrice").innerText = "0";
            document.getElementById("carImage").src = image;

            // document.getElementById("bookingModal").style.display = "block";
            $('#bookingModal').modal('show');
        });
    });

    // Close modal
    function closeModal() {
        // document.getElementById("bookingModal").style.display = "none";
        $('#bookingModal').modal('hide');
    }

    // Calculate Total Price
    document.getElementById("returnDate").addEventListener("change", () => {
        const pickup = new Date(document.getElementById("pickupDate").value);
        const dropoff = new Date(document.getElementById("returnDate").value);

        if (pickup && dropoff && dropoff > pickup) {
            const days = Math.ceil((dropoff - pickup) / (1000 * 60 * 60 * 24));
            const total = days * selectedCar.price;
            document.getElementById("totalPrice").innerText = total;
        }
    });

    // Save booking to localStorage
    document.getElementById("bookingForm").addEventListener("submit", (e) => {
        e.preventDefault();

        const booking = {
            car: selectedCar.name,
            pricePerDay: selectedCar.price,
            pickupDate: document.getElementById("pickupDate").value,
            returnDate: document.getElementById("returnDate").value,
            name: document.getElementById("userName").value,
            phone: document.getElementById("userPhone").value,
            email: document.getElementById("userEmail").value,
            total: document.getElementById("totalPrice").innerText
        };

        // Get existing bookings
        let bookings = JSON.parse(localStorage.getItem("bookings")) || [];
        bookings.push(booking);
        localStorage.setItem("bookings", JSON.stringify(bookings));

        alert("Booking Confirmed!");
        closeModal();

        //debug on console: const a = JSON.parse(localStorage.getItem("bookings")); console.log(a);
    });


});
