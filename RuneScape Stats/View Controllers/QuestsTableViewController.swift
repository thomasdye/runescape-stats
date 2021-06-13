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
      
      if questMembers == true {
        isMembers = "Yes"
      } else {
        isMembers = "No"
      }
      
      if questEligible == true {
        isEligible = "Yes"
      } else {
        isEligible = "No"
      }
      
      if questStatus == .completed {
        cell.accessoryType = .checkmark
        currentStatus = "Completed"
      } else if questStatus == .notStarted {
        cell.accessoryType = .none
        currentStatus = "Not Started"
      } else if questStatus == .started {
        cell.accessoryType = .none
        currentStatus = "Started"
      }
      
      
      
      cell.textLabel?.text = "\(questTitle)\nStatus: \(currentStatus)\nDifficulty: \(questDifficulty)\nMembers: \(isMembers)\nPoints: \(questPoints)\nEligible: \(isEligible)"


        return cell
    }


  
    // MARK: - Navigation
  
  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
    guard let titleToSearchWithSpaces = stats.quests?.quests[indexPath.row].title else { return }
    let titleToSearch = titleToSearchWithSpaces.replacingOccurrences(of: " ", with: "%20")
    guard let url = URL(string: "https://runescape.wiki/?search=\(titleToSearch)") else { return }
    
    UIApplication.shared.open(url, options: [:], completionHandler: nil)

  }
  

}
