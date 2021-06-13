//
//  StatsDetailedViewController.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 6/6/21.
//

import UIKit

class StatsDetailViewController: UIViewController {
  @IBOutlet weak var statsLabel: UILabel!
  @IBOutlet weak var levelProgressView: UIProgressView!
  @IBOutlet weak var currentLevelLabel: UILabel!
  @IBOutlet weak var nextLevelLabel: UILabel!
  @IBOutlet weak var levelProgressLabel: UILabel!
  @IBOutlet weak var statIconImage: UIImageView!
  @IBOutlet weak var checkLevelButton: UIButton!
  @IBOutlet weak var checkLevelTextField: UITextField!
  @IBOutlet weak var calculateLevelLabel: UILabel!
  
  var selectedStat: Skillvalue = Skillvalue(level: 0, xp: 0, rank: 0, id: 0)
  var nextLevel: Int = 0
  let lowerUIColor: UIColor = UIColor(red: 0.93, green: 0.26, blue: 0.19, alpha: 1.00)
  let lowerMiddleUIColor: UIColor = UIColor(red: 0.97, green: 0.53, blue: 0.11, alpha: 1.00)
  let upperMiddleUIColor: UIColor = UIColor(red: 0.98, green: 0.82, blue: 0.00, alpha: 1.00)
  let upperUIColor: UIColor = UIColor(red: 0.42, green: 0.78, blue: 0.12, alpha: 1.00)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround() 
    title = skillTitles[selectedStat.id]
    print("stat level: \(selectedStat.level)")
    setupStats()
    print("total skills: \(arrayOfStandardSkillLevels.count)")
  }
  
  // setup stats
  func setupStats() {
    
    calculateLevelLabel.text = ""
    checkLevelButton.setTitle("Check Level", for: .normal)
    
    // formatting xp to remove tenths place decimal
    var unformattedXP = String(selectedStat.xp)
    
    if unformattedXP != "0" {
    unformattedXP.removeLast()
    }
    
    guard let formattedXP = Int(unformattedXP) else { return }
    
    // calculating remaining xp to next level
    var remainingXP: Int = 0
    
    if selectedStat.level < 99 {
      remainingXP = arrayOfStandardSkillLevels[selectedStat.level] - formattedXP
    } else {
      remainingXP = 0
    }
    
    // getting level XP difference
    var levelDifference:Int = 0
    
    if selectedStat.level < 99 {
    levelDifference = arrayOfStandardSkillLevels[selectedStat.level] - arrayOfStandardSkillLevels[selectedStat.level - 1]
    } else {
      levelDifference = 0
    }
    
    // calculating progress
    var progress: Float = 0.0
    var progressPercentage: Int = 0
    
    if selectedStat.level < 99 && selectedStat.xp > 0 {
      progress = Float(remainingXP) / Float(levelDifference)
      progressPercentage = Int(progress * 100)
    } else if selectedStat.level >= 99 {
      progress = 1
      progressPercentage = 100
    } else {
      progress = 0
      progressPercentage = 0
    }
    
    if progressPercentage <= 25 {
      levelProgressView.progressTintColor = lowerUIColor
    } else if progressPercentage <= 50 {
      levelProgressView.progressTintColor = lowerMiddleUIColor
    } else if progressPercentage <= 75 {
      levelProgressView.progressTintColor = upperMiddleUIColor
    } else {
      levelProgressView.progressTintColor = upperUIColor
    }
    
    // animate level percentage bar
    UIView.animate(withDuration: 1.0) {
      self.levelProgressView.setProgress(progress, animated: true)
    }
    
    // display text properly if level is less than 99 (catch for below current level and above max level)
    let formattedXPToUse = formatXPNumber(unformattedNumber: selectedStat.xp, removeLastDigit: true)
    let formattedRemainingXPToUse = formatXPNumber(unformattedNumber: remainingXP, removeLastDigit: false)
    var nextLevelXPToUse: String = ""
    
    
    if selectedStat.level < 99 {
    nextLevelXPToUse = formatXPNumber(unformattedNumber: arrayOfStandardSkillLevels[selectedStat.level], removeLastDigit: false)
    } else {
      nextLevelXPToUse = "0"
    }
    
    if selectedStat.level < 99 {
    statsLabel.text = "Level: \(selectedStat.level)\nXP: \(formattedXPToUse)\nNext: \(nextLevelXPToUse)\nRemaining: \(formattedRemainingXPToUse)"
    currentLevelLabel.text = String(selectedStat.level)
    nextLevelLabel.text = String(selectedStat.level + 1)
    levelProgressLabel.text = "\(progressPercentage)%"
    statIconImage.image = UIImage(named: skillTitles[selectedStat.id])
    } else {
      statsLabel.text = "Level: \(selectedStat.level)\nXP: \(formattedXPToUse)\nNext: Max\nRemaining: \(formattedRemainingXPToUse)"
      currentLevelLabel.text = String(selectedStat.level)
      nextLevelLabel.text = String(selectedStat.level)
      levelProgressLabel.text = "\(progressPercentage)%"
      statIconImage.image = UIImage(named: skillTitles[selectedStat.id])
    }
  }
  
  
  @IBAction func checkLevelButtonTapped(_ sender: Any) {
    
    // check level entered correctly
    // unwrap level as a string
    guard let levelAsString = checkLevelTextField.text else { return }
    
    // unwrap Int from string
    guard let levelAsInt = Int(levelAsString) else { return }
    
    // if level entered less than current level or greater than 99
    // I'll have to handle the exeptions for the levels past 99 later
    if levelAsInt <= selectedStat.level {
      let alert = UIAlertController(title: "Already Higher Level", message: "You are already a higher level than the level entered.", preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
      return
    } else if levelAsInt > 99 {
      let alert = UIAlertController(title: "Level Too High", message: "You have entered a level higher than the maximum possible level. Please try again.", preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
      return
    }
    
    if selectedStat.level < 99 {
      
      // Get current XP subtracted from level entered
      var currentXPAsString = String(selectedStat.xp)
      currentXPAsString.removeLast()
      guard let unwrappedCurrentXPAsInt = Int(currentXPAsString) else { return }
      let goalXP = arrayOfStandardSkillLevels[levelAsInt - 1]
      let difference = formatXPNumber(unformattedNumber: (goalXP - unwrappedCurrentXPAsInt), removeLastDigit: false)
      
      calculateLevelLabel.text = "Level Goal: \(levelAsInt)\nRemaining: \(difference)"
    }
  }
}
