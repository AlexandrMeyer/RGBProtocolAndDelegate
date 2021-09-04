//
//  ViewController.swift
//  RGBProtocol
//
//  Created by Александр on 3.09.21.
//

import UIKit

protocol MixColorViewControllerDelegate {
    func setColor(_ redValue: CGFloat, _ greenValue: CGFloat, _ blueValue: CGFloat)
}

class StartViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mixColorVC = segue.destination as? MixColorViewController else { return }
        mixColorVC.mixColor = view.backgroundColor
        mixColorVC.delegate = self
    }
}

extension StartViewController: MixColorViewControllerDelegate {
    func setColor(_ redValue: CGFloat, _ greenValue: CGFloat, _ blueValue: CGFloat) {
        view.backgroundColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1)
    }
}
    
