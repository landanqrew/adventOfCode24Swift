import Foundation

let exString: String = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"""

// print(readPuzzle(puzzleName: "day2"))

func day2(inputString: String) {
    let reportStrings: [String.SubSequence] = inputString.split(separator: "\n")

    var reports: [[Int]] = []
    var reportP1SafeCount = 0
    var reportP2SafeCount = 0

    for repString in reportStrings {
        let intStrings = repString.split(separator: " ")
        var report: [Int] = []
        for intString in intStrings {
            let number = Int(intString)!
            report.append(number)
        }
        
        if (part1Pass(inputArray: report)) {
            reportP1SafeCount += 1
            reportP2SafeCount += 1
        } else if (part2Pass(inputArray: report)) {
            reportP2SafeCount += 1
        }
        reports.append(report)
    }

    //print(reports)
    //print(reportStatuses)
    print("P1safeCount: \(reportP1SafeCount) | P2safeCount: \(reportP2SafeCount)")
    
}

func part1Pass (inputArray: [Int]) -> Bool {
    var reportSafe: Bool = true
    var isIncreasing: Bool?
    var lastNumber: Int = inputArray[0]

    for (i, number) in inputArray.enumerated() {
        if i == 0 {
            continue
        }
        let dist = number - lastNumber
        //print("n: \(number) | ln: \(lastNumber)")
        if (abs(dist) == 0 || abs(dist) > 3) {
            //print("dist outside of range")
            reportSafe = false
            break
        }
        if let isIncreasing {
            if ((dist < 0 && isIncreasing == true) || (dist > 0 && isIncreasing == false)) {
                //print("list does not consistently increase or decrease")
                reportSafe = false
                break
            }
        } 

        isIncreasing = dist > 0
        lastNumber = number
    }

    return reportSafe
}

func part2Pass (inputArray: [Int]) -> Bool {

    // run modified array through part 1 test
    for i in 0...inputArray.count-1 {
        var modified = inputArray
        modified.remove(at: i)
        if (part1Pass(inputArray: modified)) {
            return true
        }
    }

    return false
}

day2(inputString: exString/*readPuzzle(puzzleName: "day2")*/)

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