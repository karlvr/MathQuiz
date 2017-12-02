//
//  ViewController.swift
//  puppies and kittens math quiz
//
//  Created by Karl von Randow on 7/05/16.
//  Copyright © 2016 XK72. All rights reserved.
//

import UIKit

class MultiplicationQuestionHandler: QuestionHandler {

    func nextQuestion() -> MathQuizQuestion {
        let a = Int(arc4random_uniform(11))
        let b = Int(arc4random_uniform(11))
        
        let correctAnswer = a * b
        let question = "What’s \(a) × \(b)?"
        return MathQuizQuestion(correctAnswer: correctAnswer, question: question)
    }
    
}

