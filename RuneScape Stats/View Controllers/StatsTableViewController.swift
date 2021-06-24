//
//  StatsTableViewController.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 6/5/21.
//

import UIKit

class StatsTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "\(player.stats.name.capitalized)"
    
  }
  
  var arrIndexPath = [IndexPath]()
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return player.stats.skillvalues.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell", for: indexPath)
    let unformatedXP = player.stats.skillvalues[indexPath.row].xp
    var removeLastFromXP = String(unformatedXP)
    removeLastFromXP.removeLast()
    let unformatedXPToFormat = Int(removeLastFromXP) ?? 0
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let formattedXP = numberFormatter.string(from: NSNumber(value: unformatedXPToFormat)) ?? ""
    cell.textLabel?.text = "\(skillTitles[indexPath.row]) - \(player.stats.skillvalues[indexPath.row].level)"
    cell.detailTextLabel?.text = "\(formattedXP) xp"
    
    if unformatedXPToFormat == 0 {
      cell.selectionStyle = .none
    }
    cell.imageView?.image = UIImage(named: skillTitles[indexPath.row])
    return cell
  }
  
  // animate each UITableViewcell
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if arrIndexPath.contains(indexPath) == false {
      cell.alpha = 0
      UIView.animate(withDuration: 0.75, delay: 0.00 * Double(indexPath.row), animations: {
        cell.alpha = 1
      })
    arrIndexPath.append(indexPath)
  }
}
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "DetailSkillSegue" {
      
      guard let indexPath = tableView.indexPathForSelectedRow,
            let statsDetailVC = segue.destination as? StatsDetailViewController else { return }
      
      let selectedStat = player.stats.skillvalues[indexPath.row]
      statsDetailVC.selectedStat = selectedStat
      selectedLevelingStat = selectedStat
    }
  }
}
