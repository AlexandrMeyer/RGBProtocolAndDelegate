//
//  ViewController.swift
//  RGBProtocol
//
//  Created by Александр on 3.09.21.
//

import UIKit

protocol MixColorViewControllerDelegate {
    func setColor(_ color: UIColor)
}

class StartViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mixColorVC = segue.destination as? MixColorViewController else { return }
        mixColorVC.delegate = self
        mixColorVC.mixColor = view.backgroundColor
    }
}

extension StartViewController: MixColorViewControllerDelegate {
    func setColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
    
