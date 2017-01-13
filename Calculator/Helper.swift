//
//  Helper.swift
//  Calculator
//
//  Created by Garret Koontz on 1/13/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class HelperFunction {
    
    static func getRandomColor() -> UIColor {
        
        let randomRed:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
}
