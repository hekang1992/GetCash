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
    var fully: String?
    var sentence: sentenceModel?
    var residence: [residenceModel]?
    var de: deModel?
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

class sentenceModel: Codable {
    var add: String?
    var emigrants: String?
    var symbol: String?
    var suppose: Int?
    var lord: lordModel?
}

class lordModel: Codable {
    var attending: attendingModel?
    var weeks: attendingModel?
}

class attendingModel: Codable {
    var shrunk: String?
    var extraordinary: String?
}

class residenceModel: Codable {
    var used: Int?
    var blanc: String?
}

class deModel: Codable {
    var blanc: String?
}
