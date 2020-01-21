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
    
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var jackpotLabel: UILabel!
    
    @IBOutlet weak var slotBackground: UIImageView!
    @IBOutlet weak var slotBottomBackground: UIImageView!
    @IBOutlet weak var spinButton: UIButton!
    
    @IBOutlet weak var winLossLabel: UILabel!
    @IBOutlet weak var jackpotAmountLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var playerMoneyLabel: UILabel!
    @IBOutlet weak var playerBetTextField: UITextField!
    @IBOutlet weak var spinStartButton: UIButton!
    @IBOutlet weak var spinStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    
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
        
    }

    @IBAction func resetGame(_ sender: UIButton) {
    }
    
    @IBAction func spinStart(_ sender: UIButton) {
        if (spinStop == 0){
            spinStop = 1
            spinStartButton.isHidden = true
            spinStopButton.isHidden = false
            beginSpinning(imageViewArray: slotOneImageViewArray, column: 0)
            beginSpinning(imageViewArray: slotTwoImageViewArray, column: 1)
            beginSpinning(imageViewArray: slotThreeImageViewArray, column: 2)
            if (self.initialSpin){
                spinAwaySpinIcons()
            }
        }
    }
    @IBAction func spinStop(_ sender: UIButton) {
        if (spinStop == 4){
            spinStop = -3
            spinStartButton.isHidden = false
            spinStopButton.isHidden = true
            slotResults = self.slotMachine.spinSlotMachine()
            print(slotResults[0])
            print(slotResults[1])
            print(slotResults[2])
        }
    }
    
    func spinAwaySpinIcons(){
        self.initialSpin = false
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn], animations: {
            for i in 0 ..< self.spinImageViewArray.count {
                var imageFrame = self.spinImageViewArray[i].frame
                imageFrame.origin.y += self.slotGap * 3
                self.spinImageViewArray[i].frame = imageFrame
            }
        })
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

