import UIKit
import Flutter
import iAd
import ApphudSDK
import GoogleMaps


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
        name: "com.example/tracker",
        binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if call.method == "AppleEmmit" {
          ADClient.shared().requestAttributionDetails { (data, error) in
            if let data = data {
                Apphud.addAttribution(data: data, from: .appleSearchAds, callback: nil)
            }
          }
          result("finish")
       }
   })
    GMSServices.provideAPIKey("AIzaSyBv41e3qknxF9my_k3Atk8tSTbZLC22U6U")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
