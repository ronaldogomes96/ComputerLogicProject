//
//  Or.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 18/12/20.
//

import Foundation

class Or: Implies {
    
    override func getFormulaDescription() -> String {
        return "(\(left.getFormulaDescription()) v \(right.getFormulaDescription()))"
    }
}
