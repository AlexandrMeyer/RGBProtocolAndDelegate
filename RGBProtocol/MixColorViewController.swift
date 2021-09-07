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
        
        colorMixView.backgroundColor = mixColor
        
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        
        getSliderValue()
        setValue(for: redValueLabel, greenValueLabel, blueValueLabel)
        setValue(for: redValueTextField, greenValueTextField, blueValueTextField)
    }
    
    override func viewWillLayoutSubviews() {
        colorMixView.layer.cornerRadius = colorMixView.frame.width / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
 
    @IBAction func rgbSliderAction(_ sender: UISlider) {
        switch sender {
        case redSlider:
            setValue(for: redValueLabel)
            setValue(for: redValueTextField)
        case greenSlider:
            setValue(for: greenValueLabel)
            setValue(for: greenValueTextField)
        default:
            setValue(for: blueValueLabel)
            setValue(for: blueValueTextField)
        }
        setupColor()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        delegate.setColor(colorMixView.backgroundColor ?? .white)
        dismiss(animated: true, completion: nil)
    }
    
    private func setValue(for labels: UILabel...) {
        labels.forEach { label in
            switch label {
            case redValueLabel:
                label.text = string(from: redSlider)
            case greenValueLabel:
                label.text = string(from: greenSlider)
            default:
                label.text = string(from: blueSlider)
            }
        }
    }
    
    private func setValue(for textFields: UITextField...) {
        textFields.forEach { textField in
            switch textField {
            case redValueTextField:
                textField.text = string(from: redSlider)
            case greenValueTextField:
                textField.text = string(from: greenSlider)
            default:
                textField.text = string(from: blueSlider)
            }
        }
    }
    
    private func setupColor() {
        colorMixView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1)
    }
    
    private func getSliderValue() {
        let ciColor = CIColor(color: mixColor)
        
        redSlider.value = Float(ciColor.red)
        greenSlider.value = Float(ciColor.green)
        blueSlider.value = Float(ciColor.blue)
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
    
    @objc private func didTapDone() {
        view.endEditing(true)
    }
}

extension MixColorViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        if let currentValue = Float(text),  currentValue <= 1 {
        switch textField {
        case redValueTextField:
            redSlider.setValue(currentValue, animated: true)
            setValue(for: redValueLabel)
        case greenValueTextField:
            greenSlider.setValue(currentValue, animated: true)
            setValue(for: greenValueLabel)
        default:
            blueSlider.setValue(currentValue, animated: true)
            setValue(for: blueValueLabel)
        }
        setupColor()
        return
    }
        alertController()
  }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        textField.inputAccessoryView = keyboardToolbar
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDone)
        )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
    
}
