//
//  AdventureLogViewController.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 6/6/21.
//

import UIKit

class AdventureLogViewController: UIViewController {

  @IBOutlet weak var adventureLabel: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  func setup() {
    var adventureText: String = ""
    
    // fix date format
    
    for log in stats.activities {
      print(log.details)
      adventureText = adventureText + "\(log.date)\n\(log.details)\n\n"
    }
    adventureLabel.text = adventureText
  }
  
}
