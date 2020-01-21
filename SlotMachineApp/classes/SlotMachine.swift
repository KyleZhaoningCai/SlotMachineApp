//
//  SlotMachine.swift
//  SlotMachineApp
//
//  Created by Zhaoning Cai on 2020-01-08.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import Foundation

class SlotMachine {
        
    // Properties
    private let _slotWeights: Array<Int> = [415, 154, 138, 123, 77, 46, 31, 15]
    private let _slotIcons: Array<String> = ["blank", "bulbasaur", "charmander", "squrtle", "ditto", "gengar", "pikachu", "lucky"]
    private var _jackpot = 5000
    private var _playerMoney = 1000
    private var _playerBet = 0
    private var _playerPrize = 0
    private var _playerJackpot = 0
    
    
    var slotIcons: Array<String>{
        get {
            return _slotIcons
        }
    }
    
    // Initializer
    init (){
        
    }
    
    
    
    func spinSlotMachine() -> Array<Int> {
        let slot1: Int = rollByWeight()
        let slot2: Int = rollByWeight()
        let slot3: Int = rollByWeight()
        var resultDic: [String: Int] = [:]
        for i in 0 ..< _slotIcons.count{
            resultDic[_slotIcons[i]] = 0
        }
        resultDic[_slotIcons[slot1]] = (resultDic[_slotIcons[slot1]] ?? 0) + 1
        resultDic[_slotIcons[slot2]] = (resultDic[_slotIcons[slot2]] ?? 0) + 1
        resultDic[_slotIcons[slot3]] = (resultDic[_slotIcons[slot3]] ?? 0) + 1
        
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
            let randomNumber: Int = Int.random(in: 1 ... 51)
            if (randomNumber == 1){
                _playerJackpot = _jackpot
                _jackpot = 1000
            }
            else{
                _playerJackpot = 0
            }
        }
        else{
            _playerPrize = 0
        }
        return [slot1, slot2, slot3, _playerBet, _playerPrize, _playerJackpot, _playerMoney, _jackpot]
    }
    
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
        return -1
    }
}
