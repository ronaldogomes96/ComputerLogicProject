//
//  CNFReader.swift
//  ComputerLogicProject
//
//  Created by Vinicius Mesquita on 26/03/21.
//

import Foundation
enum EnumFolder: String {
    case satifiable =  "satisfativeis"
    case insatistiable =  "insatisfativeis"
    case minesweeper =  "minesweeper"
    
    static let projectRoot = "Documents/Studies/LogicForComputerScience/ComputerLogicProject/ComputerLogicProject/ComputerLogicProject/DPLL/Files"
}
class CNF {
    let fileManager = FileManager.default
    var fileString: String?
    
    @available(OSX 10.12, *)
    init(from filePath: String, folder: EnumFolder) {
        let folderPath = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(EnumFolder.projectRoot)
            .appendingPathComponent(folder.rawValue)
            .appendingPathComponent(filePath)
            .appendingPathExtension("cnf")
        
        self.fileString = read(filePath: folderPath.relativePath)
    }
    
    
    private func read(filePath: String) -> String? {
        if fileManager.fileExists(atPath: filePath) {
            do {
                let fileString = try String(contentsOf: URL(fileURLWithPath: filePath))
                return fileString
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func transformInCNF() -> [[Int]] {
        var formula = ""
        guard let fileString = fileString else { fatalError("File not found") }

        if let indexFormula = fileString.index(of: "p") {
            formula = String(fileString[indexFormula..<fileString.index(of: "%")!])
            if let firstIndex = formula.firstIndex(of: "\n") {
                formula = String(formula[firstIndex..<formula.endIndex])
            }
        }

        let allLines = formula.split(separator: "\n")
        let resultMatrix = parseStringCnfToInteger(linesMatrix: allLines)
        return resultMatrix
    }
    
    private func parseStringCnfToInteger(linesMatrix: [String.SubSequence]) -> [[Int]] {
        var transformedMatrix = [[Int]]()
        for line in linesMatrix {
            let splitedValues = line.split(separator: " ")
            var parsedNumber = splitedValues.map { Int($0)! }
            parsedNumber.removeLast()
            transformedMatrix.append(parsedNumber)
        }
        
        return transformedMatrix
    }
}

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
}
