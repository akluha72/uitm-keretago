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
    console.log("=== DEBUGGING FORM SUBMISSION ===");

    // Check if form elements exist
    console.log("Form elements check:");
    console.log("carMake element:", $('#carMake').length > 0 ? "EXISTS" : "NOT FOUND");
    console.log("carModel element:", $('#carModel').length > 0 ? "EXISTS" : "NOT FOUND");
    console.log("carYear element:", $('#carYear').length > 0 ? "EXISTS" : "NOT FOUND");
    console.log("carLicense element:", $('#carLicense').length > 0 ? "EXISTS" : "NOT FOUND");
    console.log("carRate element:", $('#carRate').length > 0 ? "EXISTS" : "NOT FOUND");

    // Check values
    console.log("Form values:");
    console.log("make:", $('#carMake').val());
    console.log("model:", $('#carModel').val());
    console.log("year:", $('#carYear').val());
    console.log("license:", $('#carLicense').val());
    console.log("rate:", $('#carRate').val());
    console.log("mileage:", $('#carMileage').val());
    console.log("transmission:", $('#carTransmission').val());
    console.log("seats:", $('#carSeats').val());
    console.log("luggage:", $('#carLuggage').val());
    console.log("fuel:", $('#carFuel').val());
    console.log("status:", $('#carStatus').val());

    // Check if modal is visible
    console.log("Modal visible:", $('#carModal').is(':visible'));

    const carId = $('#carForm').data('car-id');
    const formData = new FormData();

    // Add data with logging
    const formValues = {
        'make': $('#carMake').val(),
        'model': $('#carModel').val(),
        'yearMade': $('#carYear').val(),
        'licensePlate': $('#carLicense').val(),
        'dailyRate': $('#carRate').val(),
        'mileage': $('#carMileage').val(),
        'transmission': $('#carTransmission').val(),
        'seats': $('#carSeats').val(),
        'luggage': $('#carLuggage').val(),
        'fuelType': $('#carFuel').val(),
        'status': $('#carStatus').val()
    };

    console.log("Adding to FormData:");
    Object.entries(formValues).forEach(([key, value]) => {
        console.log(`${key}: "${value}"`);
        formData.append(key, value);
    });

    const isEdit = !!carId;
    if (isEdit)
        formData.append('id', carId);

    // To see FormData content, convert it to a regular object
    const formDataObj = {};
    for (let [key, value] of formData.entries()) {
        formDataObj[key] = value;
    }
    console.log("FormData contents:", formDataObj);

    $.ajax({
        url: isEdit ? 'update-car' : 'create-car',
        method: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function () {
            $('#carModal').modal('hide');
            alert(isEdit ? 'Car updated!' : 'Car added!');
            location.reload();
        },
        error: function (xhr) {
            console.error(xhr.responseText);
            alert('Failed to save car.');
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

function openAddCarModal() {
    $('#carForm')[0].reset();
    $('#carForm').removeData('car-id');
    $('#carModalTitle').text('Add New Car');
    $('#carModal').modal('show');
}


