//
//  StatsDetailedViewController.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 6/6/21.
//

import UIKit

class StatsDetailedViewController: UIViewController {
  @IBOutlet weak var statsLabel: UILabel!
  @IBOutlet weak var levelProgressView: UIProgressView!
  @IBOutlet weak var currentLevelLabel: UILabel!
  @IBOutlet weak var nextLevelLabel: UILabel!
  @IBOutlet weak var levelProgressLabel: UILabel!
  @IBOutlet weak var statIconImage: UIImageView!
  
  var selectedStat: Skillvalue = Skillvalue(level: 0, xp: 0, rank: 0, id: 0)
  var nextLevel: Int = 0
  let lowerUIColor: UIColor = UIColor(red: 0.93, green: 0.26, blue: 0.19, alpha: 1.00)
  let lowerMiddleUIColor: UIColor = UIColor(red: 0.97, green: 0.53, blue: 0.11, alpha: 1.00)
  let upperMiddleUIColor: UIColor = UIColor(red: 0.98, green: 0.82, blue: 0.00, alpha: 1.00)
  let upperUIColor: UIColor = UIColor(red: 0.42, green: 0.78, blue: 0.12, alpha: 1.00)
  override func viewDidLoad() {
    super.viewDidLoad()
    title = skillTitles[selectedStat.id]
    setupStats()
    print("total skills: \(arrayOfStandardSkillLevels.count)")
  }
  
  func setupStats() {
    // formatting xp to remove tenths place decimal
    var unformattedXP = String(selectedStat.xp)
    unformattedXP.removeLast()
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
    
    // calculating progress as float
    let progress: Float = Float(remainingXP) / Float(levelDifference)
    var progressPercentage: Int = 0
    
    if selectedStat.level < 99 {
    progressPercentage = Int(progress * 100)
    } else {
      progressPercentage = 100
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
    
    // UI
    UIView.animate(withDuration: 1.0) {
      self.levelProgressView.setProgress(progress, animated: true)
    }
    
    if selectedStat.level < 99 {
    statsLabel.text = "Level: \(selectedStat.level)\nXP: \(formattedXP)\nNext: \(arrayOfStandardSkillLevels[selectedStat.level])\nRemaining: \(remainingXP)"
    currentLevelLabel.text = String(selectedStat.level)
    nextLevelLabel.text = String(selectedStat.level + 1)
    levelProgressLabel.text = "\(progressPercentage)%"
    statIconImage.image = UIImage(named: skillTitles[selectedStat.id])
    } else {
      statsLabel.text = "Level: \(selectedStat.level)\nXP: \(formattedXP)\nNext: Max\nRemaining: \(remainingXP)"
      currentLevelLabel.text = String(selectedStat.level)
      nextLevelLabel.text = String(selectedStat.level)
      levelProgressLabel.text = "\(progressPercentage)%"
      statIconImage.image = UIImage(named: skillTitles[selectedStat.id])
    }
  }
}
