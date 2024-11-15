# Community Collection Centers App - Mobile Application Proposal

This project is a proposal for a mobile application designed to streamline the process of collecting and managing donations for the **Banco de Alimentos de Guadalajara**. The application introduces three types of user profiles, **"Guest"**, **"Registered User"** and **"BAMX Admin"**, enabling these three individuals or businesses to participate in donation efforts effectively.

---

## Key Features

### User Roles:
- **Guest**:
  - No account creation is required.
  - Access to view nearby community collection centers on a map.
  - Designed for casual users looking to locate donation centers easily.
  
- **Registered User**:
  - Designed for businesses or organizations (e.g., Walmart, local stores).
  - Acts as a community or private collection center based on preferences.
  - Can manage inventory of donations and track progress towards collection goals.
 
- **BAMX Admin**:
  - Access to a dashboard displaying all registered collection centers and their current inventory levels.
  - Can approve or reject applications from users requesting to register as collection centers.
  - Has the authority to manage centers, including deleting.
  - Determines when collection trucks are dispatched based on inventory levels at centers.

---

## Technologies Used

### Mobile Development:
- **Front-end**: Flutter for cross-platform development (iOS/Android).

### Back-end:
- **Server**: Node.js with Express for API routing and logic.
- **Database**: Supabase (PostgreSQL-based platform for real-time database and authentication).
- **Email Notifications**: Mailgun for TFA via email notifications.
- **Google Maps API**: To fetch coordinates via an address.

### API Integration:
- **Google Maps API**: The map is central to the app experience, allowing users to locate nearby centers dynamically. It has custom features such as custom map styling and dynamic markers for showing the collection centers location and information.

### Development Tools:
- **Postman**: for testing APIs.
- **Supabase Dashboard**: Used for managing and visualizing the PostgreSQL database
- **Git**: for version control and collaboration.

---

## How It Works

1. **Guest Experience**:
   - Opens the app without creating an account.
   - Views nearby community collection centers on a map using geolocation.
   - Makes a donation, which is then added to the respective center's inventory.

2. **Registered User Experience**:
   - Registers as a business or organization to create a collection center.
   - Manages their center's inventory via the app.
   - Tracks donation progress and gets notified when a collection threshold is reached.

3. **Donation Logistics**:
   - Inventory thresholds are dynamically calculated to optimize pickup routes for **Banco de Alimentos** trucks.
   - Once reached, **Banco de Alimentos de Guadalajara** is notified to schedule a collection.

---

## Requirements to Run the Program

- Install **Flutter** and configure it for mobile development (iOS/Android).
- Install **Node.js** for running the server.
