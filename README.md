# ✨ Aura Luxury Jewelry App

A regal, high-end e-commerce application built with **Flutter**, **Firebase**, and **flutter_bloc**. Crafted with a palace-inspired **Rajwada / Mughal luxury design system**, state-of-the-art animations, zero-latency caching, secure PII encryption, and real-time inventory management.

---

## 🎨 Design System & Aesthetic (Rajwada Palace Theme)

The application features a bespoke **heritage luxury palette and typography system**:

| Design Token | Hex Code | Visual Application |
| :--- | :--- | :--- |
| **Maroon Deep** | `#5C0F1E` | Royal header gradients, primary accent, active category icons |
| **Maroon Black** | `#2B0710` | Dark gradient base, active nav bar pill indicator |
| **Antique Gold** | `#B8863B` | CTAs, ratings, hallmark tags, live gold rate ticker |
| **Antique Gold Light** | `#E4C77E` | Text highlights, jaali dividers, outline borders |
| **Warm Ivory (Sandal)** | `#F8F1E0` | Primary scaffold & screen canvas background |
| **Ivory Tint (Sandal Dark)**| `#EDE7DA` | Trust badge container, elevated card surfaces |
| **Sandstone (Charcoal Muted)**| `#8C7A5C` | Inactive tabs, secondary descriptions |
| **Charcoal Deep** | `#241812` | High-contrast luxury headings and body text |

### 🖋 Typography
- **Headlines & Display:** *Cormorant Garamond* (Mughal-inspired elegant serif)
- **Body, UI & Numbers:** *Manrope* (Clean, modern sans-serif with tabular price numerals)

---

## 💎 Features

### 🛍 Customer Experience
* **Royal Header & Live Ticker:** Custom curved maroon gradient header with live 22K Gold Rate ticker and real-time navigation shortcuts.
* **Hero Banner with Jaali Motifs:** Diagonal maroon gradient frame adorned with antique gold jaali / lattice diamond ornaments.
* **Curated Categories:** Circular category tiles (Necklaces, Bangles, Earrings, Rings, Bridal) with interactive accordions and deep filters.
* **Luxury Product Grid:** BIS Hallmark (22K916) certification tags, high-resolution cached photography, wishlist toggles, and instant cart actions.
* **Dynamic Search & Multi-criteria Filtering:** Instant zero-latency filter by text query, price slider, ring/bangle size, and category.
* **Shopping Bag & Checkout Flow:** Real-time subtotal calculation, quantity adjustment, secure mock checkout, and regal order success screen.
* **Favorites / Wishlist:** Instant state synchronization with optimistic UI updates.
* **Customer Profile & Auth:** Secure OTP/Password authentication with AES encryption for PII protection before cloud synchronization.

### 🛡 Admin Experience
* **Role-Based Access Control (RBAC):** Automatic routing for users with the `'admin'` role to the Inventory Management Dashboard.
* **Live Catalog CRUD:** Add, update, and manage jewelry items in real-time.
* **Cloud Syncing:** Changes made in the admin portal stream instantly to all connected mobile clients via Cloud Firestore listeners.

---

## 🏗 Architecture & Project Structure

The project follows clean architecture principles with feature-first modularity:

```
lib/
├── core/
│   ├── constants/        # App strings, assets, constants
│   ├── crypto/           # AES encryption for PII data protection
│   ├── firebase/         # Firebase initialization & instance services
│   └── theme/            # AppColors, AppTypography, AppTheme, AppShadows, AppSpacing
├── features/
│   ├── admin/            # Inventory dashboard & CRUD operations
│   ├── auth/             # Authentication (Login, OTP, User models, Encryption)
│   ├── cart/             # Cart state, item models, checkout screens
│   ├── categories/       # Category browser, style filter, accordion views
│   ├── home/             # Home screen, Hero banner, Category strip, Trust strip
│   ├── products/         # Product catalog, detail screens, wishlist state
│   ├── profile/          # User profile, order history, settings
│   └── search/           # Catalog search & discovery
├── shared/
│   └── widgets/          # Global loaders, error states, bottom navigation, product cards
└── main.dart             # App entry point, MultiRepositoryProvider & MultiBlocProvider setup
```

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.19.0 or newer recommended)
* Dart SDK (compatible with Flutter 3.x)
* [Firebase CLI](https://firebase.google.com/docs/cli) & [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/bhuvanprime/Aura_Jewelry.git
   cd Aura_Jewelry
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase (Optional for Cloud Sync):**
   ```bash
   flutterfire configure
   ```
   > *Note: The app comes with offline mock fallbacks, so you can run it immediately without Firebase setup for local UI development.*

4. **Run the App:**
   ```bash
   flutter run
   ```

---

## 🧪 Testing & Code Quality

Run static analysis and automated unit/widget tests:

```bash
# Run static analysis
flutter analyze

# Run unit and widget tests
flutter test
```

---

## 📦 Key Dependencies

* **State Management:** `flutter_bloc`, `bloc`, `equatable`
* **Cloud Backend:** `cloud_firestore`, `firebase_core`, `firebase_auth`
* **Local Storage & Security:** `hive_flutter`, `flutter_secure_storage`, `encrypt`
* **UI & Typography:** `google_fonts`, `cached_network_image`, `shimmer`

---

## 📄 License
This project is proprietary and built for **Aura Luxury Jewelry**. All rights reserved.
