//
//  Functions.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 02/01/21.
//

import Foundation

class Functions {
    
    func listOfAtoms(formula: Formula) -> [String]{
        if formula is Atom {
            return [formula.getFormulaDescription()]
        }
        else if formula is Not {
            guard let newFormula = formula as? Not else {
                return []
            }
            return listOfAtoms(formula: newFormula.atom)
        }
        else {
            guard let newFormula = formula as? Implies else {
                return []
            }
            return listOfAtoms(formula: newFormula.left) + listOfAtoms(formula: newFormula.right)
        }
    }
    
    func truthValue(formula: Formula, interpretation: [String: Bool]) -> Bool {
        if formula is Atom {
            return interpretation[formula.getFormulaDescription()] ?? Bool.init()
        }
        else if formula is Not {
            guard let newFormula = formula as? Not else {
                return Bool.init()
            }
            return !truthValue(formula: newFormula.atom, interpretation: interpretation)
        }
        else if formula is Implies {
            if let newFormula = formula as? And {
                return truthValue(formula: newFormula.left, interpretation: interpretation) &&
                    truthValue(formula: newFormula.right, interpretation: interpretation)
            }
            else if let newFormula = formula as? Or {
                return truthValue(formula: newFormula.left, interpretation: interpretation) ||
                    truthValue(formula: newFormula.right, interpretation: interpretation)
            }
            else if let newFormula = formula as? Implies {
                if truthValue(formula: newFormula.left, interpretation: interpretation) == true &&
                    truthValue(formula: newFormula.right, interpretation: interpretation) == false {
                    return false
                }
                else if truthValue(formula: newFormula.left, interpretation: interpretation) == false ||
                    truthValue(formula: newFormula.right, interpretation: interpretation) == true {
                    return true
                }
            }
        }
        return Bool.init()
    }
}
