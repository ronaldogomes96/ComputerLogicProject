//
//  MineSweeperSolver.swift
//  ComputerLogicProject
//
//  Created by Vinicius Mesquita on 11/03/21.
//

import Foundation

class MineSweeperSolver {
    
    private let functions = Functions()
    let dictLiterals = ["m0_0": 1, "m1_0": 11, "m2_0": 21, "m3_0": 31, "m4_0": 41,
                        "m0_1": 2, "m1_1": 12, "m2_1": 22, "m3_1": 32, "m4_1": 42,
                        "m0_2": 3, "m1_2": 13, "m2_2": 23, "m3_2": 33, "m4_2": 43,
                        "m0_3": 4, "m1_3": 14, "m2_3": 24, "m3_3": 34, "m4_3": 44,
                        "m0_4": 5, "m1_4": 15, "m2_4": 25, "m3_4": 35, "m4_4": 45,
                        "m0_5": 6, "m1_5": 16, "m2_5": 26, "m3_5": 36, "m4_5": 46,
                        "m0_6": 7, "m1_6": 17, "m2_6": 27, "m3_6": 37, "m4_6": 47,
                        "m0_7": 8, "m1_7": 18, "m2_7": 28, "m3_7": 38, "m4_7": 48,
                        "m0_8": 9, "m1_8": 19, "m2_8": 29, "m3_8": 39, "m4_8": 49,
                        "m0_9": 10, "m1_9": 20, "m2_9": 30, "m3_9": 40, "m4_9": 50]
    // Array de (i, j)
    public func mapMatrix(matrix: [[Int]]) -> Formula {
        
        let row = matrix.count
        let column = matrix[0].count
        var formulas = [Formula]()
        
        for i in 0..<row {
            for j in 0..<column {
                let position = (i, j)
                if matrix[i][j] == 0 {
                    let neighbours = addNeighbours(position: position, row: row, column: column)
                    formulas.append(notAll(position: (i, j), neighbours: neighbours))
                }
                else if matrix[i][j] == 1 {
                    let neighbours = addNeighbours(position: position, row: row, column: column)
                    formulas.append(oneMine(position: (i, j), neighbours: neighbours))
                }
                else if matrix[i][j] == 2 {
                    let neighbours = addNeighbours(position: position, row: row, column: column)
                    formulas.append(twoMines(position: (i, j), neighbours: neighbours))
                }
                else if matrix[i][j] == 3 {
                    let neighbours = addNeighbours(position: position, row: row, column: column)
                    formulas.append(threeMines(position: (i, j), neighbours: neighbours))
                }
            }
        }
        
        return functions.andAll(listOfFormulas: formulas)
    }


    private func addNeighbours(position: (Int,Int), row: Int, column: Int) -> [(Int,Int)] {
        var neigbours = [(Int,Int)]()
        for i in -1...1 {
            for j in -1...1 {
                if position.0 + i < 0 || position.0 + i > row - 1 ||
                    position.1 + j < 0 || position.1 + j > column - 1 {
                    continue
                }
                if !((position.0 + i, position.1 + j) == position) {
                    neigbours.append((position.0 + i, position.1 + j))
                }
            }
        }
        return neigbours
    }

    private func notAll(position: (Int, Int), neighbours: [(Int, Int)]) -> Formula {
        var formulas = [Formula]()
        formulas.append(Not(Atom("m\(position.0)_\(position.1)")))
        
        for neighbour in neighbours {
            formulas.append(Not(Atom("m\(neighbour.0)_\(neighbour.1)")))
        }
        return functions.andAll(listOfFormulas: formulas)
    }

    private func oneMine(position: (Int, Int),  neighbours: [(Int, Int)]) -> Formula {
        let posicao1 = Not(Atom("m\(position.0)_\(position.1)"))
        let combinations = gerarCombinacoeesUmaMina(vizinhos: neighbours)
        let formulaFinal = And(posicao1, combinations)
        return formulaFinal
    }

    private func twoMines(position: (Int, Int),  neighbours: [(Int, Int)]) -> Formula {
        let posicao1 = Not(Atom("m\(position.0)_\(position.1)"))
        let combinacoes = gerarCombinacoesDuasMinas(vizinhos: neighbours)
        let formulaFinal = And(posicao1, combinacoes)
        return formulaFinal
    }

    private func threeMines(position: (Int, Int),  neighbours: [(Int, Int)]) -> Formula {
        let posicao1 = Not(Atom("m\(position.0)_\(position.1)"))
        let combinacoes = gerarCombinacoesTresMinas(vizinhos: neighbours)
        let formulaFinal = And(posicao1, combinacoes)
        return formulaFinal
    }
    
