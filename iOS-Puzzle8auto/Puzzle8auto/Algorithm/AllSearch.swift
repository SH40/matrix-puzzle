
import UIKit
import Foundation

class AllSearch {
    
    init(m:Int) {
        self.matrix = m
    }
    
    var matrix: Int?

    lazy var MAXH = MathUtil.factorial(n: matrix! * matrix!)
    lazy var M    = self.matrix
    lazy var N    = self.matrix
    lazy var max  = Int(M! * N!)
    
    var move = [Int:String]()
    var from = [Int:Int]()
    var str  = [String]()
    
    let arrWay : [DirectionWay] = [.U, .L, .R, .D]
    enum DirectionWay: String {
        case none = ""
        case U    = "U"
        case L    = "L"
        case R    = "R"
        case D    = "D"
    }
    
    func solve_puzzle(initaial: inout [[Int]]) -> [String]?{
        
        head = 0
        queue_size = 0
        queue = [[[Int]]]()
        move  = [Int:String]()
        from  = [Int:Int]()
        str   = [String]()
        
        var m_state = slide(arr: initaial, way: .none)!
        enqueue_state(previous_state_number: -1, state: &m_state, m: "1")
        
        while true{
            if var state = dequeue() {
                if check_puzzle(arr: &state){
                    print_moves(h: MathUtil.perm_count(arr: state, n: max ))
                    return str
                    
                }else{
                    let state_number = MathUtil.perm_count(arr: state, n: max)
                    
                    arrWay.forEach {
                        if var next_state = slide(arr: state, way: $0) {
                            enqueue_state(previous_state_number: state_number, state: &next_state, m: $0.rawValue)
                        }
                    }
                }
            }else{
                print("impossible\n")
                return nil
            }
        }
    }
    
    func slide(arr : [[Int]], way: DirectionWay) -> ( [[Int]]? ){
        
        var x = 0, y = 0
        switch way {
        case .none: break
        case .U: x = -1; y =  0; break
        case .L: x =  0; y = -1; break
        case .R: x =  0; y =  1; break
        case .D: x =  1; y =  0; break
        }
        
        let M = arr.count, N = arr.count
        var zm: Int?, zn: Int?, m: Int?, n: Int?
        for i in 0..<M {
            for j in 0..<N {
                if arr[i][j] == 0 {
                    zm = i
                    zn = j
                }
            }
        }
        var arrCopy = arr
        m = zm! + x
        n = zn! + y
        
        if m == nil || n == nil || m! < 0 || n! < 0 || n! >= N || m! >= M {
            return nil
        }else{
            arrCopy[zm!][zn!] = arrCopy[m!][n!]
            arrCopy[m!][n!] = 0
            return arrCopy
        }
    }
    
    func enqueue_state(previous_state_number: Int, state: inout [[Int]], m: String) {
        let state_number = MathUtil.perm_count(arr: state, n: max )
        
        if move[state_number] == nil {
            move[state_number] = m
            from[state_number] = previous_state_number
            enqeueu(a: &state)
        }
    }

    func check_puzzle(arr: inout [[Int]]) -> (Bool) {
        
        let M = arr.count, N = arr.count
        for i in 0..<M*N-1 {
            if arr[i/N][i%N] != i+1 {
                return false
            }
        }
        
        if arr[M-1][N-1] != 0 {
            return false
        }else{
            return true
        }
        
    }
    
    func print_moves(h: Int) {
        if let fromData = from[h]{
            if fromData < 0 {
                return
            }else{
                print_moves(h: fromData )
                if let moveData = move[h] {
                    str.append(moveData)
                }
            }
        }
    }
    
    // MARK: Qeueu Instance Method
    var queue: [[[Int]]]?
    var head : Int = 0
    var queue_size : Int = 0
    
    func enqeueu(a: inout [[Int]]) {
        //queue full!
        if queue_size == Int(MAXH) { return }
        
        queue_size += 1
        queue!.append(a)
    }
    
    func dequeue() -> ([[Int]]?) {
        let r : [[Int]]?
        
        //queue empty!
        if queue_size == 0 { return nil }
        
        r = queue![head]
        head += 1
        queue_size -= 1
        return r!
    }
}

class MathUtil {
    static func factorial(n: Int) -> (Int){
        if n == 1 {
            return 1
        }else{
            return n * factorial(n: n-1)
        }
    }
    
    static func perm_count(arr: [[Int]], n:Int) -> (Int) {
        
        let M = arr.count, N = arr.count
        var a : [Int] = Array(repeating: 0, count: N*M)
        for i in 0..<M*N {
            a[i] = arr[i/N][i%N]
        }
        
        var j=0, c=0, r=0
        
        for i in 0..<n-1 {
            c=0
            
            j=i+1
            for j in j..<n {
                if a[i] > a[j] {
                    c += 1
                }
            }
            r += factorial(n: n - 1 - i) * c
        }
        return r
    }

