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
    func createClausal() -> [[Formula]] {
        let formula = Or(And(Atom("a"), Atom("b")), And(Atom("a"), Atom("c")))
        
        return [[formula.left], [formula.right]]
    }
    
    func dpll(_ clausalFormula: [[Formula]] ) -> Any {
        return dpllCheck(formula: clausalFormula, valoration: [])
    }
    
    func dpllCheck(formula: [[Formula]] , valoration: [String]) -> Any {
        let (S, valoration) = unitPropagation(formula: formula, valoration: [])
        if S.isEmpty {
            return valoration
        }
        if S.contains(where: { $0.isEmpty }) {
            return false
        }
        let atomic = getAtomic(S)
        let Sl = S.reduce([[atomic]]) { $0 + [$1] }
        let Sll = S.reduce([[Not(atomic)]]) { $0 + [$1] }
        
        let result = dpllCheck(formula: Sl, valoration: valoration)
        if !(result is Bool) {
            return result
        }
        return dpllCheck(formula: Sll, valoration: valoration)
    }
    
    func unitPropagation(formula: [[Formula]] , valoration: [String]) -> (formula: [[Formula]], valoration: [String]) {
        // Se tiver uma clausula unitaria (Atom ou Not), remove as clausulas que tem o literal e remove as clausulas quem contem a negação do literal
        // nas outras clausulas
        
//        while hasUnitClause(formula: formula) {
//
//        }
        return (formula, valoration)
    }
    
    func hasUnitClause(formula: [[Formula]]) -> Bool {
        if formula.contains(where: { clause -> Bool in
            return clause.contains {$0 is Atom || $0 is Not }
        }) {
            return true
        }
        return false
    }
    
    func removeClausesWithLiterals() {
        
    }
    
    func getAtomic(_ clausalFormula: [[Formula]]) -> Atom {
        return Atom("a")
    }
}
