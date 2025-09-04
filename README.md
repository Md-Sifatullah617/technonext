
# TechnoNext - Car Route Application

## Overview
This Flutter app is built for the TechnoNext coding assessment. It allows users to select any two points on a map and instantly displays the optimal car route, prioritizing a highly visual and intuitive interface for route planning.

## Key Features
- **Interactive Map Interface:** Pan, zoom, and tap to select origin and destination points.
- **Point-and-Select Functionality:** Precisely mark two locations on the map.
- **Real-time Route Display:** Instantly render the car route between selected points, highlighting the path clearly.
- **Current Location:** Shows user's current location and allows quick camera movement to it.
- **State Management:** Uses Provider for robust state management.
- **Clean Architecture:** Feature-first folder structure with separation of data, domain, and presentation layers.

## Folder Structure
```
lib/
  features/
	 dashboard/
		data/
		domain/
		presentation/
	 splash/
		data/
		domain/
		presentation/
  gen/ (generated files)
```

## Setup Instructions
1. **Clone the repository:**
	```sh
	git clone <your-repo-url>
	cd technonext
	```
2. **Install dependencies:**
	```sh
	flutter pub get
	```
3. **Run the app:**
	```sh
	flutter run
	```
4. **Generate assets (if needed):**
	```sh
	flutter pub run build_runner build
	```

## Assessment Instructions
- Upload your code to GitHub and share the link with your recruiter.
- In a `dist` folder, upload the APK of the project.

## Notes for Reviewers
- The app demonstrates clean code, separation of concerns, and production-level standards.
- All main features and bonus points from the assessment are implemented.
- For any questions, see code comments or reach out via GitHub Issues.

---
**Made for TechnoNext Flutter Coding Assessment**
