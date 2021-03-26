//  main.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 18/12/20.
//

import Foundation

let matrixGrid = [
    [-1, -1, -1, -1],
    [-1, -1, 3, -1],
    [1,  1,  0, -1],
    [-1,  1,  0, -1]]

let solver = MineSweeperSolver()
let function = Functions()
let tableaux = Tableaux()

let formula = solver.mapMatrix(matrix: matrixGrid)
//print(formula.getFormulaDescription())
//let result = function.satisfabilityChecking(formula: formula)
//print(result)
let resultTableaux = tableaux.tableaux(formulas: [formula], isCheck: [false])
print(resultTableaux)

//for collun in 0...matrixGrid[0].count - 1 {
//    for line in 0...matrixGrid.count - 1 {
//        let cosequence = tableaux.logicalConsequence(premise: [formula], conclusion: Atom(atom: "m\(line)_\(collun)"))
//        print("m\(line)_\(collun) = \(cosequence)")
//    }
//}
