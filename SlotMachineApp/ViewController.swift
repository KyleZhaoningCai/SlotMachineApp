//
//  ViewController.swift
//  SlotMachineApp
//
//  Created by Zhaoning Cai on 2020-01-08.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slotOneLucky: UIImageView!
    @IBOutlet weak var slotOneBlank: UIImageView!
    @IBOutlet weak var slotOneGengar: UIImageView!
    @IBOutlet weak var slotOneBulbasaur: UIImageView!
    @IBOutlet weak var slotOneCharmander: UIImageView!
    @IBOutlet weak var slotOneSqurtle: UIImageView!
    @IBOutlet weak var slotOnePikachu: UIImageView!
    @IBOutlet weak var slotOneDitto: UIImageView!
    
    @IBOutlet weak var slotTwoPikachu: UIImageView!
    @IBOutlet weak var slotTwoLucky: UIImageView!
    @IBOutlet weak var slotTwoBlank: UIImageView!
    @IBOutlet weak var slotTwoBulbasaur: UIImageView!
    @IBOutlet weak var slotTwoCharmander: UIImageView!
    @IBOutlet weak var slotTwoSqurtle: UIImageView!
    @IBOutlet weak var slotTwoDitto: UIImageView!
    @IBOutlet weak var slotTwoGengar: UIImageView!
    
    @IBOutlet weak var slotThreePikachu: UIImageView!
    @IBOutlet weak var slotThreeLucky: UIImageView!
    @IBOutlet weak var slotThreeBlank: UIImageView!
    @IBOutlet weak var slotThreeBulbasaur: UIImageView!
    @IBOutlet weak var slotThreeCharmander: UIImageView!
    @IBOutlet weak var slotThreeSqurtle: UIImageView!
    @IBOutlet weak var slotThreeDitto: UIImageView!
    @IBOutlet weak var slotThreeGengar: UIImageView!
    
    @IBOutlet weak var slotOneSpin: UIImageView!
    @IBOutlet weak var slotTwoSpin: UIImageView!
    @IBOutlet weak var slotThreeSpin: UIImageView!
    
    @IBOutlet weak var slotBackground: UIImageView!
    @IBOutlet weak var slotBottomBackground: UIImageView!
    @IBOutlet weak var spinButton: UIButton!
    
    @IBOutlet weak var winLossLabel: UILabel!
    @IBOutlet weak var jackpotLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var playerMoneyLabel: UILabel!
    @IBOutlet weak var playerBetTextField: UITextField!
    @IBOutlet weak var spinStartButton: UIButton!
    @IBOutlet weak var spinStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var disabledSpinStartButton: UIImageView!
    @IBOutlet weak var disabledResetButton: UIImageView!
    
    
    let slotMachine = SlotMachine()
    
    var spinStop:Int = 0
    var topMostYPosition: CGFloat = 0.0
    var resultYPosition: CGFloat = 0.0
    var bottomMostYPosition: CGFloat = 0.0
    var slotGap: CGFloat = 0.0
    var slotOneImageViewArray = [UIImageView]()
    var slotTwoImageViewArray = [UIImageView]()
    var slotThreeImageViewArray = [UIImageView]()
    var spinImageViewArray = [UIImageView]()
    var slotResults = [Int]()
    var initialSpin = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.topMostYPosition = self.slotOnePikachu.frame.origin.y
        self.resultYPosition = self.slotOneBlank.frame.origin.y
        self.bottomMostYPosition = self.slotOneGengar.frame.origin.y
        self.slotGap = self.slotOneLucky.frame.origin.y - self.slotOnePikachu.frame.origin.y
        self.slotOneImageViewArray = [self.slotOneBlank, self.slotOneBulbasaur, self.slotOneCharmander, self.slotOneSqurtle, self.slotOneDitto, self.slotOneGengar, self.slotOnePikachu, self.slotOneLucky]
        self.slotTwoImageViewArray = [self.slotTwoBlank, self.slotTwoBulbasaur, self.slotTwoCharmander, self.slotTwoSqurtle, self.slotTwoDitto, self.slotTwoGengar, self.slotTwoPikachu, self.slotTwoLucky]
        self.slotThreeImageViewArray = [self.slotThreeBlank, self.slotThreeBulbasaur, self.slotThreeCharmander, self.slotThreeSqurtle, self.slotThreeDitto, self.slotThreeGengar, self.slotThreePikachu, self.slotThreeLucky]
        self.spinImageViewArray = [self.slotOneSpin, self.slotTwoSpin, self.slotThreeSpin]
        self.resetSlotMachine()
    }

    @IBAction func verifyBet(_ sender: UITextField) {
        self.verifyBetInput(inputString: sender)
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        self.resetSlotMachine()
        if (self.spinStop == 0){
            self.spinInSpinIcons()
        }
    }
    
    @IBAction func spinStart(_ sender: UIButton) {
        if (self.spinStop == 0){
            self.verifyBetInput(inputString: self.playerBetTextField)
            if (!self.spinStartButton.isHidden){
                self.spinStop = 1
                self.changeButtonStatus(disable: true, start: true, stop: false, reset: true, bet: false)
                self.beginSpinning(imageViewArray: slotOneImageViewArray, column: 0)
                self.beginSpinning(imageViewArray: slotTwoImageViewArray, column: 1)
                self.beginSpinning(imageViewArray: slotThreeImageViewArray, column: 2)
                if (self.initialSpin){
                    self.spinAwaySpinIcons()
                }
            }
        }
    }
    @IBAction func spinStop(_ sender: UIButton) {
        if (spinStop == 4){
            spinStop = -3
            self.changeButtonStatus(disable: true, start: false, stop: true, reset: false, bet: true)
            self.slotResults = self.slotMachine.spinSlotMachine(playerBet: self.playerBetTextField.text!)
            self.updateLabels(resultArray: self.slotResults)
        }
    }
    
    func verifyBetInput(inputString: UITextField){
        if (Int(inputString.text ?? "") != nil && Int(inputString.text ?? "")! > 0 && Int(inputString.text ?? "")! <= Int(self.playerMoneyLabel.text ?? "0")!){
            self.changeButtonStatus(disable: true, start: false, stop: true, reset: false, bet: true)
        }
        else{
            self.changeButtonStatus(disable: false, start: true, stop: true, reset: false, bet: true)
        }
    }
    
    func resetSlotMachine(){
        if (self.spinStop == 0){
            self.slotResults = self.slotMachine.resetSlotMachine()
            self.updateLabels(resultArray: self.slotResults)
        }
    }
    
    func updateLabels(resultArray: Array<Int>){
        if (resultArray[3] >= 0){
            self.playerBetTextField.text = String(resultArray[3])
        }
        else{
            self.changeButtonStatus(disable: false, start: true, stop: true, reset: true, bet: true)
            self.playerBetTextField.text = ""
        }
        
        if (resultArray[4] > 0){
            self.winLossLabel.text = "WON!"
            if (resultArray[5] > 0){
                self.messageLabel.text = "!!!JACKPOT!!!GRATS!!!"
            }
            else{
                self.messageLabel.text = "YOU'VE WON " + String(resultArray[4]) + " CHIPS!"
            }
            
        }
        else if (resultArray[4] == 0){
            self.winLossLabel.text = "LOST!"
            self.messageLabel.text = "YOU'VE LOST"
        }
        else{
            self.winLossLabel.text = ""
            self.messageLabel.text = "BET CHIPS AND START SPIN"
        }
        self.playerMoneyLabel.text = String(resultArray[6])
        self.jackpotLabel.text = String(resultArray[7])
        
    }
    
    func changeButtonStatus(disable: Bool, start: Bool, stop: Bool, reset: Bool, bet: Bool){
        self.disabledSpinStartButton.isHidden = disable
        self.spinStartButton.isHidden = start
        self.spinStopButton.isHidden = stop
        self.disabledResetButton.isHidden = !reset
        self.resetButton.isHidden = reset
        self.playerBetTextField.isEnabled = bet
    }
    
    func spinAwaySpinIcons(){
        self.initialSpin = false
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseIn], animations: {
            for i in 0 ..< self.spinImageViewArray.count {
                var imageFrame = self.spinImageViewArray[i].frame
                imageFrame.origin.y += self.slotGap * 2
                self.spinImageViewArray[i].frame = imageFrame
            }
        })
    }
    
    func spinInSpinIcons(){
        if (!self.initialSpin){
            self.initialSpin = true
            for i in 0 ..< self.spinImageViewArray.count {
                var imageFrame = self.spinImageViewArray[i].frame
                imageFrame.origin.y = self.resultYPosition - self.slotGap * 2
                self.spinImageViewArray[i].frame = imageFrame
            }
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn], animations: {
                for i in 0 ..< self.spinImageViewArray.count {
                    var imageFrame = self.spinImageViewArray[i].frame
                    imageFrame.origin.y += self.slotGap
                    self.spinImageViewArray[i].frame = imageFrame
                }
                for i in 0 ..< self.slotOneImageViewArray.count {
                    var imageFrame = self.slotOneImageViewArray[i].frame
                    imageFrame.origin.y += self.slotGap
                    self.slotOneImageViewArray[i].frame = imageFrame
                }
                for i in 0 ..< self.slotTwoImageViewArray.count {
                    var imageFrame = self.slotTwoImageViewArray[i].frame
                    imageFrame.origin.y += self.slotGap
                    self.slotTwoImageViewArray[i].frame = imageFrame
                }
                for i in 0 ..< self.slotThreeImageViewArray.count {
                    var imageFrame = self.slotThreeImageViewArray[i].frame
                    imageFrame.origin.y += self.slotGap
                    self.slotThreeImageViewArray[i].frame = imageFrame
                }
            }, completion: { finish in
                for i in 0 ..< self.slotOneImageViewArray.count {
                    if (self.slotOneImageViewArray[i].frame.origin.y > self.bottomMostYPosition){
                        var imageFrame = self.slotOneImageViewArray[i].frame
                        imageFrame.origin.y = self.topMostYPosition
                        self.slotOneImageViewArray[i].frame = imageFrame
                        break
                    }
                }
                for i in 0 ..< self.slotTwoImageViewArray.count {
                    if (self.slotTwoImageViewArray[i].frame.origin.y > self.bottomMostYPosition){
                        var imageFrame = self.slotTwoImageViewArray[i].frame
                        imageFrame.origin.y = self.topMostYPosition
                        self.slotTwoImageViewArray[i].frame = imageFrame
                        break
                    }
                }
                for i in 0 ..< self.slotThreeImageViewArray.count {
                    if (self.slotThreeImageViewArray[i].frame.origin.y > self.bottomMostYPosition){
                        var imageFrame = self.slotThreeImageViewArray[i].frame
                        imageFrame.origin.y = self.topMostYPosition
                        self.slotThreeImageViewArray[i].frame = imageFrame
                        break
                    }
                }
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                    for i in 0 ..< self.spinImageViewArray.count {
                        var imageFrame = self.spinImageViewArray[i].frame
                        imageFrame.origin.y += self.slotGap
                        self.spinImageViewArray[i].frame = imageFrame
                    }
                    for i in 0 ..< self.slotOneImageViewArray.count {
                        var imageFrame = self.slotOneImageViewArray[i].frame
                        imageFrame.origin.y += self.slotGap
                        self.slotOneImageViewArray[i].frame = imageFrame
                    }
                    for i in 0 ..< self.slotTwoImageViewArray.count {
                        var imageFrame = self.slotTwoImageViewArray[i].frame
                        imageFrame.origin.y += self.slotGap
                        self.slotTwoImageViewArray[i].frame = imageFrame
                    }
                    for i in 0 ..< self.slotThreeImageViewArray.count {
                        var imageFrame = self.slotThreeImageViewArray[i].frame
                        imageFrame.origin.y += self.slotGap
                        self.slotThreeImageViewArray[i].frame = imageFrame
                    }
                }, completion: { finish in
                    for i in 0 ..< self.slotOneImageViewArray.count {
                        if (self.slotOneImageViewArray[i].frame.origin.y > self.bottomMostYPosition){
                            var imageFrame = self.slotOneImageViewArray[i].frame
                            imageFrame.origin.y = self.topMostYPosition
                            self.slotOneImageViewArray[i].frame = imageFrame
                            break
                        }
                    }
                    for i in 0 ..< self.slotTwoImageViewArray.count {
                        if (self.slotTwoImageViewArray[i].frame.origin.y > self.bottomMostYPosition){
                            var imageFrame = self.slotTwoImageViewArray[i].frame
                            imageFrame.origin.y = self.topMostYPosition
                            self.slotTwoImageViewArray[i].frame = imageFrame
                            break
                        }
                    }
                    for i in 0 ..< self.slotThreeImageViewArray.count {
                        if (self.slotThreeImageViewArray[i].frame.origin.y > self.bottomMostYPosition){
                            var imageFrame = self.slotThreeImageViewArray[i].frame
                            imageFrame.origin.y = self.topMostYPosition
                            self.slotThreeImageViewArray[i].frame = imageFrame
                            break
                        }
                    }
                })
            })
        }
    }
    
    func beginSpinning(imageViewArray: Array<UIImageView>, column: Int) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn], animations: {
            for i in 0 ..< imageViewArray.count {
                var imageFrame = imageViewArray[i].frame
                imageFrame.origin.y += self.slotGap
                imageViewArray[i].frame = imageFrame
            }
        }, completion: { finish in
            self.spinStop += 1
            self.keepSpinning(imageViewArray: imageViewArray, column: column)
        })
    }
    
    func keepSpinning(imageViewArray: Array<UIImageView>, column: Int) {
        for i in 0 ..< imageViewArray.count {
            if (imageViewArray[i].frame.origin.y > self.bottomMostYPosition){
                var imageFrame = imageViewArray[i].frame
                imageFrame.origin.y = self.topMostYPosition
                imageViewArray[i].frame = imageFrame
                break
            }
        }
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveLinear], animations: {
            for i in 0 ..< imageViewArray.count {
                var imageFrame = imageViewArray[i].frame
                imageFrame.origin.y += self.slotGap
                imageViewArray[i].frame = imageFrame
            }
        }, completion: { finish in
            if (self.spinStop < 0 && abs(self.resultYPosition - imageViewArray[self.slotResults[column]].frame.origin.y - self.slotGap) < 1 ){
                self.stopSpinning(imageViewArray: imageViewArray)
            }
            else{
                self.keepSpinning(imageViewArray: imageViewArray, column: column)
            }
        })
    }
    
    func stopSpinning(imageViewArray: Array<UIImageView>){
        for i in 0 ..< imageViewArray.count {
            if (imageViewArray[i].frame.origin.y > self.bottomMostYPosition){
                var imageFrame = imageViewArray[i].frame
                imageFrame.origin.y = self.topMostYPosition
                imageViewArray[i].frame = imageFrame
                break
            }
        }
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            for i in 0 ..< imageViewArray.count {
                var imageFrame = imageViewArray[i].frame
                imageFrame.origin.y += self.slotGap
                imageViewArray[i].frame = imageFrame
            }
        }, completion: { finish in
            for i in 0 ..< imageViewArray.count {
                if (imageViewArray[i].frame.origin.y > self.bottomMostYPosition){
                    var imageFrame = imageViewArray[i].frame
                    imageFrame.origin.y = self.topMostYPosition
                    imageViewArray[i].frame = imageFrame
                    break
                }
            }
            self.spinStop += 1
        })
    }
    
}

