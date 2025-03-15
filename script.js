let selectedPrice = 0;

// Open booking popup
function openBookingPopup(button) {
    let card = button.closest(".accommodation-card");
    selectedPrice = parseInt(card.getAttribute("data-price"));

    document.getElementById("total-price").innerText = `Total: $${selectedPrice}`;
    document.getElementById("booking-popup").style.display = "block";

    // Auto-update price when nights change
    document.getElementById("num-nights").addEventListener("input", updateTotalPrice);
}

// Close booking popup
function closeBookingPopup() {
    document.getElementById("booking-popup").style.display = "none";
}

// Update total price dynamically
function updateTotalPrice() {
    let nights = document.getElementById("num-nights").value;
    let total = selectedPrice * nights;
    document.getElementById("total-price").innerText = `Total: $${total}`;
}

// Confirm booking
function confirmBooking() {
    let checkInDate = document.getElementById("check-in-date").value;
    let nights = document.getElementById("num-nights").value;

    if (!checkInDate || nights < 1) {
        alert("Please enter a valid check-in date and number of nights.");
        return;
    }

    let total = selectedPrice * nights;
    alert(`Booking Confirmed! Check-in: ${checkInDate}, Nights: ${nights}, Total: $${total}`);

    // Update Eco-Coins (reward system)
    let ecoCoins = parseInt(document.getElementById("eco-coins").innerText);
    ecoCoins += 10;
    document.getElementById("eco-coins").innerText = ecoCoins;

    closeBookingPopup();
}

// Open "List Your Stay" popup
function openPopup() {
    document.getElementById("popup-form").style.display = "block";
}

// Close "List Your Stay" popup
function closePopup() {
    document.getElementById("popup-form").style.display = "none";
}

// Submit new hotel
function submitHotel() {
    let name = document.getElementById("hotel-name").value;
    let price = document.getElementById("hotel-price").value;
    let rating = document.getElementById("hotel-rating").value;
    let image = document.getElementById("hotel-image").files[0];

    if (!name || !price || !rating || !image) {
        alert("Please fill in all fields.");
        return;
    }

    let newHotel = document.createElement("div");
    newHotel.classList.add("accommodation-card");
    newHotel.setAttribute("data-price", price);

    let imageURL = URL.createObjectURL(image);

    newHotel.innerHTML = `
        <img src="${imageURL}" alt="New Eco Hotel">
        <h2>${name}</h2>
        <p>🌿 Sustainability Score: ${rating}/10</p>
        <p>Price: $${price}/night</p>
        <button class="book-btn" onclick="openBookingPopup(this)">Book Now</button>
    `;

    document.querySelector(".accommodations").appendChild(newHotel);
    closePopup();

    document.getElementById("hotel-name").value = "";
    document.getElementById("hotel-price").value = "";
    document.getElementById("hotel-rating").value = "";
    document.getElementById("hotel-image").value = "";
}
