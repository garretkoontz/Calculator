//
//  SplitViewController.swift
//  Calculator
//
//  Created by Garret Koontz on 1/9/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import AVFoundation

class SplitViewController: UIViewController {
    
    @IBOutlet weak var totalAmount: UILabel!
    
    @IBOutlet weak var totalBillTextField: UITextField!
    
    @IBOutlet weak var partyOfTextField: UITextField!
    
    @IBOutlet weak var partyOfStepper: UIStepper!
    
    @IBOutlet weak var splitPayLabel: UILabel!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var calculateButton: UIButton!
    
    @IBOutlet weak var infoButton: UIButton!
    
    let interactor = Interactor()
    
    var moneySound = Bundle.main.url(forResource: "moneysound", withExtension: "mp3")!
    var moneyPlayer = AVAudioPlayer()
    
    
    func playSound() {
        moneyPlayer = try! AVAudioPlayer(contentsOf: moneySound)
        moneyPlayer.prepareToPlay()
        moneyPlayer.play()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        partyOfStepper.autorepeat = true
        partyOfStepper.minimumValue = 1
        partyOfStepper.maximumValue = 99
        partyOfTextField.text = "\(Int(partyOfStepper.value))"
        partyOfStepper.addTarget(self, action: #selector(stepperValueChanged(stepper:)), for: .valueChanged)
        
        
        totalBillTextField.keyboardType = .decimalPad
        totalBillTextField.keyboardAppearance = .dark
        partyOfTextField.keyboardType = .numberPad
        partyOfTextField.keyboardAppearance = .dark
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(self.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        
        splitPayLabel.text = ""
        
        
        partyOfStepper.layer.cornerRadius = 3.0
        partyOfStepper.layer.borderColor = UIColor(colorLiteralRed: 156/255, green: 144/255, blue: 93/255, alpha: 1.0).cgColor
        partyOfStepper.layer.borderWidth = 3.0
    }
    
    func didTapView() {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func calculateButtonTapped(_ sender: Any) {
        
        playSound()
        
        addPulseToCalculateButton()
        
        let button = sender as! UIButton
        let bounds = button.bounds
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6, options: .curveEaseInOut, animations: {
            button.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y - 20, width: bounds.size.width, height: bounds.size.height)
        }) { (success: Bool) in
            if success {
                button.bounds = bounds
            }
        }
        
        let billAmount: Double? = Double(totalBillTextField.text!)
        
        let partyNumber: Int? = Int(partyOfTextField.text!)
        
        
        if let billAmount = billAmount,
            let partyNumber = partyNumber {
            
            let totalBillAmount = Double(billAmount) / Double(partyNumber)
            
            let formatter = NumberFormatter()
            
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            if let formattedAmount = formatter.string(from: totalBillAmount as NSNumber) {
                splitPayLabel.text = "Each person will pay \(formattedAmount)"
            }
        }
        self.splitPayLabel.alpha = 1
    }
    
    
    func stepperValueChanged(stepper: UIStepper) {
        
        let stepperMapping: [UIStepper: UITextField] = [partyOfStepper: partyOfTextField]
        stepperMapping[stepper]!.text = "\(Int(stepper.value))"
        
    }
    
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        
        addPulse()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.splitPayLabel.alpha = 0
        }) { (finished: Bool) in
            self.totalBillTextField.text = ""
            self.partyOfTextField.text = "1"
        }
    }
    
    
    //MARK: - Core Animations
    
    func addPulse() {
        
        let pulse = PulsingAnimation(numberOfPulses: 1, radius: 80, position: clearButton.center)
        pulse.animationDuration = 0.5
        pulse.backgroundColor = getRandomColor().cgColor
        
        self.view.layer.insertSublayer(pulse, below: clearButton.layer)
    }
    
    func addPulseToCalculateButton() {
        
        let pulse = PulsingAnimation(numberOfPulses: 1, radius: 100, position: calculateButton.center)
        pulse.animationDuration = 0.5
        pulse.backgroundColor = getRandomColor().cgColor
        
        self.view.layer.insertSublayer(pulse, below: calculateButton.layer)
        
    }
    
    
    func getRandomColor() -> UIColor {
        
        let randomRed:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }

    
    // Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? InfoViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
        }
        
    }
    
}

extension SplitViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
}





