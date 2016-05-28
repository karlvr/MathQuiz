//
//  AdditionViewController.swift
//  puppies and kittens math quiz
//
//  Created by Karl von Randow on 7/05/16.
//  Copyright © 2016 XK72. All rights reserved.
//

import UIKit

class AdditionViewController: BaseMathViewController {

    override func nextQuestion() {
        let a: Int
        let b: Int
        if arc4random_uniform(2) == 0 {
            a = Int(arc4random_uniform(91))
            b = Int(arc4random_uniform(11))
        } else {
            b = Int(arc4random_uniform(91))
            a = Int(arc4random_uniform(11))
        }
        
        correctAnswer = a + b
        question.text = "What’s \(a) + \(b)?"
        answer.text = ""
        
        answer.becomeFirstResponder()
    }

}
