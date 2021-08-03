//
//  ExperienceTables.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 6/6/21.
//

import Foundation

let arrayOfStandardSkillLevels: [Int] = [0, 83, 174, 276, 388, 512, 650, 801, 969, 1154, 1358, 1584, 1833, 2107, 2411, 2746, 3115, 3523, 3973, 4470, 5018, 5624, 6291, 7028, 7842, 8740, 9730, 10824, 12031, 13363, 14833, 16456, 18247, 20224, 22406, 24815, 27473, 30408, 33648, 37224, 41171, 45529, 50339, 55649, 61512, 67983, 75127, 83014, 91721, 101333, 111945, 123660, 136594, 150872, 166636, 184040, 203254, 224446, 247886, 273742, 302288, 333804, 368599, 407015, 449428, 496254, 547953, 605032, 668051, 737627, 814445, 899257, 992895, 1096278, 1210421, 1336443, 1475581, 1629200, 1798808, 1968068, 2192818, 2421087, 2673114, 2951373, 3258594, 3597792, 3972294, 4385776, 4842295, 5346332, 5902831, 6517253, 7195629, 7944614, 8771558, 9684557, 10692629, 11805606, 13034431]

func formatXPNumber(unformattedNumber: Int, removeLastDigit: Bool) -> String {
  
  // Pass number and index path
  let unformatedXP = unformattedNumber
  
  // Removing tenths place from number as string
  var removeLastFromXP = String(unformatedXP)
  
  if removeLastDigit == true {
  removeLastFromXP.removeLast()
  }
  
  // Reverting to Int
  let unformatedXPToFormat = Int(removeLastFromXP) ?? 0
  
  // Formatting to .decimal
  let numberFormatter = NumberFormatter()
  numberFormatter.numberStyle = .decimal
  
  // Getting formatted number as a string
  let formattedXP = numberFormatter.string(from: NSNumber(value: unformatedXPToFormat)) ?? ""
  
  return formattedXP
}