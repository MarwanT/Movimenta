//
//  Event.swift
//  Movimenta
//
//  Created by Marwan  on 7/23/17.
//  Copyright © 2017 Keeward. All rights reserved.
//

import CoreLocation
import Foundation
import SwiftyJSON

struct Event: ModelCommonProperties {
  var id: String?
  var link: URL?
  var content: String?
  var title: String?
  var excerpt: String?
  var subtitle: String?
  var languageCode: String?
  var typesIds: [String]?
  var categoriesIds: [String]?
  var image: URL?
  var venueId: String?
  var coordinates: CLLocationCoordinate2D?
  var address: String?
  var organizersIds: [String]?
  var speakersIds: [String]?
  var artistsIds: [String]?
  var companiesIds: [String]?
  var sponsorsIds: [String]?
  var dates: [DateRange]?
  
  var isBookmarked: Bool {
    guard let id = id else {
      return false
    }
    return DataManager.shared.bookmarked(eventId: id)
  }
  
  var categories: [Category] {
    return generateCategories()
  }
  
  var artists: [Participant] {
    return artistsCollection()
  }
  
  var speakers: [Participant] {
    return speakersCollection()
  }
  
  var sponsors: [Participant] {
    return sponsorsCollection()
  }
  
  var companies: [Participant] {
    return companiesCollection()
  }
  
  var organizers: [Participant] {
    return organizersCollection()
  }
  
  var participants: [Participant] {
    return artists + speakers + sponsors + companies + organizers
  }
  
  var venue: Venue? {
    return DataManager.shared.venue(id: venueId)
  }
  
  var displayedCategoryLabel: String {
    return categories.first?.displayStrings().first ?? ""
  }
  
  var displayedPrticipantsLabel: String {
    let names = participants.flatMap { (participant) -> String? in
      let name = participant.fullName.trimed()
      return name.isEmpty ? nil : name
    }
    return names.joined(separator: ", ")
  }
  
  func preferredDateRange(for givenDate: Date = Date()) -> DateRange? {
    return dates?.preferredDateRange(for: givenDate)
  }
  
  func startsWithin(minutes: Int) -> Bool {
    guard let dates = dates else {
      return false
    }
    
    for date in dates {
      if date.startsWithin(minutes: minutes) {
        return true
      }
    }
    
    return false
  }
  
  func happens(in dateRange: DateRange) -> Bool {
    guard let dates = dates else {
      return false
    }
    for date in dates {
      if date.intercept(with: dateRange) {
        return true
      }
    }
    return false
  }
  
  /// return false in case of error
  func within(kilometers: Double, to coordinates: CLLocationCoordinate2D) -> Bool {
    guard let eventCoordinates = self.coordinates else {
      return false
    }
    // distance in Km
    let distance = CLLocationCoordinate2D.getDistance(fromCoordinates: eventCoordinates, toCoordinates: coordinates)/1000
    return distance <= kilometers
  }
}

//MARK: Helpers
extension Event {
  fileprivate func generateCategories() -> [Category] {
    var tempArray = [Category]()
    categoriesIds?.forEach({ (id) in
      guard var cat = DataManager.shared.categories[id] else {
        return
      }
      
      if let subCat = cat.subCategories, subCat.count > 0 {
        var subCategories = [Category]()
        subCat.forEach({
          if let id = $0.id, (categoriesIds?.contains(id) ?? false) {
            subCategories.append($0)
          }
        })
        cat.subCategories = subCategories
      }
      
      tempArray.append(cat)
    })
    return tempArray
  }
  
  fileprivate func artistsCollection() -> [Participant] {
    return participants(with: artistsIds ?? [], in: DataManager.shared.artists)
  }
  
  fileprivate func speakersCollection() -> [Participant] {
    return participants(with: speakersIds ?? [], in: DataManager.shared.speakers)
  }
  
  fileprivate func sponsorsCollection() -> [Participant] {
    return participants(with: sponsorsIds ?? [], in: DataManager.shared.sponsers)
  }
  
  fileprivate func companiesCollection() -> [Participant] {
    return participants(with: companiesIds ?? [], in: DataManager.shared.companies)
  }
  
  fileprivate func organizersCollection() -> [Participant] {
    return participants(with: organizersIds ?? [], in: DataManager.shared.organizers)
  }
  
  fileprivate func participants(with ids: [String], in participantsDictionary: [String : Participant]) -> [Participant] {
    var collection = [Participant]()
    ids.forEach({ (id) in
      guard let participant = participantsDictionary[id] else {
        return
      }
      collection.append(participant)
    })
    return collection
  }
}

//MARK: APIs
extension Event {
  func bookmark() {
    _ = DataManager.shared.bookmark(event: self)
  }
  
  func unbookmark() {
    _ = DataManager.shared.unBookmark(event: self)
  }
}