    private func gerarCombinacoesDuasMinas(vizinhos: [(Int, Int)]) -> Formula {
        var orInterno = [Formula]()
        var formulaInterna = [Not]()
        // Criar todas as atomicas
        for vizinho in vizinhos {
            formulaInterna.append(Not(Atom("m\(vizinho.0)_\(vizinho.1)")))
        }
        
        // Criar as atomicas.
        for i in 0..<vizinhos.count {
            for j in i..<vizinhos.count {
                if j != i {
                    var combinacao = formulaInterna.map { $0 as Formula }
                    combinacao[i] = formulaInterna[i].inner
                    combinacao[j] = formulaInterna[j].inner
                    orInterno.append(functions.andAll(listOfFormulas: combinacao))
                }
            }
        }
        
        let resultado = functions.orAll(listOfFormulas: orInterno)
        return resultado
    }

    private func gerarCombinacoeesUmaMina(vizinhos: [(Int, Int)]) -> Formula {
        var orInterno = [Formula]()
        var formulaInterna = [Not]()
        // Criar todas as atomicas
        for vizinho in vizinhos {
            formulaInterna.append(Not(Atom("m\(vizinho.0)_\(vizinho.1)")))
        }
        
        // Criar as atomicas.
        for i in 0..<vizinhos.count {
            var combinacao = formulaInterna.map { $0 as Formula }
            combinacao[i] = formulaInterna[i].inner
            orInterno.append(functions.andAll(listOfFormulas: combinacao))
        }
        
        let resultado = functions.orAll(listOfFormulas: orInterno)
        return resultado
    }

    private func gerarCombinacoesTresMinas(vizinhos: [(Int, Int)]) -> Formula {
        var orInterno = [Formula]()
        var formulaInterna = [Not]()
        // Criar todas as atomicas
        for vizinho in vizinhos {
            formulaInterna.append(Not(Atom("m\(vizinho.0)_\(vizinho.1)")))
        }
        
        // Criar as atomicas.
        for i in 0..<vizinhos.count {
            for j in i..<vizinhos.count {
                for k in j..<vizinhos.count {
                    if j != k && j != i {
                        var combinacao = formulaInterna.map { $0 as Formula }
                        combinacao[i] = formulaInterna[i].inner
                        combinacao[j] = formulaInterna[j].inner
                        combinacao[k] = formulaInterna[k].inner
                        orInterno.append(functions.andAll(listOfFormulas: combinacao))
                    }
                }
            }
        }
        
        let resultado = functions.orAll(listOfFormulas: orInterno)
        return resultado

    }
    
}

extension MineSweeperSolver {
    
    func convertToCNF(_ formula: Formula) -> Formula {
        var result = implicationFree(formula)
        result = negationNormalForm(formula)
        result = distributive(result)
        return result
    }
    
    func implicationFree(_ formula: Formula) -> Formula {
        return formula
    }
    
    func negationNormalForm(_ formula: Formula) -> Formula {
        return formula
    }
    
    func distributive(_ formula: Formula) -> Formula {
        if formula is Atom || formula is Not {
            return formula
        }
        
        if let formula = formula as? And {
            return And(distributive(formula.left), distributive(formula.right))
        }
        
        if let formula = formula as? Or {
            let left = distributive(formula.left)
            let right = distributive(formula.right)
            
            if let andLeft = left as? And {
                return And(distributive(Or(andLeft.left, right)), distributive(Or(andLeft.right, right)))
            }
            
            if let andRight = right as? And {
                return And(distributive(Or(left, andRight.left)), distributive(Or(left, andRight.right)))
            }
            return Or(left, right)
        }
        return formula
    }
    
    func convertToIntegerCNF(_ formula: Formula) -> [[Int]] {
        let convertedCNF = self.convertToCNF(formula)
        return getArrayLiteralsFromOrFormula(convertedCNF)
    }
    
    func getArrayLiteralsFromOrFormula(_ formula: Formula) -> [[Int]] {
        if formula is Atom {
            return [[Int(dictLiterals[formula.getFormulaDescription()]!)]]
        }
        
        if let formulaNot = formula as? Not {
            return [[Int(dictLiterals[(formulaNot.inner.getFormulaDescription())]!) * -1]]
        }
        
        if let formula = formula as? And {
            return getArrayLiteralsFromOrFormula(formula.left) + getArrayLiteralsFromOrFormula(formula.right)
        }
        
        if let formula = formula as? Or {
            let allLiterals = functions.listOfLiterals(formula: formula)
            let transformToInt = allLiterals.map { literal -> Int in
                if literal.contains("-") {
                    var newLiteral = literal
                    newLiteral.removeFirst()
                    return (Int(dictLiterals[newLiteral]!) * -1)
                } else {
                    return (Int(dictLiterals[literal]!))
                }
            }
            return [transformToInt]
        }
        return [[]]
    }
    
}
