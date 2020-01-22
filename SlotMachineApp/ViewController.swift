/*
 File Name: ViewController.swift
 Author: Zhaoning Cai
 Student ID: 300817368
 Date: Jan 22, 2020
 App Description: Slot Machine App
 Version Information: v1.0
 */

import UIKit

// ViewController class for the main game view
class ViewController: UIViewController {

    // All image view references for the first reel
    @IBOutlet weak var slotOneLucky: UIImageView!
    @IBOutlet weak var slotOneBlank: UIImageView!
    @IBOutlet weak var slotOneGengar: UIImageView!
    @IBOutlet weak var slotOneBulbasaur: UIImageView!
    @IBOutlet weak var slotOneCharmander: UIImageView!
    @IBOutlet weak var slotOneSqurtle: UIImageView!
    @IBOutlet weak var slotOnePikachu: UIImageView!
    @IBOutlet weak var slotOneDitto: UIImageView!
    
    // All image view references for the second reel
    @IBOutlet weak var slotTwoPikachu: UIImageView!
    @IBOutlet weak var slotTwoLucky: UIImageView!
    @IBOutlet weak var slotTwoBlank: UIImageView!
    @IBOutlet weak var slotTwoBulbasaur: UIImageView!
    @IBOutlet weak var slotTwoCharmander: UIImageView!
    @IBOutlet weak var slotTwoSqurtle: UIImageView!
    @IBOutlet weak var slotTwoDitto: UIImageView!
    @IBOutlet weak var slotTwoGengar: UIImageView!
    
    // All image view references for the third reel
    @IBOutlet weak var slotThreePikachu: UIImageView!
    @IBOutlet weak var slotThreeLucky: UIImageView!
    @IBOutlet weak var slotThreeBlank: UIImageView!
    @IBOutlet weak var slotThreeBulbasaur: UIImageView!
    @IBOutlet weak var slotThreeCharmander: UIImageView!
    @IBOutlet weak var slotThreeSqurtle: UIImageView!
    @IBOutlet weak var slotThreeDitto: UIImageView!
    @IBOutlet weak var slotThreeGengar: UIImageView!
    
    // Image view references for the three "spin and win" images
    @IBOutlet weak var slotOneSpin: UIImageView!
    @IBOutlet weak var slotTwoSpin: UIImageView!
    @IBOutlet weak var slotThreeSpin: UIImageView!
    
    // Image view references for background images
    @IBOutlet weak var slotBackground: UIImageView!
    @IBOutlet weak var slotBottomBackground: UIImageView!
    
    // References for other views
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
    
    let slotMachine = SlotMachine() // New SlotMachine class object
    
    var spinStop:Int = 0 // Variable used to check the status of the game
    
    // Y coordinates used to animate the spinning effect
    var topMostYPosition: CGFloat = 0.0
    var resultYPosition: CGFloat = 0.0
    var bottomMostYPosition: CGFloat = 0.0
    var slotGap: CGFloat = 0.0
    
    // Each array holds all image views of a reel
    var slotOneImageViewArray = [UIImageView]()
    var slotTwoImageViewArray = [UIImageView]()
    var slotThreeImageViewArray = [UIImageView]()
    
    var spinImageViewArray = [UIImageView]() // Array of "spin and win" images
    var slotResults = [Int]() // Status of the game after a spin
    var initialSpin = true // Represents if it's the first spin after a game reset
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Get top most Y position, win line Y position, and bottom most Y position,
        // and the distance between 2 icons for a reel
        self.topMostYPosition = self.slotOnePikachu.frame.origin.y
        self.resultYPosition = self.slotOneBlank.frame.origin.y
        self.bottomMostYPosition = self.slotOneGengar.frame.origin.y
        self.slotGap = self.slotOneLucky.frame.origin.y - self.slotOnePikachu.frame.origin.y
        
