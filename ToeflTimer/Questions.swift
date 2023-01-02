//
//  Questions.swift
//  ToeflTimer
//
//  Created by 이민섭 on 2022/12/15.
//

import Foundation
import Firebase


class Questions {
    
    
    static let shared = Questions()
    
    let db = Database.database().reference()
    
    var datekey : String = "05-16"
    
    var task1Question : String = "Click to try today's Task1 or Swipe to delete"
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        
        return dateFormatter
    }()
    
        
    func getTodaysTask1Question() -> String{
        
        setTodayDatekey()
        
        
        db.child(datekey).observeSingleEvent(of: .value) { snapshot in
            
            self.task1Question = snapshot.value as? String ?? "Check your network connection and try again"
             
        }
        
        return self.task1Question
        
        
    }
    
    func setTodayDatekey(){
        
        datekey = dateFormatter.string(from: Date())
        
    }
    
    
}
