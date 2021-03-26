//
//  Grid.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 26/03/21.
//

import Foundation

class Grid {
    
    let gridOne = [
        [2, -1],
        [-1, 1]
    ]
    
    let gridTwo = [
        [-1, 0],
        [1, -1]
    ]
    
    let gridTree = [
        [0, -1, -1],
        [1, -1, 0],
        [0, -1, 2]
    ]
    
    let gridFour = [
        [-1, 0, 0],
        [-1, 0, 2],
        [-1, 0, 1]
    ]
    
    let gridFive = [
        [-1, -1, -1],
        [-1, 3, 1],
        [-1, -1, 0]
    ]
    
    let gridSix = [
        [-1, 0, -1, 1],
        [-1, -1, -1, -1],
        [-1, -1, -1, -1],
        [-1, -1, -1, 1]
    ]
    
    let gridSeven = [
        [0, -1, -1, -1],
        [3, 2, -1, -1],
        [-1, -1, -1, 1],
        [-1 , 1, -1, 0]
    ]
    
    let gridEight = [
        [-1, 1,  0, -1],
        [1,  1,  0, -1],
        [0,  0,  0, -1],
        [-1, -1, -1, -1]
    ]
    
    let gridNine = [
        [-1, -1, -1, -1],
        [-1, -1, 3, -1],
        [1,  1,  0, -1],
        [-1,  1,  0, -1]
    ]
    
    let gridTen = [
        [-1, 1, 0, -1, -1],
        [-1, 2, -1, -1, 1],
        [-1, -1, 1, -1, 3],
        [2, -1, -1, -1, -1],
        [0, -1, -1, 1, 1]
    ]
    
    func listOfGrid() -> [[[Int]]] {
        return [gridOne, gridTwo, gridTree, gridFour, gridFive, gridSix, gridSeven, gridEight, gridNine, gridTen]
    }
}
