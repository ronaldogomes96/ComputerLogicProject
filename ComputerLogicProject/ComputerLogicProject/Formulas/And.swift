//
//  And.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 18/12/20.
//

import Foundation

class And: Implies {
    
    override func getFormulaDescription() -> String {
        return "(\(left.getFormulaDescription()) ˆ \(right.getFormulaDescription()))"
    }
}
