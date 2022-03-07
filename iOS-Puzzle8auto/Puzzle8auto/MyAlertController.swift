
import UIKit

class MyAlertController: UIViewController {
    
    var m_bodyHeigth : CGFloat = 147.0
    var m_isAutoHeight : Bool = false
    var m_title   : String?
    var m_message : String?
    private var actions: [MyAlertAction] = [MyAlertAction]()
    
    lazy var contentsView :UIView = {
        let uv = UIView()
        uv.backgroundColor = UIColor.white
        uv.layer.cornerRadius = 8.0
        uv.clipsToBounds = true
        return uv
    }()
    
    lazy var textLbl : UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.white
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()
    
    lazy var lblTitle : UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.white
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()
    
    func setButton(tag: Int, title: String, colorStyle: colorStype) -> UIButton {
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let UalertGreen = UIColor.rgb(red: 35,  green: 164, blue: 26,  alpha: 1)
        
        switch colorStyle {
        case .gray:
            btn.setBackgroundColor(color: UalertGreen, forState: .normal)
            btn.setBackgroundColor(color: UalertGreen.withAlphaComponent(0.7), forState: .highlighted)
            break;
        case .red :
            btn.setBackgroundColor(color: UalertGreen, forState: .normal)
            btn.setBackgroundColor(color: UalertGreen.withAlphaComponent(0.7), forState: .highlighted)
            break;
        }
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        btn.tag = tag
        return btn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(title: String, message: String, isAutoHeigth: Bool = false){
        self.init(nibName: nil, bundle: nil)
        
        self.m_isAutoHeight = isAutoHeigth
        self.m_title        = title
        self.m_message      = message
        
        self.modalTransitionStyle   = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        if self.m_isAutoHeight == true {
            self.m_bodyHeigth = self.m_message!.height(constraintedWidth: self.view.frame.width*0.8 - 10, font: UIFont.systemFont(ofSize: 16) )
            self.m_bodyHeigth += 50
        }
        
        self.view.addSubview(contentsView)
        contentsView.frame.size = CGSize(width: self.view.frame.width*0.8, height: m_bodyHeigth+53)
        contentsView.center.y = self.view.center.y - 30
        contentsView.center.x = self.view.center.x
        
        if self.m_title == "" {
            self.contentsView.addSubview(textLbl)
            self.contentsView.visualFormata(format: "H:|-5-[v0]-5-|", views: textLbl)
            self.contentsView.visualFormata(format: "V:|[v0(\(m_bodyHeigth))]",   views: textLbl)
            self.textLbl.text  = self.m_message
        }else{
            self.contentsView.addSubview(lblTitle)
            self.contentsView.addSubview(textLbl)
            self.contentsView.visualFormata(format: "H:|-5-[v0]-5-|", views: lblTitle)
            self.contentsView.visualFormata(format: "H:|-5-[v0]-5-|", views: textLbl)
            self.contentsView.visualFormata(format: "V:|[v0(40)][v1(\(m_bodyHeigth-40))]",   views: lblTitle, textLbl)
            self.lblTitle.text = self.m_title
            self.textLbl.text  = self.m_message
        }
        
        
        
        if actions.count == 0
        {
            contentsView.frame.size = CGSize(width: self.view.frame.width*0.8, height: m_bodyHeigth)
        }
        else if actions.count == 1
        {
            let btn = setButton(tag: 1, title: actions[0].m_title! ,colorStyle: actions[0].m_style! )
            self.contentsView.addSubview(btn)
            self.contentsView.visualFormata(format: "H:|[v0]|"   ,   views: btn)
            self.contentsView.visualFormata(format: "V:[v0(53)]|",   views: btn)
        }
        else if actions.count >= 2
        {
            let btn1 = setButton(tag: 1, title: actions[0].m_title! ,colorStyle: actions[0].m_style! )
            self.contentsView.addSubview(btn1)
            
            let btn2 = setButton(tag: 2, title: actions[1].m_title! ,colorStyle: actions[1].m_style! )
            self.contentsView.addSubview(btn2)
            
            self.contentsView.visualFormata(format: "H:|[v0(\(contentsView.frame.size.width/2))][v1]|",   views: btn1, btn2)
            self.contentsView.visualFormata(format: "V:[v0(53)]|",    views: btn1)
            self.contentsView.visualFormata(format: "V:[v0(53)]|",    views: btn2)
        }
    }
    
    @objc func btnClick(sender:UIButton){
        dismiss(animated: true) {
            if let handler = self.actions[sender.tag-1].completionHandlers{
                handler()
            }
        }
    }
    
    public func addAction(_ action: MyAlertAction){
        actions.append(action)
    }
    
}

let isAlertAnimation = false
public enum colorStype {
    case red
    case gray
}

class MyAlertAction {
    var m_title   : String?
    var m_style   : colorStype?
    var completionHandlers: (() -> Void)?
    
    init(title: String, style: colorStype, handler: (() -> Void)? ){
        self.m_title   = title
        self.m_style   = style
        completionHandlers = handler
    }
}



