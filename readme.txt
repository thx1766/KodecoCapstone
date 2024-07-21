This is an app that uses the Edamam API for finding recipes.

It has a tab view with three tabs: a search tab, a saved recipes tab, and a settings tab. You can search for recipes and view details, including a list of ingredients for the recipe. You can save a recipe for later, and browse the saved list. The settings tab lets you repeat the onboarding flow introducing the app.

This app relies on an API key saved in the /MealPrepCapstone/Config/ directory as APIKey.plist. This file is not included in the repository. It has the following format:

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>API_URL</key>
	<string>https://api.edamam.com</string>
	<key>API_APP_ID</key>
	<string>12345678</string>
	<key>API_APP_KEY</key>
	<string>1234567890abcdef1234567890abcdef</string>
</dict>
</plist>

Replace 12345678 with the app ID and 1234567890abcdef1234567890abcdef with the key.

Capstone requirements:
Includes data saved in your app after retrieving it from an API
- The recipes can be saved for viewing later. The text of the recipe is saved using user defaults, and the image for the recipe is retrieved when the recipe is saved. The image is saved to disk to be used later, since the API provides image links that expire shortly after the API request is sent.

Includes a list (or more) of any data the user can view
- The user can view recipes returned from the api in the search view as a list of results. The saved recipes also appear in a list.

When the user clicks on one of the list cards, they can navigate to a detail screen showing the chosen data associated with that card.
- The search view shows results in a list, and when a list item is tapped, it shows a detail view with a larger image and list of ingredients. The saved recipes view shows a list and when an item is tapped you can view details that have been saved.

Includes various calculations performed in the background on the data displayed.
- The images are provided from the Edamam API, and can be used in an AsyncImage for the list items and initial display, but the links expire, so they can't be saved directly. Instead, they are saved as files and loaded as image data when they are shown in the saved recipe view. The recipe is saved as json in user defaults, but each recipe is associated with an image on disk.

Uses images based on some kind of dynamic information provided by the API
- There are images in the search result list, and larger versions on the detail page. Images are saved offline when a recipe is saved to user defaults, so they can be displayed after the original image links expire.

This app does not use any 3rd party frameworks of packages.

It has a launch screen with the Edamam logo that is static before the app loads the onboarding screen.

There are no unfinished features in this project.

There are lists for search and saved recipes. The lists appear in a tab view along with settings.

Each list item for search contains the recipe name and an image. The detail view shows a larger image and recipe ingredients and a link to the original recipe. The search result list is generally scrollable with the number of hits for search items. The saved recipe list is long enough to scroll when populated with enough saved data.

The app accesses the network to make API calls using URLSession. The repo does not contain the api key.

The API request limit is 10 searches per minute. I haven't hit it yet.

The user is informed when there are network errors.

The app saves data using user defaults for json for recipes and files for the images.

The app does not use dispatch queues or completion handlers.

The app has appropriate error screens and indicators of missing data.

Views work in landscape and portrait modes for all iPhone models. NOTE: This app runs on iPad but is not optimized for it, so you will need to expand the side bars to get to the search lists, for example.

The code is organized and readable.

There is something like 70% code coverage between unit tests and UI tests. They are in the testing directories.

The app has a custom icon, an onboarding screen, a custom display name.

The save/ delete button is animated, and the network loading data is animated if you slow the connection down to EDGE speeds.