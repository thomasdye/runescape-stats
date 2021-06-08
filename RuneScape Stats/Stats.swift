//
//  Stats.swift
//  RuneScape Stats
//
//  Created by Thomas Dye on 5/26/21.
//

import Foundation

// MARK: - Stats
struct Stats: Codable {
  var magic, questsstarted, totalskill, questscomplete: Int
  var questsnotstarted, totalxp, ranged: Int
  var activities: [Activity]
  var skillvalues: [Skillvalue]
  var name, rank: String
  var melee, combatlevel: Int
  var loggedIn: String
  var error: String?
}

// MARK: - Activity
struct Activity: Codable {
  var date, details, text: String
}

// MARK: - Skillvalue
struct Skillvalue: Codable {
  var level, xp, rank, id: Int
}
