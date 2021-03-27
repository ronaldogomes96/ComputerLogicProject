//
//  Tableaux.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 26/03/21.
//

import Foundation

class Tableaux {
    
    func logicalConsequence(premise: [Formula], conclusion: Formula) -> Bool {
        var premise = premise
        var uniquePremise: Formula = premise.popLast()!
        premise.forEach { formula in
            uniquePremise = And(uniquePremise, formula)
        }
        let consequence = And(uniquePremise, Not(conclusion))
        if tableaux(formulas: [consequence], isCheck: [false]) == false {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - TABLEAUX: Verifica se um conjunto de formulas é satisfativel ou nao
    func tableaux(formulas: [Formula], isCheck: [Bool]) -> Bool {
        var formulas = formulas
        var isCheck = isCheck
        
        for (index, value) in formulas.enumerated() {
            
            //Verifica se a formula ainda nao foi verificada
            if !isCheck[index] {
                //Marca como verificada
                isCheck[index] = true

                // Atom
                if value is Atom {
                    //Caso não tenha uma contradição
                    if !isContradiction(results: formulas) {
                        //Caso nao tenha mais elementos para analisar, ou seja é o ultimo da arvore
                        if !isCheck.contains(false) {
                            return true
                        }
                        //Caso ainda tenha elementos para analisar
                        else {
                            return tableaux(formulas: formulas, isCheck: isCheck)
                        }
                    }
                    //Caso tenha uma contradição
                    return false
                }
                
                // And
                else if let value = value as? And {
                    formulas.append(value.left)
                    isCheck.append(false)
                    //Caso o primeiro elemento ja tenha uma contradicao
                    if isContradiction(results: formulas) {
                        return false
                    }
                    
                    formulas.append(value.right)
                    isCheck.append(false)
                    //Caso o segundo elementos tenha uma contradicao
                    if isContradiction(results: formulas) {
                        return false
                    }

                    return tableaux(formulas: formulas, isCheck: isCheck)
                }
                
                //Not
                else if let value = value as? Not {
                    //Valor interno é um Atom
                    if value.inner is Atom {
                        //Caso não tenha uma contradição
                        if !isContradiction(results: formulas) {
                            //Caso nao tenha mais elementos para analisar, ou seja é o ultimo da arvore
                            if !isCheck.contains(false) {
                                return true
                            }
                            //Caso ainda tenha elementos para analisar
                            else {
                                return tableaux(formulas: formulas, isCheck: isCheck)
                            }
                        }
                        
                        //Caso tenha uma contradição
                        return false
                    }
                    
                    //Valor interno é um Not
                    else if let valueAsNot = value.inner as? Not {
                        formulas[index] = valueAsNot.inner
                        isCheck[index] = false
                        return tableaux(formulas: formulas, isCheck: isCheck)
                    }
                    
                    //Valor interno é OR
                    else if let valueAsOr = value.inner as? Or {
                        formulas.append(Not(valueAsOr.left))
                        isCheck.append(false)
                        //Caso o primeiro elemento ja tenha uma contradicao
                        if isContradiction(results: formulas) {
                            return false
                        }
                        
                        formulas.append(Not(valueAsOr.right))
                        isCheck.append(false)
                        //Caso o segundo elementos tenha uma contradicao
                        if isContradiction(results: formulas) {
                            return false
                        }
                        
                        return tableaux(formulas: formulas, isCheck: isCheck)
                    }
                    
                    //Valor interno é IMPLIES
                    else if let valueAsImplies = value.inner as? Implies {
                        formulas.append(valueAsImplies.left)
                        isCheck.append(false)
                        //Caso o primeiro elemento ja tenha uma contradicao
                        if isContradiction(results: formulas) {
                            return false
                        }
                        
                        formulas.append(Not(valueAsImplies.right))
                        isCheck.append(false)
                        //Caso o segundo elementos tenha uma contradicao
                        if isContradiction(results: formulas) {
                            return false
                        }
                        
                        return tableaux(formulas: formulas, isCheck: isCheck)
                    }
                    
                    //Valor interno é AND
                    else if let valueAsAnd = value.inner as? And {
                        formulas.append(Not(valueAsAnd.left))
                        isCheck.append(false)
                        //Caso esse ramo seja satisfativel
                        if tableaux(formulas: formulas, isCheck: isCheck) {
                            return true
                        }
                        //Caso nao seja, remove o elemento e vai para o outro ramo
                        formulas.removeLast()
                        formulas.append(Not(valueAsAnd.right))
                        return tableaux(formulas: formulas, isCheck: isCheck)
                    }
                }
                
                //OR
                else if let value = value as? Or {
                    formulas.append(value.left)
                    isCheck.append(false)
                    //Caso esse ramo seja satisfativel
                    if tableaux(formulas: formulas, isCheck: isCheck) {
                        return true
                    }
                    //Caso nao seja, remove o elemento e vai para o outro ramo
                    formulas.removeLast()
                    formulas.append(value.right)
                    return tableaux(formulas: formulas, isCheck: isCheck)
                }
                
                //IMPLIES
                else {
                    guard let value = value as? Implies else {
                        fatalError()
                    }
                                        
                    formulas.append(Not(value.left))
                    isCheck.append(false)
                    //Caso esse ramo seja satisfativel
                    if tableaux(formulas: formulas, isCheck: isCheck) {
                        return true
                    }
                    //Caso nao seja, remove o elemento e vai para o outro ramo
                    formulas.removeLast()
                    formulas.append(value.right)
                    return tableaux(formulas: formulas, isCheck: isCheck)
                }
            }
        }
        
        return false
    }
    
    private func isContradiction(results: [Formula]) -> Bool {
        var formula = results
        let formulaForComparation = formula.popLast()!
        for formula in formula {
            if let formulaForComparation = formulaForComparation as? Not {
                if formula.getFormulaDescription() == formulaForComparation.inner.getFormulaDescription() {
                    return true
                }
            }
            if let formula = formula as? Not {
                if formula.inner.getFormulaDescription() == formulaForComparation.getFormulaDescription() {
                    return true
                }
            }
        }
        
        return false
    }
    
    func getLogicaConsequenceForGrid(grid: [[Int]], formula: Formula) {
        for collun in 0...grid[0].count - 1 {
            for line in 0...grid.count - 1 {
                let cosequence = self.logicalConsequence(premise: [formula], conclusion: Atom("m\(line)_\(collun)"))
                print("m\(line)_\(collun) = \(cosequence)")
            }
        }
    }
}
