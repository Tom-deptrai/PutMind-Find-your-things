# Store product setup (PutMind Lifetime)

Code uses product id: **`putmind_lifetime`** (non-consumable / one-time).

Production mobile runtime wires `StorePurchaseService` from `lib/main.dart`.
Web / tests use `FakePurchaseService`. If the store product is not created yet,
purchase/restore surfaces an unavailable state without crashing Home/Capture.

## Google Play Console

1. Create app (or open existing) with package `com.putmind.putmind`.
2. Monetize → In-app products → Create product.
3. Product ID: `putmind_lifetime`
4. Type: **Managed product** (one-time / non-subscription)
5. Name: PutMind Lifetime
6. Description: Unlimited memories — one-time unlock
7. Default price: **USD 6.99** (or local equivalents)
8. Activate the product.
9. License testing: add Gmail test accounts under Setup → License testing.
10. Upload a signed build (internal testing track) that includes Billing Library via `in_app_purchase`.

Until the product is active and the app is installed from Play (or sideloaded with the same package + license tester), store purchase/restore cannot be production-verified.

## App Store Connect

1. App → Features → In-App Purchases → Create.
2. Type: **Non-Consumable**
3. Product ID: `putmind_lifetime`
4. Reference name: PutMind Lifetime
5. Price: tier matching **$6.99**
6. Localization for display name/description
7. Clear for Sale
8. Submit with a binary that includes the IAP capability
9. Sandbox Apple ID for TestFlight / sandbox purchase testing

## Restore Purchase

Implemented via `InAppPurchase.restorePurchases()` and purchase stream (`purchased` / `restored` for `putmind_lifetime`). Entitlement persists in `AppSettings.isLifetimeUnlocked` after a verified store event.
