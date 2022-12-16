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
    
    var datekey : String = "2001-05-16"
    
    var task1Question : String = "Try today's Task1 Question"
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter
    }()
    
        
    func getTodaysTask1Question() -> String{
        
        setTodayDatekey()
        
        
        db.child(datekey).observeSingleEvent(of: .value) { snapshot in
            print("-->\(snapshot)")
            
            self.task1Question = snapshot.value as? String ?? ""
             
        }
        
        return self.task1Question
        
        
    }
    
    func setTodayDatekey(){
        
        datekey = dateFormatter.string(from: Date())
        
    }
    
    
}
