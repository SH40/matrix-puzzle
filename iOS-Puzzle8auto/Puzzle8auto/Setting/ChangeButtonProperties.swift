
import UIKit

class ChangeButtonProperties: UIViewController {
    
    func setTexts() -> ([String]) {
        
        var str = "3"
        if let value = UserDefaults.standard.string(forKey: UmatrixKey) {
            str = value
        }else{
            UserDefaults.standard.set("3", forKey: UmatrixKey) //default
        }
        
        var texts = [String]()
        let counts : Int = Int(str)! * Int(str)!
        for i in 1..<counts {
            texts.append(String(i))
        }
        texts.append("")
        
        return texts
    }
    
    lazy var texts = setTexts()
    lazy var matrix = MathUtil.sqrt(count: self.texts.count)
    lazy var btnWidth = self.getBtnWidth()
    let SIZE   : CGFloat = CGFloat(30)
    let MARGIN : CGFloat = CGFloat(5)
    lazy var sqrt = MathUtil.sqrt(count: texts.count)
    
    func getBtnWidth() -> CGFloat {
        let btnBetweenMargin = MARGIN * CGFloat(sqrt-1)
        let witdh2 = safeView.bounds.width-btnBetweenMargin-SIZE*2
        let witdh  = witdh2 / CGFloat(sqrt)
        return witdh
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = UIColor.black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIUtil.getBackColor()
        safeView.backgroundColor = UIUtil.getBackColor()
    }
    
    let sliderRadius       = UISlider()
    let sliderBtnTextColor = UISlider()
    let sliderBtnBackAlpha = UISlider()
    
    var radius : CGFloat {
        get{return CGFloat(UserDefaults.standard.float(forKey: Uradius))}
        set(newValue){UserDefaults.standard.set(newValue, forKey: Uradius)}}
    
    var btnTextColor : CGFloat {
        get{return CGFloat(UserDefaults.standard.float(forKey: UbtnTextColor))}
        set(newValue){UserDefaults.standard.set(newValue, forKey: UbtnTextColor)}}
    
    var btnBackColor : CGFloat {
        get{return CGFloat(UserDefaults.standard.float(forKey: UbtnBackColor))}
        set(newValue){UserDefaults.standard.set(newValue, forKey: UbtnBackColor)}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Butotn Setting"
        
        self.view.backgroundColor = UIUtil.getBackColor()
        safeView.backgroundColor  = UIUtil.getBackColor()
        
        for i in 0..<texts.count {
            safeView.addSubview(Btns![i])
        }
        
        for i in 0..<texts.count {
            let rate : Int = Int(i / sqrt)
            let x : CGFloat = (i % sqrt == 0) ? SIZE : Btns![i-1].frame.origin.x + self.btnWidth + MARGIN
            let y : CGFloat = SIZE + CGFloat(rate) * self.btnWidth + (CGFloat(rate)-1) * MARGIN
            Btns![i].frame = CGRect(x: x, y: y, width: self.btnWidth, height: self.btnWidth)
            Btns![i].layer.cornerRadius = self.btnWidth * CGFloat(UserDefaults.standard.float(forKey: Uradius)) / 2
            Btns![i].setTitleColor(UIColor.init(white: CGFloat(UserDefaults.standard.float(forKey: UbtnTextColor)), alpha: 1), for: .normal)
            if texts.count-1 != i {
                Btns![i].backgroundColor = UIColor(white: CGFloat(UserDefaults.standard.float(forKey: UbtnBackColor)), alpha: 0.3)
            }
        }
        
        sliderRadius.addTarget(self, action: #selector(sliderMove(sender:)), for: .allEvents)
        sliderBtnTextColor.addTarget(self, action: #selector(sliderMove(sender:)), for: .allEvents)
        sliderBtnBackAlpha.addTarget(self, action: #selector(sliderMove(sender:)), for: .allEvents)
        
        safeView.addSubview(sliderRadius)
        safeView.addSubview(sliderBtnTextColor)
        safeView.addSubview(sliderBtnBackAlpha)
        
        sliderRadius.value       = Float(radius)
        sliderBtnTextColor.value = Float(btnTextColor)
        sliderBtnBackAlpha.value = Float(btnBackColor)
        
        safeView.addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: sliderRadius)
        safeView.addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: sliderBtnTextColor)
        safeView.addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: sliderBtnBackAlpha)
        
        safeView.addConstraintsWithFormat(format: "V:[v0(30)]-10-[v1(30)]-10-[v2(30)]-10-|", views: sliderRadius, sliderBtnTextColor, sliderBtnBackAlpha)
        
    }
    
    @objc func sliderMove(sender: UISlider){
        
        if sender === sliderRadius {
            radius = CGFloat( sender.value )
            for i in 0..<texts.count {
                Btns![i].layer.cornerRadius = radius * self.btnWidth / 2
            }
            
        }else if sender === sliderBtnTextColor {
            btnTextColor = CGFloat( sender.value )
            for i in 0..<texts.count {
                Btns![i].setTitleColor(UIColor.init(white: btnTextColor, alpha: 1), for: .normal)
            }
            
        }else if sender === sliderBtnBackAlpha {
            btnBackColor = CGFloat( sender.value )
            for i in 0..<texts.count-1 {
                Btns![i].backgroundColor = UIColor.init(white: btnBackColor, alpha: 0.3)
            }
        }
    }
    
    lazy var safeView : UIView = {
        let uv = UIView()
        uv.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(uv)
        uv.topAnchor.constraint(equalTo:     self.view.safeAreaLayoutGuide.topAnchor).isActive     = true
        uv.bottomAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.bottomAnchor).isActive  = true
        uv.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        uv.rightAnchor.constraint(equalTo:   self.view.safeAreaLayoutGuide.rightAnchor).isActive   = true
        uv.layoutIfNeeded()
        return uv
    }()
    
    lazy var Btns : [UIButton]? = {
        return self.setBtn()
    }()
    
    func setBtn() -> [UIButton] {
        var btns = [UIButton]()
        for i in 0..<texts.count {
            let btn = UIButton()
            btn.setTitle(texts[i], for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitleColor(UIColor.brown, for: .highlighted)
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.translatesAutoresizingMaskIntoConstraints = true
            btn.tag = i+1
            
            if i != texts.count-1{
                btn.backgroundColor = UIColor(white: 0, alpha: 0.3)
                btn.layer.cornerRadius = 5
                btn.clipsToBounds = true
            }
            btns.append(btn)
        }
        return btns
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}



