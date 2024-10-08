import UIKit
import Flutter
import CoreTelephony

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let simInfoChannel = FlutterMethodChannel(name: "sim_info_channel", binaryMessenger: controller.binaryMessenger)

        simInfoChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "isSimPresent" {
                let networkInfo = CTTelephonyNetworkInfo()
                if let carrier = networkInfo.subscriberCellularProvider, let mobileNetworkCode = carrier.mobileNetworkCode, !mobileNetworkCode.isEmpty {
                    // SIM card is present and valid
                    result(true)
                } else {
                    // No SIM card or invalid carrier
                    result(false)
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        })

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
