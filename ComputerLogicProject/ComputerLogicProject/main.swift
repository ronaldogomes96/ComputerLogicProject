//  main.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 18/12/20.
//

import Foundation

let matrixGrid = [
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1,  3,  -1, -1],
    [-1,  -1,  -1, -1]]

let solver = MineSweeperSolver()

let formula = solver.mapMatrix(matrix: matrixGrid)
let function = Functions()

print(formula.getFormulaDescription())
let consequence = function.logicalConsequence(premise: [formula], conclusion: Atom(atom: "m1_1"))
print(consequence)

// ["m2_1": false, "m1_1": false, "m1_2": false, "m1_0": false, "m3_2": true, "m3_1": true, "m3_0": true, "m2_2": false, "m2_0": false]
