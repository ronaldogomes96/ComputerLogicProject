//
//  MineSweeperSolver.swift
//  ComputerLogicProject
//
//  Created by Vinicius Mesquita on 11/03/21.
//

import Foundation

class MineSweeperSolver {
    
    private let functions = Functions()
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
        formulas.append(Not(atom: Atom(atom:"m\(position.0)_\(position.1)")))
        
        for neighbour in neighbours {
            formulas.append(Not(atom: Atom(atom: "m\(neighbour.0)_\(neighbour.1)")))
        }
        return functions.andAll(listOfFormulas: formulas)
    }
    
//    private func createMineComb(position: position: (Int, Int),  neighbours: [(Int, Int)], type: (Int) -> )

    private func oneMine(position: (Int, Int),  neighbours: [(Int, Int)]) -> Formula {
        let posicao1 = Not(atom: Atom(atom:"m\(position.0)_\(position.1)"))
        let combinations = gerarCombinacoeesUmaMina(vizinhos: neighbours)
        let formulaFinal = And(left: posicao1, right: combinations)
        return formulaFinal
    }

    private func twoMines(position: (Int, Int),  neighbours: [(Int, Int)]) -> Formula {
        let posicao1 = Not(atom: Atom(atom:"m\(position.0)_\(position.1)"))
        let combinacoes = gerarCombinacoesDuasMinas(vizinhos: neighbours)
        let formulaFinal = And(left: posicao1, right: combinacoes)
        return formulaFinal
    }

    private func threeMines(position: (Int, Int),  neighbours: [(Int, Int)]) -> Formula {
        let posicao1 = Not(atom: Atom(atom:"m\(position.0)_\(position.1)"))
        let combinacoes = gerarCombinacoesTresMinas(vizinhos: neighbours)
        let formulaFinal = And(left: posicao1, right: combinacoes)
        return formulaFinal
    }
    
    private func gerarCombinacoesDuasMinas(vizinhos: [(Int, Int)]) -> Formula {
        var orInterno = [Formula]()
        var formulaInterna = [Not]()
        // Criar todas as atomicas
        for vizinho in vizinhos {
            formulaInterna.append(Not(atom: Atom(atom: "m\(vizinho.0)_\(vizinho.1)")))
        }
        
        // Criar as atomicas.
        for i in 0..<vizinhos.count {
            for j in i..<vizinhos.count {
                if j != i {
                    var combinacao = formulaInterna.map { $0 as Formula }
                    combinacao[i] = formulaInterna[i].atom
                    combinacao[j] = formulaInterna[j].atom
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
            formulaInterna.append(Not(atom: Atom(atom: "m\(vizinho.0)_\(vizinho.1)")))
        }
        
        // Criar as atomicas.
        for i in 0..<vizinhos.count {
            var combinacao = formulaInterna.map { $0 as Formula }
            combinacao[i] = formulaInterna[i].atom
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
            formulaInterna.append(Not(atom: Atom(atom: "m\(vizinho.0)_\(vizinho.1)")))
        }
        
        // Criar as atomicas.
        for i in 0..<vizinhos.count {
            for j in i..<vizinhos.count {
                for k in j..<vizinhos.count {
                    if j != k && j != i {
                        var combinacao = formulaInterna.map { $0 as Formula }
                        combinacao[i] = formulaInterna[i].atom
                        combinacao[j] = formulaInterna[j].atom
                        combinacao[k] = formulaInterna[k].atom
                        orInterno.append(functions.andAll(listOfFormulas: combinacao))
                    }
                }
            }
        }
        
        let resultado = functions.orAll(listOfFormulas: orInterno)
        return resultado

    }
    

    
}
