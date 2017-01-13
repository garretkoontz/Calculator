//
//  TipViewController.swift
//  Calculator
//
//  Created by Garret Koontz on 1/9/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import AVFoundation

class TipViewController: UIViewController {
    
    
    @IBOutlet weak var tipAmountSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var enterTotalAmountLabel: UILabel!
    
    @IBOutlet weak var userInputTextField: UITextField!
    
    @IBOutlet weak var tipAmountLabel: UILabel!
    
    @IBOutlet weak var totalBillAmountLabel: UILabel!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var calculateButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var gratuitityLabel: UILabel!
    
    var moneySound = Bundle.main.url(forResource: "moneysound", withExtension: "mp3")!
    var moneyPlayer = AVAudioPlayer()
    
    func playSound() {
        
        moneyPlayer = try! AVAudioPlayer(contentsOf: moneySound)
        moneyPlayer.prepareToPlay()
        moneyPlayer.play()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInputTextField.keyboardType = .decimalPad
        userInputTextField.keyboardAppearance = .dark
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(self.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        tipAmountSegmentedControl.layer.cornerRadius = 3.0
        tipAmountSegmentedControl.layer.borderColor = UIColor(colorLiteralRed: 156/255, green: 144/255, blue: 93/255, alpha: 1.0).cgColor
        tipAmountSegmentedControl.layer.borderWidth = 4.0
        
    }
    func didTapView() {
        self.view.endEditing(true)
    }
    
    //MARK: - Actions
    
    @IBAction func calculateButtonTapped(_ sender: Any) {
        
        addPulseToCalculateButton()
        playSound()
        
        var tipPercentage: Double {
            
            if tipAmountSegmentedControl.selectedSegmentIndex == 0 {
                return 0.05
            } else if tipAmountSegmentedControl.selectedSegmentIndex == 1 {
                return 0.10
            } else {
                return 0.2
            }
        }
        
        let billAmount: Double? = Double(userInputTextField.text!)
        
        if let billAmount = billAmount {
            let tipAmount = billAmount * tipPercentage
            let totalBillAmount = billAmount + tipAmount
            
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            if let formattedTipAmount = formatter.string(from: tipAmount as NSNumber),
                let formattedBillAmount = formatter.string(from: totalBillAmount as NSNumber) {
                tipAmountLabel.text = "Tip: \(formattedTipAmount)"
                totalBillAmountLabel.text = "Total Bill: \(formattedBillAmount)"
            }
        }
        
        let button = sender as! UIButton
        let bounds = button.bounds
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6, options: .curveEaseInOut, animations: {
            button.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y - 20, width: bounds.size.width, height: bounds.size.height)
        }) { (success: Bool) in
            button.bounds = bounds
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.tipAmountLabel.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseIn, animations: {
            self.totalBillAmountLabel.alpha = 1
        }, completion: nil)
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        
        addPulse()
        
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseOut, animations: {
            self.tipAmountLabel.alpha = 1
        }) { (finished: Bool) in
            if finished {
                self.tipAmountLabel.text = "Tip Amount"
            }
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.3, options: .curveEaseOut, animations: {
            self.totalBillAmountLabel.alpha = 1
        }) { (finished: Bool) in
            if finished {
                self.totalBillAmountLabel.text = "Total Bill Amount"
                self.userInputTextField.text = ""
            }
        } 
    }
    
    
    @IBAction func randomColorButton(_ sender: Any) {
        
        addPulseToTitleButton()
    }
    
    
    //MARK: - Core Animations
    
    func addPulse() {
        
        let pulse = PulsingAnimation(numberOfPulses: 1, radius: 80, position: clearButton.center)
        pulse.animationDuration = 0.5
        pulse.backgroundColor = HelperFunction.getRandomColor().cgColor
        
        self.view.layer.insertSublayer(pulse, below: clearButton.layer)
        
    }
    
    func addPulseToTitleButton() {
        
        let labelPulse = PulsingAnimation(numberOfPulses: 1, radius: 200, position: gratuitityLabel.center)
        labelPulse.animationDuration = 0.5
        labelPulse.backgroundColor = HelperFunction.getRandomColor().cgColor
        
        self.view.layer.insertSublayer(labelPulse, below: gratuitityLabel.layer)
        
    }
    
    func addPulseToCalculateButton() {
        
        let buttonPulse = PulsingAnimation(numberOfPulses: 1, radius: 100, position: calculateButton.center)
        buttonPulse.animationDuration = 0.5
        buttonPulse.backgroundColor = HelperFunction.getRandomColor().cgColor
        
        self.view.layer.insertSublayer(buttonPulse, below: calculateButton.layer)
    }
}
