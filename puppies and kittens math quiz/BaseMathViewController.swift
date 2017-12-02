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
    @IBOutlet weak var huh: UILabel!
    @IBOutlet weak var close: UILabel!
    @IBOutlet weak var score: UILabel!
    
    var correctAnswer: Int!
    var currentScore: Int = 0
    var waitingForNextQuestion: Bool = false
    var speechRecognizer: SpeechRecognizerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 10.0, *) {
            speechRecognizer = SpeechRecognizer(handler: { (result) in
                self.checkSpeechResult(result: result)
            })
        }
        
        answer.text = ""
        nextQuestion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        answer.becomeFirstResponder()
    }
    
    func nextQuestion() {
        fatalError()
    }

    func didNextQuestion() {
        answer.becomeFirstResponder()

        do {
            try speechRecognizer?.start(contextualStrings: ["\(correctAnswer!)"])
        } catch {
            print("Failed to start speech recognition: \(error)")
        }
    }

    private func extractNumbers(string: String) -> [Int] {
        let spellOutFormatter = NumberFormatter()
        spellOutFormatter.numberStyle = .spellOut

        let numberFormatter = NumberFormatter()

        var result = [Int]()
        string.enumerateLinguisticTags(in: string.startIndex..<string.endIndex, scheme: NSLinguisticTagScheme.lexicalClass.rawValue, options: [], orthography: nil) { (tag, tokenRange, _, _) in
            let token = String(string[tokenRange]).lowercased()

            if let number = spellOutFormatter.number(from: token) {
                print("FOUND SPELLED NUMBER \(number)")
                result.append(number.intValue)
            } else if let number = numberFormatter.number(from: token) {
                print("FOUND NUMBER \(number)")
                result.append(number.intValue)
            } else if token == "to" || token == "too" {
                result.append(2)
            } else if token == "sex" || token == "sucks" {
                result.append(6)
            } else if token == "teen" || token == "team" || token == "tin" {
                result.append(10)
            } else if token == "through" {
                result.append(3)
            } else if token == "won" {
                result.append(1)
            } else if token == "ate" {
                result.append(8)
            } else if token == "sarah" {
                result.append(0)
            } else {
                print("NOT NUMBER \"\(token)\"")
            }
        }
        return result
    }

    private func checkSpeechResult(result: String) {
        guard !waitingForNextQuestion else {
            return
        }

        let numbers = extractNumbers(string: result)

        print("Checking \(result) => \(numbers)")
        guard !numbers.isEmpty else {
            answer.text = ""
            gotUnintelligibleAnswer()
            return
        }

        let lastNumber = numbers[numbers.endIndex.advanced(by: -1)]
        answer.text = "\(lastNumber)"
        checkAnswerNumber(lastNumber)
    }

    private func cancelPreviousDelays() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideRight), object: nil)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideClose), object: nil)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideWrong), object: nil)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideUnintelligble), object: nil)
    }

    private func gotAnswerRight() {
        guard !waitingForNextQuestion else {
            return
        }
        right.isHidden = false
        close.isHidden = true
        wrong.isHidden = true
        huh.isHidden = true

        cancelPreviousDelays()
        perform(#selector(hideRight), with: nil, afterDelay: 2)

        currentScore = currentScore + 1
        updateScore()
        waitingForNextQuestion = true

        answer.resignFirstResponder()
    }

    private func gotAnswerClose() {
        guard !waitingForNextQuestion else {
            return
        }

        close.isHidden = false
        right.isHidden = true
        wrong.isHidden = true
        huh.isHidden = true

        cancelPreviousDelays()
        perform(#selector(hideClose), with: nil, afterDelay: 2)
    }

    private func gotAnswerWrong() {
        guard !waitingForNextQuestion else {
            return
        }
        
        wrong.isHidden = false
        close.isHidden = true
        right.isHidden = true
        huh.isHidden = true

        cancelPreviousDelays()
        perform(#selector(hideWrong), with: nil, afterDelay: 15)
    }

    private func gotUnintelligibleAnswer() {
        guard !waitingForNextQuestion else {
            return
        }

        huh.isHidden = false
        wrong.isHidden = true
        close.isHidden = true
        right.isHidden = true

        cancelPreviousDelays()
        perform(#selector(hideUnintelligble), with: nil, afterDelay: 2)
    }

    private func checkAnswerNumber(_ answerNumber: Int) {
        if answerNumber == correctAnswer {
            gotAnswerRight()
        } else if answerIsClose(answerNumber) {
            gotAnswerClose()
        } else {
            gotAnswerWrong()
        }
    }
    
    @IBAction func checkAnswer(_ sender: AnyObject) {
        if let answerText = answer.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), let answerNumber = Int(answerText), !waitingForNextQuestion {
            checkAnswerNumber(answerNumber)
        } else {
            answer.text = ""
        }
    }
    
    @objc func hideRight() {
        right.isHidden = true
        waitingForNextQuestion = false
        
        nextQuestion()
    }
    
    @objc func hideWrong() {
        wrong.isHidden = true
    }
    
    @objc func hideClose() {
        close.isHidden = true
    }

    @objc func hideUnintelligble() {
        huh.isHidden = true
    }
    
    func answerIsClose(_ answerNumber: Int) -> Bool {
        return abs(correctAnswer - answerNumber) <= 2
    }
    
    func updateScore() {
        score.text = "Score: \(currentScore)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.endIndex == string.startIndex {
            return true
        }
        
        guard let _ = Int(string) else {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkAnswer(textField)
        return true
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
