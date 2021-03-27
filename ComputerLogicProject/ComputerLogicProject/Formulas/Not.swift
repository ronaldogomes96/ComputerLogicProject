//
//  Not.swift
//  ComputerLogicProject
//
//  Created by Ronaldo Gomes on 18/12/20.
//

import Foundation

class Not: Formula {
    
    let inner: Formula
    
    init(_ inner: Formula) {
        self.inner = inner
    }
    
    func getFormulaDescription() -> String {
        return "-\(inner.getFormulaDescription())"
    }
    
}
