import Foundation
import RegexBuilder

let exString: String = "xmul(2,4)%&mul[3,7]!@^don't()_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

let exString2: String = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"


func day3(_ inputString: String) {
    //print(inputString)

    let evalList = inputString.components(separatedBy: "mul(")
    var outputs: [(doMul: Bool, number1: Int, number2: Int, result: Int)] = []
    var doList: [Bool] = []
    var isMul: Bool = true
    var subString: Substring = ""


    for i: Int in 0...inputString.count-4 {
        if (i > 9) {
            subString = inputString[inputString.index(inputString.startIndex, offsetBy: i-8) ..< inputString.index(inputString.startIndex, offsetBy: i)]
        } else {
            subString = inputString.prefix(upTo: inputString.index(inputString.startIndex, offsetBy: i+1))
        }

        if (subString.hasSuffix("mul(")) {
            doList.append(isMul)
        }

        if (subString.hasSuffix("do()") && !isMul) {
            //print("------ IDENITFIED do() change")
            isMul.toggle()
        } else if  (subString.hasSuffix("don't()") && isMul) {
            isMul.toggle()
        }

        //print(subString)

    }
    doList.append(isMul)

    for (i,  eval) in evalList.enumerated() {
        let doMul: Bool = i==0 ? doList[i] : doList[i-1]
        //print("eval: \(eval) |  i: \(i) |  doMul: \(doMul)")

        let evalRes: (result: Bool, number1: Int?, number2: Int?) = regexTest(eval)
        if (evalRes.result) {
            outputs.append((doMul: doMul, number1: evalRes.number1!, number2: evalRes.number2!, result: evalRes.number1! * evalRes.number2!))
        }

    }

    var p1: Int = 0
    var p2: Int = 0
    for output in outputs {
        p1 += output.result
        if (output.doMul) {
            p2 += output.result
        }
    }

    //print(doList)
    //print(outputs)

    print("part1: \(p1) | part2: \(p2)")

}


func regexTest(_ inputString: String) -> (result: Bool, number1: Int?, number2: Int?) {

    if (inputString.count == 0 || !inputString.contains(")")) {
        return (result: false, number1: nil, number2: nil)
    } else {
        let newString: String = inputString.components(separatedBy: ")")[0]
        if (!newString.contains(",")) {
            return (result: false, number1: nil, number2: nil)
        } else {
            let numStrings = newString.components(separatedBy: ",")
            if (numStrings.count != 2) {
                return (result: false, number1: nil, number2: nil)
            } else {
                var numbers: [Int] = []
                for num in numStrings {
                    if isValidNumber(num) {
                        numbers.append(Int(num)!)
                    } else {
                        return (result: false, number1: nil, number2: nil)
                    }
                }

                return (result: true, number1: numbers[0], number2: numbers[1])
            }
        }
    }
    
}

func isValidNumber(_ inputString: String) -> Bool {

    if (inputString.count > 0) {
        if (inputString.count == 1 && inputString.getChar(atIndex: 0).isNumber) {
            return true
        } else {
            if (inputString.count > 3) {
                return false
            } else {
                for (i, char) in inputString.enumerated() {
                    if (i == 0 && char == "0") {
                        return false
                    } else if (!char.isNumber) {
                        return false
                    }

                }
                return true
            }
        }

    }
    return false
}

extension String {
    func getChar(atIndex: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: atIndex)] as Character
    }
}

day3(readPuzzle(puzzleName: "day3"))

//regexTest("abcd")
//let myString: String = "345"

//print(isValidNumber(myString))






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