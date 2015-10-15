# FB_GooglePlusLogin
Practice to FB SDK and Google+ SDK Login

##Use
* Facebook SDK for iOS v4.7
* Google+ iOS SDK v1.7.1

##Issue
* Facebook SDK v4.6 later have new behavior in login. It use Safari View Controller by default rather the fast-app-switching to the native Facebook app.

Reference:[stack overflow](http://stackoverflow.com/questions/32567179/facebook-login-does-not-return-to-app-with-xcode-7-ios-9) , [Facebook Bug](https://developers.facebook.com/bugs/786729821439894/?search_id)

##How to Use
* Start the SDK, Please see the [Facebook SDK for iOS](https://developers.facebook.com/docs/ios) and [Google+ Platform for iOS](https://developers.google.com/+/mobile/ios/getting-started).
* <font size = 5> In ViewController.m </font>
	* googlePlusClientId : Please enter your Client ID.
	* googleAPIKey : Please enter your API Key.
	* Client ID and API Key is create in [Google Developers Console](https://console.developers.google.com/).
* <font size = 5> In Info.plist </font>
	* FacebookAppID : Please enter your FB App ID.
	* FacebookDisplayName : Please enter your display name.
	* URL types -> Item 0 -> URL Schemes -> Item 0 : Please enter  "fb + your FB App ID", Ex:fb6456xxxxxxxxxxx.

##In iOS9
* should setting <font color = blue>NSAppTransportSecurity</font> and <font color = blue>LSApplicationQueriesSchemes</font> in Info.plist