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

// create empty stats
var stats: Stats = Stats(magic: 1,
                         questsstarted: 1,
                         totalskill: 1,
                         questscomplete: 1,
                         questsnotstarted: 1,
                         totalxp: 1,
                         ranged: 1,
                         activities: [.init(date: "",
                                            details: "",
                                            text: "")],
                         skillvalues: [.init(level: 1,
                                             xp: 1,
                                             rank: 1,
                                             id: 1)],
                         name: "",
                         rank: "",
                         melee: 1,
                         combatlevel: 1,
                         loggedIn: "")
