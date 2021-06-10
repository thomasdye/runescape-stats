//
//  Keyboard Dismissal.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 6/10/21.
//

import UIKit

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(hideKeyboard))
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc func hideKeyboard() {
    view.endEditing(true)
  }
}
