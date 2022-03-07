
import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    lazy var util : AllSearch = {
        return self.setAllSearchInstance()
    }()
    
    func setAllSearchInstance() -> AllSearch {
        let u = AllSearch.init(m: self.matrix)
        return u
    }
    
    lazy var Astar : AStarOrigin = {
        return self.setAstar(star: [[1, 2, 3], [4, 5, 6], [7, 8, 0]], goal: [[1, 2, 3], [4, 5, 6], [7, 8, 0]])
    }()
    
    func setAstar(star: [[Int]], goal: [[Int]]) -> AStarOrigin {
        let u = AStarOrigin.init(star: star, goal: goal)
        return u
    }
    
    
    let motionManager = CMMotionManager()
    func sensor(){
        // accelerometerUpdateInterval 은  가속도 센서가 호출 간격을 설정하게 됩니다.
        motionManager.accelerometerUpdateInterval = 0.1
        
        // 가속도 센서를 시작합니다. 가속도 센서의 리스너는 클로저로 처리되며, outputAccelerationData() 함수을 호출합니다.
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {accelerometerData, error in self.outputAccelerationData(acceleration: (accelerometerData?.acceleration)!)})
    }
    
    var sensorX : Double = 0.0
    var sensorY : Double = 0.0
    func outputAccelerationData(acceleration: CMAcceleration){

        if UserDefaults.standard.bool(forKey: accelSensorKey) {
            if sensorX * acceleration.x < 0 && sensorY * acceleration.y < 0 {
                self.shuffleRandom()
            }
            sensorX = acceleration.x
            sensorY = acceleration.y
        }
    }
    
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
//    let dic3 : Dictionary<Int, [Int]> = [ 1 : [2, 4],    2 : [1, 3, 5],    3 : [2, 6],
//                                          4 : [1, 5, 7], 5 : [2, 4, 6, 8], 6 : [3, 5, 9],
//                                          7 : [4, 8],    8 : [5, 7, 9],    9 : [6, 8]
//    ]
//
//    let dic4 : Dictionary<Int, [Int]> = [ 1 : [2, 5],       2 : [1, 3, 6],       3 : [2, 4, 7],        4 : [3, 8],
//                                          5 : [1, 6, 9],    6 : [2, 5, 7, 10],   7 : [3, 6, 8, 11],    8 : [4, 7, 12],
//                                          9 : [5, 10, 13], 10 : [6, 9, 11, 14], 11 : [7, 10, 12, 15], 12 : [8, 11, 16],
//                                         13 : [9, 14],     14 : [10, 13, 15],   15 : [11, 14, 16],    16 : [12, 15]
//    ]
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(shuffle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(setting))
        
        self.sensor()
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let value = UserDefaults.standard.string(forKey: UmatrixKey) {
            let printValue : Int = Int(value)! * Int(value)! - 1
            navigationItem.title = "\(printValue) puzzle"
        }else{
            navigationItem.title = "8 puzzle"
        }
        
        super.viewWillAppear(animated)
        self.shuffle()
    }
    
    func test() {
//        let start = [[2, 1, 0], [7, 3, 4], [5, 8, 6]] //16
//        let goal  = [[1, 2, 3], [4, 5, 6], [7, 8, 0]]
//        let ttt =  AStar.init(star: start, goal: goal)
//        ttt.main()
    }
    
    @objc func shuffle(){
        
        self.test()
        
        self.removeAllView(view: safeView)
        
        resetTime()
        resumeTapped = false
        self.pauseButtonTapped()
        
        texts = setTexts()
        matrix = MathUtil.sqrt(count: self.texts.count)
        Btns = self.setBtn()
        if self.isAutoPossible() {
            autoAnimationAction = self.setAutoAnimationAction()
        }
        self.shuffleBtn = self.setShuffleBtn()
        
        self.Astar.end()
        initLayout()
        self.view.viewWithTag(909)?.removeFromSuperview()
    }
    
    func isAutoPossible() -> (Bool) {
        if UserDefaults.standard.bool(forKey: autocal) && self.matrix < 5 { // 지금 알고리즘 상태로 4*4 이상은 불가
            return true
        }else{
            return false
        }
    }
    
    func initLayout() {
        
        self.view.backgroundColor     = UIUtil.getBackColor()
        self.safeView.backgroundColor = UIUtil.getBackColor()
        
        for i in 0..<texts.count {
            safeView.addSubview(Btns![i])
        }

        let SIZE   : CGFloat = CGFloat(30)
        let MARGIN : CGFloat = CGFloat(5)
        
        let sqrt = MathUtil.sqrt(count: texts.count)
        
        let btnBetweenMargin = MARGIN * CGFloat(sqrt-1)
        let witdh2 = safeView.bounds.width-btnBetweenMargin-SIZE*2
        let witdh  = witdh2 / CGFloat(sqrt)
        
        for i in 0..<texts.count {
            let rate : Int = Int(i / sqrt)
            let x : CGFloat = (i % sqrt == 0) ? SIZE : Btns![i-1].frame.origin.x + witdh + MARGIN
            let y : CGFloat = SIZE + CGFloat(rate) * witdh + (CGFloat(rate)-1) * MARGIN
            Btns![i].frame = CGRect(x: x, y: y, width: witdh, height: witdh)
            Btns![i].layer.cornerRadius = witdh * CGFloat(UserDefaults.standard.float(forKey: Uradius)) / 2
            Btns![i].setTitleColor(UIColor.init(white: CGFloat(UserDefaults.standard.float(forKey: UbtnTextColor)), alpha: 1), for: .normal)
            
            if texts.count-1 != i {
                if UserDefaults.standard.bool(forKey: URandomBtnBackColor) {
                    let randomRed   = Int(arc4random_uniform(UInt32(256)))
                    let randomGreen = Int(arc4random_uniform(UInt32(256)))
                    let randomBlue  = Int(arc4random_uniform(UInt32(256)))
                    Btns![i].backgroundColor = UIColor.rgb(red: CGFloat(randomRed), green: CGFloat(randomGreen), blue: CGFloat(randomBlue), alpha: 0.6)
                
                }else{
                    Btns![i].backgroundColor = UIColor(white: CGFloat(UserDefaults.standard.float(forKey: UbtnBackColor)), alpha: 0.3)
                }
            }
        }
        
        if self.isAutoPossible() {
            safeView.addSubview(autoAnimationAction)
            safeView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: autoAnimationAction)
        }

        safeView.addSubview(timerLabel)
        safeView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: timerLabel)
        
        safeView.addSubview(shuffleBtn)
        safeView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: shuffleBtn)
        
        
        if self.isAutoPossible() {
            safeView.addConstraintsWithFormat(format: "V:[v0(50)]-10-[v1(50)]-10-[v2(50)]-10-|", views: autoAnimationAction, shuffleBtn, timerLabel)
        }else{
            safeView.addConstraintsWithFormat(format: "V:[v0(50)]-10-[v1(50)]-10-|", views: shuffleBtn, timerLabel)
        }
        
    }
    
    weak var delegate: Navigation?
    
    private func removeAllView(view: UIView){
        for view1 in view.subviews {
            self.removeAllView(view: view1)
            view1.removeFromSuperview()
        }
    }
    
    var autoFlag = false
    
    var timer = Timer()
    var seconds = 60
    var isTimerRunning = false
    var resumeTapped = false
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds > 60*30 { //Max Min Time is 30 Minutes
            timer.invalidate()
            
            let alert = MyAlertController(title: "", message: "Get a chance!", isAutoHeigth: true)
            let action = MyAlertAction(title: "ok", style: .gray, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            seconds += 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
            
            if self.isAutoPossible() {
                self.calcurateAuto()
            }

        }
    }
    
    func calcurateAuto(){
        if autoFlag {
            autoFlag = false
            
            //Loading View
            self.setLoadingView(nType: 2)
            
            //-----------------------------------------------------------------------------------------------------
            var arrMatrix : [[Int]] = Array(repeating: Array(repeating: 0, count: self.matrix), count: self.matrix)
            var arrGoalMatrix : [[Int]] = Array(repeating: Array(repeating: 0, count: self.matrix), count: self.matrix)
            
            var arr = [Int]()
            for i in 0..<self.Btns!.count {
                if let value = self.Btns![i].titleLabel?.text {
                    arr.append(Int(value)!)
                }else{
                    arr.append(0)
                }
            }
           
            //puzzle valid check
//            if !UIUtil.isSolvable(puzzle: arr) {
//                return
//            }
            
            var count = 0
            for i in 0..<self.matrix{
                for j in 0..<self.matrix{
                    arrMatrix[i][j] = arr[count]
                    count += 1
                }
            }
            
            var goalCount = 1
            for i in 0..<self.matrix{
                for j in 0..<self.matrix{
                    arrGoalMatrix[i][j] = goalCount
                    goalCount += 1
                }
            }
            arrGoalMatrix[self.matrix-1][self.matrix-1] = 0 //마지막은 항상 0
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                if UserDefaults.standard.string(forKey: UAutoAlgorithm) == "A Star Matching Goal" {
                    
                    self.Astar = self.setAstar(star: arrMatrix, goal: arrGoalMatrix)
//                    self.Astar = self.setAstar(star: arrMatrix, goal: [[1, 2, 3], [4, 5, 6], [7, 8, 0]])

                    if let solutionArr = self.Astar.main() {
                        self.setAutoResultArr(resultArt: solutionArr)
                    }
                    
                }else{
                    self.util = self.setAllSearchInstance()
                    if let solutionArr = self.util.solve_puzzle(initaial: &arrMatrix){
                        self.setAutoResultArr(resultArt: solutionArr)
                    }
                }
                
            }
            //-----------------------------------------------------------------------------------------------------
        }
    }
    
    private func setAutoResultArr(resultArt : [String] ){
        DispatchQueue.main.async(execute: {
            self.g_solutionArr = [String]()
            self.g_solutionArr = resultArt
            
            self.autoAnimationAction.setTitle("Auto : [\(resultArt.count)] time:\(self.timerLabel.text!)", for: .normal)
            self.autoAnimationAction.setTitleColor(UIColor.red, for: .normal)
            self.autoAnimationAction.isEnabled = true
            
            self.clickDimView()
        })
    }
    
    var g_solutionArr = [String]() //solution array
    
    func pauseButtonTapped() {
        if self.resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
            isTimerRunning = false
        } else {
            runTimer()
            self.resumeTapped = false
            isTimerRunning = true
        }
    }
    
    func resetTime() {
        timer.invalidate()
        seconds = 0 //time init
        timerLabel.text = "\(seconds)"
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    let timerLabel : UILabel = {
       let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var autoAnimationAction : UIButton = {
        return self.setAutoAnimationAction()
    }()
    
    func setAutoAnimationAction() -> UIButton {
        let btn = UIButton()
        var title = "Auto"
        if let autoTitle = UserDefaults.standard.string(forKey: UAutoAlgorithm) {
            title = "Auto: \(autoTitle)"
        }
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.red, for: .highlighted)
        btn.setTitleColor(UIColor.red, for: .selected)
        btn.addTarget(self, action: #selector(autoActionClick), for: .touchUpInside)
        btn.backgroundColor = UIColor(white: 0, alpha: 0.3)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.isEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        return btn
    }
    
    
    lazy var shuffleBtn : UIButton = {
        return self.setShuffleBtn()
    }()
    
    func setShuffleBtn() -> UIButton {
        let btn = UIButton()
        btn.setTitle("touch and move button", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.red, for: .highlighted)
        btn.backgroundColor = UIColor(white: 0, alpha: 0.3)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.isEnabled = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
    
    
    @objc func autoActionClick(){
        
        if g_solutionArr.count < 2 {
            return
        }
        for i in 0..<self.Btns!.count {
            if let _ = Btns![i].titleLabel?.text {
            }else{
                
                // 자동 돌리는 동안 버튼 클릭 못하도록 button을 위에 올린다
                let uiview = UIButton()
                uiview.frame = self.view.frame
                uiview.backgroundColor = .clear
                uiview.tag = 909
                self.view.addSubview(uiview)
                //----------------------------
                
               self.dodo(standIndex: i, nextIndex: 0)
                break
            }
            
        }
    }
    
    func dodo(standIndex: Int, nextIndex: Int) {
        
        if g_solutionArr.count > nextIndex {
            
            let targetIndex: Int
            
            switch g_solutionArr[nextIndex] {
            case "U": targetIndex = standIndex + -self.matrix; break
            case "R": targetIndex = standIndex +  1          ; break
            case "D": targetIndex = standIndex +  self.matrix; break
            case "L": targetIndex = standIndex + -1          ; break
            default : targetIndex = 0                        ; break}
            
            //함수 구현 필요
            let timeInterval = UserDefaults.standard.float(forKey: UAutoTime)
            UIView.animate(withDuration: TimeInterval(timeInterval), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .preferredFramesPerSecond30, animations: {
                self.swapValue(lhs: &self.Btns![standIndex].frame, rhs: &self.Btns![targetIndex].frame)
                
                let btn = self.Btns![standIndex]
                self.Btns![standIndex] = self.Btns![targetIndex]
                self.Btns![targetIndex] = btn
                
                self.swapValue(lhs: &self.Btns![standIndex].tag, rhs: &self.Btns![targetIndex].tag)
                
            }) { (Bool) in
                
                if Bool {
                    self.dodo(standIndex: targetIndex, nextIndex: nextIndex+1)
                }
            }
            
        }else{
            //함수 구현 필요
            if self.isSuccess() && self.isTimerRunning == true {
                
                //----------------------------
                self.view.viewWithTag(909)?.removeFromSuperview()
                
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                
                self.pauseButtonTapped()
                
                let alert = MyAlertController(title: "", message: "time : \(self.timerLabel.text!)", isAutoHeigth: true)
                let action = MyAlertAction(title: "ok", style: .gray, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        
        }
    }

    let gradientLayer = CAGradientLayer()
    
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
            btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
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
    
    func isMovePossible(sIndex: Int) -> (Int){
        
        var returnValue = 0
        let arr = UIUtil.getDicM(m: self.matrix)[sIndex]!
        for i in 0..<arr.count {
            if let _ = Btns![arr[i]-1].titleLabel?.text{
                
            }else{
                returnValue = arr[i]
                return returnValue
            }
        }
        return returnValue
    }
    
    @objc func btnClick(sender:UIButton){
        
        let i = sender.tag - 1
        let targetIndex = self.isMovePossible(sIndex: sender.tag) - 1
        if targetIndex >= 0, let text = Btns![i].titleLabel?.text, text != "" {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            
            self.swapButton(pInt: i, nInt: targetIndex, duration: 0.2)
        }
    }
    
    func swapButton(pInt:Int, nInt:Int, duration: CGFloat){
        
        //자동 계산 후에 숫자 버튼을 클릭 했을 경우
        if self.isAutoPossible() {
            self.autoAnimationAction.isEnabled = false
        }
        
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .preferredFramesPerSecond30, animations: {
            self.swapValue(lhs: &self.Btns![pInt].frame, rhs: &self.Btns![nInt].frame)
            
            let btn = self.Btns![pInt]
            self.Btns![pInt] = self.Btns![nInt]
            self.Btns![nInt] = btn
            
            self.swapValue(lhs: &self.Btns![pInt].tag, rhs: &self.Btns![nInt].tag)
            
        }) { (Bool) in
            
            if Bool {
                if self.isSuccess() && self.isTimerRunning == true {
                    
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    self.pauseButtonTapped()
                    
                    let alert = MyAlertController(title: "", message: "time : \(self.timerLabel.text!)", isAutoHeigth: true)
                    let action = MyAlertAction(title: "ok", style: .gray, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func isSuccess() -> (Bool) {
        for i in 0..<texts.count-1 {
            if Btns![i].titleLabel?.text != texts[i]{
                return false
            }
        }
        return true
    }
    
    func swapValue<T>(lhs: inout T, rhs : inout T){
        let tmp = lhs
        lhs = rhs
        rhs = tmp
    }
    
    @objc func setting(){
        delegate?.pushSettingView()
        self.shuffle()
    }

    private func shuffleRandom(){
        for i in 0..<20*self.matrix { //50
            let random = Int(arc4random_uniform(UInt32(texts.count))) //0~8
            let targetIndex = self.isMovePossible(sIndex: random+1 ) - 1
            if targetIndex >= 0, let text = Btns![random].titleLabel?.text, text != "" {
                self.swapButton(pInt: random, nInt: targetIndex, duration: 0.002 * CGFloat((i*i)/5/self.matrix) ) //0.002   5
            }
        }
        
        resetTime()
        resumeTapped = true
        pauseButtonTapped()
        
        autoFlag = true
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.g_solutionArr = [String]()
        self.autoAnimationAction.setTitle("Auto", for: .normal)
        self.autoAnimationAction.setTitleColor(UIColor.white, for: .normal)
        
        let touch = touches.first!
        let point = touch.location(in: self.shuffleBtn)
        if self.shuffleBtn.frame.height > point.y && point.y > 0 {
            self.shuffleRandom()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Loading View
    let ani = loadingView()
    func setLoadingView(subtext: String = "Auto Calculating...", nType: Int = 0) {
        //[[***************************************Loading View Animation***************************************]]
        let DimView = UIView()
        DimView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        DimView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        DimView.tag = 987
        
        let labelText = UILabel()
        labelText.text = subtext
        labelText.textAlignment = .center
        labelText.textColor = UIColor.white
        DimView.addSubview(labelText)
        labelText.frame = CGRect(x: 0, y: DimView.center.y + 25, width: DimView.bounds.width, height: 50)
        
        let control = UIControl()
        control.backgroundColor = UIColor.clear
        DimView.addSubview(control)
        control.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)

        self.view.addSubview(DimView)
        
        let lodingLayer = CALayer()
        lodingLayer.frame = CGRect(x:DimView.center.x - 25 , y: DimView.center.y - 25, width: 50, height: 50)
        if nType == 0 {
            ani.setUpAnimation(in: lodingLayer, size: lodingLayer.frame.size, color: UIColor.red)
        }else if nType == 1 {
            ani.setUpAnimationAudio(in: lodingLayer, size: lodingLayer.frame.size, color: UIColor.red)
        }else if nType == 2 {
            ani.setUpBubbleAnimation(in: lodingLayer, size: lodingLayer.frame.size, color: UIColor.red)
        }
        
        DimView.layer.addSublayer(lodingLayer)
    }
    
    @objc func clickDimView(){
        self.view.viewWithTag(987)?.removeFromSuperview()
    }
    
}



