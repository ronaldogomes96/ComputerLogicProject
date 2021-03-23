//
//  MineSweeperDPPLSolver.swift
//  ComputerLogicProject
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import Foundation

class MineSweeperDPLL {

    // [[a,b], [b, c]]
    // Create clausal formula
    func createClausal(formula: Formula) {
        
    }
    
    func dpll() {
        let clausalFormula = Or(left: And(left: Atom(atom: "a"), right: Atom(atom: "b")), right: And(left: Atom(atom: "a"), right: Atom(atom: "c")))
        print(formula.getFormulaDescription())
        return dpllCheck(formula: clausalFormula, valoration: [])
    }
    
    func dpllCheck(formula: Formula, valoration: [String]) {
        
    }
    
    func unitPropagation(formula: Formula, valoration: [String]) {
        while hasUnitClause(formula: formula) {
            
        }
    }
    
    func hasUnitClause(formula: Formula) -> Bool {
        return true
    }
    
    func removeClausesWithLiterals() {
        
    }
}
