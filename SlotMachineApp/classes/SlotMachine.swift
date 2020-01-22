/*
 File Name: SlotMachine.swift
 Author: Zhaoning Cai
 Student ID: 300817368
 Date: Jan 22, 2020
 App Description: Slot Machine App
 Version Information: v1.0
 */

import Foundation

// SlotMachine class that holds the logic of the game
class SlotMachine {
        
    // Properties
    
    // Each value in the _slotWeights array represents the weight of the corresponding
    // icon in _slotIcons array. The weights are used for calculating the odds of an icon
    // showing up at the end of a spin.
    // The odds are the same as the web version
    private let _slotWeights: Array<Int> = [415, 154, 138, 123, 77, 46, 31, 15]
    private let _slotIcons: Array<String> = ["blank", "bulbasaur", "charmander", "squrtle", "ditto", "gengar", "pikachu", "lucky"]
    private var _jackpot = 5000
    private var _playerMoney = 1000
    private var _playerBet = -1
    private var _playerPrize = -1
    private var _playerJackpot = 0
    
    // Initializer
    init (){
        
    }
    
    // Resets all values to default, and return an integer array of the values
    func resetSlotMachine() ->Array<Int> {
        self._jackpot = 5000
        self._playerMoney = 1000
        self._playerBet = -1
        self._playerPrize = -1
        self._playerJackpot = 0
        return [0, 0, 0, self._playerBet, self._playerPrize, self._playerJackpot, self._playerMoney, self._jackpot]
    }
    
    // Decides the outcome of a spin.
    func spinSlotMachine(playerBet: String) -> Array<Int> {
        _playerPrize = 0 // Resets player prize money for this spin
        _playerBet = Int(playerBet)!
        _playerMoney -= _playerBet // Reduce player's money by bet amount
        
        // Get the integer outcome of each slot
        let slot1: Int = rollByWeight()
        let slot2: Int = rollByWeight()
        let slot3: Int = rollByWeight()
        
        // Create a dictionary with the icons as keys and numbers of appearance as values
        var resultDic: [String: Int] = [:]
        for i in 0 ..< _slotIcons.count{
            resultDic[_slotIcons[i]] = 0
        }
        resultDic[_slotIcons[slot1]] = (resultDic[_slotIcons[slot1]] ?? 0) + 1
        resultDic[_slotIcons[slot2]] = (resultDic[_slotIcons[slot2]] ?? 0) + 1
        resultDic[_slotIcons[slot3]] = (resultDic[_slotIcons[slot3]] ?? 0) + 1
        
        // Check if the player wins and what the player won
        // Winning condition replicated from the web version
        if (resultDic["blank"] == 0){
            if (resultDic["bulbasaur"] == 3){
                _playerPrize = _playerBet * 10
            }
            else if (resultDic["charmander"] == 3){
                _playerPrize = _playerBet * 20
            }
            else if (resultDic["squrtle"] == 3){
                _playerPrize = _playerBet * 30
            }
            else if (resultDic["ditto"] == 3){
                _playerPrize = _playerBet * 40
            }
            else if (resultDic["gengar"] == 3){
                _playerPrize = _playerBet * 50
            }
            else if (resultDic["pikachu"] == 3){
                _playerPrize = _playerBet * 75
            }
            else if (resultDic["lucky"] == 3){
                _playerPrize = _playerBet * 100
            }
            else if (resultDic["bulbasaur"] == 2){
                _playerPrize = _playerBet * 2
            }
            else if (resultDic["charmander"] == 2){
                _playerPrize = _playerBet * 2
            }
            else if (resultDic["squrtle"] == 2){
                _playerPrize = _playerBet * 3
            }
            else if (resultDic["ditto"] == 2){
                _playerPrize = _playerBet * 4
            }
            else if (resultDic["gengar"] == 2){
                _playerPrize = _playerBet * 5
            }
            else if (resultDic["pikachu"] == 2){
                _playerPrize = _playerBet * 10
            }
            else if (resultDic["lucky"] == 2){
                _playerPrize = _playerBet * 20
            }
            else if (resultDic["lucky"] == 1){
                _playerPrize = _playerBet * 5
            }
            else{
                _playerPrize = _playerBet
            }
            
            // As long as the player wins, roll for a potential jackpot
            // Jackpot odd is the same as the web version
            let randomNumber: Int = Int.random(in: 1 ... 51)
            if (randomNumber == 1){
                _playerJackpot = _jackpot
                _jackpot = 1000
                _playerMoney += _playerJackpot
            }
            else{
                _playerJackpot = 0
            }
            _playerMoney += _playerPrize
        }
        else{
            _playerPrize = 0
        }
        
        // Return an integer array of values at the end of this spin
        return [slot1, slot2, slot3, _playerBet, _playerPrize, _playerJackpot, _playerMoney, _jackpot]
    }
    
    // Roll an index based on the given weight
    private func rollByWeight() -> Int{
        let total = _slotWeights.reduce(0, +)
        var randomNumber: Int = Int.random(in: 1 ... total)
        var index: Int = -1
        for weight in _slotWeights{
            index += 1
            randomNumber -= weight
            if (randomNumber <= 0){
                return index
            }
        }
        return -1 // This line shouldn't be reached without error
    }
}
