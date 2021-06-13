//
//  QuestViewController.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 6/13/21.
//

import UIKit

class QuestViewController: UIViewController {
  @IBOutlet weak var questsDetailLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
        // Do any additional setup after loading the view.
    }
  
  func setup() {
    // quests detail label
    questsDetailLabel.numberOfLines = 0
    questsDetailLabel.font = UIFont(name: "RuneScape-UF", size: 20)
    questsDetailLabel.textAlignment = .center
    questsDetailLabel.text = "Started: \(stats.questsstarted)\nNot Started: \(stats.questsnotstarted)\nComplete: \(stats.questscomplete)"
  }
}
