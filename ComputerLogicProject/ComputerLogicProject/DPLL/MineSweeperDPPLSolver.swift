//
//  MineSweeperDPPLSolver.swift
//  ComputerLogicProject
//
//  Created by Vinicius Mesquita on 17/03/21.
//

import Foundation

protocol DPLL {
    func solve(_ clausalFormula: [[Formula]]) -> Any
    func dpllCheck(formula: [[Formula]] , valuation: [String]) -> Any
    
    /// Se tiver uma clausula unitaria (Atom ou Not), remove as clausulas que tem o literal e remove as clausulas quem contem a negação do literal nas outras clausulas
    /// - Parameters:
    ///   - formula:
    ///   - valuation: Array com os resultados de cada atomica para satisfazer a formula
    /// - Returns: Retorna uma tupla com a formula transformada e os resultados obtidos
    func unitPropagation(formula: [[Formula]] , valuation: [String]) -> (formula: [[Formula]], valuation: [String])
    
    // Essa função verifica se a formula possui algum literal de mesma descrição do literal passad
    // se sim ela remove a clausula
    func removeClauses(from formula: [[Formula]], with literal: Formula) -> [[Formula]]
    
    // Essa função verifica se a formula possui algum literal de mesma descrição do literal passad
    // se sim ela remove-o do array e retorna o array sem o literal.
    func removeComplement(from formula: [[Formula]], with literal: Formula) -> [[Formula]]
    
    // Essa função retorna uma atomica qualquer, que será considerada um valor verdadeiro,
    // Pode se usar essa função como forma de otimização dos eleemntos.
    func getAtomic(_ clausalFormula: [[Formula]]) -> Atom
    
    // Retorna um literal da formula principal.
    func getLiteralUnit(from formula: [[Formula]]) -> Formula?
}

class MineSweeperDPLL: DPLL {
    
    private let functions = Functions()
    private var atomicChosen = [Atom]()
    
    func solve(_ clausalFormula: [[Formula]]) -> Any {
        return dpllCheck(formula: clausalFormula, valuation: [])
    }
    
    internal func dpllCheck(formula: [[Formula]] , valuation: [String]) -> Any {
        let (S, valuation) = unitPropagation(formula: formula, valuation: [])
        if S.isEmpty {
            return valuation
        }
        if S.contains(where: { $0.isEmpty }) {
            return false
        }
        let atomic = getAtomic(S)
        let Sl = S.reduce([[atomic]]) { $0 + [$1] }
        let Sll = S.reduce([[Not(atomic)]]) { $0 + [$1] }
        
        let result = dpllCheck(formula: Sl, valuation: valuation)
        if (result as? Bool) != false {
            return result
        }
        return dpllCheck(formula: Sll, valuation: valuation)
    }
    
    internal func unitPropagation(formula: [[Formula]] , valuation: [String]) -> (formula: [[Formula]], valuation: [String]) {
        
        var newValuation = valuation
        var newFormula = formula
        
        var literalUnit = getLiteralUnit(from: newFormula)
        while literalUnit != nil {
            newValuation = newValuation.reduce(["\(literalUnit!.getFormulaDescription()) = true"]) { $0 + [$1] }
            newFormula = removeClauses(from: newFormula, with: literalUnit!)
            newFormula = removeComplement(from: newFormula, with: literalUnit!)
            literalUnit = getLiteralUnit(from: newFormula)
        }
        return (newFormula, newValuation)
    }
    
    internal func getLiteralUnit(from formula: [[Formula]]) -> Formula? {
        var unitClause: Formula?
        formula.forEach { $0.forEach { elem in
            if elem is Atom || elem is Not {
                unitClause = elem
            }
            if let elem = elem as? Or {
                unitClause = getLiteralUnit(from: [[elem.left]])
            }
        }}
        return unitClause
    }
    
    internal func removeClauses(from formula: [[Formula]], with literal: Formula) -> [[Formula]] {
        var newFormula = formula
        for (indexClause, clause) in newFormula.enumerated() {
            for  formulaLiteral in clause {
                if contains(literal: literal, in: formulaLiteral) {
                    if newFormula.count > indexClause {
                        newFormula.remove(at: indexClause)
                    }
                }
            }
        }
        return newFormula
    }
    
    
    internal func getAtomic(_ clausalFormula: [[Formula]]) -> Atom {
        let randomIndex = Int.random(in: 0..<clausalFormula.count)
        if !clausalFormula.isEmpty {
            let randomIndexAtomic = Int.random(in: 0..<clausalFormula[randomIndex].count)
            if let insideFormula = clausalFormula[randomIndex][randomIndexAtomic] as? Or {
                return getAtomic([[insideFormula.left]])
            }
            
            if let atomic = clausalFormula[randomIndex][randomIndexAtomic] as? Atom {
                atomicChosen.append(atomic)
                return atomic
            }
            fatalError("This is not a clausal formula")
        }
        fatalError("There's no atomic to chose")
    }
    
    internal func removeComplement(from formula: [[Formula]], with literal: Formula) -> [[Formula]] {
        var newFormula = formula
        let checkedLiteral = checkLiteralFormat(literal)
        
        for (indexClause, clause) in newFormula.enumerated() {
            for formulaLiteral in clause {
                
                if contains(literal: checkedLiteral, in: formulaLiteral) {
                    let result = removeElementFromFormula(formula: formulaLiteral, literal: literal)
                    newFormula.remove(at: indexClause)
                    newFormula.append(result)
                }
            }
        }
        
        return newFormula
    }
    
    /* Auxiliar functions */
    fileprivate func contains(literal: Formula, in formula: Formula) -> Bool {
        if let _ = formula as? Atom {
            if formula.getFormulaDescription().elementsEqual(literal.getFormulaDescription()) {
                return true
            } else {
                return false
            }
        }
        
        if let _ = formula as? Not {
            if formula.getFormulaDescription().elementsEqual(literal.getFormulaDescription()) {
                return true
            } else {
                return false
            }
        }
        
        if let formulaOr = formula as? Or {
            if contains(literal: literal, in: formulaOr.left) {
                return true
            }
            if contains(literal: literal, in: formulaOr.right) {
                return true
            }
            return false
        }
        
        return false
    }
    
    fileprivate func removeElementFromFormula(formula: Formula, literal: Formula) -> [Formula] {
        var arrayNames = functions.listOfAtoms(formula: formula)
        arrayNames = arrayNames.filter { !$0.elementsEqual(literal.getFormulaDescription()) }
        
        let atomArray = arrayNames.map { Atom($0) }
        return [functions.orAll(listOfFormulas: atomArray)]
    }
    
    fileprivate func checkLiteralFormat(_ literal: Formula) -> Formula {
        if let notLiteral = literal as? Not {
            return notLiteral.inner
        }
        
        if let atomLiteral = literal as? Atom {
            return Not(atomLiteral)
        }
        
        fatalError("Incossistent literal")
    }
    
}

struct MSDPLLTests {

    func removeClauseTest() {
        let solver = MineSweeperDPLL()
        let formulaClausal: [[Formula]] = [ [Or(Atom("c"), Or(Atom("d"), Atom("f")))] , [Atom("b")] ]
        var result = solver.removeClauses(from: formulaClausal, with: Atom("b"))
        result = solver.removeClauses(from: result, with:  Atom("d"))
        result.forEach { $0.forEach { print($0.getFormulaDescription()) }}
    }

    func dpllSolveTest() {
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
        let result2 = solver.removeComplement(from: formulaClausal, with: Not(Atom("f")))
        print(result2.map { $0.map { $0.getFormulaDescription()} })
    }
}

