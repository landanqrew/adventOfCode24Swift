import Foundation
//import SourceKit

let exString = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"""

func day4 (inputString: String) {
    let buildGrid: (grid: [Coordinate:Character], xCoors: [Coordinate], aCoors: [Coordinate]) = buildGrid(inputString)
    let grid: [Coordinate:Character] = buildGrid.grid
    let xCoors: [Coordinate] = buildGrid.xCoors
    let aCoors: [Coordinate] = buildGrid.aCoors
    var xmasCount: Int = 0
    var dxmasCount: Int = 0

    for xCoor: Coordinate in xCoors {
        //print("xCoor: \(xCoor)")
        let adjacents: [Coordinate] = generateAdjacents(coor: xCoor)
        //print("adjacents:")
        //print(adjacents)
        var chars: [Character] = []
        for adj: Coordinate in adjacents {
            if (grid[adj] != nil) {
                chars.append(grid[adj]!)
            } else {
                chars.append(".")
            }
        }

        var eval: String = ""
        while (chars.count > 0) {
            for _ in 1...3 {
                eval += String(chars.popLast()!)
            }
            if eval == "SAM" {
                xmasCount += 1
            }
            //print(eval)
            eval = ""
        }

    }

    for aCoor: Coordinate in aCoors {
        let diags: [Coordinate] = generateDiagonals(coor: aCoor)
        var chars: [Character] = []
        for d in diags {
            if (grid[d] != nil) {
                chars.append(grid[d]!)
            } else {
                chars.append(".")
            }
        }

        let eval: String = String(chars)
        if (["SMSM", "MSMS", "SMMS", "MSSM"].contains(eval)) {
            dxmasCount += 1
        }
        


    }

    print("xmasCount: \(xmasCount)")
    print("dxmasCount: \(dxmasCount)")
}

func buildGrid(_ inputString: String) -> (grid: [Coordinate:Character], xCoors: [Coordinate], aCoors: [Coordinate]) {
    let lines = inputString.components(separatedBy: "\n")
    var grid: [Coordinate:Character] = [:]
    var xCoors: [Coordinate] = []
    var aCoors: [Coordinate] = []

    for (i, line) in lines.reversed().enumerated() {
        for (j, char) in line.enumerated() {
            let curCoor: Coordinate = Coordinate(x: j, y: i)
            grid[curCoor] = char
            if (char == "X") {
                xCoors.append(curCoor)
            }
            if (char == "A") {
                aCoors.append(curCoor)
            }
        }
    }

    return (grid: grid, xCoors: xCoors, aCoors: aCoors)
}

func generateAdjacents(coor: Coordinate) -> [Coordinate] {
    var adjacents: [Coordinate] = []
    for x: Int in -1...1 {
        for y: Int in -1...1 {
            if ((x,y) != (0,0)) {
                for z: Int in 1...3 {
                    adjacents.append(Coordinate(x: coor.x+(x*z), y: coor.y + (y*z)))
                }
            }
        } 
    }
    return adjacents
}

func generateDiagonals(coor: Coordinate) -> [Coordinate] {
    let upperLeft = Coordinate(x: coor.x - 1,y: coor.y + 1)
    let lowerRight = Coordinate(x: coor.x + 1,y: coor.y - 1)
    let upperRight = Coordinate(x: coor.x + 1,y: coor.y + 1)
    let lowerLeft = Coordinate(x: coor.x - 1,y: coor.y - 1)

    let adjacents = [upperLeft, lowerRight, upperRight, lowerLeft]
    return adjacents
}

let exGrid = buildGrid(exString)

//print(exGrid[Coordinate(x: 0,y: 0)]!)
//day4(inputString: /*exString*/ readPuzzle(puzzleName: "day4"))
day4(inputString: exString)


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



