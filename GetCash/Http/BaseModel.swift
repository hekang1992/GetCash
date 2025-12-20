//
//  BaseModel.swift
//  GetCash
//
//  Created by hekang on 2025/12/20.
//

class BaseModel: Codable {
    var hoping: String?
    var recollected: String?
    var awe: aweModel?
}

class aweModel: Codable {
    var studded: String?
    var extreme: String?
    var settled: [settledModel]?
}

class settledModel: Codable {
    var courteous: String?
    var inherited: [inheritedModel]?
}

class inheritedModel: Codable {
    var suspended: Int?
    var add: String?
    var emigrants: String?
    var lends: String?
    var casements: String?
    var painted: String?
    var dim: String?
    var blunted: String?
    var ashes: String?
    var hopeless: String?
}
