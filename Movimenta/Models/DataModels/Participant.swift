//
//  Participant.swift
//  Movimenta
//
//  Created by Marwan  on 7/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Participant: ModelCommonProperties {
  var id: String?
  var type: ParticipantType
  var link: URL?
  var content: String?
  var title: String?
  var excerpt: String?
  var name: String?
  var firstName: String?
  var lastName: String?
  var profession: String?
  var image: URL?
  var website: URL?
  var phone: String?
  var email: String?
  var facebook: URL?
  var twitter: URL?
  var linkedin: URL?
  var googleplus: URL?
  var youtube: URL?
  var tumblr: URL?
  var vimeo: URL?
  var instagram: URL?
  
  var fullName: String {
    let names = [firstName, lastName].flatMap({ $0 }).joined(separator: " ")
    return names.isEmpty ? "N/A" : names
  }
}

extension Participant {
  enum ParticipantType: String {
    case Organizer = "organizers"
    case Speaker = "speakers"
    case Artist = "artists"
    case Company = "companies"
    case Sponsor = "sponsors"
    case Default = "default"
    
    var sectionDisplayName: String {
      switch self {
      case .Artist:
        return Strings.artists()
      case .Company:
        return Strings.companies()
      case .Default:
        return Strings.participants()
      case .Organizer:
        return Strings.organizers()
      case .Speaker:
        return Strings.speakers()
      case .Sponsor:
        return Strings.sponsors()
      }
    }
  } 
}

extension Participant: Parsable {
  static func objectsDictionary(fromArray json: [JSON]?, type: ParticipantType = .Default) -> [String : Participant]? {
    guard let jsonArray = json else {
      return nil
    }
    
    var parsedObjects = [String: Participant]()
    for jsonObject in jsonArray {
      var objectWithType = jsonObject
      objectWithType["type"].string = type.rawValue
      
      guard let generatedObject = objectElement(from: objectWithType) else {
        continue
      }
      parsedObjects[generatedObject.key] = generatedObject.value
    }
    return parsedObjects
  }
  
  static func objects(from json: JSON, type: ParticipantType = .Default) -> [Participant]? {
    guard let jsonArray = json.array else {
      return nil
    }
    
    var parsedObjects = [Participant]()
    for jsonObject in jsonArray {
      var objectWithType = jsonObject
      objectWithType["type"].string = type.rawValue
      
      guard let generatedObject = object(from: objectWithType) else {
        continue
      }
      parsedObjects.append(generatedObject)
    }
    return parsedObjects
  }
  
  static func object(from json: JSON) -> Participant? {
    let id = json["id"].stringValue
    let type = ParticipantType(rawValue: json["type"].stringValue) ?? .Default
    let link = json["link"].url
    let content = json["content"].string
    let title = json["title"].string
    let excerpt = json["excerpt"].string
    let name = json["name"].string
    let firstName = json["first_name"].string
    let lastName = json["last_name"].string
    let profession = json["profession"].string
    let image = json["image"].url
    let website = json["website"].url
    let phone = json["phone"].string
    let email = json["email"].string
    let facebook = json["facebook"].url
    let twitter = json["twitter"].url
    let linkedin = json["linkedin"].url
    let googleplus = json["googleplus"].url
    let youtube = json["youtube"].url
    let tumblr = json["tumblr"].url
    let vimeo = json["vimeo"].url
    let instagram = json["instagram"].url
    
    return Participant(id: id, type: type, link: link, content: content, title: title, excerpt: excerpt, name: name, firstName: firstName, lastName: lastName, profession: profession, image: image, website: website, phone: phone, email: email, facebook: facebook, twitter: twitter, linkedin: linkedin, googleplus: googleplus, youtube: youtube, tumblr: tumblr, vimeo: vimeo, instagram: instagram)
  }
}

//MARK: - Array extensions
extension Array where Element == Participant {
  mutating func appendUnique(participant: Participant) {
    if !self.contains(participant) {
      append(participant)
    }
  }
}
