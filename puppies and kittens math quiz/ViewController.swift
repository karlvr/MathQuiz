//
//  ViewController.swift
//  puppies and kittens math quiz
//
//  Created by Karl von Randow on 7/05/16.
//  Copyright © 2016 XK72. All rights reserved.
//

import UIKit

class ViewController: BaseMathViewController {

    override func nextQuestion() {
        let a = Int(arc4random_uniform(11))
        let b = Int(arc4random_uniform(11))
        
        correctAnswer = a * b
        question.text = "What’s \(a) × \(b)?"
        answer.text = ""
        
        didNextQuestion()
    }
    
}

