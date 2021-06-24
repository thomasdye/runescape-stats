//
//  LevelingGuideViewController.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 6/21/21.
//

import UIKit

class LevelingGuideViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    
  }

  func setup() {
    var selectedStat: Skillvalue = selectedLevelingStat
    title = skillTitles[selectedStat.id]
  }
}
