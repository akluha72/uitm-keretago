// Function to open NEW user modal
function openNewUserModal() {
    document.getElementById("userModalTitle").textContent = "Add New User";
    document.getElementById("saveUserBtn").innerHTML = '<i class="fas fa-save mr-2"></i>Save User';
  
    document.getElementById("userForm").reset();
    document.getElementById("userId").value = "";

    document.getElementById("passwordHelpText").textContent = "Minimum 6 characters required";
    document.getElementById("userPassword").required = true;
    document.getElementById("userConfirmPassword").required = true;

    $('#userModal').modal('show');
}


function editUser(userId) {

    document.getElementById("userModalTitle").textContent = "Edit User";
    document.getElementById("saveUserBtn").innerHTML = '<i class="fas fa-save mr-2"></i>Update User';


    fetch(`./get-user?id=${userId}`)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to fetch user details');
                }
                return response.json();
            })
            .then(user => {
  
                document.getElementById("userId").value = user.id;
                document.getElementById("userFullName").value = user.fullName;
                document.getElementById("userEmail").value = user.email;
                document.getElementById("userPhone").value = user.phone || '';
                document.getElementById("userRole").value = user.roles;

  
                document.getElementById("userPassword").value = '';
                document.getElementById("userConfirmPassword").value = '';

               
                document.getElementById("passwordHelpText").textContent = "Leave blank to keep current password";
                document.getElementById("userPassword").required = false;
                document.getElementById("userConfirmPassword").required = false;

               
                $('#userModal').modal('show');
            })
            .catch(error => {
                console.error("Error fetching user:", error);
                alert("Error loading user details: " + error.message);
            });
}


function saveUser() {
 
    const userId = document.getElementById("userId").value;
    const fullName = document.getElementById("userFullName").value.trim();
    const email = document.getElementById("userEmail").value.trim();
    const phone = document.getElementById("userPhone").value.trim();
    const role = document.getElementById("userRole").value;
    const password = document.getElementById("userPassword").value;
    const confirmPassword = document.getElementById("userConfirmPassword").value;


    if (!fullName || !email || !role) {
        alert("Please fill in all required fields (Full Name, Email, Role).");
        return;
    }

  
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        alert("Please enter a valid email address.");
        return;
    }

    if (!userId || password) { 
        if (!password) {
            alert("Password is required.");
            return;
        }
        if (password.length < 6) {
            alert("Password must be at least 6 characters long.");
            return;
        }
        if (password !== confirmPassword) {
            alert("Passwords do not match.");
            return;
        }
    }


    const formData = new URLSearchParams();
    formData.append("full_name", fullName);
    formData.append("email", email);
    formData.append("phone", phone);
    formData.append("roles", role);

    if (password) {
        formData.append("password", password);
    }

    if (userId) {
        formData.append("user_id", userId);
    }


    const url = userId ? "update-user" : "create-user";

    // Send request
    fetch(url, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: formData.toString(),
    })
            .then(response => {
                if (response.ok) {
                    $('#userModal').modal('hide');
                    const message = userId ? "User updated successfully." : "User created successfully.";
                    alert(message);
                    location.reload(); // Refresh the page to update the user list
                } else {
                    return response.text().then(text => {
                        throw new Error(text || "Failed to save user.");
                    });
                }
            })
            .catch(error => {
                console.error("Save user error:", error);
                alert("Error saving user: " + error.message);
            });
}

// Function to delete user
function deleteUser(userId) {

    if (!confirm("Are you sure you want to delete this user? This action cannot be undone.")) {
        return;
    }


    const formData = new URLSearchParams();
    formData.append("user_id", userId);


    fetch("delete-user", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
        },
        body: formData.toString(),
    })
            .then(response => {
                if (response.ok) {
                    alert("User deleted successfully.");
                    location.reload();
                } else {
                    return response.text().then(text => {
                        throw new Error(text || "Failed to delete user.");
                    });
                }
            })
            .catch(error => {
                console.error("Delete user error:", error);
                alert("Error deleting user: " + error.message);
            });
}


document.addEventListener("DOMContentLoaded", function () {
    const passwordField = document.getElementById("userPassword");
    const confirmPasswordField = document.getElementById("userConfirmPassword");

    if (passwordField && confirmPasswordField) {
        confirmPasswordField.addEventListener("input", function () {
            if (passwordField.value !== confirmPasswordField.value) {
                confirmPasswordField.setCustomValidity("Passwords do not match");
            } else {
                confirmPasswordField.setCustomValidity("");
            }
        });

        passwordField.addEventListener("input", function () {
            if (passwordField.value !== confirmPasswordField.value) {
                confirmPasswordField.setCustomValidity("Passwords do not match");
            } else {
                confirmPasswordField.setCustomValidity("");
            }
        });
    }
});