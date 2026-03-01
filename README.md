# 🛒 Twende Markiti – Flutter Online Market App

A complete Flutter e-commerce app for online grocery/market shopping with
**Customer** and **Admin** sides, built with Riverpod state management and mock data.

---

## 📱 Features

### Customer Side
- 🎬 Splash + Onboarding screens  
- 🔐 Login / Register  
- 🏪 Home with promo banners & category filters  
- 🔍 Product search  
- 📦 Product detail with reviews  
- 🛒 Cart with quantity management  
- ❤️ Wishlist / Saved items  
- 💳 Checkout with address + M-Pesa/Airtel/Cash payment  
- 🎉 Order success screen  
- 📋 Order history with live timeline tracking  
- 🔔 Notifications  
- 👤 Profile & account management  

### Admin Side
- 📊 Dashboard with revenue chart (fl_chart) & stats  
- 📦 Product management (Add / Edit / Delete / Toggle active)  
- 📋 Order management with status updates  
- 👥 Customer list  
- ⚙️ Settings panel  

---

## 🚀 How to Build

### Requirements
- Flutter SDK ≥ 3.10  
- Android Studio / VS Code  
- Android SDK (for APK)

### Steps

```bash
# 1. Get dependencies
flutter pub get

# 2. Run on device/emulator
flutter run

# 3. Build APK
flutter build apk --release

# APK location:
# build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔑 Demo Login

| Role     | Email                    | Password   |
|----------|--------------------------|------------|
| Admin    | admin@twende.co.tz       | admin123   |
| Customer | amina@example.com        | password123|

---

## 📁 Project Structure

```
lib/
├── main.dart              # App entry point
├── router.dart            # GoRouter navigation
├── models/models.dart     # Data models
├── data/mock_data.dart    # Mock products, orders, users
├── providers/providers.dart # Riverpod state management
├── utils/app_theme.dart   # Theme & helpers
├── widgets/               # Reusable widgets
└── screens/
    ├── auth/              # Splash, Onboarding, Login, Register
    ├── customer/          # Home, Cart, Orders, Profile, etc.
    └── admin/             # Dashboard, Products, Orders, Customers
```

---

## 💡 Tech Stack

| Package            | Use                        |
|--------------------|----------------------------|
| flutter_riverpod   | State management           |
| go_router          | Navigation                 |
| fl_chart           | Revenue charts             |
| google_fonts       | DM Sans + Playfair Display |
| badges             | Cart count badge           |
| smooth_page_indicator | Onboarding dots         |
| timeline_tile      | Order tracking timeline    |
| uuid               | Unique order IDs           |

---

Built with ❤️ for Tanzanian markets 🇹🇿