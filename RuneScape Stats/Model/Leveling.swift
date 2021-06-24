//
//  Leveling.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 6/21/21.
//

import Foundation

var selectedLevelingStat: Skillvalue = Skillvalue(level: 0, xp: 0, rank: 0, id: 0)

struct Attack {
  var title: String
  var level: Int
  var experience: Int
  var nextLevel: Int
  var experienceToNextLevel: Int
}
