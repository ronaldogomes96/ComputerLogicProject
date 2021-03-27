//
//  Grid.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 26/03/21.
//

import Foundation

class Grid {
    
    // Tem solução
    let gridOne = [
        [3, -1],
        [-1, -1]
    ]
    
    // Não tem solução
    let gridTwo = [
        [-1, 0],
        [1, -1]
    ]
    
    // Tem solução
    let gridTree = [
        [0, -1, 1],
        [-1, -1, -1],
        [1, -1, 2]
    ]
    
    // Não tem solução
    let gridFour = [
        [-1, 0, -1],
        [3, 0, -1],
        [-1, 0, -1]
    ]
    
    // Tem solução
    let gridFive = [
        [-1, -1, -1],
        [1,  3,  1],
        [-1, 0, -1]
    ]
    
    // Tem solução
    let gridSix = [
        [-1, 0, -1, 1],
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
        [-1, 2, -1, 1]
    ]
    
    // Não tem solução
    let gridSeven = [
        [0, -1, -1, 0],
        [3, -1, -1, -1],
        [-1, -1, -1, 1],
        [0 , 1, -1, 0]
    ]
    
    // Tem solução
    let gridEight = [
        [-1, 1,  0, -1],
        [1,  1,  0, -1],
        [0,  0,  0, -1],
        [-1, -1, -1, -1]
    ]
    
    // Não tem solução
    let gridNine = [
        [1, 0, -1, -1],
        [-1, -1, 3, -1],
        [1,  -1,  0, -1],
        [0,  1,  -1, -1]
    ]
    
    // Tem solução
    let gridTen = [
        [3,  -1,  2,  -1,  -1],
        [-1, -1,  -1,  -1, 0],
        [-1,  -1, -1, -1, -1],
        [-1, -1,  -1, -1, -1],
        [ -1,  0, -1,  2,  2]
    ]
    
    func listOfGrid() -> [[[Int]]] {
        return [gridOne, gridTwo, gridTree, gridFour, gridFive, gridSix, gridSeven, gridEight, gridNine, gridTen]
    }
}
