//
//  MainViewController.swift
//  puppies and kittens math quiz
//
//  Created by Karl von Randow on 3/12/17.
//  Copyright © 2017 XK72. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let mathQuiz = segue.destination as? MathQuizViewController {
            switch segue.identifier! {
            case "multiplication":
                mathQuiz.questionHandler = MultiplicationQuestionHandler()
            case "addition":
                mathQuiz.questionHandler = AdditionViewController()
            default:
                fatalError("Unsupported segue: \(segue.identifier!)")
            }
        }
    }

}
