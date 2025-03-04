# StrideHub

StrideHub is a Flutter application designed to provide a seamless user experience for authentication, profile setup, and navigation through various features. This README provides a comprehensive guide to the project's structure, setup, and functionality.

## Table of Contents

- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Features](#features)
  - [Authentication](#authentication)
  - [Profile Setup](#profile-setup)
  - [Home](#home)
- [Routes](#routes)
- [Build and Run](#build-and-run)
- [Contributing](#contributing)
- [License](#license)

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.

## Project Structure
stridehub/ ├── android/ ├── ios/ ├── lib/ │ ├── core/ │ │ ├── constants/ │ │ ├── utils/ │ │ ├── widgets/ │ ├── data/ │ │ ├── models/ │ │ ├── repositories/ │ ├── features/ │ │ ├── auth/ │ │ │ ├── screens/ │ │ │ ├── widgets/ │ │ │ ├── controllers/ │ │ │ ├── services/ │ ├── routes/ │ ├── main.dart ├── test/ ├── .dart_tool/ ├── .idea/ ├── .vscode/ ├── build/ ├── linux/ ├── macos/ ├── web/ ├── windows/ ├── pubspec.lock ├── pubspec.yaml ├── README.md


### Core

- **constants/**: Contains app-wide constants such as colors, strings, and styles.
- **utils/**: Reusable utility functions like validators and formatters.
- **widgets/**: Reusable widgets like custom buttons and loading spinners.

### Data

- **models/**: Data models for the application.
- **repositories/**: Abstracted data sources (e.g., APIs, Firebase, local DB).

### Features

- **auth/**: Authentication feature including screens, widgets, controllers, and services.

### Routes

- **app_routes.dart**: Centralized navigation management.

## Features

### Authentication

The authentication feature includes the following screens:

- **Login Screen**: Allows users to log in to the application.
- **Sign Up Screen**: Allows new users to create an account.

### Profile Setup

The profile setup feature includes:

- **Profile Setup Screen**: Allows users to set up their profile after signing up.

### Home

The home feature includes:

- **Bottom Navigation Bar**: Provides navigation to different sections of the app.

## Routes

The routes are managed in the [`AppRoutes`](lib/routes/app_routes.dart) class. Here are the available routes:

- **Login**: `/`
- **Sign Up**: `/signup`
- **Profile Setup**: `/profileSetup`
- **Home**: `/home`

## Build and Run

To build and run the project, follow these steps:

1. **Clone the repository**:
   ```sh
   git clone https://github.com/MOHIT-S-MAURYA/stridehub.git
   cd stridehub
2. **Install dependencies**:
    ```sh
    flutter pub get
4.  **Run the application**:
   ```sh
    flutter run
