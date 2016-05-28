//
//  BaseMathViewController.swift
//  puppies and kittens math quiz
//
//  Created by Karl von Randow on 28/05/16.
//  Copyright © 2016 XK72. All rights reserved.
//

import UIKit

class BaseMathViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answer: UITextField!
    @IBOutlet weak var right: UILabel!
    @IBOutlet weak var wrong: UILabel!
    @IBOutlet weak var close: UILabel!
    @IBOutlet weak var score: UILabel!
    
    var correctAnswer: Int!
    var currentScore: Int = 0
    var waitingForNextQuestion: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answer.text = ""
        nextQuestion()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        answer.becomeFirstResponder()
    }
    
    func nextQuestion() {
        fatalError()
    }
    
    @IBAction func checkAnswer(sender: AnyObject) {
        if let answerText = answer.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()), let answerNumber = Int(answerText) where !waitingForNextQuestion {
            if answerNumber == correctAnswer {
                right.hidden = false
                close.hidden = true
                wrong.hidden = true
                performSelector(#selector(hideRight), withObject: nil, afterDelay: 2)
                
                currentScore = currentScore + 1
                updateScore()
                waitingForNextQuestion = true
                
                answer.resignFirstResponder()
            } else if answerIsClose(answerNumber) {
                close.hidden = false
                right.hidden = true
                wrong.hidden = true
                
                performSelector(#selector(hideClose), withObject: nil, afterDelay: 2)
            } else {
                wrong.hidden = false
                close.hidden = true
                right.hidden = true
                
                performSelector(#selector(hideWrong), withObject: nil, afterDelay: 15)
            }
        } else {
            answer.text = ""
        }
    }
    
    func hideRight() {
        right.hidden = true
        waitingForNextQuestion = false
        
        nextQuestion()
    }
    
    func hideWrong() {
        wrong.hidden = true
    }
    
    func hideClose() {
        close.hidden = true
    }
    
    func answerIsClose(answerNumber: Int) -> Bool {
        return abs(correctAnswer - answerNumber) <= 2
    }
    
    func updateScore() {
        score.text = "Score: \(currentScore)"
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string.endIndex == string.startIndex {
            return true
        }
        
        guard let _ = Int(string) else {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        checkAnswer(textField)
        return true
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
