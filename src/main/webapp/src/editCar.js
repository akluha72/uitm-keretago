function editCar(carId) {
    $.ajax({
        url: 'get-car?id=' + carId,
        method: 'GET',
        dataType: 'json',
        success: function (data) {
            console.log(data);
            $('#carModalTitle').text("Edit Car");

            $('#carMake').val(data.make);
            $('#carModel').val(data.model);
            $('#carYear').val(data.yearMade);
            $('#carLicense').val(data.licensePlate);
            $('#carRate').val(data.dailyRate);
            $('#carMileage').val(data.mileage);
            $('#carTransmission').val(data.transmission.toLowerCase());
            $('#carSeats').val(data.seats);
            $('#carLuggage').val(data.luggage);
            $('#carFuel').val(data.fuelType.toLowerCase());
            $('#carStatus').val(data.status.toLowerCase());
            $('#carPreview').val(data.imageUrl);

            if (data.imageUrl && data.imageUrl !== "") {
                $('#carPreview').attr('src', data.imageUrl);
            } else {
                $('#carPreview').attr('src', 'https://placehold.co/200x150');
            }


            // Show modal
            $('#carModal').modal('show');

            // Store current carId (for update later)
            $('#carForm').data('car-id', carId);
        },
        error: function () {
            alert("Failed to fetch car details.");
        }
    });
}

function saveCar() {
    const carId = $('#carForm').data('car-id'); // If it's for editing
    const formData = new FormData();

    formData.append('id', carId);
    formData.append('make', $('#carMake').val());
    formData.append('model', $('#carModel').val());
    formData.append('yearMade', $('#carYear').val());
    formData.append('licensePlate', $('#carLicense').val());
    formData.append('dailyRate', $('#carRate').val());
    formData.append('mileage', $('#carMileage').val());
    formData.append('transmission', $('#carTransmission').val());
    formData.append('seats', $('#carSeats').val());
    formData.append('luggage', $('#carLuggage').val());
    formData.append('fuelType', $('#carFuel').val());
    formData.append('status', $('#carStatus').val());

    $.ajax({
        url: 'update-car',
        method: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function (response) {
            $('#carModal').modal('hide');
            alert('Car updated weh!');
            location.reload();
        },
        error: function (xhr) {
            console.error(xhr.responseText);
            alert('Failed to update car.');
        }
    });
}

function deleteCar(carId) {
    if (confirm("Are you sure you want to delete this car?")) {
        fetch('delete-car', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'id=' + encodeURIComponent(carId)
        })
                .then(response => {
                    if (response.ok) {
                        alert('Car deleted successfully.');
                        location.reload(); // reload the page to update list
                    } else {
                        alert('Failed to delete car.');
                    }
                })
                .catch(error => {
                    console.error('Error deleting car:', error);
                    alert('Error occurred while deleting car.');
                });
    }
}


