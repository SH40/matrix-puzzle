
import UIKit

class Navigation: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nv = ViewController()
        nv.delegate = self
        self.pushViewController(nv, animated: true)
    }
    
    func pushSettingView(){
        let sc = SettingView()
        self.pushViewController(sc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
