
News Feed App

Overview

The News Feed App is designed to provide users with a streamlined and intuitive interface for accessing news from various sources. The app displays news from general and business sources, as well as top headlines from India and the US. Users can tap on any news item to view more details. The app also features a search function to explore popular news and find articles based on specific categories.

Features

Dashboard Screen: Displays news categorized into general and business sources, along with top headlines from India and the US.
Article Details: Users can tap on any news item to view detailed information about the article.
Search Functionality: A search icon on the top right allows users to search for popular news and filter results based on user queries.
Search Results: Search results are displayed based on the user's input, with options to view more details about each article.
Architecture

The app is built using the MVVM-C (Model-View-ViewModel-Coordinator) architecture, which separates the concerns of data, business logic, and UI components for better maintainability and testability.

Model: Represents the data structures and network responses.
View: Handles the user interface components and displays data.
ViewModel: Manages the data and business logic, providing data to the view and handling user interactions.
Coordinator: Manages the navigation and flow between different screens.
API Integration

The app uses a news API to fetch news articles. If you encounter any issues with the API due to key limitations or errors, please update the API key in the Constants class. Two API keys are provided for backup purposes.

Testing

Test cases have been written to ensure the functionality of the core features of the app, including:

Displaying news in the dashboard.
Handling search queries and displaying results.
Navigating to detailed article views.
Setup

Clone the Repository:
sh
Copy code
git clone https://github.com/devireddy1818/TechVibeSwift-
Open the Project: Open the project in Xcode.
Update API Keys:
Open Constants.swift.
Update the API keys as needed.
Run the App: Build and run the app on a simulator or device.
Troubleshooting

If you experience any issues:

Ensure that you have the correct API key in the Constants class.
Check the network requests for errors.
Review the test cases to verify the functionality.
Contact

For any questions or support, please contact devireddy1818@gmail.com
