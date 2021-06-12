//
//  StatsTableViewController.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 6/5/21.
//

import UIKit

class StatsTableViewController: UITableViewController {
  
  let reuseIdentifier: String = "StatsCell"

    override func viewDidLoad() {
      super.viewDidLoad()
      title = "\(stats.name)"

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      return stats.skillvalues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
      let unformatedXP = stats.skillvalues[indexPath.row].xp
      var removeLastFromXP = String(unformatedXP)
      removeLastFromXP.removeLast()
      let unformatedXPToFormat = Int(removeLastFromXP) ?? 0
      let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = .decimal
      let formattedXP = numberFormatter.string(from: NSNumber(value: unformatedXPToFormat)) ?? ""
      cell.textLabel?.text = "\(skillTitles[indexPath.row]) - \(stats.skillvalues[indexPath.row].level)"
      cell.detailTextLabel?.text = "\(formattedXP) xp"
      
      if unformatedXPToFormat == 0 {
        cell.selectionStyle = .none
      }
      cell.imageView?.image = UIImage(named: skillTitles[indexPath.row])
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "DetailSkillSegue" {
        
        guard let indexPath = tableView.indexPathForSelectedRow,
              let statsDetailVC = segue.destination as? StatsDetailedViewController else { return }
        
        let selectedStat = stats.skillvalues[indexPath.row]
        statsDetailVC.selectedStat = selectedStat
      }
    }
}
