# Absence Manager

Absence Manager is a Flutter app designed to manage and view employee absence records. It leverages the BLoC pattern for state management and integrates with external services to fetch absence and member records. Users can apply filters, view records, and interact with the absence details.

Application demo video : https://drive.google.com/file/d/1lubxT6YL08RJGavqk1evG2IoMc4L74Sn/view?usp=sharing

## Features

- Fetch employee absence records from the server.
- Paginate records for efficient viewing.
- Apply filters based on request type and date.
- View detailed information for each absence record.
- Display error messages when the service fails.
- Responsive and user-friendly interface with Flutter.

## Architecture

The application follows the BLoC (Business Logic Component) pattern for state management, which helps to separate business logic from UI code. The application includes:

- **BLoC**: Handles events and states for managing absence records, pagination, and filtering.
- **Services**: Communicate with external APIs to fetch absence and member records.
- **Models**: Represent the data structure of the records.
- **Widgets**: UI components that interact with the BLoC to display data.

## Installation

1. Clone the repository:

    ```bash
   git clone https://github.com/iamkhalil1986/absence_manager.git
   
2. Navigate to the project directory:

    ```bash
   cd absence_manager

3. Install the dependencies:

    ```bash
   flutter pub get

4. Run the app:

    ```bash
   flutter run

## Usage
Once the app is running, you can interact with the following components:

1. Absence Records List
   - The list displays the absence records for employees.
   - It supports pagination, so you can scroll to load more records.
   - You can apply filters (e.g., by date or request type) to refine the records shown.
2. Absence Record Details
   - Tapping on any record will navigate to the details screen where you can view more information about the absence.
3. Filters
   -The filters are available via the App Bar, allowing users to filter by request type (e.g., sickness, vacation) or by a specific date.

# Testing
   To run the tests for the project, you can use the following commands:

## Commands for running application and execute unit/widget/integration tests

Once dependencies are fetched using "flutter pub get", run below command to run application.

    flutter run
    
 We have created a dedicated test suite in the file ./test/absence_manager_test.dart that allows you to run all test cases at once. Simply execute the command below to run the tests. This approach is efficient and faster, as it allows you to run all tests together, rather than executing tests for the entire /test folder.

    flutter test ./test/absence_manager_test.dart 


Inorder to run integration test, run below command

    flutter test integration_test/absence_manager_integration_test.dart


## Code Coverage
To generate code coverage, use:

    flutter test --coverage ./test/absence_manager_test.dart

You can then view the coverage report in the coverage/lcov-report/index.html file.

## Code Coverage Dependencies
- flutter_bloc: For state management using the BLoC pattern.
- http: To make network requests to fetch records.
- collection: Provides utility methods like firstWhereOrNull for lists.
- mocktail: For mocking dependencies in tests.

---

# Important Note: 
This application requires the Mockoon server to fetch absence records. A pre-configured mockoon.json file containing all the sample responses has already been created for you. You can find this file in the root folder of the project.

    ~/absence_manager/mockoon.json

## App-Level Configuration in `app_configuration.dart`

The `app_configuration.dart` file contains essential app-level configurations, including the web service's base URL. This URL can be easily modified to point to the Mockoon server by updating the IP address and port number as per your setup.

```
class AppConfiguration {
   static String baseURL = "localhost:3000";
}
```

# Running Mockoon GUI App Locally with an Existing `mockoon.json` File

This guide will show you how to run the Mockoon GUI application locally using an existing `mockoon.json` file to start a server.

## Prerequisites

1. **Mockoon GUI Application**: If you don’t have the Mockoon app installed, follow the instructions below.
2. **Existing `mockoon.json` File**: You should already have a `mockoon.json` file that contains the configuration for your mock API.

## Installation

### 1. Download and Install Mockoon GUI

The Mockoon GUI app is available for Windows, macOS, and Linux. Follow the installation instructions for your operating system.

- **Windows**: Download the installer from the [Mockoon website](https://mockoon.com/download/) and run the installer.
- **macOS**: Download the `.dmg` file from the [Mockoon website](https://mockoon.com/download/) and follow the installation process.
- **Linux**: Follow the instructions on the [Mockoon GitHub Releases page](https://github.com/mockoon/mockoon/releases) to install the `.AppImage` file or use your distribution's package manager if available.

Once installed, launch the Mockoon GUI application.

### 2. Verify Installation

You can verify that the app is working by launching it from your applications list. The Mockoon GUI should open with an empty workspace.

## Running Mockoon with an Existing `mockoon.json` File

### 1. Open the Mockoon GUI

Open the Mockoon application you just installed.

### 2. Import the Existing `mockoon.json` File

1. In the Mockoon GUI, click on the **"File"** menu at the top.
2. Select **"Import"**.
3. Navigate to the directory containing your `mockoon.json` file, and select it.

Alternatively, you can drag and drop the `mockoon.json` file directly into the Mockoon workspace.

### 3. Start the Mockoon Server

Once the `mockoon.json` file is imported:

1. You should see the mock environment(s) in the workspace.
2. To start the server, simply click the **"Play"** button (it looks like a green triangle) located at the top-left of the window.

By default, Mockoon will run the server on port `3000`. If you'd like to change the port:

1. Click on the **"Environment"** tab in the Mockoon app.
2. In the **"Port"** field, change the port number to your desired port (e.g., `5000`).
3. Click the **"Save"** button to apply the changes.

### 4. Test the Server

Once the server is running, you can test the mock API by visiting the following URL in your browser or API client (like Postman):

- Default port: `http://localhost:3000`
- Custom port (if you changed it): `http://localhost:5000`

You should be able to see the mock API responses defined in your `mockoon.json` file.

### 5. Stopping the Server

To stop the Mockoon server, simply click the **"Stop"** button (it looks like a red square) located at the top-left of the window.
