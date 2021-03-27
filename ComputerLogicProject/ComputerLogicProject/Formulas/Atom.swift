//
//  Atom.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 18/12/20.
//

import Foundation

class Atom: Formula {
    
    let atom: String
    
    init(_ atom: String) {
        self.atom = atom
    }
    
    func getFormulaDescription() -> String {
        return "\(atom)"
    }
}

