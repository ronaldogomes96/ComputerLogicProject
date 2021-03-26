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

//let solver = MineSweeperSolver()
//
//let formula = solver.mapMatrix(matrix: matrixGrid)
//let function = Functions()
//print(formula.getFormulaDescription())
//let result = function.satisfabilityChecking(formula: formula)
//print(result)
//
//for collun in 0...matrixGrid[0].count - 1 {
//    for line in 0...matrixGrid.count - 1 {
//        let cosequence = function.logicalConsequence(premise: [formula], conclusion: Atom(atom: "m\(line)_\(collun)"))
//        print("m\(line)_\(collun) = \(cosequence)")
//    }
//}
//



func removeClauseTest() {
    let solver = MineSweeperDPLL()
    let formulaClausal: [[Formula]] = [ [Or(Atom("c"), Or(Atom("d"), Atom("f")))] , [Atom("b")] ]
    var result = solver.removeClauses(from: formulaClausal, with: Atom("b"))
    result = solver.removeClauses(from: result, with:  Atom("d"))
    result.forEach { $0.forEach { print($0.getFormulaDescription()) }}
}

func dpllTests() {
    let dpll = MineSweeperDPLL()
    let formulaClausal: [[Formula]] = [ [Or(Atom("c"), Or(Atom("d"), Atom("f")))] , [Atom("b")] ]
    print(formulaClausal.map { $0.map { $0.getFormulaDescription()} })
    let result = dpll.solve(formulaClausal)
    print(result)
}

func getLiteralUnitTest() {
    let solver = MineSweeperDPLL()
    let formulaClausal: [[Formula]] = [ [Or(Atom("c"), Or(Atom("d"), Atom("f")))] , [Atom("b")] ]
    let literalUnit = solver.getLiteralUnit(from: formulaClausal)
    print(literalUnit!)
}

func removeComplementsTest() {
    let solver = MineSweeperDPLL()
    let formulaClausal: [[Formula]] = [ [Or(Atom("c"), Or(Atom("d"), Not(Atom("f"))))] , [Atom("b")] ]
    formulaClausal.forEach { $0.forEach { print($0.getFormulaDescription()) }}
    print("\n")
//    var naruto = solver.removeComplement(from: formulaClausal, with: Not(Atom("d")))
    let result2 = solver.removeComplement(from: formulaClausal, with: Not(Atom("f")))
    
    print(result2.map { $0.map { $0.getFormulaDescription()} })
}


//removeComplementsTest()

dpllTests()
