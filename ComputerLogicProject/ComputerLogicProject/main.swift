//  main.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 18/12/20.
//

import Foundation

// Criar um array com os vizinhos

let m = [
    [-1, -1, -1, -1],
    [-1 ,-1, -1, -1],
    [-1, 1, 1, 1],
    [-1, 1, 0, 0]]

// Array de (i, j)
func percorreMatriz(matriz: [[Int]], linha: Int, coluna: Int) -> Formula{
    var vizinhos = [(Int,Int)]()
    var formulas = [Formula]()
    
    for i in 0..<linha {
        for j in 0..<coluna {
            if matriz[i][j] == 0 {
                vizinhos = adicionarVizinhos(posicao: (i, j), linha: linha, Coluna: coluna)
                formulas.append(negarTodos(posicao: (i, j), vizinhos: vizinhos))
            }
            else if matriz[i][j] == 1 {
                vizinhos = adicionarVizinhos(posicao: (i, j), linha: linha, Coluna: coluna)
                formulas.append(umMina(posicao: (i, j), vizinhos: vizinhos))
            }
            else if matriz[i][j] == 2 {
                vizinhos = adicionarVizinhos(posicao: (i, j), linha: linha, Coluna: coluna)
                formulas.append(duasMina(posicao: (i, j), vizinhos: vizinhos))
            }
            else if matriz[i][j] == 3 {
                vizinhos = adicionarVizinhos(posicao: (i, j), linha: linha, Coluna: coluna)
                formulas.append(tresMina(posicao: (i, j), vizinhos: vizinhos))
            }
        }
    }
    
    return andAll(listOfFormulas: formulas)
}


func adicionarVizinhos(posicao: (Int,Int), linha: Int, Coluna: Int) -> [(Int,Int)] {
    var vizinhos = [(Int,Int)]()
    for i in -1...1 {
        for j in -1...1 {
            if posicao.0 + i < 0 || posicao.0 + i > linha - 1 || posicao.1 + j < 0 || posicao.1 + j > Coluna - 1 {
                continue
            }
            if !((posicao.0 + i, posicao.1 + j) == posicao) {
                vizinhos.append((posicao.0 + i, posicao.1 + j))
            }
        }
    }
    return vizinhos
}


// Restricao para m(i,j) = 0
func negarTodos(posicao: (Int, Int), vizinhos: [(Int, Int)]) -> Formula {
    var formulas = [Formula]()
    formulas.append(Not(atom: Atom(atom:"m\(posicao.0)_\(posicao.1)")))
    
    for vizinho in vizinhos {
        formulas.append(Not(atom: Atom(atom: "m\(vizinho.0)_\(vizinho.1)")))
    }
    return andAll(listOfFormulas: formulas)
}

func umMina(posicao: (Int, Int),  vizinhos: [(Int, Int)]) -> Formula {

    var formulas = [Formula]()
    var OrInterno = [Formula]()
    formulas.append(Not(atom: Atom(atom:"m\(posicao.0)_\(posicao.1)")))

    for i in 0..<vizinhos.count {
        var formulaInterna = [Formula]()
        formulaInterna.append(Atom(atom: "m\(vizinhos[i].0)_\(vizinhos[i].1)"))
        
        var listaDeIndices = [Int]()
        for x in 0..<vizinhos.count {
            listaDeIndices.append(x)
        }
        listaDeIndices.remove(at: i)

        for j in listaDeIndices {
            formulaInterna.append(Not(atom: Atom(atom: "m\(vizinhos[j].0)_\(vizinhos[j].1)")))
        }
        OrInterno.append(andAll(listOfFormulas: formulaInterna))
    }
    
    formulas.append(orAll(listOfFormulas: OrInterno))
    
    return andAll(listOfFormulas: formulas)
}

func duasMina(posicao: (Int, Int),  vizinhos: [(Int, Int)]) -> Formula {
    
    var formulas = [Formula]()
    var OrInterno = [Formula]()
    formulas.append(Not(atom: Atom(atom:"m\(posicao.0)_\(posicao.1)")))
    
    for i in 0..<vizinhos.count {
        var formulaInterna = [Formula]()

        for y in i+1..<vizinhos.count {
            formulaInterna.append(Atom(atom: "m\(vizinhos[i].0)_\(vizinhos[i].1)"))
            formulaInterna.append(Atom(atom: "m\(vizinhos[y].0)_\(vizinhos[y].1)"))
            
            var listaDeIndices = [Int]()
            for x in 0..<vizinhos.count {
                listaDeIndices.append(x)
            }
            listaDeIndices.remove(at: i)
            listaDeIndices.remove(at: y-1)

            for j in listaDeIndices {
                formulaInterna.append(Not(atom: Atom(atom: "m\(vizinhos[j].0)_\(vizinhos[j].1)")))
            }
        }
        OrInterno.append(andAll(listOfFormulas: formulaInterna))
    }
    
    formulas.append(orAll(listOfFormulas: OrInterno))
    
    return andAll(listOfFormulas: formulas)
}

func tresMina(posicao: (Int, Int),  vizinhos: [(Int, Int)]) -> Formula {
    
    var formulas = [Formula]()
    var OrInterno = [Formula]()
    formulas.append(Not(atom: Atom(atom:"m\(posicao.0)_\(posicao.1)")))
    
    for i in 0...vizinhos.count {
        var formulaInterna = [Formula]()

        for y in i+1...vizinhos.count {
            
            for k in y+1...vizinhos.count {
                
                formulaInterna.append(Atom(atom: "m\(vizinhos[i].0)_\(vizinhos[i].1)"))
                formulaInterna.append(Atom(atom: "m\(vizinhos[y].0)_\(vizinhos[y].1)"))
                formulaInterna.append(Atom(atom: "m\(vizinhos[k].0)_\(vizinhos[k].1)"))
                
                var listaDeIndices = [Int]()
                for x in 0...vizinhos.count {
                    listaDeIndices.append(x)
                }
                
                listaDeIndices.remove(at: i)
                listaDeIndices.remove(at: y)
                listaDeIndices.remove(at: k)

                for j in listaDeIndices {
                    formulaInterna.append(Not(atom: Atom(atom: "m\(vizinhos[j].0)_\(vizinhos[j].1)")))
                }
            }
           
        }
        
        OrInterno.append(andAll(listOfFormulas: formulaInterna))
    }
    
    formulas.append(orAll(listOfFormulas: OrInterno))
    
    return andAll(listOfFormulas: formulas)
}


func andAll(listOfFormulas: [Formula]) -> Formula {
    var firstFormula = listOfFormulas[0]
    var newListOfFormulas = listOfFormulas
    newListOfFormulas.remove(at: 0)
    newListOfFormulas.forEach { (formula) in
        firstFormula = And(left: firstFormula, right: formula)
    }
    return firstFormula
}

func orAll(listOfFormulas: [Formula]) -> Formula {
    var firstFormula = listOfFormulas[0]
    var newListOfFormulas = listOfFormulas
    newListOfFormulas.remove(at: 0)
    newListOfFormulas.forEach { (formula) in
        firstFormula = Or(left: firstFormula, right: formula)
    }
    return firstFormula
}


let formula = percorreMatriz(matriz: m, linha: 4, coluna: 4)
let function = Functions()

print(formula.getFormulaDescription())
print(function.satisfabilityChecking(formula: formula))
