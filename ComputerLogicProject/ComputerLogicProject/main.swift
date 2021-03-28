//  main.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 18/12/20.
//

import Foundation

//MARK: - Instancias
let grid = Grid()
let mine = MineSweeperSolver()
let function = Functions()
let tableaux = Tableaux()
let dpll = DPLLSolver()
var results = [String: [Double]]()


//Percorre cada um dos 10 grids
for (index, grid) in grid.listOfGrid().enumerated() {

    //Faz a modelagem do grid em uma formula
    let formula = mine.mapMatrix(matrix: grid)

    print("\n\n\nGRID\(index+1)")
    results["\(index+1)"] = []

    // run your work
    print(formula.getFormulaDescription())

    //Consequencia logica normal, de forca bruta
    print("\nSATISFABILIDADE")
    var start = CFAbsoluteTimeGetCurrent()
    function.getLogicaConsequenceForGrid(grid: grid, formula: formula)
    var diff = CFAbsoluteTimeGetCurrent() - start
    results["\(index+1)"]?.append(diff.toMinutes())
    print(results)

    //Consequencia logica pelo metodo dos tableaux
    print("\nTABLEUX")
    start = CFAbsoluteTimeGetCurrent()
    tableaux.getLogicaConsequenceForGrid(grid: grid, formula: formula)
    diff = CFAbsoluteTimeGetCurrent() - start
    results["\(index+1)"]?.append(diff.toMinutes())
    print(results)
    
    if index < 3 {
        print("\nDPLL")
        start = CFAbsoluteTimeGetCurrent()
        let integerFormula = mine.convertToIntegerCNF(formula)
        dpll.getLogicalConsequenceForGrid(grid: grid, formula: integerFormula)
        diff = CFAbsoluteTimeGetCurrent() - start
        results["\(index+1)"]?.append(diff.toMinutes())
        print(results)
    }
}


//Salvando
if #available(OSX 10.12, *) {
    let path = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Downloads/results")
    print(path)
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do { // write
        let jsonData = try encoder.encode(results.self)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            try jsonString.write(to: URL(fileURLWithPath: path.relativePath), atomically: true, encoding: .utf8)
        }
    } catch {
        print(error.localizedDescription)
    }
} else {
    // Fallback on earlier versions
}