    static func sqrt(count: Int) -> (Int){
        var result = 0
        for i in 1..<count/2 {
            if count == i * i{
                result = i
                break
            }
        }
        return result
    }
    
}


class UIUtil {
    static func getBackColor() -> (UIColor){
        
        let red   = CGFloat(UserDefaults.standard.float(forKey: Ured))   * 255
        let green = CGFloat(UserDefaults.standard.float(forKey: Ugreen)) * 255
        let blue  = CGFloat(UserDefaults.standard.float(forKey: Ublue))  * 255
        let alpha = CGFloat(UserDefaults.standard.float(forKey: Ualpha))
        
        return UIColor.rgb(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // MARK: Util Method
    static func getDicM(m: Int) -> Dictionary<Int, [Int]> {
        
        var dic = Dictionary<Int, [Int]>()
        
        //Vertex
        dic[1]       = [2, 1+m]
        dic[m]       = [m-1, m+m]
        dic[m*m-m+1] = [m*m-(2*m)+1, m*m-m+2]
        dic[m*m]     = [m*m-1, m*m-m]
        
        //Side top
        for i in 2..<m {
            dic[i] = [i-1, i+1, i+m]
        }
        //Side bottom
        for i in m*m-m+2..<m*m {
            dic[i] = [i-1, i+1, i-m]
        }
        //Side letf
        for i in 1+m...m*m-(2*m)+1 where i%m==0 {
            dic[i] = [i-m, i+1, i+m]
        }
        //Side right
        for var i in m+m...m*m-m where i%m==0 {
            dic[i] = [i-m, i-1, i+m]
            i = i+m
        }
        
        //inner index
        for i in 1...m*m{
            if dic[i] == nil {
                dic[i] = [i-1, i+1, i-m, i+m]
            }
        }
        
        return dic
    }
    
    //3*3 Valid Check---------------------------------------------------------------------
//    static func getInvCount(arr: [Int]) -> (Int) {
//        var inv_count = 0
//        for i in 0..<9-1 {
//            var j = i+1
//            for _ in 0..<9 {
//                if j < 9 && arr[i] > arr[j] {
//                    inv_count += 1
//                }
//                j += 1
//            }
//        }
//        return inv_count
//    }
    
//    static func isSolvable(arr: [Int]) -> Bool {
//        let count = self.getInvCount(arr: arr)
//        return (count%2 == 0)
//    }
    //3*3 Valid Check------------------------------------------------------------------end

    //Multi Valid Check---------------------------------------------------------------------
    static func getInvCount(arr: [Int]) -> Int{
        let N = Int(sqrt(Double(arr.count)))
        var inv_count = 0
        for i in 0..<N*N-1  {
            var j = i+1
            while j < N * N{
                if arr[i] > arr[j] {
                    inv_count += 1
                }
                j += 1
            }
        }
        return inv_count
    }
    
    static func findXPosition(puzzle : [[Int]]) -> Int {
        let matrix = puzzle.count
        var i = matrix - 1
        while i>=0 {
            var j = matrix - 1
            while j>=0{
                if puzzle[i][j] == 0{
                    return matrix-i
                }
                j -= 1
            }
            i -= 1
        }
        
        return 0
    }
    
    static func isSolvable(puzzle: [Int]) -> Bool {
        let N = Int(sqrt(Double(puzzle.count)))
        let invCount = UIUtil.getInvCount(arr: puzzle)
    
        if UInt8(N) & 1 == 1 { //0 포함 짝수는 false
            return UInt8(invCount) & 1 == 1 ? false : true
            
        }else{
            let pos = UIUtil.findXPosition(puzzle: UIUtil.convertTwoDimension(puzzle))
            if UInt8(pos) & 1 == 1 {
                return UInt8(invCount) & 1 == 1 ? false : true
            }else{
                return UInt8(invCount) & 1 == 1 ? true : false
            }
        }
    }
    
    static func convertTwoDimension(_ arr:[Int] ) -> [[Int]] {
        var cnt = 0
        let matrix = Int(sqrt(Double(arr.count)))
        var arr2 = Array(repeating: Array(repeating: 0, count: matrix), count: matrix)

        for i in 0..<matrix {
            for j in 0..<matrix {
                arr2[i][j] = arr[cnt]
                cnt += 1
            }
        }
        
        return arr2
    }
    //Multi Valid Check-------------------------------------------------------------end
}
