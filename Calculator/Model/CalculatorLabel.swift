//
//  CalculatorLabel.swift
//  Calculator
//
//  Created by Misha on 26.10.2022.
//  Copyright © 2022 London App Brewery. All rights reserved.
//

import UIKit

class CalculatorLabel: UILabel {
    
    func digitsLimit(label: UILabel, limit: Int) {
        guard let textAsNSString = label.text as? NSString else {fatalError()}
        if textAsNSString.length > limit {
            label.text = textAsNSString.substring(with: NSRange(location: 0, length: textAsNSString.length > limit ? limit : textAsNSString.length))
        }
    }
    
    override var text: String? {
        didSet {
            if text != nil {
                digitsLimit(label: self, limit: 9)
            }
        }
    }
}


