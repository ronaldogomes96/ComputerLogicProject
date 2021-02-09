//
//  main.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 18/12/20.
//

import Foundation


let m = [
    [-1, -1, -1, -1],
    [-1, -1, -1, -1],
    [-1,  3,  -1, -1],
    [-1,  -1,  -1, -1]]

// Array de (i, j)
func percorreMatriz(matriz: [[Int]], linha: Int, coluna: Int) -> Formula{
    // var vizinhos = [(Int,Int)]()
    var formulas = [Formula]()
    
    for i in 0..<linha {
        for j in 0..<coluna {
            if matriz[i][j] == 0 {
                let vizinhos = adicionarVizinhos(posicao: (i, j), linha: linha, Coluna: coluna)
                formulas.append(negarTodos(posicao: (i, j), vizinhos: vizinhos))
            }
            else if matriz[i][j] == 1 {
                let vizinhos = adicionarVizinhos(posicao: (i, j), linha: linha, Coluna: coluna)
                formulas.append(umMina(posicao: (i, j), vizinhos: vizinhos))
            }
            else if matriz[i][j] == 2 {
                let vizinhos = adicionarVizinhos(posicao: (i, j), linha: linha, Coluna: coluna)
                formulas.append(duasMina(posicao: (i, j), vizinhos: vizinhos))
            }
            else if matriz[i][j] == 3 {
                let vizinhos = adicionarVizinhos(posicao: (i, j), linha: linha, Coluna: coluna)
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
            if posicao.0 + i < 0 || posicao.0 + i > linha - 1 ||
                posicao.1 + j < 0 || posicao.1 + j > Coluna - 1 {
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
    let posicao1 = Not(atom: Atom(atom:"m\(posicao.0)_\(posicao.1)"))
    let combinacoes = gerarCombinacoeesUmaMina(vizinhos: vizinhos)
    let formulaFinal = And(left: posicao1, right: combinacoes)
    return formulaFinal
}

func duasMina(posicao: (Int, Int),  vizinhos: [(Int, Int)]) -> Formula {
    let posicao1 = Not(atom: Atom(atom:"m\(posicao.0)_\(posicao.1)"))
    let combinacoes = gerarCombinacoeesUmaMina(vizinhos: vizinhos)
    let formulaFinal = And(left: posicao1, right: combinacoes)
    return formulaFinal
}

func tresMina(posicao: (Int, Int),  vizinhos: [(Int, Int)]) -> Formula {
    let posicao1 = Not(atom: Atom(atom:"m\(posicao.0)_\(posicao.1)"))
    let combinacoes = gerarCombinacoesTresMinas(vizinhos: vizinhos)
    let formulaFinal = And(left: posicao1, right: combinacoes)
    return formulaFinal
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


func gerarCombinacoesDuasMinas(vizinhos: [(Int, Int)]) -> Formula {
    var posicao_pivo = 0
    var orInterno = [Formula]()
    
    for posicao_atual in (0..<vizinhos.count).reversed() {
        if posicao_pivo > posicao_atual {
            break
        }
        for j in 1..<vizinhos.count {
            
            if j != posicao_pivo {
                var formulaInterna = [Formula]()
                // GERAR PROPOSICOES
                for vizinho in vizinhos {
                    
                    if vizinhos[posicao_pivo] == vizinho || vizinhos[j] == vizinho {
                        formulaInterna.append(Not(atom: Atom(atom: "m\(vizinho.0)_\(vizinho.1)")))
                    } else {
                        formulaInterna.append(Atom(atom: "m\(vizinho.0)_\(vizinho.1)"))
                    }
                }
                
                orInterno.append(andAll(listOfFormulas: formulaInterna))
            }

        }
        
        posicao_pivo += 1
    }
    
    let resultado = orAll(listOfFormulas: orInterno)
    return resultado
}

func gerarCombinacoeesUmaMina(vizinhos: [(Int, Int)]) -> Formula {
    var orInterno = [Formula]()
    
    for _ in 0..<vizinhos.count {
        for j in 0..<vizinhos.count {
            
            var formulaInterna = [Formula]()
            // GERAR PROPOSICOES
            for vizinho in vizinhos {
                
                if vizinhos[j] == vizinho {
                    formulaInterna.append(Atom(atom: "m\(vizinho.0)_\(vizinho.1)"))
                } else {
                    formulaInterna.append(Not(atom: Atom(atom: "m\(vizinho.0)_\(vizinho.1)")))
                }
            }
            
            orInterno.append(andAll(listOfFormulas: formulaInterna))
            
        }
    }
    
    let resultado = orAll(listOfFormulas: orInterno)
    return resultado
}

func gerarCombinacoesTresMinas(vizinhos: [(Int, Int)]) -> Formula {
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
                    orInterno.append(andAll(listOfFormulas: combinacao))
                }
            }
        }
    }
    let resultado = orAll(listOfFormulas: orInterno)
    return resultado

}


