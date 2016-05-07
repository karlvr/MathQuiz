//
//  ViewController.swift
//  puppies and kittens math quiz
//
//  Created by Karl von Randow on 7/05/16.
//  Copyright © 2016 XK72. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answer: UITextField!
    @IBOutlet weak var right: UILabel!
    @IBOutlet weak var wrong: UILabel!
    @IBOutlet weak var close: UILabel!
    @IBOutlet weak var score: UILabel!
    
    var correctAnswer: Int!
    var currentScore: Int = 0
    
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
        let a = Int(arc4random_uniform(11))
        let b = Int(arc4random_uniform(11))
        
        correctAnswer = a * b
        question.text = "What’s \(a) × \(b)?"
        answer.text = ""
    }

    @IBAction func checkAnswer(sender: AnyObject) {
        if let answerText = answer.text, let answerNumber = Int(answerText) {
            if answerNumber == correctAnswer {
                right.hidden = false
                performSelector(#selector(hideRight), withObject: nil, afterDelay: 2)
                
                currentScore = currentScore + 1
                updateScore()
            } else if answerIsClose(answerNumber) {
                close.hidden = false
                performSelector(#selector(hideClose), withObject: nil, afterDelay: 2)
            } else {
                wrong.hidden = false
                performSelector(#selector(hideWrong), withObject: nil, afterDelay: 15)
            }
        }
    }
    
    func hideRight() {
        right.hidden = true
        
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

}

