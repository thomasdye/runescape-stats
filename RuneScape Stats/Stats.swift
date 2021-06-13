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
  var quests: Quests?
}

// MARK: - Activity
struct Activity: Codable {
  var date, details, text: String
}

// MARK: - Skillvalue
struct Skillvalue: Codable {
  var level, xp, rank, id: Int
}

struct Quests: Codable {
  var quests: [Quest]
  var loggedIn: String
}

struct Quest: Codable {
  let title: String
  let status: Status
  let difficulty: Int
  let members: Bool
  let questPoints: Int
  let userEligible: Bool
}

enum Status: String, Codable {
  case completed = "COMPLETED"
  case notStarted = "NOT_STARTED"
  case started = "STARTED"
}

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
                         loggedIn: "",
                         quests: Quests(quests: [], loggedIn: ""))
