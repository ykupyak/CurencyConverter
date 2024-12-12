# Currency Converter

Currency Converter is an iOS application that allows users to convert amounts between different currencies using real-time exchange rates. The app is built using Swift and UIKit, and it leverages the Model-View-ViewModel (MVVM) architecture pattern for a clean and maintainable codebase.

## Features

- Convert amounts between multiple currencies
- Real-time exchange rate updates
- User-friendly interface with intuitive controls
- Support for a wide range of currencies
- Error handling and user feedback for network issues

## Requirements

- iOS 18.0+
- Xcode 16.0+

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/CurrencyConverter.git
   ```
2. Open the project in Xcode:
   ```bash
   cd CurrencyConverter
   open CurrencyConverter.xcodeproj
   ```
3. Build and run the project on your simulator or device.

## Usage

1. Enter the amount you wish to convert in the text field.
2. Select the source and target currencies using the provided pickers.
3. The converted amount and exchange rate will be displayed automatically.
4. Use the "Swap" button to quickly switch between source and target currencies.

## Architecture

The project follows the MVVM architecture pattern:

- **Model**: Represents the data and business logic (e.g., `Currency`, `CurrencyResponse`).
- **View**: The UI components (e.g., `CurrencyViewController`).
- **ViewModel**: Handles the presentation logic and data binding (e.g., `CurrencyViewModel`).

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any improvements or bug fixes.

## Acknowledgments

- [SnapKit](https://github.com/SnapKit/SnapKit) for layout constraints
- [API Provider](http://api.evp.lt) for exchange rate data
