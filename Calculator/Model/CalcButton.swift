//
//  CalcButton.swift
//  Calculator
//
//  Created by Misha on 27.10.2022.
//  Copyright © 2022 London App Brewery. All rights reserved.
//

import UIKit

class CalcButton: UIButton {

    override var isSelected: Bool {
            didSet {
                if isSelected == true {
                    backgroundColor = UIColor.white.withAlphaComponent(1)
                    tintColor = UIColor.clear
                } else {
                    backgroundColor = .systemOrange
                }
                setNeedsDisplay()
            }
        }
}
