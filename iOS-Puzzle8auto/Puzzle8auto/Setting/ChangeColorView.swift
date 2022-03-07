
import UIKit

class ChangeColorView: UIViewController {
    
    lazy var safeView : UIView = {
        let uv = UIView()
        uv.backgroundColor = UIColor.clear
        uv.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(uv)
        uv.topAnchor.constraint(equalTo:     self.view.safeAreaLayoutGuide.topAnchor).isActive     = true
        uv.bottomAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.bottomAnchor).isActive  = true
        uv.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        uv.rightAnchor.constraint(equalTo:   self.view.safeAreaLayoutGuide.rightAnchor).isActive   = true
        uv.layoutIfNeeded()
        return uv
    }()
    
    let colorView :UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 20
        return view
    }()
    
    let sliderRed   = UISlider()
    let sliderGreen = UISlider()
    let sliderBlue  = UISlider()
    let sliderAlpha = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        navigationItem.title = "Color Setting"
        
        sliderRed.addTarget(self, action: #selector(sliderMove(sender:)), for: .allEvents)
        sliderGreen.addTarget(self, action: #selector(sliderMove(sender:)), for: .allEvents)
        sliderBlue.addTarget(self, action: #selector(sliderMove(sender:)), for: .allEvents)
        sliderAlpha.addTarget(self, action: #selector(sliderMove(sender:)), for: .allEvents)
        
        sliderRed.maximumTrackTintColor = UIColor.red
        sliderRed.minimumTrackTintColor = UIColor.red
        
        sliderGreen.maximumTrackTintColor = UIColor.green
        sliderGreen.minimumTrackTintColor = UIColor.green
        
        sliderBlue.maximumTrackTintColor = UIColor.blue
        sliderBlue.minimumTrackTintColor = UIColor.blue
        
        sliderAlpha.maximumTrackTintColor = UIColor.white
        sliderAlpha.minimumTrackTintColor = UIColor.white
        sliderRed.value   = Float(red)
        sliderGreen.value = Float(green)
        sliderBlue.value  = Float(blue)
        sliderAlpha.value = Float(alpha)
        
        
        safeView.addSubview(colorView)
        safeView.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: colorView)
        safeView.addConstraintsWithFormat(format: "V:|-20-[v0]-20-|", views: colorView)
        
        colorView.addSubview(sliderRed)
        colorView.addSubview(sliderGreen)
        colorView.addSubview(sliderBlue)
        colorView.addSubview(sliderAlpha)

        colorView.addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: sliderRed)
        colorView.addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: sliderGreen)
        colorView.addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: sliderBlue)
        colorView.addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: sliderAlpha)
        
        colorView.addConstraintsWithFormat(format: "V:[v0(30)]-10-[v1(30)]-10-[v2(30)]-10-[v3(30)]-10-|", views: sliderRed, sliderGreen, sliderBlue, sliderAlpha)
        
        colorView.backgroundColor = UIColor.rgb(red: red*CGFloat(255), green: green*CGFloat(255), blue: blue*CGFloat(255), alpha: alpha)
    }
    
    
    var red : CGFloat {
        get{return CGFloat(UserDefaults.standard.float(forKey: Ured))}
        set(newValue){UserDefaults.standard.set(newValue, forKey: Ured)}}
    var green : CGFloat {
        get{return CGFloat(UserDefaults.standard.float(forKey: Ugreen))}
        set(newValue){UserDefaults.standard.set(newValue, forKey: Ugreen)}
    }
    var blue : CGFloat {
        get{return CGFloat(UserDefaults.standard.float(forKey: Ublue))}
        set(newValue){UserDefaults.standard.set(newValue, forKey: Ublue)}
    }
    var alpha : CGFloat {
        get{return CGFloat(UserDefaults.standard.float(forKey: Ualpha))}
        set(newValue){UserDefaults.standard.set(newValue, forKey: Ualpha)}
    }
    
    @objc func sliderMove(sender: UISlider){
        
        if sender === sliderRed {
            red = CGFloat( sender.value )
        }else if sender === sliderGreen {
            green = CGFloat( sender.value )
        }else if sender === sliderBlue {
            blue = CGFloat( sender.value )
        }else if sender === sliderAlpha {
            alpha = CGFloat(sender.value )
        }
        
        colorView.backgroundColor = UIColor.rgb(red: red*CGFloat(255), green: green*CGFloat(255), blue: blue*CGFloat(255), alpha: alpha)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
