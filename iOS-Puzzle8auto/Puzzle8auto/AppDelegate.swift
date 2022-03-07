
import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.inituserData()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let nc = Navigation()
        window?.rootViewController = nc
        window?.makeKeyAndVisible()

        return true
    }
    
    func inituserData(){
        
        //background color
        if UserDefaults.standard.float(forKey: Ured)   == 0 && UserDefaults.standard.float(forKey: Ugreen) == 0 && UserDefaults.standard.float(forKey: Ublue) == 0 && UserDefaults.standard.float(forKey: Ualpha) == 0 {
            UserDefaults.standard.set(0.0,        forKey: Ured)
            UserDefaults.standard.set(0.8243243,  forKey: Ugreen)
            UserDefaults.standard.set(0.3764479,  forKey: Ublue)
            UserDefaults.standard.set(0.38416988, forKey: Ualpha)
        }
        
        //btn Corner Radius
        if UserDefaults.standard.float(forKey: Uradius) == 0 && !UserDefaults.standard.bool(forKey: UInit) {
            UserDefaults.standard.set(0.1, forKey: Uradius)
        }
        
        //btn text color
        if UserDefaults.standard.float(forKey: UbtnTextColor) == 0 && !UserDefaults.standard.bool(forKey: UInit) {
            UserDefaults.standard.set(1, forKey: UbtnTextColor)
        }
        
        //btn background color
        if UserDefaults.standard.float(forKey: UbtnBackColor) == 0 && !UserDefaults.standard.bool(forKey: UInit) {
            UserDefaults.standard.set(0, forKey: UbtnBackColor)
        }
        
        //init var
        if !UserDefaults.standard.bool(forKey: UInit){
            UserDefaults.standard.set(true, forKey: UInit)
            
            //auto
            UserDefaults.standard.set(true, forKey: autocal)
            UserDefaults.standard.set("A Star Matching Goal", forKey: UAutoAlgorithm)
            UserDefaults.standard.set("A Star Origin", forKey: UAutoAlgorithmType)
            UserDefaults.standard.set(0.2, forKey: UAutoTime)
        }
    }
   
}







