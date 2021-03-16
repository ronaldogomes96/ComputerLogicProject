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

let formula = solver.mapMatrix(matrix: matrixGrid)
let function = Functions()
print(formula.getFormulaDescription())
let result = function.satisfabilityChecking(formula: formula)
print(result)

for collun in 0...matrixGrid[0].count - 1 {
    for line in 0...matrixGrid.count - 1 {
        let cosequence = function.logicalConsequence(premise: [formula], conclusion: Atom(atom: "m\(line)_\(collun)"))
        print("m\(line)_\(collun) = \(cosequence)")
    }
}
