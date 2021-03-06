//
//  Functions.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 02/01/21.
//

import Foundation

class Functions {
    
    func listOfAtoms(formula: Formula) -> [String] {
        if formula is Atom {
            return [formula.getFormulaDescription()]
        }
        else if formula is Not {
            guard let newFormula = formula as? Not else {
                return []
            }
            return listOfAtoms(formula: newFormula.inner)
        }
        else {
            guard let newFormula = formula as? Implies else {
                return []
            }
            return listOfAtoms(formula: newFormula.left) + listOfAtoms(formula: newFormula.right)
        }
    }
    
    func listOfLiterals(formula: Formula) -> [String] {
        if formula is Atom || formula is Not {
            return [formula.getFormulaDescription()]
        }
        else {
            guard let newFormula = formula as? Implies else {
                return []
            }
            return listOfLiterals(formula: newFormula.left) + listOfLiterals(formula: newFormula.right)
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
            return !truthValue(formula: newFormula.inner, interpretation: interpretation)
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
    
    func satisfabilityChecking(formula: Formula) -> Any {
        let listOfAtoms = self.listOfAtoms(formula: formula)
        let setList = Set(listOfAtoms)
        var listOfAtomsTransformed = setList.map { String($0) }
        
        let interpretation = self.createInterpretations(formula: formula)
                
        listOfAtomsTransformed.forEach {
            if interpretation[$0] != nil {
                if let index = listOfAtomsTransformed.firstIndex(of: $0) {
                    listOfAtomsTransformed.remove(at: index)
                }
            }
        }
        
        return isSatisfactory(formula: formula, atoms: listOfAtomsTransformed, interpretation: interpretation)
    }
    
    private func isSatisfactory(formula: Formula, atoms: [String], interpretation: [String: Bool]) -> Any {
        
        
        if atoms == [] {
            if truthValue(formula: formula, interpretation: interpretation) {
                return interpretation
            } else {
                return false
            }
        }
        var newAtons = atoms
        let atom = newAtons.popLast() ?? ""
        var interpretationOne = interpretation
        var interpretationTwo = interpretation
        interpretationOne[atom] = true
        interpretationTwo[atom] = false
        let result = isSatisfactory(formula: formula, atoms: newAtons, interpretation: interpretationOne)
        if (result as? Bool) != false {
            return result
        }
        return isSatisfactory(formula: formula, atoms: newAtons, interpretation: interpretationTwo)
    }
    
    func andAll(listOfFormulas: [Formula]) -> Formula {
        var firstFormula = listOfFormulas[0]
        var newListOfFormulas = listOfFormulas
        newListOfFormulas.remove(at: 0)
        newListOfFormulas.forEach { (formula) in
            firstFormula = And(firstFormula, formula)
        }
        return firstFormula
    }

    func orAll(listOfFormulas: [Formula]) -> Formula {
        var firstFormula = listOfFormulas[0]
        var newListOfFormulas = listOfFormulas
        newListOfFormulas.remove(at: 0)
        newListOfFormulas.forEach { (formula) in
            firstFormula = Or(firstFormula, formula)
        }
        return firstFormula
    }
    
    func createInterpretations(formula: Formula) -> [String: Bool] {
        var listOfFormulas = [formula]
        var interpretationFormulas = [String: Bool]()
        
        while true {
            let listOfFormulasActual = listOfFormulas
            for (index, insideFormula) in listOfFormulas.enumerated() {
                if let insideFormula = insideFormula as? And {
                    listOfFormulas.remove(at: index)
                    listOfFormulas.append(insideFormula.left)
                    listOfFormulas.append(insideFormula.right)
                }
            }
            if listOfFormulasActual.count == listOfFormulas.count {
                break
            }
        }
        
        listOfFormulas.forEach {
            if $0 is Atom {
                interpretationFormulas["\($0.getFormulaDescription())"] = true
            }
            if $0 is Not {
                interpretationFormulas["\($0.getFormulaDescription())"] = false
            }
        }
        
        return interpretationFormulas
    }
    
    func logicalConsequence(premise: [Formula], conclusion: Formula) -> Bool {
        var premise = premise
        var uniquePremise: Formula = premise.popLast()!
        premise.forEach { formula in
            uniquePremise = And(uniquePremise, formula)
        }
        let consequence = And(uniquePremise, Not(conclusion))
        if satisfabilityChecking(formula: consequence) is Bool {
            return true
        } else {
            return false
        }
    }
    
    func numberOfAtoms(formula: Formula) -> Int {
        if formula is Atom {
            return 1
        }
        else if formula is Not {
            guard let newFormula = formula as? Not else {
                return 0
            }
            return numberOfAtoms(formula: newFormula.inner)
        }
        else {
            guard let newFormula = formula as? Implies else {
                return 0
            }
            return numberOfAtoms(formula: newFormula.left) + numberOfAtoms(formula: newFormula.right)
        }
    }
    
    func getLogicaConsequenceForGrid(grid: [[Int]], formula: Formula) {
        for collun in 0...grid[0].count - 1 {
            for line in 0...grid.count - 1 {
                let cosequence = function.logicalConsequence(premise: [formula], conclusion: Atom("m\(line)_\(collun)"))
                print("m\(line)_\(collun) = \(cosequence)")
            }
        }
    }
    
}