//MARK: Parsing
extension Event: Parsable {
  static func object(from json: JSON) -> Event? {
    let id = json["id"].stringValue
    let link = json["link"].url
    let content = json["content"].string
    let title = json["title"].string
    let excerpt = json["excerpt"].string
    let subtitle = json["subtitle"].string
    let languageCode = json["language_code"].string
    let typesIds = json["types"].arrayObject as? [String]
    let categoriesIds = json["categories"].arrayObject as? [String]
    let image = json["image"].url
    let venueId = json["venue"].stringValue
    let coordinates = CLLocationCoordinate2D.object(from: json["coordinates"])
    let address = json["coordinates"]["address"].string
    let organizersIds = json["organizers"].arrayObject?.map({ "\($0)" })
    let speakersIds = json["speakers"].arrayObject?.map({ "\($0)" })
    let artistsIds = json["artists"].arrayObject?.map({ "\($0)" })
    let companiesIds = json["companies"].arrayObject?.map({ "\($0)" })
    let sponsorsIds = json["sponsors"].arrayObject?.map({ "\($0)" })
    let dates = DateRange.objects(from: json["dates"])?.sortedAscending()
    
    return Event(id: id, link: link, content: content, title: title, excerpt: excerpt, subtitle: subtitle, languageCode: languageCode, typesIds: typesIds, categoriesIds: categoriesIds, image: image, venueId: venueId, coordinates: coordinates, address: address, organizersIds: organizersIds, speakersIds: speakersIds, artistsIds: artistsIds, companiesIds: companiesIds, sponsorsIds: sponsorsIds, dates: dates)
  }
}

//MARK: - Declare Event Category
extension Event {
  struct Category {
    var id: String?
    var label: String?
    var subCategories: [Category]?
    var parentId: String?
    
    /**
     If the category has no subcategories then the array has one element with
     the category label.
     Otherwise, the subcategories labels are concatenated with the label
     of this category.
     */
    func displayStrings() -> [String] {
      var labels = [String]()
      if let subCategories = subCategories, subCategories.count > 0 {
        var parentLabel = ""
        if let label = label {
          parentLabel = label + " / "
        }
        subCategories.forEach({
          guard let subLabel = $0.label else {
            return
          }
          labels.append("\(parentLabel)\(subLabel)")
        })
      } else if let label = label {
        labels.append(label)
      }
      return labels
    }
    
    static func subCategories(of category1: Category?, and category2: Category?) -> [Category] {
      var categories: [Category] = category1?.subCategories ?? []
      category2?.subCategories?.forEach({ (category) in
        if !categories.contains(category) {
          categories.append(category)
        }
      })
      return categories
    }
  }
}

extension Event.Category: Equatable {}
func ==(lhs: Event.Category, rhs: Event.Category) -> Bool {
  guard let lhsId = lhs.id, let rhsId = rhs.id else {
    return false
  }
  return lhsId == rhsId
}

extension Event.Category: Parsable {
  static func object(from json: JSON) -> Event.Category? {
    let id = json["id"].stringValue
    let label = json["label"].stringValue
    var subCategories = objects(from: json["children"])
    
    if let categories = subCategories, categories.count > 0 {
      subCategories = categories.map({
        var updatedCategory = $0
        updatedCategory.parentId = id
        return updatedCategory
      })
    }
    
    return Event.Category(id: id, label: label, subCategories: subCategories, parentId: nil)
  }
}

extension Array where Element == Event.Category {
  /// Flattenes a 2D structure categories
  var flatCategories: [Event.Category] {
    var allCategories: [Event.Category] = []
    for category in self {
      allCategories.append(category)
      if let subCategories = category.subCategories, subCategories.count > 0 {
        allCategories.append(contentsOf: subCategories)
      }
    }
    return allCategories
  }
  
  mutating func remove(category: Event.Category) {
    guard let index = self.index(of: category) else {
      return
    }
    remove(at: index)
  }
}

//MARK: - Declare Event Type
extension Event {
  struct EventType {
    var id: String?
    var label: String?
  }
}

extension Event.EventType: Parsable {
  static func object(from json: JSON) -> Event.EventType? {
    let id = json["id"].stringValue
    let label = json["label"].stringValue
    return Event.EventType(id: id, label: label)
  }
}

//MARK: - Event Array extensions
extension Array where Element == Event {
  func sortedAscending() -> [Event] {
    let sortedEvents = sorted { (event1, event2) -> Bool in
      guard let evente1FromDate = event1.dates?.first?.from,
        let event2FromDate = event2.dates?.first?.from else {
        return false
      }
      
      switch evente1FromDate.compare(event2FromDate) {
      case .orderedSame, .orderedAscending:
        return true
      case .orderedDescending:
        return false
      }
    }
    return sortedEvents
  }
  
  func sortedDescending() -> [Event] {
    let sortedEvents = sorted { (event1, event2) -> Bool in
      guard let event1ToDate = event1.dates?.sortedDescending().first?.to,
        let event2ToDate = event2.dates?.sortedDescending().first?.to else {
          return false
      }
      
      switch event1ToDate.compare(event2ToDate) {
      case .orderedSame, .orderedDescending:
        return true
      case .orderedAscending:
        return false
      }
    }
    return sortedEvents
  }
}
