//
//  UIButtonExtension.swift
//  spinoff_62417_exam_s153901
//
//  Created by Magnus Enevoldsen on 09/05/2019.
//  Copyright © 2019 Magnus Enevoldsen. All rights reserved.
//

//The following code is borrowed from : https://gist.github.com/SAllen0400/a09754049fcdcc00695291b3a011fbbd

import Foundation
import UIKit

extension UITextField {
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.borderColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.5).cgColor
        layer.add(shake, forKey: "position")
    }
}
