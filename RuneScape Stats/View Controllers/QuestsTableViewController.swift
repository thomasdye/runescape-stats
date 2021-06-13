//
//  QuestsTableViewController.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 6/13/21.
//

import UIKit

class QuestsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      
      guard let numberOfQuests = stats.quests?.quests.count else { return 0 }
      return numberOfQuests
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestCell", for: indexPath)
      let quest = stats.quests?.quests[indexPath.row]
      guard let questTitle = quest?.title,
            let questStatus = quest?.status,
            let questDifficulty = quest?.difficulty,
            let questMembers = quest?.members,
            let questPoints = quest?.questPoints,
            let questEligible = quest?.userEligible else { return UITableViewCell() }
      
      var isMembers: String = ""
      var isEligible: String = ""
      var currentStatus: String = ""
      
      switch questMembers {
      case true:
        isMembers = "Yes"
      case false:
        isMembers = "No"
      }
      
      switch questEligible {
      case true:
        isEligible = "Yes"
      case false:
        isEligible = "No"
      }
      
      switch questStatus {
      case .completed:
        currentStatus = "Completed"
        cell.accessoryType = .checkmark
      case .notStarted:
        currentStatus = "Not Started"
        cell.accessoryType = .none
      case .started:
        currentStatus = "Started"
        cell.accessoryType = .none
      }
      cell.textLabel?.text = questTitle
      cell.detailTextLabel?.text = "Status: \(currentStatus)\nDifficulty: \(questDifficulty)\nMembers: \(isMembers)\nPoints: \(questPoints)\nEligible: \(isEligible)"
      
      return cell
    }
  
  // this doesnt work right... yet...
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let titleToSearchWithSpaces = stats.quests?.quests[indexPath.row].title else { return }
    let titleToSearch = titleToSearchWithSpaces.replacingOccurrences(of: " ", with: "%20")
    guard let url = URL(string: "https://runescape.wiki/?search=\(titleToSearch)") else { return }
    
    UIApplication.shared.open(url, options: [:], completionHandler: nil)

  }

}
