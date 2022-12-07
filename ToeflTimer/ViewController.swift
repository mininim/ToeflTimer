//
//  ViewController.swift
//  ToeflTimer
//
//  Created by 이민섭 on 2022/11/29.
//

import UIKit

class ToeflTimerController: UIViewController {

    // MARK: - Properties
    var timer: Timer?
    
    var currentTask : Int = 0
    
    var prepareDelaySecondsLeft: Int = 0
    var prepareSecondsLeft: Int = 0
    var speakingDelaySecondsLeft: Int = 0
    var speakingSecondsLeft: Int = 0
    
    // MARK: - UI Components
    
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskInfoLabel: UILabel!
    
    @IBOutlet weak var timerAnnouncementLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerSlider: UIProgressView!
    
    @IBOutlet weak var taskSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var timerControlButton: UIButton!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addTargets()
        self.setInitialUi()
    }
    
    func addTargets(){
        
        taskSegmentControl.addTarget(self, action: #selector(taskChange), for: .valueChanged)
        
        timerControlButton.addTarget(self, action: #selector(timerControlButtonTapped), for: .touchUpInside)
        

    }
    
    func setInitialUi(){
        
        self.setSecondProperties()
        
        self.setTaskInfoLabels()
        
        self.setTimer()
            
        self.setStackView()
        
        self.setTaskSegment()
        
        self.setPlayImage()
        
        
                
    }
    
    func setSecondProperties(){
        
        self.prepareDelaySecondsLeft  = 2
        self.prepareSecondsLeft = Tasks.shared.taskTime[currentTask][0]
        self.speakingDelaySecondsLeft = 2
        self.speakingSecondsLeft = Tasks.shared.taskTime[currentTask][1]

    }
    
    func setTaskInfoLabels(){
        self.taskLabel.text = "Task \(self.currentTask + 1)"
        self.taskInfoLabel.text = "Prepare \(self.prepareSecondsLeft)s | Speak \(self.speakingSecondsLeft)s"
    }
    
    func setTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    
    func freezeTaskSegment(){
        
        self.taskSegmentControl.setEnabled(false, forSegmentAt: 0)
        self.taskSegmentControl.setEnabled(false, forSegmentAt: 1)
        self.taskSegmentControl.setEnabled(false, forSegmentAt: 2)
        self.taskSegmentControl.setEnabled(false, forSegmentAt: 3)
        
    }
        
    func setTaskSegment(){
        
        self.taskSegmentControl.setEnabled(true, forSegmentAt: 0)
        self.taskSegmentControl.setEnabled(true, forSegmentAt: 1)
        self.taskSegmentControl.setEnabled(true, forSegmentAt: 2)
        self.taskSegmentControl.setEnabled(true, forSegmentAt: 3)
        
        self.taskSegmentControl.selectedSegmentIndex = currentTask
    }
    
    func setStackView(){
        //Announcement & Time & Progressbar
        self.timerAnnouncementLabel.text = "Task \(currentTask + 1) - \(prepareSecondsLeft)s/\(speakingSecondsLeft)s"
        self.timerLabel.text = "00:00"
        self.timerSlider.progress = 0
    }
    
    func setPlayImage(){
        let configuration = UIImage.SymbolConfiguration(pointSize: 80)
        let image = UIImage(systemName: "play.circle.fill", withConfiguration: configuration)
        self.timerControlButton.setImage(image, for: .normal)
    }
    
    func setResetImage(){
        let configuration = UIImage.SymbolConfiguration(pointSize: 80)
        let image = UIImage(systemName: "stop.circle.fill", withConfiguration: configuration)
        timerControlButton.setImage(image, for: .normal)
    }
    
    
}


// MARK: - Methods

extension ToeflTimerController{
    
    @objc func taskChange(){
        
        switch self.taskSegmentControl.selectedSegmentIndex{
        case 0:
            self.currentTask = 0
            self.setInitialUi()
        case 1:self.currentTask = 0
            self.setInitialUi()
            self.currentTask = 1
            self.setInitialUi()
        case 2:
            self.currentTask = 2
            self.setInitialUi()
        case 3:
            self.currentTask = 3
            self.setInitialUi()
        default:
            return
        }
        
        
    }
    
    @objc func timerControlButtonTapped() {

        if timer == nil{//case1- reset
            
            //Timer Start!
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerRun), userInfo: nil, repeats: true)
            
            
            //UI 관리
            self.setResetImage()
            
            self.freezeTaskSegment()
            
            
        }else{//case2- play
            
            //ui 변경
            self.setPlayImage()
            
            self.setInitialUi()
            
            
        }
    }
    
    @objc func timerRun(){
        
        if prepareDelaySecondsLeft > 0 {
            
            prepareDelaySecondsLeft -= 1
            
            self.timerAnnouncementLabel.text = "Please prepare your answer after the Beep"
            self.timerLabel.text = "00:00"
            
        }else if prepareDelaySecondsLeft == 0{
            
            prepareDelaySecondsLeft -= 1
            
            self.timerAnnouncementLabel.text = "Beep"
            self.timerLabel.text = String(format: "00:%02d", prepareSecondsLeft)
            
        }else if prepareSecondsLeft > 0 {
            
            prepareSecondsLeft -= 1
            
            self.timerAnnouncementLabel.text = "Prepare your response"
            self.timerLabel.text = String(format: "00:%02d", prepareSecondsLeft)
            
            self.timerSlider.setProgress(Tasks.shared.getPrepareProgress(task: 0, prepareOrSpeak: 0, timeleft: prepareSecondsLeft), animated: true)
            
        }else if speakingDelaySecondsLeft > 0{
            
            speakingDelaySecondsLeft -= 1
            
            self.timerAnnouncementLabel.text = "Please begin speacking after the Beep"
            self.timerLabel.text = String("00:00")
            
            self.timerSlider.setProgress(0, animated: false)
            
        }else if speakingDelaySecondsLeft == 0{
            
            speakingDelaySecondsLeft -= 1
            
            self.timerAnnouncementLabel.text = "Beep"
            self.timerLabel.text = String(format: "00:%02d", speakingSecondsLeft)
            
        }else if speakingSecondsLeft > 0{
            
            speakingSecondsLeft -= 1
            
            self.timerAnnouncementLabel.text = "Recording"
            self.timerLabel.text = String(format: "00:%02d", speakingSecondsLeft)
            
            self.timerSlider.setProgress(Tasks.shared.getPrepareProgress(task: 0, prepareOrSpeak: 1, timeleft: speakingSecondsLeft), animated: true)
            
        }else{
            self.setInitialUi()
        }
        
        
    }
    
    
}
