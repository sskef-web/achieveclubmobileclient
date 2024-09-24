
# Achieve CLub Mobile Application

Flutter application for completing achievements

# How to launch application
- [Installing Dart and Flutter on Windows](#installing-dart-and-flutter-on-windows)
- [Installing Dart and Flutter on Linux](#installing-dart-and-flutter-on-linux)
- [How to Run the Project](#how-to-run-the-project)
- [Additional Notes](#additional-notes)


# Installing Dart and Flutter on Windows

## Installing Dart

1. **Download the Dart SDK:**

    - Go to the [Dart SDK releases page](https://dart.dev/get-dart/archive) and download the latest stable release for Windows.

2. **Extract the SDK:**

    - Extract the downloaded zip file to a preferred location, e.g., `C:\dart`.

3. **Add Dart to the PATH environment variable:**

    - Open the **Start** search, and type `env`, select **"Edit the system environment variables"**.
    - Click on the **"Environment Variables"** button.
    - In the **"System variables"** section, find the `Path` variable and click **Edit**.
    - Click **New** and add the path to the Dart SDK `bin` folder, e.g., `C:\dart\dart-sdk\bin`.
    - Click **OK** to close all dialog boxes.

4. **Verify Dart installation:**

    Open a new Command Prompt window and run:

    ```sh
    dart --version
    ```

## Installing Flutter

1. **Download the Flutter SDK:**

    - Go to the [Flutter SDK releases page](https://docs.flutter.dev/get-started/install/windows) and download the latest stable release for Windows.

2. **Extract the SDK:**

    - Extract the downloaded zip file to a preferred location, e.g., `C:\flutter`.

3. **Add Flutter to the PATH environment variable:**

    - Open the **Start** search, and type `env`, select **"Edit the system environment variables"**.
    - Click on the **"Environment Variables"** button.
    - In the **"System variables"** section, find the `Path` variable and click **Edit**.
    - Click **New** and add the path to the Flutter SDK `bin` folder, e.g., `C:\flutter\bin`.
    - Click **OK** to close all dialog boxes.

4. **Verify Flutter installation:**

    Open a new Command Prompt window and run:

    ```sh
    flutter doctor
    ```

5. **Install additional dependencies:**

    - Install Git for Windows from [git-scm.com](https://git-scm.com/download/win) if not already installed.
    - Run `flutter doctor` again to check for any other missing dependencies and follow the instructions to resolve them.

## Additional Steps

- **Install Android Studio (if required for Android app development):**

    Download and install Android Studio from the [official website](https://developer.android.com/studio). After installation, open Android Studio and install the SDK and necessary tools.

- **Setup devices for testing:**

    Ensure you have access to an emulator or physical device for testing applications. You may need to install additional drivers or tools for this.

## Conclusion

After completing these steps, you should be ready to develop applications using Dart and Flutter on your Windows system.


# Installing Dart and Flutter on Linux

## Installing Dart

1. **Add the Dart repository:**

    ```sh
    sudo apt update
    sudo apt install apt-transport-https
    sudo sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
    sudo sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
    ```

2. **Update packages and install Dart:**

    ```sh
    sudo apt update
    sudo apt install dart
    ```

3. **Add Dart to the PATH environment variable:**

    ```sh
    echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.profile
    source ~/.profile
    ```

4. **Verify Dart installation:**

    ```sh
    dart --version
    ```

## Installing Flutter

1. **Download the Flutter SDK:**

    ```sh
    cd ~
    git clone https://github.com/flutter/flutter.git -b stable
    ```

2. **Add Flutter to the PATH environment variable:**

    ```sh
    echo 'export PATH="$PATH:~/flutter/bin"' >> ~/.profile
    source ~/.profile
    ```

3. **Verify Flutter installation:**

    ```sh
    flutter doctor
    ```

4. **Install required dependencies:**

    ```sh
    sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
    ```

5. **Check for required components:**

    ```sh
    flutter doctor
    ```

    Ensure all necessary components are installed. Follow the instructions provided by `flutter doctor` to fix any issues.

## Additional Steps

- **Install Android Studio (if required for Android app development):**

    Download and install Android Studio from the [official website](https://developer.android.com/studio). After installation, open Android Studio and install the SDK and necessary tools.

- **Setup devices for testing:**

    Ensure you have access to an emulator or physical device for testing applications. You may need to install additional drivers or tools for this.

## Conclusion

After completing these steps, you should be ready to develop applications using Dart and Flutter on your Linux system.

# How to Run the Project

 1. **Clone the Repository**:
	   ```sh
	   git clone https://github.com/sskef-web/achieveclubmobileclient.git
	   ```
   2. **Navigate to the Project Directory**:
		```sh
		cd achieveclubmobileclient
		```
   3. **Get Dependencies**:
		```sh
		flutter pub get
		```
   4. **Run the Project**:
		```sh
		flutter run
		```
## Additional Notes
- Make sure you have a device connected or an emulator running before executing `flutter run`.
- If you encounter any issues, ensure that your Flutter SDK is up-to-date by running:
	```sh
	flutter upgrade
	```
That's it! You should now be able to run the Flutter project successfully.
