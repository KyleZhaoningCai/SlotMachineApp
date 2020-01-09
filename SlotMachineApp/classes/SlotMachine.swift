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
        return [slot1, slot2, slot3]
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
