//
//  Not.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 18/12/20.
//

import Foundation

class Not: Formula {
    
    let atom: Formula
    
    init(atom: Formula) {
        self.atom = atom
    }
    
    func getFormulaDescription() -> String {
        return "-\(atom.getFormulaDescription())"
    }
    
}
