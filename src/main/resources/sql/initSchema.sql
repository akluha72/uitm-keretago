
CREATE TABLE users (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    roles VARCHAR(20) CHECK (roles IN ('admin', 'customer')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE cars (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year_made INT,
    license_plate VARCHAR(20) NOT NULL UNIQUE,
    daily_rate DECIMAL(10, 2) NOT NULL,
    mileage INT,
    transmission VARCHAR(20),
    seats INT,
    luggage INT,
    fuel_type VARCHAR(20),
    features VARCHAR(255),
    image_url VARCHAR(255),
    status VARCHAR(20) CHECK (status IN ('available', 'booked', 'maintenance')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);


CREATE TABLE bookings (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    car_id INT NOT NULL,
    user_email VARCHAR(100) NOT NULL,
    pickup_date DATE NOT NULL,
    return_date DATE NOT NULL,
    pickup_time TIME,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_car FOREIGN KEY (car_id) REFERENCES cars(id),
    CONSTRAINT fk_user_email FOREIGN KEY (user_email) REFERENCES users(email)
);


CREATE TABLE messages (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(200),
    message VARCHAR(5000) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- adding sample data for initial setup
INSERT INTO cars (make, model, year_made, license_plate, daily_rate, mileage, transmission, seats, luggage, fuel_type, features, image_url, status)
VALUES 
('Perodua', 'Myvi', 2022, 'WXA1234', 120.00, 15000, 'Automatic', 5, 2, 'Petrol', 'Air Conditioning, Bluetooth, ABS', 'myvi.jpg', 'available'),
('Proton', 'Saga', 2021, 'BCA5678', 100.00, 22000, 'Automatic', 5, 2, 'Petrol', 'Air Conditioning, USB, EBD', 'saga.jpg', 'available'),
('Honda', 'City', 2023, 'VDR9988', 180.00, 8000, 'Automatic', 5, 2, 'Petrol', 'Cruise Control, Airbags, Touchscreen', 'city.jpg', 'booked'),
('Toyota', 'Vios', 2022, 'JHL4455', 170.00, 12000, 'Automatic', 5, 3, 'Petrol', 'Reverse Camera, ABS, EBD', 'vios.jpg', 'available'),
('Perodua', 'Alza', 2023, 'MKH7777', 200.00, 5000, 'Automatic', 7, 4, 'Petrol', '7-Seater, Rear A/C, Parking Sensor', 'alza.jpg', 'maintenance'),
('Proton', 'X70', 2023, 'WXK8888', 250.00, 4000, 'Automatic', 5, 4, 'Petrol', 'Sunroof, ADAS, Keyless Entry', 'x70.jpg', 'available');


INSERT INTO bookings (car_id, user_email, pickup_date, return_date, pickup_time, status)
VALUES 
(1, 'user1@example.com', '2025-07-21', '2025-07-24', '10:00:00', 'active');


INSERT INTO bookings (car_id, user_email, pickup_date, return_date, pickup_time, status)
VALUES 
(1, 'user1@example.com', '2025-07-21', '2025-07-24', '10:00:00', 'active'),
(2, 'user2@example.com', '2025-07-22', '2025-07-25', '09:00:00', 'active'),
(3, 'user3@example.com', '2025-07-23', '2025-07-26', '11:30:00', 'active');