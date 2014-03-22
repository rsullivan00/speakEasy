# Integrating Facebook Tutorial

## iOS Setup

The Xcode project teaches you how to create a Facebook profile viewer application using the Parse framework.

### How to Run

1. Clone the repository and open the Xcode project at `IntegratingFacebookTutorial-iOS/IntegratingFacebookTutorial.xcodeproj`.
2. Add your Parse application id and client key in `AppDelegate.m`
3. Set your Facebook application id as a URLType Project > Info > URL Types > Untitled > URL Schemes using the format fbYour_App_id (ex. for 12345, enter fb12345)
4. Set your Facebook application id in the `FacebookAppID` property in `IntegratingFacebookTutorial-Info.plist`.

### Learn More

To learn more, take a look at the [Integrating Facebook in iOS](https://www.parse.com/tutorials/integrating-facebook-in-ios) tutorial.

## Android Setup

The Android project teaches you how to create a Facebook profile viewer application using the Parse framework.

1. Clone the repository and import the Facebook SDK and sample project by navigating to the `IntegratingFacebookTutorial` folder and selecting the `facebook` and `IntegratingFacebookTutorial-Android` projects.
2. Add your Parse application id and client key in `IntegratingFacebookTutorialApplication.java`.
3. Add your Facebook application id in `strings.xml`

### Learn More

To learn more, take a look at the [Integrating Facebook in Android](https://www.parse.com/tutorials/integrating-facebook-in-android) tutorial.

## Unity Setup

The Unity project teaches you how to create a Facebook profile viewer application using the Parse framework.

1. Clone the repository and open the Unity project at `IntegratingFacebookTutorial-Unity`. Then open the `Menu` scene.
2. Set your Parse application id and .NET key in the `Parse Initialize Behaviour` script of the `Parse Initialization` GameObject.
3. Go to Facebook > Edit Settings in the Unity Editor and set the `App Name` and `App id` parameters.
4. **iOS Deploy Setup:** Go to Edit > Project Settings > Player in the Unity Editor. Set the Bundle Identifier. This should match the settings on your Facebook App Dashboard, iOS settings.
5. **Android Deploy Setup:** 
  + Go to Edit > Project Settings > Player in the Unity Editor. Set the Bundle Identifier. Save the project.
  + Go to Facebook > Edit Settings in the Unity Editor and open up Android Build Facebook Settings.
  + Note the Package Name, Class Name, and Debug Android Key Hash values.
  + Go to your Facebook App Dashboard's Android settings.
  + Copy over the Unity settings into the corresponding Package Name, Class Name, and Key Hashes fields.
  + Save your Facebook App Dashboard changes.
6. **Web Player Deploy Setup:** 
  + Make sure you have [Parse Hosting](https://www.parse.com/docs/hosting_guide#started) and have deployed at least a simple website. 
  + Go to your Facebook App Dashboard. Add the App on Facebook platform. Enable Unity Integration. 
  + Set the Unity Binary URL to `Your_Domain_Name/web/web.unity3d` (ex: https://example.parseapp.com/web/web.unity3d). 
  + When building in Unity, save the build as `web` to match your URL setting. Place this build inside your Parse app's Cloud Code directory, under the `public` folder. Deploy your Parse Cloud Code changes.

### Learn More

To learn more, take a look at the [Integrating Facebook in Unity](https://www.parse.com/tutorials/integrating-facebook-in-unity) tutorial.
