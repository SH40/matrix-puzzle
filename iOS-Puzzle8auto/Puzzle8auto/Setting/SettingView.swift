
import UIKit

class SettingView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    let tableCV   = [ChangeColorView.self, ChangeButtonProperties.self]
    let tableData = ["Change Background Color", "Change Button Properties", "Change MATRIX", "Acceleration Sensor", "Button Background Color Random?", "Automatic calculation menu"]

    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tv
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableData[indexPath.row] == "Change Background Color" {
            self.navigationController?.pushViewController(tableCV[indexPath.row].init(), animated: true)
       
        }else if tableData[indexPath.row] == "Change Button Properties" {
            
            let uu = tableCV[indexPath.row].init()
            uu.view.backgroundColor = UIColor.black
            self.navigationController?.pushViewController(uu, animated: true)
            
            
        }else if tableData[indexPath.row] == "Change MATRIX" {
            let acv = UIAlertController(title: "", message:"MATRIX", preferredStyle: .actionSheet)
            for i in 3...10{
                let action = UIAlertAction(title: "\(i) X \(i)", style: .default) { (aa:UIAlertAction) in
                    UserDefaults.standard.set("\(i)", forKey: UmatrixKey)
                    self.dismiss(animated: true, completion: nil)
                    //                    UIApplication.shared.setAlternateIconName("AppIcon\(i)")
                }
                
                acv.addAction(action)
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (aa:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            acv.addAction(actionCancel)
            self.present(acv, animated: true, completion: nil)
         
        }else if tableData[indexPath.row] == "Acceleration Sensor" {
            let acv = UIAlertController(title: "", message:"Acceleration", preferredStyle: .actionSheet)
            let action3 = UIAlertAction(title: "Use", style: .default) { (aa:UIAlertAction) in
                UserDefaults.standard.set(true, forKey: accelSensorKey)
                self.dismiss(animated: true, completion: nil)
            }
            let action4 = UIAlertAction(title: "Not Use", style: .default) { (aa:UIAlertAction) in
                UserDefaults.standard.set(false, forKey: accelSensorKey)
                self.dismiss(animated: true, completion: nil)
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (aa:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            acv.addAction(action3)
            acv.addAction(action4)
            acv.addAction(actionCancel)
            self.present(acv, animated: true, completion: nil)
            
        }else if tableData[indexPath.row] == "Automatic calculation menu" {
            self.navigationController?.pushViewController(AutoAlgorithmSettingView(), animated: true)
            
        }else if tableData[indexPath.row] == "Button Background Color Random?" {
            let acv = UIAlertController(title: "", message:"Button Background Color Random?", preferredStyle: .actionSheet)
            let action3 = UIAlertAction(title: "Use", style: .default) { (aa:UIAlertAction) in
                UserDefaults.standard.set(true, forKey: URandomBtnBackColor)
                self.dismiss(animated: true, completion: nil)
            }
            let action4 = UIAlertAction(title: "Not Use", style: .default) { (aa:UIAlertAction) in
                UserDefaults.standard.set(false, forKey: URandomBtnBackColor)
                self.dismiss(animated: true, completion: nil)
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (aa:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            acv.addAction(action3)
            acv.addAction(action4)
            acv.addAction(actionCancel)
            self.present(acv, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        navigationItem.title = "Setting"
        
        self.view.addSubview(tableView)
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        self.view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
