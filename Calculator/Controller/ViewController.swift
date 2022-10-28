//
//  ViewController.swift
//  Calculator
//
//  Created by Angela Yu on 10/09/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var displayLabel: CalculatorLabel!
    @IBOutlet private weak var makeZeroButton: UIButton!
    @IBOutlet private weak var dotButton: UIButton!
    @IBOutlet private var calcButtons: [CalcButton]!
    
    private let defaults = UserDefaults.standard
    
    private var isFinishedPrintingNumber: Bool = true
    private var currentValue: Double = 0
    private var resultValue: Double = 0
    private var memoryValue: Double = 0
    private var isButtonSelected: Bool = false
    
    
    enum Operations {
        case add, divide, substract, multiply, none
    }
    
    private var operation: Operations = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLabel.text = defaults.object(forKey: "lastText") as? String
        operation = .none
    }
    
    private func storeData() {
        defaults.set(displayLabel.text, forKey: "lastText")
    }
    
    private func deselectAllButtons() {
        for button in calcButtons {
            if button.isSelected {
                if !resultValue.isNaN && !resultValue.isInfinite {
                    memoryValue = Double(displayLabel.text!)!
                    button.isSelected = false
                    button.isUserInteractionEnabled = true
                    isButtonSelected = false
                } else {
                    button.isSelected = false
                    button.isUserInteractionEnabled = true
                    isButtonSelected = false
                }
            }
        }
    }
    
    //MARK: - Calculation functions and number formatting
    
    private func scientificFormat() -> String {
        
        if resultValue.isNaN || resultValue.isInfinite {
            displayLabel.text = "Idiot..."
            makeZeroButton.setTitleWithOutAnimation(title: "C")
        } else {
            if resultValue.decimalCount() + resultValue.integerCount() >= 8 {
                return resultValue.scientificFormatted
            } else {
                return String(resultValue)
            }
        }
        return String(resultValue)
    }
    
    private func isInt() {
        if displayLabel.text?.range(of: "e", options: .regularExpression) == nil {
            if floor(resultValue) == resultValue {
                displayLabel.text = String(Int(resultValue))
            }
        }
    }
    
    private func add() {
        resultValue = currentValue + memoryValue
        displayLabel.text = scientificFormat()
        isInt()
        isFinishedPrintingNumber = true
        operation = .none
    }
    
    private func divide() {
        resultValue = currentValue / memoryValue
        if resultValue.isNaN || resultValue.isInfinite {
            displayLabel.text = "Idiot..."
            makeZeroButton.setTitleWithOutAnimation(title: "C")
        } else {
            displayLabel.text = scientificFormat()
            isInt()
            isFinishedPrintingNumber = true
            operation = .none
        }
    }
    
    private func substract() {
        resultValue = currentValue - memoryValue
        displayLabel.text = scientificFormat()
        isInt()
        isFinishedPrintingNumber = true
        operation = .none
    }
    
    private func multiply() {
        resultValue = currentValue * memoryValue
        displayLabel.text = scientificFormat()
        isInt()
        isFinishedPrintingNumber = true
        operation = .none
    }
    
    private func operations(_ operation: Operations = .none) {
        if operation == .add {
            add()
        } else if operation == .divide {
            divide()
        } else if operation == .substract {
            substract()
        } else if operation == .multiply {
            multiply()
        }
    }
    
    private func performOperation(_ operation: Operations = .none) {
        isFinishedPrintingNumber = true
        isButtonSelected = true
        operations(operation)
        currentValue = resultValue
        storeData()
        self.operation = operation
    }
    
    private func saveValue() {
        if resultValue.isNaN == true || resultValue.isInfinite == true {
            displayLabel.text = "Idiot..."
            makeZeroButton.setTitleWithOutAnimation(title: "C")
        } else {
            currentValue = Double(displayLabel.text!)!
        }
    }
    
    //MARK: - Numbers and Calculation Methods Buttons
    
    @IBAction private func supportButtonPressed(_ sender: UIButton) {
        
        let number = Double(displayLabel.text!) ?? 0
        deselectAllButtons()
        
        if let supportButton = sender.currentTitle {
            switch supportButton {
            case "+/-":
                displayLabel.text = String(number * -1)
                makeZeroButton.setTitleWithOutAnimation(title: "C")
            case "AC":
                displayLabel.text = "0"
                memoryValue = 0
                currentValue = 0
                resultValue = 0
                operation = .none
            case "C":
                displayLabel.text = "0"
                memoryValue = 0
                currentValue = 0
                resultValue = 0
                operation = .none
                makeZeroButton.setTitleWithOutAnimation(title: "AC")
            case "%":
                displayLabel.text = String(number / 100)
                makeZeroButton.setTitleWithOutAnimation(title: "C")
            default:
                if resultValue.isNaN == true || resultValue.isInfinite == true {
                    displayLabel.text = "Idiot..."
                    makeZeroButton.setTitleWithOutAnimation(title: "C")
                } else {
                    performOperation(operation)
                    memoryValue = 0
                    operation = .none
                }
            }
            storeData()
        }
    }
    
    @IBAction private func calcButtonPressed(_ sender: UIButton) {
        
        //What should happen when a non-number button is pressed
        dotButton.isUserInteractionEnabled = true
        deselectAllButtons()
        
        guard Double(displayLabel.text!) != nil else {return}
        
        if let calcMethod = sender.currentTitle {
            switch calcMethod {
            case "÷":
                sender.isUserInteractionEnabled = false
                performOperation(operation)
                saveValue()
                operation = .divide
            case "×":
                sender.isUserInteractionEnabled = false
                performOperation(operation)
                saveValue()
                operation = .multiply
            case "+":
                sender.isUserInteractionEnabled = false
                performOperation(operation)
                saveValue()
                operation = .add
            case "-":
                sender.isUserInteractionEnabled = false
                performOperation(operation)
                saveValue()
                operation = .substract
            default:
                operation = .none
            }
        }
        
        if isButtonSelected == true {
            deselectAllButtons()
            sender.isSelected = true
            sender.isUserInteractionEnabled = false
        }
        storeData()
    }
    
    @IBAction private func numButtonPressed(_ sender: UIButton) {
        
        //What should happen when a number is entered into the keypad
        deselectAllButtons()
        
        if resultValue.isNaN == true || resultValue.isInfinite == true {
            currentValue = 0
            resultValue = 0
            operation = .none
            makeZeroButton.setTitleWithOutAnimation(title: "C")
        }
        
        if displayLabel.text?.range(of: ".", options: .regularExpression) != nil {
            if sender.currentTitle == "." {
                dotButton.isUserInteractionEnabled = false
            }
        }
        
        if isFinishedPrintingNumber == true && displayLabel.text != "0" && sender.currentTitle == "." {
            displayLabel.text = "0"
        }
        
        if let numValue = sender.currentTitle {
            
            if displayLabel.text == "0" && numValue == "." {
                displayLabel.text = displayLabel.text! + numValue.dropLast()
                isFinishedPrintingNumber = false
            } else if displayLabel.text == "0" {
                isFinishedPrintingNumber = true
            }
            
            if isFinishedPrintingNumber {
                displayLabel.text = numValue
                isFinishedPrintingNumber = false
            } else {
                displayLabel.text = displayLabel.text! + numValue
                makeZeroButton.setTitleWithOutAnimation(title: "C")
            }
        }
        
        if sender.currentTitle != "0" {
            makeZeroButton.setTitleWithOutAnimation(title: "C")
        }
        
        memoryValue = Double(displayLabel.text!)!
        storeData()
    }
}


//MARK: - Extensions - UIButton, String, Double, Formatter, Numeric

extension UIButton {
    fileprivate func setTitleWithOutAnimation(title: String?) {
        UIView.setAnimationsEnabled(false)
        
        setTitle(title, for: .normal)
        
        layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
}

extension String {
    fileprivate func maxLength(length: Int) -> String {
        var str = self
        let nsString = str as NSString
        if nsString.length >= length {
            str = nsString.substring(with:
                                        NSRange(
                                            location: 0,
                                            length: nsString.length > length ? length : nsString.length)
            )
        }
        return  str
    }
}

extension Double {
    fileprivate func decimalCount() -> Int {
        let integerString = String(Int(self))
        let doubleString = String(Double(self))
        let decimalCount = doubleString.count - integerString.count - 1
        
        return decimalCount
    }
    
    fileprivate func integerCount() -> Int {
        let integerString = String(Int(self))
        
        return integerString.count
    }
}

extension Formatter {
    fileprivate static let scientific: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = "0.###E+0"
        formatter.exponentSymbol = "e"
        return formatter
    }()
}

extension Numeric {
    fileprivate var scientificFormatted: String {
        return Formatter.scientific.string(for: self) ?? ""
    }
}
