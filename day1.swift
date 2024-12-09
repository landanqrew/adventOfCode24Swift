import Foundation

print("hello world")



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

let puzzle: String = readPuzzle(puzzleName: "day1")
func day1(inputString: String) {

    let lines: Array<String.SubSequence> = inputString.split(separator: "\n")
    
    var left: Array<Int> = []
    var right: Array<Int> = []
    
    for line in lines {
        let strings = line.split(separator: "   ")
        for (i,string) in strings.enumerated() {
            let number = Int(string)
            if (i == 0) {
                left.append(number!)
            }
            if (i == 1) {
                right.append(number!)
            }
        }
    }
    
    left = left.sorted()
    right = right.sorted()
    
    var distances: Array<Int> = []
    var totalDist: Int = 0
    
    for i in 0...left.count-1 {
        let dist = abs(left[i] - right[i])
        distances.append(dist)
        totalDist += dist
    }
    
    print("p1Res: \(totalDist)")
    
    //PART 2
    
    var rCounter: Dictionary<Int,Int> = [:]
        
    for r in right {
        if (rCounter[r] == nil) {
            rCounter[r] = 1
        } else {
            rCounter[r]! += 1
        }
    }
    
    var p2Res = 0
    for l in left {
        if (rCounter[l] != nil) {
            p2Res += rCounter[l]! * l
        }
    }
    
    print("p2Res: \(p2Res)")
}

day1(inputString: puzzle)


/// File name components are used to build the URL for a file's location.
/// - Parameters:
///    - fileName: The file name.
///    - fileExtension: An optional file extension (ex: "txt" for .txt).
///    - directoryName: An optional directory name. If the directory does not exist it will be created.
///    - directoryPath: The directory path were the optional directory name and file will be created (ex: FileManager.SearchPathDirectory.documentsDirectory).

public enum FileError: Error {
    case unableToCreateDirectory(directory: String, reason: String)
}

public struct FileURLComponents {
    var fileName: String
    var fileExtension: String?
    var directoryName: String?
    var directoryPath: FileManager.SearchPathDirectory
}

public class File: NSObject {
    /// A static function that will handle writing data to a file.
    /// - Parameters:
    ///    - data: The data to be written.
    ///    - to: The components that will make up the destination file URL.
    /// - Returns: The URL to the file.
    public static func write(_ data: Data, to fileURLComponents: FileURLComponents) throws -> URL {
        do {
            // Get the file destination url
            let destinationURL = try File.fileURL(using: fileURLComponents)
            
            // Write the data to the file
            try data.write(to: destinationURL)
            return destinationURL
        } catch {
            throw error
        }
    }

    /// A static function that will handle reading data from a file.
    /// - Parameters:
    ///    - from: The components that will make up the source file URL.
    /// - Returns: The file data.
    public static func read(from fileURLComponents: FileURLComponents) throws -> Data {
        do {
            // Get the file source url
            let sourceURL = try File.fileURL(using: fileURLComponents)
            
            // Read the data from the file
            return try Data(contentsOf: sourceURL)
        } catch {
            throw error
        }
    }


    /// Constructs the file URL from the file components.
    /// - Parameters:
    ///    - using: The file components to be used when constructing the file URL.
    /// - Returns: The file URL.
    private static func fileURL(using fileURLComponents: FileURLComponents) throws -> URL {
        do {
            // Get the destination directory url
            let dirURL = try File.directoryURL(for: fileURLComponents.directoryName, at: fileURLComponents.directoryPath)
            
            // Create the file url
            var fileURL: URL
            if let fileExtension = fileURLComponents.fileExtension {
                // Add the file extension to the url
                fileURL = URL(fileURLWithPath: fileURLComponents.fileName, relativeTo: dirURL).appendingPathExtension(fileExtension)
            } else {
                fileURL = URL(fileURLWithPath: fileURLComponents.fileName, relativeTo: dirURL)
            }
            return fileURL
        } catch {
            throw error
        }
    }
    
    /// Constructs a directory URL from the given directory path and optional name.
    /// - Parameters:
    ///    - for: An optional directory name.
    ///    - at: The base directory path.
    /// - Returns: The directory URL.
    private static func directoryURL(for directoryName: String?, at directoryPath: FileManager.SearchPathDirectory) throws -> URL {
        // Get base directory path url
        var destinationDirectoryURL = FileManager.default.urls(for: directoryPath, in: .userDomainMask)[0]
        
        // Append a new directory name if applicable
        if let directoryName = directoryName {
            destinationDirectoryURL = destinationDirectoryURL.appendingPathComponent(directoryName, isDirectory: true)
        }
        
        // Create the directory
        do {
            try FileManager.default.createDirectory(at: destinationDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            return destinationDirectoryURL
        } catch {
            throw FileError.unableToCreateDirectory(directory: destinationDirectoryURL.absoluteString, reason: error.localizedDescription)
        }
    }
}




/*
func testFileWriteThenRead() {
    // let fileName = "day1.txt"

    let directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0]
    

    let fileURL = URL(fileURLWithPath: "day2", relativeTo: directoryURL).appendingPathExtension("txt")


    print(fileURL)

    //let testString = "Hello World"
    // Create data to be saved
    let myString = "Saving data with FileManager is easy!"
    guard let data = myString.data(using: .utf8) else {
        print("Unable to convert string to data")
        return
    }
    // Save the data
    do {
        try data.write(to: fileURL)
        print("File saved: \(fileURL.absoluteURL)")
    } catch {
        // Catch any errors
        print(error.localizedDescription)
    }

    do {
    // Get the saved data
    let savedData = try Data(contentsOf: fileURL)
    // Convert the data back into a string
    if let savedString = String(data: savedData, encoding: .utf8) {
        print(savedString)
    }
    } catch {
    // Catch any errors
    print("Unable to read the file")
    }
}

func testFileWriteThenRead2() {
    // let fileName = "day1.txt"

    let directoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0]

    let baseDirURL = directoryURL.appendingPathComponent("Development/SwiftPlayground/Advent_Of_Code/.build")
    

    let fileURL = URL(fileURLWithPath: "day2", relativeTo: baseDirURL).appendingPathExtension("txt")


    print(fileURL)

    //let testString = "Hello World"
    // Create data to be saved
    let myString = "Saving data with FileManager is easy!"
    guard let data = myString.data(using: .utf8) else {
        print("Unable to convert string to data")
        return
    }
    // Save the data
    do {
        try data.write(to: fileURL)
        print("File saved: \(fileURL.absoluteURL)")
    } catch {
        // Catch any errors
        print(error.localizedDescription)
    }

    do {
    // Get the saved data
    let savedData = try Data(contentsOf: fileURL)
    // Convert the data back into a string
    if let savedString = String(data: savedData, encoding: .utf8) {
        print(savedString)
    }
    } catch {
    // Catch any errors
    print("Unable to read the file")
    }
}

testFileWriteThenRead2()
*/

