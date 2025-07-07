// js/admin.js

function login() {
    const user = document.getElementById("username").value;
    const pass = document.getElementById("password").value;
    const errorMsg = document.getElementById("errorMsg");

    // Simulated admin credentials
    if (user === "admin" && pass === "1234") {
        localStorage.setItem("isAdmin", "true");
        showAdminPanel();
    } else {
        errorMsg.textContent = "Incorrect username or password.";
    }
}

function showAdminPanel() {
    document.getElementById("loginBox").style.display = "none";
    document.getElementById("adminPanel").style.display = "block";
    // document.getElementById("sidebar").style.display = "block";
}

function logout() {
    localStorage.removeItem("isAdmin");
    window.location.reload();
}

// Auto login check on page load
window.onload = () => {
    if (localStorage.getItem("isAdmin") === "true") {
        showAdminPanel();
    }
};
