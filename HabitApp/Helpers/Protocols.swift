//
//  Protocols.swift
//  HabitApp
//
//  Created by Avinash kumar on 28/08/25.
//

import Foundation

protocol DataPass {
    
    func refreshPage()
}

protocol CellCheckMarkDelegate {
    
    func OnClickCheckMArk(index: Int)
}
