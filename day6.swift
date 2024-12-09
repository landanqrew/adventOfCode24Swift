import Foundation

let exString: String = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"""

let dirMap: [Character :(x: Int, y: Int, next: Character)] = [
    "N": (x: 0, y: 1, next: "E"),
    "E": (x: 1, y: 0, next: "S"),
    "S": (x: 0, y: -1, next: "W"),
    "W": (x: -1, y: 0, next: "N")
]



func day6(inputString: String) {
    var dir: Character = "N"
    let gridData: (grid: [Coordinate : (char: Character, visitDir: Character)], start: Coordinate) = buildGrid(inputString)
    var grid: [Coordinate : (char: Character, visitDir: Character)] = gridData.grid
    let start: Coordinate = gridData.start
    grid[start]?.char = "."
    var curCoor: Coordinate = start
    var curChar: Character? = "."
    var visited: [Coordinate] = []
    var obstructions: [Coordinate] = []
    var visitTracking: [Character:[Int:[Int]]] = [:]

    while (curChar != nil) {
        let nextCoor: Coordinate = Coordinate(x: curCoor.x + dirMap[dir]!.x, y: curCoor.y + dirMap[dir]!.y)
        let nextChar: Character? = grid[nextCoor]?.char
        let searchDir: Character = dirMap[dir]!.next
        //let searchCoor: Coordinate = Coordinate(x: curCoor.x + dirMap[searchDir]!.x, y: curCoor.y + dirMap[searchDir]!.y)
        if (nextChar == ".") {
            //check right to see if there is an existing visit going that direction and if it doesnt have a # between it and curCoor
            
            var needsObstruction: Bool = false
            if (searchDir == "E") {
                let perpendicularVisits: [Int]? = visitTracking[searchDir]?[curCoor.y]
                if let perpendicularVisits {
                    let filtered = perpendicularVisits.filter({$0 > curCoor.x})
                    if (filtered.count > 0) {
                        for i in curCoor.x+1...filtered[0] {
                            let searchC: Coordinate = Coordinate(x:i, y: curCoor.y)
                            let mapRes: (char: Character, visitDir: Character)? = grid[searchC]
                            if let mapRes {
                                if (mapRes.char == ".") {
                                    if (mapRes.visitDir == "E"  || filtered[0] == searchC.x) {
                                        needsObstruction = true
                                        break
                                    }
                                } else  {
                                    let lastCheck = grid[Coordinate(x: searchC.x-1, y: searchC.y)]!
                                    if (lastCheck.visitDir == dirMap[searchDir]?.next) {
                                        needsObstruction = true
                                    }
                                    break
                                }
                            }
                        }
                    }
                }
            } else if (searchDir == "W") {
                let perpendicularVisits: [Int]? = visitTracking[searchDir]?[curCoor.y]
                if let perpendicularVisits {
                    let filtered = perpendicularVisits.filter({$0 < curCoor.x})
                    if (filtered.count > 0) {
                        for i in (filtered[0]...curCoor.x-1).reversed() {
                            let searchC: Coordinate = Coordinate(x:i, y: curCoor.y)
                            let mapRes: (char: Character, visitDir: Character)? = grid[searchC]
                            if let mapRes {
                                if (mapRes.char == ".") {
                                    if (mapRes.visitDir == "W"  || filtered[0] == searchC.x) {
                                        needsObstruction = true
                                        break
                                    }
                                } else  {
                                    let lastCheck = grid[Coordinate(x: searchC.x+1, y: searchC.y)]!
                                    if (lastCheck.visitDir == dirMap[searchDir]?.next) {
                                        needsObstruction = true
                                    }
                                    break
                                }
                            }
                        }
                    }
                }
            } else if (searchDir == "N") {
                let perpendicularVisits: [Int]? = visitTracking[searchDir]?[curCoor.x]
                if let perpendicularVisits {
                    let filtered: [Int] = perpendicularVisits.filter({$0 > curCoor.y})
                    if (filtered.count > 0) {
                        for i in curCoor.y+1...filtered[0] {
                            let searchC: Coordinate = Coordinate(x: curCoor.x, y: i)
                            let mapRes: (char: Character, visitDir: Character)? = grid[searchC]
                            if let mapRes {
                                if (mapRes.char == ".") {
                                    if (mapRes.visitDir == "N"  || filtered[0] == searchC.y) {
                                        needsObstruction = true
                                        break
                                    }
                                } else  {
                                    let lastCheck = grid[Coordinate(x: searchC.x, y: searchC.y-1)]!
                                    if (lastCheck.visitDir == dirMap[searchDir]?.next) {
                                        needsObstruction = true
                                    }
                                    break
                                }
                            }
                        }
                    }
                }
            } else if (searchDir == "S") {
                let perpendicularVisits: [Int]? = visitTracking[searchDir]?[curCoor.x]
                if let perpendicularVisits {
                    let filtered = perpendicularVisits.filter({$0 < curCoor.y})
                    if (filtered.count > 0) {
                    //print("filtered \(filtered)")
                        for i in (filtered[0]...curCoor.y-1).reversed() {
                            //print(i)
                            let searchC: Coordinate = Coordinate(x:curCoor.x, y: i)
                            let mapRes: (char: Character, visitDir: Character)? = grid[searchC]
                            if let mapRes {
                                if (mapRes.char == ".") {
                                    if (mapRes.visitDir == "S" || filtered[0] == searchC.y) {
                                        needsObstruction = true
                                        break
                                    }
                                } else  {
                                    let lastCheck = grid[Coordinate(x: searchC.x, y: searchC.y+1)]!
                                    if (lastCheck.visitDir == dirMap[searchDir]?.next) {
                                        needsObstruction = true
                                    }
                                    break
                                }
                            }
                        }
                    }
                }
            }


            // add obstruction if coodinate directly to the right is going right
            if (needsObstruction == true) {
                obstructions.append(nextCoor)
            }
            
            //advance position & increment Visited
            visited.append(curCoor)
            
            if (["E", "W"].contains(dir)) {
                // may need to supply an array of one element for first execution?
                if (visitTracking[dir] == nil || visitTracking[dir]?[curCoor.y] == nil) {
                    visitTracking[dir]?[curCoor.y] = [curCoor.x]
                } else {
                    visitTracking[dir]?[curCoor.y]?.append(curCoor.x)
                }
            } else {
                if (visitTracking[dir] == nil || visitTracking[dir]?[curCoor.x] == nil) {
                    visitTracking[dir]?[curCoor.x] = [curCoor.y]
                } else {
                    visitTracking[dir]?[curCoor.x]?.append(curCoor.y)
                }
            }
            
            grid[curCoor]?.visitDir = dir
            curCoor = nextCoor
        } else if (nextChar == "#") {
            //change direction (turn right)
            if (["E", "W"].contains(dir)) {
                // may need to supply an array of one element for first execution?
                if (visitTracking[dir] == nil) {
                    visitTracking[dir] = [curCoor.y: [curCoor.x]]
                } else if (visitTracking[dir]![curCoor.y] == nil) {
                    visitTracking[dir]![curCoor.y] = [curCoor.x]
                } else {
                    visitTracking[dir]![curCoor.y]!.append(curCoor.x)
                }
            } else {
                if (visitTracking[dir] == nil) {
                    visitTracking[dir] = [curCoor.x: [curCoor.y]]
                } else if (visitTracking[dir]![curCoor.x] == nil) {
                    visitTracking[dir]![curCoor.x] = [curCoor.y]
                } else {
                    visitTracking[dir]![curCoor.x]!.append(curCoor.y)
                }
            }
            
            dir = dirMap[dir]!.next
        } else {
            // only other case should be no next character
            visited.append(curCoor)
            grid[curCoor]?.visitDir = dir
            break
        }

        curChar = nextChar
    }

    let visitedSet: Set<Coordinate> = Set(visited)
    print("p1: \(visitedSet.count)")
    //print(visitTracking)
    print("p1: \(visitedSet.count) | p2: \(obstructions.count)")
    //print(obstructions)
    



}

//day6(inputString: exString)
day6(inputString: readPuzzle(puzzleName: "day6"))

func buildGrid(_ inputString: String) -> (grid: [Coordinate:(char: Character, visitDir: Character)], start: Coordinate) {
    let lines = inputString.components(separatedBy: "\n")
    var grid: [Coordinate:(char: Character, visitDir: Character)] = [:]
    var start: Coordinate = Coordinate(x: 0, y: 0)
    let baseChar: Character = "Z"

    for (i, line) in lines.reversed().enumerated() {
        for (j , char) in line.enumerated() {
            let curCoor: Coordinate = Coordinate(x: j, y: i)
            grid[curCoor] = (char: char, visitDir: baseChar)
            if (char == "^" ) {
                start = Coordinate(x: j, y: i)
            }
        }
    }

    return (grid: grid, start: start)
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

struct Coordinate: Hashable {
    let x: Int
    let y: Int

    // Custom initializer
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}
