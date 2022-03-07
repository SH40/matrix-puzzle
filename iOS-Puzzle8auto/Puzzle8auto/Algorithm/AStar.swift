
//Not use
import UIKit

class Node{
    var parent: Int
    var child: Int
    var next: Node?
    
    init(parent: Int, child: Int) {
        self.parent = parent
        self.child  = child
    }
}

class List{
    var cnt: Int
    var head: Node?
    
    init(cnt: Int, head: Node?) {
        self.cnt  = cnt
        self.head = head
    }
}

class AStar: NSObject {

    var start : [Int]
    var goal  : [Int]
    var close: Int = 0
    var dist:  Int = 0
    lazy var MatrixCnt = 9 //self.start.count
    
    init(star: [Int], goal: [Int]) {
        self.start = star
        self.goal = goal
    }
    
    // don't use
    func o_c_node_init(list: inout List) {
        list.cnt = 0
        list.head = nil
    }
    
    func add_o_node(list : inout List, parent: Int, child: Int) {
        let p : Node = Node(parent: parent, child: child)
        var tmp = list.head
        if self.close == child {
            return
        }
        if list.cnt == 0 {
            list.head = p
            p.next = list.head
            list.cnt = 1
        }else{
            tmp = list.head
            for _ in 0..<list.cnt {
                tmp = tmp?.next
            }
            p.next = tmp?.next
            tmp?.next = p
            list.cnt += 1
        }
    }
    
    func del_node(list: inout List) {
        let tmp = list.head
        while list.cnt != 0 {
            list.head = nil
            list.head = tmp?.next
            tmp?.next = (tmp?.next)?.next
            list.cnt -= 1
        }
        
    }
    
    func find_empty() -> Int {
        for i in 0..<MatrixCnt {
            if self.start[i] == -1 {
                return i
            }
        }
        return -1
    }
    
    func funcc() {
        
        var select = [0, 0]
        var empty = 0
        var list: List = List(cnt: 0, head: nil)
        var tmp: Node
        
        empty = find_empty()
        
        if empty != -1 {
            if empty > 2 {
                add_o_node(list: &list, parent: empty, child: empty-3) //up
            }
            if empty < 6 {
                add_o_node(list: &list, parent: empty, child: empty+3) //down
            }
            if (empty % 3) != 2 {
                add_o_node(list: &list, parent: empty, child: empty+1) //right
            }
            if (empty % 3) != 0 {
                add_o_node(list: &list, parent: empty, child: empty-1) //left
            }
            
            //이동비용이 최소인 값을 찾는다
            dist += 1
            close = empty
            select[1] = heruistic(list: &list)
            tmp = list.head!
            while true{
                if select[1] == tmp.child {
                    select[0] = tmp.parent
                    break
                }
                tmp = tmp.next!
            }
            start[ select[0] ] = start[ select[1] ]
            start[ select[1] ] = -1
            
        }
        del_node(list: &list)
    }
    
    func heruistic(list: inout List) -> Int {
        
        var node = Array.init(repeating: 0, count: self.MatrixCnt)
        var misplaced = 0
        var totalHerst = 0
        var _short = -1
        var select_node = 0
        var i = 0
        var tmp = list.head
        
        while true {
            if i == list.cnt {
                break
            }else{
                misplaced = 0
                node = self.start
                node[ (tmp?.child)! ] = node[ (tmp?.parent)! ]
                node[ (tmp?.parent)!] = -1
                
                //목표 타일과 이동했을 때의 타일을 비교하여, 맞지 않는 타일의 개수를 확인한다.
                for j in 0..<self.MatrixCnt {
                    if node[j] != self.goal[j] {
                        misplaced += 1
                    }
                }
                totalHerst = self.dist + misplaced
                
                //열린 노드중에서 F값이 가장 작은 노드를 찾는다
                if (_short == -1) || (_short > totalHerst) {
                    _short = totalHerst
                    select_node = (tmp?.child)!
                }
                tmp = tmp?.next
                i += 1
            }
        }
        print("close: \(self.close), dist: \(self.dist), short path: \(_short), select tile: \(select_node)" )
        
        return select_node
    }
    
    func draw(node: inout [Int]) {
        var str = ""
        for i in 0..<self.MatrixCnt {
            if i%3 == 0 {
                print(str)
                str = ""
            }
            if node[i] == -1 {
                str = "\(str)  "
            }else{
                str = "\(str) \(node[i])"
            }
        }
        print(str)
        print("\n")
    }
    
    func main() {
        draw(node: &self.start)
        while true {
            print("=====================\n")
            if start == goal {
                break
            }
            funcc()
            draw(node: &self.start)
        }
        print("close: \(self.close), dist: \(self.dist)" )
        print("end")
    }
    
}







