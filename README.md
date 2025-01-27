# DVT-Weather

An iOS weather application that fetches real-time weather data and forecasts based on the user's location. The app uses `SwiftUI` for the User Interface, and `Combine` to handle asynchronous data fetching and presents errors in a user-friendly manner with alerts. It integrates with the `OpenWeather API` for weather data, and `CLGeocoder` for translating location names' to Coordinates and Maps from Apple.

## Preview (Both Light and Dark Modes)
<div style="display:flex; justify-content:center;">
  <img src="https://github.com/gichukipaul/DVT-Weather/blob/main/screenshots/main1light.png" alt="Light Mode Screenshot 1" width="220" style="margin-right: 25px;"/>

  <img src="https://github.com/gichukipaul/DVT-Weather/blob/main/screenshots/main2light.png" alt="Light Mode Screenshot 2" width="220" style="margin-right: 25px;"/>

  <img src="https://github.com/gichukipaul/DVT-Weather/blob/main/screenshots/main3light.png" alt="Light Mode Screenshot 3" width="220" />
</div>
<br>
<div style="display:flex; justify-content:center;">
  <img src="https://github.com/gichukipaul/DVT-Weather/blob/main/screenshots/main4light.png" alt="Light Mode Screenshot 1" width="220" style="margin-right: 25px;"/>

  <img src="https://github.com/gichukipaul/DVT-Weather/blob/main/screenshots/main3dark.png" alt="Light Mode Screenshot 2" width="220" style="margin-right: 25px;"/>

  <img src="https://github.com/gichukipaul/DVT-Weather/blob/main/screenshots/main2dark.png" alt="Light Mode Screenshot 3" width="220" />
</div>

## Prerequisites
- [A valid Open Weather API Key](https://openweathermap.org/appid)
- Xcode 16
- **NOTE: This uses the 3.0 version of the OpenWeather API**

## Setup
- Signup and get a free API Key at [https://openweathermap.org/api](https://openweathermap.org/api)
- You can clone this project directly from XCode or use your terminal below
   ```sh
   git clone git@github.com:gichukipaul/DVT-Weather.git
   ```

- Launch Xcode and open the project.
- Select the Project Target.
- In the Xcode project navigator, click on your project name at the top of the list. This will open the project settings.
- Navigate to the `Info` tab located at the top of the Xcode window.
- Locate the `weatherAPIKey` entry in the list of properties, and replace the placeholder text with your actual API key.
- Save the File

```xml
<key>weatherAPIKey</key> 
<string>Your-OpenWeather-API-Key</string>
```
- Build the project

## Features
- Current Weather: Fetches current weather data based on the user's location.
- Weather Forecast: Provides a 5-day weather forecast with daily details.
- Search for new locations by name or select them from the map to get weather forecasts.
- Save Favourites: Tap on the heart icon to save the location and weather forecast as favourite.

## Usage
- Launch the app, and it will request the user's location.
Once granted, the app will fetch the current weather and forecast data based on the user's coordinates.
An alert will be presented if there is any error (such as no location access or network issues).

## Architecture
This project follows an MVVM (Model-View-ViewModel) architecture with the following components:

- Model: Represents the weather data (WeatherResponse, ForecastResponse).
- View: Displays the weather data to the user. The Main view is Programmatic UIKit and the rest are SwiftUI
- ViewModel: Manages the data fetching, provides data to the view, and handles errors.
- Combine: Used for handling asynchronous data fetching and combining the results of multiple API calls (weather and forecast).
- Error Handling: - The project uses a custom error enum to handle errors more effectively.

## Acknowledgements
- [Openweathermap.org](Openweathermap.org) : For the API endpoint to source the weather data
- [https://app.quicktype.io/?l=swift](https://app.quicktype.io/?l=swift) : JSON to Swift Models
- [Iconfinder.com](Iconfinder.com ) : I got the AppIcon from there

## License
This project is licensed under the [MIT License](LICENSE).
