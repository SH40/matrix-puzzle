
import UIKit

enum DirectionWay: String {
    case none = ""
    case U    = "U"
    case L    = "L"
    case R    = "R"
    case D    = "D"
}
let arrWay : [DirectionWay] = [.U, .L, .R, .D]

class Node2{
    
    var state : [[Int]]
    var parent: Node2?
    var isOpen: Bool = true
    var move: DirectionWay = .none
    var step : Int
    var h    : Double
    var sum  : Double
    
    init(_ arr: [[Int]]) {
        self.state = arr
        self.parent = nil
        self.step = 0
        self.h = 0
        self.sum = 0
    }
    
    init(arr: [[Int]],parent: inout Node2, move: DirectionWay, step: Int, h: Double) {
        self.state = arr
        self.parent = parent
        self.move  = move
        self.step = step
        self.h = h
        
        if UserDefaults.standard.string(forKey: UAutoAlgorithmType) == "A Star without step value" {
            self.sum = h
        }else{
            self.sum = Double(step) + h
        }
    }
}

class AStarOrigin {
    
    var node : [Node2] = [Node2]()
    var nodeHistory = Set<[[Int]]>()
    var move = [[[Int]]:String]()
    var stopFlag = false
    var goal : [[Int]]!
    
    init(star: [[Int]], goal: [[Int]]) {
        self.stopFlag = false
        self.node     = [Node2]()
        self.move     = [[[Int]]:String]()
        self.goal     = goal
        
        self.matric = self.getXYDictionary(matrix: star.count)
        self.node.append(Node2(star))
    }
    
    func main() -> [String]? {
        var returnStr = [String]()
        while (!stopFlag) {
            
            if var node : Node2 = getBestNode(){
                //다시 찾자
                if !check_puzzle(arr: &node.state){
                    self.expandNode( &node )
                //찾았어
                }else{
                    returnStr = self.returnResultRoot(returnStr: returnStr, node: &node)
                    stopFlag = true
                    break
                }
            }
        }
        
        return returnStr.reversed()
    }
    
    func end(){
        stopFlag = true
        node = [Node2]()
        move = [[[Int]]:String]()
    }
    
    private func returnResultRoot(returnStr: [String], node : inout Node2 ) -> [String] {
        var returnStr = returnStr
        returnStr.append(node.move.rawValue)
        while true{
            if let nodeResult : Node2 = node.parent, nodeResult.move.rawValue != "" {
                node = nodeResult
                returnStr.append(nodeResult.move.rawValue)
                
            }else{
                break
            }
        }
        
        return returnStr
    }
    
    //open할 노드를 선택
    func getBestNode() -> Node2? {
        var sum  = 0.0
        var tmpNode : Node2? = nil
        
        for (index, node) in self.node.enumerated() {
            
            if node.isOpen {
                if sum == 0 || sum > node.sum {
                    tmpNode = node
                    sum = node.sum
                }
//                tmpNode = node
//                break
                
            }else{
                self.node.remove(at: index)
            }
        }
        
        return tmpNode
    }
    
    func getReverseDirection(_ d: DirectionWay) -> (DirectionWay) {
        switch d {
        case .D:
            return .U
        case .U:
            return .D
        case .L:
            return .R
        case .R:
            return .L
        case .none:
            return .none
        }
    }
    
    func expandNode(_ searNode: inout Node2) {
        let list = searNode.state
        arrWay.forEach {
            if let next_state = slide(arr: list, way: $0), //노드 값이 존재한다면
                getReverseDirection(searNode.move) != $0,  //부모 노드 값을 제외한 방향이라면
                searNode.isOpen                           //노드가 열려있다면
//                self.nodeHistory.update(with: next_state) == nil //중복 노드값이 아니라면
                {
                
                if move[next_state] == nil {
                    move[next_state] = $0.rawValue
                    
                    let heruistic = self.heruistic(list)
                    let node = Node2(arr: next_state, parent: &searNode, move: $0, step: searNode.step+1 , h: heruistic )
                    self.node.append(node)
                }
            }
        }
        //해당 node의 값을 다 펼쳤다면 닫힌목록으로 표시한다.
        searNode.isOpen = false
    }
    
    struct XY{
        let x: Int!
        let y: Int!
    }
    var matric : [Int:XY]!
    
    func getXYDictionary(matrix: Int) -> [Int:XY] {
        var dic = [Int:XY]()
        dic[0] = XY(x: matrix-1, y: matrix-1)
        
        let M = matrix, N = matrix
        for i in 0..<M*N-1 {
            dic[i+1] = XY(x: i/N, y: i%N)
        }
        return dic
    }
    
    func heruistic(_ arr: [[Int]] ) -> Double {
    
        var dismatchingCnt = 0.0
        let M = arr.count, N = arr.count
        var count = 1
        
        for i in 0..<M*N-1 {
            if arr[i/N][i%N] != self.goal[i/N][i%N] {
//            if arr[i/N][i%N] != count {

                let v1 = self.goal[i/N][i%N]
                let x1 : Int = self.matric[v1]!.x
                let y1 : Int = self.matric[v1]!.y
                
                let v2 = arr[i/N][i%N]
                let x2 : Int = self.matric[v2]!.x
                let y2 : Int = self.matric[v2]!.y
                
                let Distance = sqrt( Double( (x2-x1)*(x2-x1)+(y2-y1)*(y2-y1) ) )
                
                dismatchingCnt += Distance
            }
            count += 1
        }
        
        return dismatchingCnt
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
    
    func find_Zero(_ arr: [Int]) -> Int {
        for i in 0..<arr.count {
            if arr[i] == 0 {
                return i
            }
        }
        return -1
    }
    
    func check_puzzle(arr: inout [[Int]]) -> (Bool) {
        
        let M = arr.count, N = arr.count
        for i in 0..<M*N-1 {
            if arr[i/N][i%N] != self.goal[i/N][i%N] {
//            if arr[i/N][i%N] != i+1 {
                return false
            }
        }
        
            if arr[M-1][N-1] != self.goal[M-1][N-1] {
//        if arr[M-1][N-1] != 0 {
            return false
        }else{
            return true
        }
        
    }
    
}







