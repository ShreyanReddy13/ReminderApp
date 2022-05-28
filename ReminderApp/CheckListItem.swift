//
//  CheckListItem.swift
//  ReminderApp
//
//  Created by Prathima Juturu Chinna on 21/05/22.
//

import Foundation

class CheckListItem : NSObject, Codable{
    var text = ""
    
    
    var isChecked = false
    
    
    func toggleCheck() {
        isChecked = !isChecked
    }
}
