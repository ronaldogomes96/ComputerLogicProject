//
//  DPPLSolver.swift
//  ComputerLogicProject
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import Foundation

class DPLLSolver {
    
    func solve(_ clausalFormula: [[Int]]) -> Any {
        return dpllCheck(formula: clausalFormula, valuation: [])
    }
    
    internal func dpllCheck(formula: [[Int]] , valuation: [String]) -> Any {
        let (S, valuation) = unitPropagation(formula: formula, valuation: [])
        if S.isEmpty {
            return valuation
        }
        if S.contains(where: { $0.isEmpty }) {
            return false
        }
        let atomic = getAtomic(S)
        let Sl = S.reduce([[atomic]]) { $0 + [$1] }
        let Sll = S.reduce([[atomic * -1]]) { $0 + [$1] }
        
        let result = dpllCheck(formula: Sl, valuation: valuation)
        if (result as? Bool) != false {
            return result
        }
        return dpllCheck(formula: Sll, valuation: valuation)
    }
    
    internal func unitPropagation(formula: [[Int]] , valuation: [String]) -> (formula: [[Int]], valuation: [String]) {
        
        var newValuation = valuation
        var newFormula = formula
        
        var literalUnit = getLiteralUnit(from: newFormula)
        while literalUnit != nil {
            newValuation = newValuation.reduce(["\(literalUnit!) = true"]) { $0 + [$1] }
            newFormula = removeClauses(from: newFormula, with: literalUnit!)
            newFormula = removeComplement(from: newFormula, with: literalUnit!)
            literalUnit = getLiteralUnit(from: newFormula)
        }
        
        return (newFormula, newValuation)
    }
    
    internal func getLiteralUnit(from formula: [[Int]]) -> Int? {
        var literal: Int?
        formula.forEach { clause in
            if clause.count == 1 {
                literal = clause.first
            }
        }
        return literal
    }
    
    internal func removeClauses(from formula: [[Int]], with literal: Int) -> [[Int]] {
        var newFormula = formula
        for (indexClause, clause) in newFormula.enumerated() {
                if clause.contains(literal) {
                    let index = newFormula.lastIndex(of: clause)!
                    newFormula.remove(at: index)
                }
            }
        return newFormula
    }
    
    
    internal func getAtomic(_ clausalFormula: [[Int]]) -> Int {
        let randomIndex = Int.random(in: 0..<clausalFormula.count)
        if !clausalFormula.isEmpty {
            let randomIndexAtomic = Int.random(in: 0..<clausalFormula[randomIndex].count)
            return clausalFormula[randomIndex][randomIndexAtomic]
        }
        
        fatalError()
    }
    
    internal func removeComplement(from formula: [[Int]], with literal: Int) -> [[Int]] {
        var newFormula = formula
        
        for (indexClause, clause) in newFormula.enumerated() {
            for (literalIndex, formulaLiteral) in clause.enumerated() {
                if formulaLiteral == literal * -1 {
                    newFormula[indexClause].remove(at: literalIndex)
                }
            }
        }
        return newFormula
    }
    
    internal func hasUnitClause(from formula: [[Int]]) -> Bool {
        formula.contains { $0.count == 1 }
    }
    
}

struct DPLLSolverTests {
    func testDPLL() {
        if #available(OSX 10.12, *) {
            let cnf = CNF(from: "uuf50-01", folder: .insatistiable).transformInCNF()
            let result = DPLLSolver().solve(cnf)
            print(result)
        } else {
            // Fallback on earlier versions
        }
    }
}

