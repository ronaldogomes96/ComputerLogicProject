//
//  Implies.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 18/12/20.
//

import Foundation

class Implies: Formula {
    
    let left: Formula
    let right: Formula
    
    init(left: Formula, right: Formula) {
        self.left = left
        self.right = right
    }
    
    func getFormulaDescription() -> String {
        return "(\(left.getFormulaDescription()) -> \(right.getFormulaDescription()))"
    }
}
