import Foundation

let exString: String = """
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
"""

func day7(inputString: String) {
    let lines: [String] = inputString.components(separatedBy: "\n")
    var passed: [Int] = []
    var p2passed: [Int] = []
    for line in lines {
        let lineSplit = line.components(separatedBy: ": ")
        let check: Int = Int(lineSplit[0])!
        let remaining: [Int128] = lineSplit[1].components(separatedBy: " ").map({Int128($0)!})
        let remInt: [Int] = lineSplit[1].components(separatedBy: " ").map({Int($0)!})

        if (recursiveCheck(check: check, remaining: remInt)) {
            passed.append(check)
            p2passed.append(check)
            //print("line: \(line) | PASS")
        } else if (p2recursiveCheck(check: Double(check), remaining: remaining, lastNumber: nil, lastOperator: "+", original: Int128(check) )) {
            p2passed.append(check)
            //print("line: \(line) | PASS")
        } else {
            //print("line: \(line) | FAIL")
        }
    }

    print("part1: passed: \(passed.reduce(0, +))")
    print("part2: passed: \(p2passed.reduce(0,+))")
}

func recursiveCheck (check: Int, remaining: [Int]) -> Bool {
    var remainingTemp: [Int] = remaining
    let last: Int = remainingTemp.popLast()!
    if (remaining.count == 1) {
        return (check == remaining[0])
    } else if (recursiveCheck(check: check - last, remaining: remainingTemp) == true) {
        return true
    } else {
        //print("last: \(last) | check: \(check) | check.isMultiple(of: last): \(check.isMultiple(of: last))" )
        return check.isMultiple(of: last)  ? recursiveCheck(check: check/last, remaining: remainingTemp) : false
    }
}

func p2recursiveCheck (check: Double, remaining: [Int128], lastNumber: Int128?, lastOperator: Character, original: Int128) -> Bool {
    if remaining.count  == 0 {
        return check == 0
    }
    /*if ((Int128(check) - 10) > original) {
        return false
    }*/
    let remainingTemp: [Int128] = Array(remaining[1...])
    let last: Int128 = remaining[0]

    //print("last: \(last) | check: \(check) | remaining: \(remaining) | remainingTemp: \(remainingTemp) | lastNumber: \(lastNumber ?? -1)" )

    if (remaining.count == 1) {
        return (Int128(check) == remaining[0])/* || (lastNumber != nil && Int(check) == Int(String(lastNumber!) + String(remaining[0])))*/
    } else if (p2recursiveCheck(check: check - Double(last), remaining: remainingTemp, lastNumber: last, lastOperator: "+", original: original) == true) {
        return true
    } else if (/*check.isMultiple(of: last)*/ true ? p2recursiveCheck(check: check/Double(last), remaining: remainingTemp, lastNumber: last*(lastNumber ?? 1), lastOperator: "*", original: original) : false) {
        return true
    } else if (remainingTemp.count >= 1) {
        // may need to account for a third case: combining the last number with the second to last number
        //print("remainingTemp: \(remainingTemp)")
        var combined: Int128 = lastNumber ?? 0 
        var res: Bool = false
        //print("enter FOR loop: check: \(check) | remaining: \(remaining)")
        for (i, r) in remaining.enumerated() {
            //print("r: \(r)")
            if (i > 0 || true || lastNumber == nil) {
                //let num2: Int = r
                let subRem: [Int128] = remaining.count > 1 ? Array(remaining[(i+1)...]) : []
                //print("Rem: \(remaining)")
                //print("subRem: \(subRem) | lastNumber: \(lastNumber)")
                //Base check number on the last Number and Operator
                var newCheck = lastNumber != nil ? check*Double(lastNumber!) : check
                if (lastNumber != nil) {
                    if (lastOperator == "+") {
                        newCheck = check + Double(lastNumber!)
                    } else {
                        newCheck = check * Double(lastNumber!)
                    }
                } else {
                    newCheck = check
                }
                //COMBINE NUMBERS
                var cString: String = i == 0 ? String(r) : ""
                if (i > 0) {
                    for int in Array(remaining[0...i]) {
                        if (int > 0) {
                            cString += String(int)
                        }
                    }
                }
                
                //print("cString: \(cString) | i: \(i) | lastNumber: \(lastNumber ?? -1) | newCheck: \(newCheck) | combined: \(combined)")
                if (lastNumber != nil && combined > 0 && Double(combined) < newCheck && newCheck < Double(original + 10)) {
                    //print("combined: \(String(combined)) | cString: \(cString)")
                    combined = Int128(String(combined) + cString)!
                } else {
                    combined = Int128(cString) ?? 0
                }
                //print("loop \(i) (remaining: \(remaining)) | remainingTemp: \(subRem) | check: \(newCheck) | cString: \(cString) | combined: \(combined), lastNumber: \(lastNumber ?? -1)")
                if (newCheck < Double(combined) || newCheck > Double(original + 10)) {
                    //print("failure")
                    continue
                } else if (p2recursiveCheck(check: newCheck-Double(combined), remaining: subRem, lastNumber: combined, lastOperator: lastOperator, original: original) == true) {
                    res = true
                    return true
                } else if (/*combined.isMultiple(of: check)*/ subRem.count > 0 && p2recursiveCheck(check: newCheck/Double(combined), remaining: subRem, lastNumber: last*combined, lastOperator: lastOperator, original: original) == true) {
                    res = true
                    return true
                } else {
                    //print("failure")
                }
            }

        }
        //print("end FOR LOOP")
        return res
    } else {
        return false
    }
}


//7290: 6 8 6 15
/*
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
*/

//print(p2recursiveCheck(check: 7290, remaining: [6,8,6,15], lastNumber: nil,lastOperator: "+", original: 7290))
//357611951: 9 19 8 1 613 463 7 3 3 5
//print(p2recursiveCheck(check: 357611951, remaining: [9, 19, 8, 1, 613, 463, 7, 3, 3, 5], lastNumber: nil, lastOperator: "+", original: 357611951))
//day7(inputString: exString)
day7(inputString: readPuzzle(puzzleName: "day7"))

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