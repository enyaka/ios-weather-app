//
//  UIViewController+Ext.swift
//  WeatherApp
//
//  Created by Ensar Yasin Karaköse on 17.11.2022.
//

import UIKit

extension UIViewController{
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
