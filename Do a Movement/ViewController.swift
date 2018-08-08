//
//  ViewController.swift
//  Do a Movement
//
//  Created by Nickson Kley Gonçalves Da Silva on 17/07/2018.
//  Copyright © 2018 Nickson Kley Gonçalves Da Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //
    
    @IBOutlet weak var feedLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var instrucao: UIButton!
    @IBOutlet weak var imageButton: UIImageView!
    @IBOutlet weak var instructButton: UIImageView!
    
    var sequenciaTeste: [Character] = []
    var index: Int = 0
    var acertos: Int = 0
    var timer = Timer()
    var tempo: Float = 0.0
    var inGame: Bool = false
    var xInit: CGFloat = 0
    var yInit: CGFloat = 0
    let animationTime: TimeInterval = 0.5
    let deslizamento: CGFloat = 80
    
    @IBAction func helpButton(_ sender: UIButton) {
        let titulo = "Intruções"
        let message = "Deslize a comida para o animal correto\nDuplo toque para 💩"
        
        let alert = UIAlertController(title: titulo,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .default,
                                   handler: nil)
        alert.addAction(action)
        
        present(alert,
                animated: true,
                completion: nil)
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        sortearSequencia()
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true)
        inGame = true
        changeImage()
        startButton.isHidden = true
        imageButton.isHidden = true
        instructButton.isHidden = true
        instrucao.isHidden = true
    }
    
    @IBAction func trashTap(_ sender: UITapGestureRecognizer) {
        teste(lado: .tap)
    }
    
    @IBAction func upSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended{
            teste(lado: .up)
        }
    }
    
    @IBAction func downSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended{
            teste(lado: .down)
        }
    }
    
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended{
            teste(lado: .left)
        }
    }
    
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended{
            teste(lado: .right)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timer.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    enum swipe {
        case up
        case down
        case left
        case right
        case tap
    }
    
    @objc func timerAction() {
        tempo += 0.1
    }
    
    func teste(lado: swipe){
        if inGame {
            switch lado {
            case .up:
                
                UIView.animate(withDuration: animationTime, animations: { self.feedLabel.center.y -= self.deslizamento})
                {
                    (hasCompleted) in if hasCompleted {
                        self.changeImage()
                        self.feedLabel.center.y = self.view.center.y
                    }
                }
                
                if sequenciaTeste[index] == "🐶"{
                    index += 1
                    acertos += 1
                }
                else{
                    endOfGame()
                }
            case .down:
                
                UIView.animate(withDuration: animationTime, animations: { self.feedLabel.center.y += self.deslizamento })
                {
                    (hasCompleted) in if hasCompleted {
                        self.changeImage()
                        self.feedLabel.center.y = self.view.center.y
                    }
                }
                
                if sequenciaTeste[index] == "🐭"{
                    index += 1
                    acertos += 1
                }
                else{
                    endOfGame()
                }
            case .left:
                
                UIView.animate(withDuration: animationTime, animations: { self.feedLabel.center.x -= self.deslizamento })
                {
                    (hasCompleted) in if hasCompleted {
                        self.changeImage()
                        self.feedLabel.center.x = self.view.center.x
                    }
                }
                
                if sequenciaTeste[index] == "🐵"{
                    index += 1
                    acertos += 1
                }
                else{
                    endOfGame()
                }
            case .right:
                
                UIView.animate(withDuration: animationTime, animations: { self.feedLabel.center.x += self.deslizamento })
                { (hasCompleted) in if hasCompleted {
                        self.changeImage()
                        self.feedLabel.center.x = self.view.center.x
                    }
                }
                
                if sequenciaTeste[index] == "🐰"{
                    index += 1
                    acertos += 1
                }
                else{
                    endOfGame()
                }
            case .tap:
                
                UIView.animate(withDuration: animationTime,
                               animations: {
                                    self.feedLabel.transform = CGAffineTransform(rotationAngle: 90)
                                    self.feedLabel.transform = CGAffineTransform(rotationAngle: 180)
                                    self.feedLabel.transform = CGAffineTransform(rotationAngle: 0)
                                })
                                { (hasCompleted) in if hasCompleted {
                                        self.changeImage()
                                        self.feedLabel.center.x = self.view.center.x
                                    }
                                }
                
                if sequenciaTeste[index] == " " {
                    index += 1
                    acertos += 1
                }
                else{
                    endOfGame()
                }
            }
            if index == sequenciaTeste.count{
                sortearSequencia()
            }
            else{
                timerLabel.text = String(acertos)
            }
        }
        
        
    }
    
    func changeImage(){
        switch sequenciaTeste[index] {
        case "🐶":
            feedLabel.text = "🥩"
        case "🐭":
            feedLabel.text = "🧀"
        case "🐵":
            feedLabel.text = "🍌"
        case "🐰":
            feedLabel.text = "🥕"
        case " ":
            feedLabel.text = "💩"
        default:
            feedLabel.text = " "
        }
    }
    
    func endOfGame(){
        let titulo = "Fim de Jogo"
        let message : String
        if acertos == 1{
            message = "Em \(tempo) segundos você fez \(acertos) ponto"
        }
        else{
            message = "Em \(tempo) segundos você fez \(acertos) pontos"
        }
        let alert = UIAlertController(title: titulo,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .default,
                                   handler: nil)
        alert.addAction(action)
        
        present(alert,
                animated: true,
                completion: nil)
        timer.invalidate()
        zerarVariaveis()
        startButton.isHidden = false
        imageButton.isHidden = false
        instructButton.isHidden = false
        instrucao.isHidden =  false
        inGame = false
    }
    
    func zerarVariaveis(){
        tempo = 0
        index = 0
        acertos = 0
        sequenciaTeste = ["😄"]
        feedLabel.text = ""
    }
    
    func sortearSequencia(){
        index = 0
        sequenciaTeste = []
        for _ in 1...15{
            let rand = Int(arc4random_uniform(5))
            switch rand{
            case 0:
                sequenciaTeste.append("🐶")
            case 1:
                sequenciaTeste.append("🐭")
            case 2:
                sequenciaTeste.append("🐰")
            case 3:
                sequenciaTeste.append("🐵")
            default:
                sequenciaTeste.append(" ")
            }
            xInit = feedLabel.center.x
            yInit = feedLabel.center.y
            
        }
    }
}
