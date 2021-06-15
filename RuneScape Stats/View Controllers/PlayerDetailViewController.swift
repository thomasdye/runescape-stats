//
//  PlayerDetailViewController.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 6/12/21.
//

import UIKit

class PlayerDetailViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var adventureLogTableView: UITableView!
  @IBOutlet weak var playerDetailLabel: UILabel!
  @IBOutlet weak var attackImage: UIImageView!
  @IBOutlet weak var strengthImage: UIImageView!
  @IBOutlet weak var defenceImage: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    title = stats.name
    self.adventureLogTableView.register(UITableViewCell.self, forCellReuseIdentifier: "AdventureLog")
    self.adventureLogTableView.dataSource = self
  }
  
  func setup() {
    // top images
    attackImage.image = UIImage(named: "Attack")
    strengthImage.image = UIImage(named: "Strength")
    defenceImage.image = UIImage(named: "Defence")
    
    
    // player detail label
    playerDetailLabel.numberOfLines = 0
    playerDetailLabel.font = UIFont(name: "RuneScape-UF", size: 20)
    playerDetailLabel.textAlignment = .center
    playerDetailLabel.text = "Combat Level: \(stats.combatlevel)\nRank:\(stats.rank)\nTotal XP:\(stats.totalxp)\nMelee: \(stats.melee)\nRanged: \(stats.ranged)\nMagic: \(stats.magic)"
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stats.activities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AdventureLog", for: indexPath)
    cell.textLabel?.numberOfLines = 0
    cell.textLabel?.font = UIFont(name: "RuneScape-UF", size: 25)
    
    // Configure the cell...
    let details = stats.activities[indexPath.row].details
    let unformattedDate = stats.activities[indexPath.row].date
    var date = unformattedDate.replacingOccurrences(of: "-", with: " ")
    date.removeLast(5)
    
    if date.starts(with: "0") {
      date.removeFirst()
    }
    
    for skill in skillTitles {
      if details.contains(skill) {
        cell.imageView?.image = UIImage(named: skill)
      }
    }
    cell.textLabel?.text = "\(date)\n\(details)"
    return cell
  }
}
