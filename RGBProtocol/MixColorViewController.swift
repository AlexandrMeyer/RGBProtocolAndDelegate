//
//  MixColorViewController.swift
//  RGBProtocol
//
//  Created by Александр on 3.09.21.
//

import UIKit

class MixColorViewController: UIViewController {
    
    @IBOutlet var colorMixView: UIView!
    
    @IBOutlet var redValueLabel: UILabel!
    @IBOutlet var greenValueLabel: UILabel!
    @IBOutlet var blueValueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redValueTextField: UITextField!
    @IBOutlet var greenValueTextField: UITextField!
    @IBOutlet var blueValueTextField: UITextField!
    
    var mixColor: UIColor!
    var delegate: MixColorViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redValueTextField.delegate = self
        greenValueTextField.delegate = self
        blueValueTextField.delegate = self
        
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        
        setupValue(for: redSlider, greenSlider, blueSlider)
        
        getSliderValue()
        setupColor()
    }
    
    override func viewWillLayoutSubviews() {
        colorMixView.layer.cornerRadius = colorMixView.frame.width / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
 
    @IBAction func redSliderAction(_ sender: UISlider) {
        updateValue(for: sender)
        setupColor()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        delegate.setColor(CGFloat(redSlider.value), CGFloat(greenSlider.value), CGFloat(blueSlider.value))
        
        dismiss(animated: true, completion: nil)
    }
    
    private func setupValue(for sliders: UISlider...) {
        sliders.forEach { slider in
            updateValue(for: slider)
        }
    }
    
    private func updateValue(for slider: UISlider) {
        switch slider {
        case redSlider:
            redValueLabel.text = string(from: redSlider)
            redValueTextField.text = string(from: redSlider)
        case greenSlider:
            greenValueLabel.text = string(from: greenSlider)
            greenValueTextField.text = string(from: greenSlider)
        default:
            blueValueLabel.text = string(from: blueSlider)
            blueValueTextField.text = string(from: blueSlider)
        }
    }
    
    private func setupColor() {
        colorMixView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1)
    }
    
    private func string(from slider: UISlider) -> String {
        String(format:"%.2f", slider.value)
    }
    
    private func alertController() {
            let alertController = UIAlertController(title: "Ошибка", message: "Диапазон ввводимый чисел от 0 до 1", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
            if self.redValueTextField.isFirstResponder {
                self.redValueTextField.text = ""
            } else if self.greenValueTextField.isFirstResponder {
                self.greenValueTextField.text = ""
            } else {
                self.blueValueTextField.text = ""
            }
            }
            alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func getSliderValue() {
        let ciColor = CIColor(color: mixColor)
        let red = ciColor.red
        let blue = ciColor.blue
        let green = ciColor.green

        redSlider.value = Float(red)
        greenSlider.value = Float(green)
        blueSlider.value = Float(blue)
    }
}

extension MixColorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard Float(textField.text!)! <= 1  else { alertController()
            return false
        }
        updateValueIfTextFieldIsEditing(for: textField)
        setupColor()
        return true
    }
    
    private func updateValueIfTextFieldIsEditing(for textField: UITextField) {
        switch textField.isEditing {
        case redValueTextField.isEditing:
            redValueLabel.text = redValueTextField.text
            redSlider.value = Float(redValueTextField.text ?? "")!
        case greenValueTextField.isEditing:
            greenValueLabel.text = greenValueTextField.text
            greenSlider.value = Float(greenValueTextField.text ?? "")!
        default:
            blueValueLabel.text = blueValueTextField.text
            blueSlider.value = Float(blueValueTextField.text ?? "")!
        }
        textField.resignFirstResponder()
    }
}
