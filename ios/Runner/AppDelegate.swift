import Flutter
import UIKit
import AudioToolbox

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let vibrationChannel = FlutterMethodChannel(name: "dev_quiz_fix/vibration",
                                              binaryMessenger: controller.binaryMessenger)

    vibrationChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "vibrate" {
          AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
          result(nil)
      } else {
          result(FlutterMethodNotImplemented)
      }
    })

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
