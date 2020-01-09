//
//  ViewController.swift
//  SlotMachineApp
//
//  Created by Zhaoning Cai on 2020-01-08.
//  Copyright © 2020 CentennialCollege. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slotOneImageView: UIImageView!
    @IBOutlet weak var slotTwoImageView: UIImageView!
    @IBOutlet weak var slotThreeImageView: UIImageView!
    @IBOutlet weak var spinButton: UIButton!
    
    let slotMachine = SlotMachine()
    
    var slotMachineIconImages: Array<UIImage> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for slotMachineIcon in slotMachine.slotIcons{
            let iconImage: UIImage = UIImage(named: slotMachineIcon)!
            slotMachineIconImages.append(iconImage)
        }
    }

    @IBAction func spinStop(_ sender: UIButton) {
        let slots = self.slotMachine.spinSlotMachine()
        slotOneImageView.image = slotMachineIconImages[slots[0]]
        slotTwoImageView.image = slotMachineIconImages[slots[1]]
        slotThreeImageView.image = slotMachineIconImages[slots[2]]
    }
    
}

