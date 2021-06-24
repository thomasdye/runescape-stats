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
    title = player.stats.name
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
    playerDetailLabel.text = "Combat Level: \(player.stats.combatlevel)\nRank:\(player.stats.rank)\nTotal XP:\(player.stats.totalxp)\nMelee: \(player.stats.melee)\nRanged: \(player.stats.ranged)\nMagic: \(player.stats.magic)"
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return player.stats.activities.count
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    cell.alpha = 0
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0.05 * Double(indexPath.row),
      animations: {
      cell.alpha = 1
    })
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AdventureLog", for: indexPath)
    cell.textLabel?.numberOfLines = 0
    cell.textLabel?.font = UIFont(name: "RuneScape-UF", size: 19)
    
    // Configure the cell...
    let details = player.stats.activities[indexPath.row].details
    let unformattedDate = player.stats.activities[indexPath.row].date
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