        // Populate image view arrays
        self.slotOneImageViewArray = [self.slotOneBlank, self.slotOneBulbasaur, self.slotOneCharmander, self.slotOneSqurtle, self.slotOneDitto, self.slotOneGengar, self.slotOnePikachu, self.slotOneLucky]
        self.slotTwoImageViewArray = [self.slotTwoBlank, self.slotTwoBulbasaur, self.slotTwoCharmander, self.slotTwoSqurtle, self.slotTwoDitto, self.slotTwoGengar, self.slotTwoPikachu, self.slotTwoLucky]
        self.slotThreeImageViewArray = [self.slotThreeBlank, self.slotThreeBulbasaur, self.slotThreeCharmander, self.slotThreeSqurtle, self.slotThreeDitto, self.slotThreeGengar, self.slotThreePikachu, self.slotThreeLucky]
        self.spinImageViewArray = [self.slotOneSpin, self.slotTwoSpin, self.slotThreeSpin]
        
        // Reset the game when first starting the app
        self.resetSlotMachine()
    }

    // When player enters bet, on text change, checks if the text can be converted to an integer,
    // then checks if the integer is larger than 0, then checks if the player's money is no less
    // than the bet. If any of the check fails, disable the start button
    @IBAction func verifyBet(_ sender: UITextField) {
        if (Int(sender.text ?? "") != nil && Int(sender.text ?? "")! > 0 && Int(sender.text ?? "")! <= Int(self.playerMoneyLabel.text ?? "0")!){
            self.changeButtonStatus(disable: true, start: false, stop: true, reset: false, bet: true)
        }
        else{
            self.changeButtonStatus(disable: false, start: true, stop: true, reset: false, bet: true)
        }    }
    
    // Alert the player about exiting the app. Upon clicking "Yes", exit the app
    @IBAction func exitGame(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are You Leaving?", message: "You will lose your progress.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            exit(0)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    // Reset the game
    @IBAction func resetGame(_ sender: UIButton) {
        self.resetSlotMachine()
        
        // Spin the "spin and win" images to the win line position
        if (self.spinStop == 0){ // Checks if the reels are stopped
            self.spinInSpinIcons()
        }
    }
    
    // Start spinning the reels
    @IBAction func spinStart(_ sender: UIButton) {
        if (self.spinStop == 0){ // Checks if the reels are stopped
            self.spinStop = 1 // Change status to start spinning
            
            // Hide start button, unhide stop button, disable the reset button
            self.changeButtonStatus(disable: true, start: true, stop: false, reset: true, bet: false)
            
            // Spin each reel independently
            self.beginSpinning(imageViewArray: slotOneImageViewArray, column: 0)
            self.beginSpinning(imageViewArray: slotTwoImageViewArray, column: 1)
            self.beginSpinning(imageViewArray: slotThreeImageViewArray, column: 2)
            
            // If it's the first spin after game resets, spin away the "spin and win" images
            if (self.initialSpin){
                self.spinAwaySpinIcons()
            }
        }
    }
    
    // Stop the spinning reels and get the result
    @IBAction func spinStop(_ sender: UIButton) {
        if (spinStop == 4){ // Check if all 3 reels are currently spinning
            spinStop = -3 // Change status to stop spinning
            
            // Get the game status after this spin
            self.slotResults = self.slotMachine.spinSlotMachine(playerBet: self.playerBetTextField.text!)
            
            // Check if player's money is no less than the bet. Disable the start button otherwise.
            if (self.slotResults[3] > self.slotResults[6]){
                self.changeButtonStatus(disable: false, start: true, stop: true, reset: false, bet: true)
            }
            else{
                self.changeButtonStatus(disable: true, start: false, stop: true, reset: false, bet: true)
            }
            self.updateLabels(resultArray: self.slotResults)
        }
    }
    
    // Reset the game values
    func resetSlotMachine(){
        if (self.spinStop == 0){
            self.slotResults = self.slotMachine.resetSlotMachine()
            self.updateLabels(resultArray: self.slotResults)
        }
    }
    
    // Update all labels and text fields with the values in the array
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
    
    // Change the status of all buttons on the app
    func changeButtonStatus(disable: Bool, start: Bool, stop: Bool, reset: Bool, bet: Bool){
        self.disabledSpinStartButton.isHidden = disable
        self.spinStartButton.isHidden = start
        self.spinStopButton.isHidden = stop
        self.disabledResetButton.isHidden = !reset
        self.resetButton.isHidden = reset
        self.playerBetTextField.isEnabled = bet
    }
    
    // Spin the "spin and win" images out of view
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
    
    // Spin the "spin and win" images back to win line positions
    // Spin the reels by 2 slots at the same time to match the movements
    func spinInSpinIcons(){
        if (!self.initialSpin){
            self.initialSpin = true
            
            // Shift all "spin and win" images to positions 2 slots above win line
            for i in 0 ..< self.spinImageViewArray.count {
                var imageFrame = self.spinImageViewArray[i].frame
                imageFrame.origin.y = self.resultYPosition - self.slotGap * 2
                self.spinImageViewArray[i].frame = imageFrame
            }
            
            // Spin "spin and win" images and all reel images down one slot with ease in effect
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
            
            // Upon completion, shift the bottom most images of each reel to the top most position
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
                
                // Spin "spin and win" images and all reel images down one slot with ease out effect
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
                    
                // Upon completion, shift the bottom most images of each reel to the top most position
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
    
    // Start spinning a reel
    func beginSpinning(imageViewArray: Array<UIImageView>, column: Int) {
        
        // Spin all images on a reel by one slot with ease in effect
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn], animations: {
            for i in 0 ..< imageViewArray.count {
                var imageFrame = imageViewArray[i].frame
                imageFrame.origin.y += self.slotGap
                imageViewArray[i].frame = imageFrame
            }
            
        // Upon completion, add 1 to spinStop variable, meaning the reel has finished starting phase
        // and has entered constantly spinning phase
        }, completion: { finish in
            self.spinStop += 1
            self.keepSpinning(imageViewArray: imageViewArray, column: column)
        })
    }
    
    // Constantly spinning the reel with same speed
    func keepSpinning(imageViewArray: Array<UIImageView>, column: Int) {
        for i in 0 ..< imageViewArray.count {
            
            // Shift the bottom most image to the top most position
            if (imageViewArray[i].frame.origin.y > self.bottomMostYPosition){
                var imageFrame = imageViewArray[i].frame
                imageFrame.origin.y = self.topMostYPosition
                imageViewArray[i].frame = imageFrame
                break
            }
        }
        
        // Spin all images on a reel by one slot with linear effect
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveLinear], animations: {
            for i in 0 ..< imageViewArray.count {
                var imageFrame = imageViewArray[i].frame
                imageFrame.origin.y += self.slotGap
                imageViewArray[i].frame = imageFrame
            }
            
        // Upon completion, keeps spinning.
        }, completion: { finish in
            
            // If spinStop is less than 0, the game has changed to stop spinning status,
            // and when the result image is 1 slot above the win line, begin to stop the spin
            if (self.spinStop < 0 && abs(self.resultYPosition - imageViewArray[self.slotResults[column]].frame.origin.y - self.slotGap) < 1 ){
                self.stopSpinning(imageViewArray: imageViewArray)
            }
            else{
                self.keepSpinning(imageViewArray: imageViewArray, column: column)
            }
        })
    }
    
    // Stop spinning the reel
    func stopSpinning(imageViewArray: Array<UIImageView>){
        
        // Shift the bottom most image the the top most position
        for i in 0 ..< imageViewArray.count {
            if (imageViewArray[i].frame.origin.y > self.bottomMostYPosition){
                var imageFrame = imageViewArray[i].frame
                imageFrame.origin.y = self.topMostYPosition
                imageViewArray[i].frame = imageFrame
                break
            }
        }
        
        // Spin all images on a reel by one slot with ease out effect
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            for i in 0 ..< imageViewArray.count {
                var imageFrame = imageViewArray[i].frame
                imageFrame.origin.y += self.slotGap
                imageViewArray[i].frame = imageFrame
            }
            
        // Upon completion, shift the bottom most image to the top most position
        }, completion: { finish in
            for i in 0 ..< imageViewArray.count {
                if (imageViewArray[i].frame.origin.y > self.bottomMostYPosition){
                    var imageFrame = imageViewArray[i].frame
                    imageFrame.origin.y = self.topMostYPosition
                    imageViewArray[i].frame = imageFrame
                    break
                }
            }
            // Adding 1 to spinStop variable means the the reel has come to a full stop
            self.spinStop += 1
        })
    }
    
}

