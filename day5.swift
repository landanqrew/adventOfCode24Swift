import Foundation

var greeting = "Hello, playground123"


//var regex = Regex("[0-9]+")

let exString = """
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"""

let pattern = "[0-9]+"

func day5(_ inputString: String) {
    let inputSplit: [String] = inputString.components(separatedBy: "\n\n")
    let pageOrders: [[Int]] = inputSplit[0].components(separatedBy: "\n").map {matches(for: pattern, in: $0).map {Int($0)!}}
    let orderedLists: [[Int]] = inputSplit[1].components(separatedBy: "\n").map {matches(for: pattern, in: $0).map {Int($0)!}}
    var map: [Int : Node] = [:]
    var passed: [[Int]] = []
    var midPrints: [Int] = []
    var sortedPrints: [[Int]] = []
    var sortedMidPrints: [Int] = []

    for page in pageOrders {
        if (map[page[0]] == nil) {
            var parentNode = Node(value: page[0])
            parentNode.addChild(child: page[1])
            var childNode = Node(value: page[1])
            childNode.addParent(parent: page[0])

            map[page[0]] = parentNode
            map[page[1]] = childNode
        } else {
            //var parentNode: Node = map[page[0]]!
            if (!map[page[0]]!.children.contains(page[1])) {
                map[page[0]]!.addChild(child: page[1])
            }
            if (map[page[1]] == nil) {
                var childNode: Node = Node(value: page[1])
                childNode.addParent(parent: page[0])
                //var parentNode: Node = map[page[0]]!
                map[page[0]]!.addChild(child: page[1])
                map[page[1]] = childNode
            } else {
                //var childNode: Node = map[page[1]]!
                //var parentNode: Node = map[page[0]]!
                if (!map[page[1]]!.parents.contains(page[0])) {
                    map[page[1]]!.addParent(parent: page[0])
                }
                if (!map[page[0]]!.children.contains(page[1])) {
                    map[page[0]]!.addChild(child: page[1])
                }
            }
            
        }

    }

    //print(map)

    for list in orderedLists {
        //print("list \(list)")
        var lastNode: Node = map[list[0]]!
        var successStatus: Bool = true
        //var allParents: Set<Int> = lastNode.getAllParents(searchDict: map)
        let middle: Int = list[Int(floor(Double(list.count)/2.0))]
        for (i, num) in list.enumerated() {
            //print("Allparents: \(allParents)")
            if (i == 0 ) {
                continue
            } else {
                //let lastNodeParents = lastNode.getAllParents(searchDict: map)
                let lastNodeParents = lastNode.parents
                /*if( i>1) {
                    //print("localParents: \(lastNodeParents)")
                    allParents = allParents.union(lastNodeParents) 
                    print("newParents: \(allParents) | check for \(num) in parents")
                }*/
                if (lastNodeParents.contains(num)) {
                    //print("Parents: \(/*allParents*/ lastNodeParents) | \(num)  IS in parents")
                    successStatus = false
                    break
                }
                // reset last node
                lastNode = map[num]!
            }

        }
        if (successStatus) {
            passed.append(list)
            midPrints.append(middle)
        } else {
            
            var sortedList: [Int] = customSort(list: list, searchDict: map)
            sortedList = customSort(list: sortedList, searchDict: map)
            //print("\(list) --> \(sortedList)")

            let newMid: Int = sortedList[Int(floor(Double(list.count)/2.0))]

            sortedPrints.append(sortedList)
            sortedMidPrints.append(newMid)
        }
    }

    print("p1: \(midPrints.reduce(0, +)) | p2: \(sortedMidPrints.reduce(0, +))")


}

func customSort(list: [Int], searchDict: [Int: Node]) -> [Int] {
    let sortedList = list.sorted { 
                let element1: Node = searchDict[$0]!
                let element2: Node = searchDict[$1]!
                if (element1.parents.contains(element2.value)) {
                    return false
                } else {
                    return true
                }
            
            }
    //let sortedAgain: [Int] = customSort(list: sortedList, searchDict: searchDict)
    if (true /*sortedList == sortedAgain*/) {
        return sortedList
    } else {
        return customSort(list: sortedList, searchDict: searchDict)
    }
}

//day5(exString)
day5(readPuzzle(puzzleName: "day5"))

/*
var myNode = Node(value: 29)
myNode.addParent(parent: 45)
myNode.addParent(parent: 63)
myNode.addParent(parent: 27)

print(myNode)
*/

 // Regex pattern
let testString = "123,45)" // The string to test

func matches(for regex: String, in text: String) -> [String] {

    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        //print("results: \(results)")
        /*
        for result: NSTextCheckingResult in results {
            print(text[Range(result.range, in: text)!])
        }*/
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

struct Node {
    let value: Int
    var parents: [Int]
    var children: [Int]

    init(value: Int) {
        self.value = value
        self.parents = []
        self.children = []
    }

    mutating func addParent(parent: Int) {
        parents.append(parent)
        /*if (value == 29) {
            print("adding parent \(parent) to Node \(value)")
            print("New Parents: \(parents)")
        }*/
    }

    mutating func addChild(child: Int) {
        children.append(child)
    }

    func getAllParents(searchDict: [Int:Node]) -> Set<Int> {
        var searchParents: [Int] = self.parents
        var returnSet: Set<Int> = Set()

        while (searchParents.count > 0) {
            let curParent: Int = searchParents.popLast()!
            let curParentNode: Node = searchDict[curParent]!
            returnSet.insert(curParent)

            for parent in curParentNode.parents {
                if (!returnSet.contains(parent)) {
                    searchParents.append(parent)
                }
            }
        }

        return returnSet
    }

    func getAllChildren(searchDict: [Int:Node]) -> Set<Int> {
        var searchChildren: [Int] = self.children
        var returnSet: Set<Int> = Set()

        while (searchChildren.count > 0) {
            let curChild: Int = searchChildren.popLast()!
            let curChildNode: Node = searchDict[curChild]!
            returnSet.insert(curChild)

            for child in curChildNode.children {
                if (!returnSet.contains(child)) {
                    searchChildren.append(child)
                }
            }
        }

        return returnSet
    }
}

func readPuzzle(puzzleName: String) -> String {
    let deskDirectoryUrl = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0]
    let puzzleDirectoryUrl = deskDirectoryUrl.appendingPathComponent("Development/SwiftPlayground/Advent_Of_Code/.build/puzzles")
    let puzzleUrl = URL(fileURLWithPath: puzzleName, relativeTo: puzzleDirectoryUrl).appendingPathExtension("txt")
    var result: String = ""

    do {
    // Get the saved data
        let savedData = try Data(contentsOf: puzzleUrl)
    // Convert the data back into a string
        if let savedString = String(data: savedData, encoding: .utf8) {
            //print(savedString)
            result = savedString
        }
    } catch {
        // Catch any errors
        print("Unable to read the file")
    }

    return result
}

//print(matches(for: pattern, in: testString))