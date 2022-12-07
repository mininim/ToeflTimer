//
//  Timer.swift
//  ToeflTimer
//
//  Created by 이민섭 on 2022/11/30.
//

import Foundation


class Tasks {
    
    static let shared = Tasks()
    
    var taskTime: Array<Array<Int>> = [ [15, 45] , [30,60] , [30,60], [20,60] ]
    
    func getPrepareProgress(task :Int  , prepareOrSpeak : Int ,timeleft : Int ) -> Float {
        
        return (1 -  Float(timeleft)/Float(taskTime[task][prepareOrSpeak]))
        
    }
    
    
    
}



