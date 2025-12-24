# Appium Testing Instructions

This project includes Appium test scripts to verify core functionalities: Authentication and Cart operations.

## Prerequisites
1.  **Python 3.x** installed.
2.  **Appium Server** installed and running (`npm install -g appium`).
3.  **Appium Inspector** (optional, for debugging).
4.  **Android SDK / Xcode** (for Emulators/Simulators).
5.  **Flutter Driver** extension (optional, but standard Appium works with accessibility IDs).

## Dependencies
Install the required Python client for Appium:
```bash
pip install Appium-Python-Client
```

## Running the Tests
1.  Start your Android Emulator or connect a real device.
2.  Start the Appium Server:
    ```bash
    appium
    ```
3.  Run the tests:
    ```bash
    python tests/appium/auth_test.py
    python tests/appium/cart_test.py
    ```

> Note: You may need to update the `desired_caps` in the scripts to match your specific device name, platform version, and the path to the generate APK build.

## Test Scenarios
1.  **auth_test.py**: Verified Sign Up flow and Login flow, checking for successful navigation to Home.
2.  **cart_test.py**: Selects a product, adds it to cart, navigates to cart screen, and verifies the item is present.
