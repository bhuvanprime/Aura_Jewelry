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

