import AVFoundation
import SwiftUI
@main
struct MobsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private var settings: Settings = {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let settings = Settings()
        settings.load()
        return settings
    }()

    var body: some Scene {
        WindowGroup {
            MainView(settings: settings)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all
    
    static func setAllowedOrientations(mask: UIInterfaceOrientationMask) {
        AppDelegate.orientationLock = mask
        if let controller = UIApplication.shared.windows[0].rootViewController {
            controller.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .voiceChat, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
        } catch {
            logger.error("app: Session error \(error)")
        }
        return true
    }
}
