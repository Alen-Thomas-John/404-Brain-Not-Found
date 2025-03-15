let selectedMealPrice = 0;

// Open order popup
function openOrderPopup(button) {
    let card = button.closest(".restaurant-card");
    selectedMealPrice = parseInt(card.getAttribute("data-price"));

    document.getElementById("order-total").innerText = `Total: $${selectedMealPrice}`;
    document.getElementById("order-popup").style.display = "block";

    // Auto-update price when quantity changes
    document.getElementById("meal-quantity").addEventListener("input", updateTotalPrice);
}

// Close order popup
function closeOrderPopup() {
    document.getElementById("order-popup").style.display = "none";
}

// Update total price dynamically
function updateTotalPrice() {
    let quantity = document.getElementById("meal-quantity").value;
    let total = selectedMealPrice * quantity;
    document.getElementById("order-total").innerText = `Total: $${total}`;
}

// Confirm order
function confirmOrder() {
    let mealName = document.getElementById("meal-name").value;
    let quantity = document.getElementById("meal-quantity").value;

    if (!mealName || quantity < 1) {
        alert("Please enter a valid meal name and quantity.");
        return;
    }

    let total = selectedMealPrice * quantity;
    alert(`Order Confirmed! Meal: ${mealName}, Quantity: ${quantity}, Total: $${total}`);

    // Update Eco-Coins (reward system)
    let ecoCoins = parseInt(document.getElementById("eco-coins").innerText);
    ecoCoins += 5; // Reward 5 Eco-Coins per order
    document.getElementById("eco-coins").innerText = ecoCoins;

    closeOrderPopup();
}

// Open "List Your Restaurant" popup
function openRestaurantPopup() {
    document.getElementById("restaurant-popup").style.display = "block";
}

// Close "List Your Restaurant" popup
function closeRestaurantPopup() {
    document.getElementById("restaurant-popup").style.display = "none";
}

// Submit new restaurant
function submitRestaurant() {
    let name = document.getElementById("restaurant-name").value;
    let location = document.getElementById("restaurant-location").value;
    let price = document.getElementById("restaurant-price").value;
    let image = document.getElementById("restaurant-image").files[0];

    if (!name || !location || !price || !image) {
        alert("Please fill in all fields.");
        return;
    }

    let newRestaurant = document.createElement("div");
    newRestaurant.classList.add("restaurant-card");
    newRestaurant.setAttribute("data-price", price);

    let imageURL = URL.createObjectURL(image);

    newRestaurant.innerHTML = `
        <img src="${imageURL}" alt="New Eco Restaurant">
        <h2>${name}</h2>
        <p>📍 Location: ${location}</p>
        <p>Avg Meal Price: $${price}</p>
        <button class="order-btn" onclick="openOrderPopup(this)">Order Now</button>
    `;

    document.querySelector(".restaurants").appendChild(newRestaurant);
    closeRestaurantPopup();

    document.getElementById("restaurant-name").value = "";
    document.getElementById("restaurant-location").value = "";
    document.getElementById("restaurant-price").value = "";
    document.getElementById("restaurant-image").value = "";
}
