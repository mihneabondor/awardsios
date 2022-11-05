//
//  struct.swift
//  Awards
//
//  Created by Mihnea on 6/29/22.
//

import Foundation
import UIKit

public struct Award : Codable {
    var name : String
    var image : Data
    var count : Int
}

public struct Prediction {
    var classification: String
    var confidencePercentage: String
}

public struct UserPrefs : Codable {
    var limitedEditToggle : Bool = true
}

struct leChallenges : Codable {
    var name, id : String
    var month, day : Int
}

struct dbAward : Identifiable, Hashable {
    var id : String
    var name, imgPath, collection : String
    var image : Data
    var orderNo : Int
}

