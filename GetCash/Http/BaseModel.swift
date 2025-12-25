//
//  BaseModel.swift
//  GetCash
//
//  Created by Bea Alcantara on 2025/12/20.
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
    var fane: faneModel?
    var hid: faneModel?
    var pardon: [String]?
    var quickness: [String]?
    var ridiculous: [ridiculousModel]?
    var got: [gotModel]?
    var relations: [relationsModel]?
    var userInfo: userInfoModel?
    var aether: aetherModel?
    var breathe: Int?
    var customerService: [customerServiceModel]?
    var departed: departedModel?
}

class departedModel: Codable {
    var indicated: String?
}

class settledModel: Codable {
    var courteous: String?
    var inherited: [inheritedModel]?
    var planet: String?
    var settled: [settledModel]?
    var suspended: Int?
    var departed: String?
    var shrunk: String?
    var fully: String?
    var add: String?
    var emigrants: String?
    var lends: String?
    var grasshoppers: String?
    var married: String?
    var possessed: String?
    var agnes: String?
    var permitted: String?
    var dancing: String?
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
    var narrative: String?
}

class sentenceModel: Codable {
    var add: String?
    var emigrants: String?
    var symbol: String?
    var suppose: Int?
    var lord: lordModel?
    var chiefly: String?
    var died: String?
    var reported: Int?
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
    var shrunk: String?
    var favourite: String?
    var fully: String?
}

class deModel: Codable {
    var blanc: String?
    var shrunk: String?
    var fully: String?
}

class faneModel: Codable {
    var used: Int?
}

class ridiculousModel: Codable {
    var warning: String?
    var outlived: String?
    var hoping: String?
}

class relationsModel: Codable {
    var shrunk: String?
    var bitter: String?
    var sweeten: String?
    var innocently: String?
    var disembodied: String?
    var mortals: [mortalsModel]?
    var renewing: String?
    var planet: String?
    var cheeks: String?
}

class userInfoModel: Codable {
    var userphone: String?
}

class aetherModel: Codable {
    var boundless: String?
    var mould: String?
    var mortal: String?
    var unsphered: String?
}

class customerServiceModel: Codable {
    var fully: String?
}

class gotModel: Codable {
    var shrunk: String?
    var favourite: String?
    var hoping: String?
    var dead: String?
    var rejoined: Int?
    var remark: String?
    var courteous: String?
    var mortals: [mortalsModel]?
    
    enum CodingKeys: String, CodingKey {
        case shrunk, favourite, hoping, dead, rejoined, remark, mortals
        case courteous
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shrunk = try container.decodeIfPresent(String.self, forKey: .shrunk)
        favourite = try container.decodeIfPresent(String.self, forKey: .favourite)
        hoping = try container.decodeIfPresent(String.self, forKey: .hoping)
        dead = try container.decodeIfPresent(String.self, forKey: .dead)
        rejoined = try container.decodeIfPresent(Int.self, forKey: .rejoined)
        remark = try container.decodeIfPresent(String.self, forKey: .remark)
        mortals = try container.decodeIfPresent([mortalsModel].self, forKey: .mortals)
        if let stringValue = try? container.decode(String.self, forKey: .courteous) {
            courteous = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .courteous) {
            courteous = String(intValue)
        }
    }
}

class mortalsModel: Codable {
    var planet: String?
    var courteous: Int?
    
    enum CodingKeys: String, CodingKey {
        case planet
        case courteous
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        planet = try container.decodeIfPresent(String.self, forKey: .planet)
        if let intValue = try? container.decode(Int.self, forKey: .courteous) {
            courteous = intValue
        } else if let stringValue = try? container.decode(String.self, forKey: .courteous) {
            courteous = Int(stringValue)
        } else {
            courteous = nil
        }
    }
}
