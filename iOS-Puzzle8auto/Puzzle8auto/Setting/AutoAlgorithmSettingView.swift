
import UIKit

class AutoAlgorithmSettingView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    let tableData = ["Auto Function", "Auto Function Time Interval", "Auto Algorithm", "A Star Matching Goal Type"]
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
        
        if tableData[indexPath.row] == "Auto Function" {
            let acv = UIAlertController(title: "", message:"Auto Function", preferredStyle: .actionSheet)
            let action3 = UIAlertAction(title: "Use", style: .default) { (aa:UIAlertAction) in
                UserDefaults.standard.set(true, forKey: autocal)
                self.dismiss(animated: true, completion: nil)
            }
            let action4 = UIAlertAction(title: "Not Use", style: .default) { (aa:UIAlertAction) in
                UserDefaults.standard.set(false, forKey: autocal)
                self.dismiss(animated: true, completion: nil)
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (aa:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            acv.addAction(action3)
            acv.addAction(action4)
            acv.addAction(actionCancel)
            self.present(acv, animated: true, completion: nil)
            
        }else if tableData[indexPath.row] == "Auto Function Time Interval" {
            let acv = UIAlertController(title: "", message:"Auto Function Time Interval", preferredStyle: .actionSheet)
            let timeInterVals = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
            for i in 0..<timeInterVals.count {
                let action = UIAlertAction(title: "\(timeInterVals[i])", style: .default) { (aa:UIAlertAction) in
                    UserDefaults.standard.set(timeInterVals[i], forKey: UAutoTime)
                    self.dismiss(animated: true, completion: nil)
                }
                
                acv.addAction(action)
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (aa:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            acv.addAction(actionCancel)
            self.present(acv, animated: true, completion: nil)
            
        }else if tableData[indexPath.row] == "Auto Algorithm" {
            let acv = UIAlertController(title: "", message:"Auto Algorithm", preferredStyle: .actionSheet)
            let timeInterVals = ["All Search", "A Star Matching Goal"]
            for i in 0..<timeInterVals.count {
                let action = UIAlertAction(title: "\(timeInterVals[i])", style: .default) { (aa:UIAlertAction) in
                    UserDefaults.standard.set(timeInterVals[i], forKey: UAutoAlgorithm)
                    self.dismiss(animated: true, completion: nil)
                }
                
                acv.addAction(action)
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (aa:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            acv.addAction(actionCancel)
            self.present(acv, animated: true, completion: nil)
            
        }else if tableData[indexPath.row] == "A Star Matching Goal Type" {
            let acv = UIAlertController(title: "", message:"A Star Matching Goal Type", preferredStyle: .actionSheet)
            let timeInterVals = ["A Star Origin", "A Star without step value"]
            for i in 0..<timeInterVals.count {
                let action = UIAlertAction(title: "\(timeInterVals[i])", style: .default) { (aa:UIAlertAction) in
                    UserDefaults.standard.set(timeInterVals[i], forKey: UAutoAlgorithmType)
                    self.dismiss(animated: true, completion: nil)
                }
                
                acv.addAction(action)
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (aa:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            acv.addAction(actionCancel)
            self.present(acv, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        navigationItem.title = "Auto Setting"
        
        self.view.addSubview(tableView)
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        self.view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
