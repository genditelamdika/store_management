# Copilot Instructions for store_management

## Overview
This repository contains a multi-component system for store management, consisting of a Go backend (`server/`) and a Flutter frontend (`store_app/`). The backend handles data, authentication, and reporting, while the Flutter app manages the user interface and local data persistence.

## Architecture
- **Backend (`server/`)**: Go modules organized by domain (models, handlers, repositories, routes, etc.). Uses PostgreSQL, JWT, and bcrypt. Data flows from HTTP handlers → repositories → models/database.
- **Frontend (`store_app/`)**: Flutter app using GetX for state management, Hive for local storage, and connectivity_plus for network checks. Data is cached locally and synced to the backend when online.

## Key Patterns & Conventions
- **Local Data Sync**: Flutter app stores pending reports in Hive (e.g., `PendingPromoStore`). On connectivity, it attempts to POST to the backend and, on success, moves data to permanent storage (`PromoStore`).
- **Key Naming**: Hive keys are structured as `PromoStore{storeId}Product{productId}` for easy lookup and deletion.
- **API URLs**: Managed via environment variables (see `.env` and `flutter_dotenv`).
- **Error Handling**: User feedback via `Get.snackbar`. Network errors do not block local data entry.
- **State Management**: Uses `Rx`/`Rxn` from GetX for observable state.

## Developer Workflows
- **Backend**:
  - Build: `go build ./...` in `server/`
  - Run: `go run main.go` in `server/`
  - Migrations: See `database/migration.go`
- **Frontend**:
  - Build/Run: `flutter run` in `store_app/`
  - Test: `flutter test` in `store_app/`
  - Update dependencies: `flutter pub get`

## Integration Points
- **API Contract**: See Go handlers in `server/handlers/` and DTOs in `server/dto/` for request/response shapes.
- **Data Models**: Dart models in `store_app/lib/app/data/model/` should match Go models in `server/models/`.
- **Environment**: API URL must be set in both Go and Flutter environments.

## Examples
- **Sync Pending Promos**: See `promo_controller.dart: sendPromoReport()` for the pattern of syncing local Hive data to the backend.
- **Add/Remove Promos**: See `addPromo()` and `deletePendingPromo()` for local data mutation and cleanup.

## Tips
- Always check for network connectivity before attempting API calls in Flutter.
- Use structured Hive keys for efficient data management.
- Keep API contracts in sync between frontend and backend.

---
For more details, see `README.md` in each component and key files referenced above.
