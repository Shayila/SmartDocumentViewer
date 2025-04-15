//
//  ListModal.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 15/04/25.
//

import Foundation
import CoreData


// MARK: - ListModal
struct ListModal: Codable {
    let id, name: String
    let data: DataClassModal?
}

// MARK: - DataClass
struct DataClassModal: Codable {
    let dataColor, dataCapacity: String?
    let capacityGB: Int?
    let dataPrice: Double?
    let dataGeneration: String?
    let year: Int?
    let cpuModel, hardDiskSize, strapColour, caseSize: String?
    let color, descDetails, capacity: String?
    let screenSize: Double?
    let generation, price: String?

    enum CodingKeys: String, CodingKey {
        case dataColor = "color"
        case dataCapacity = "capacity"
        case capacityGB = "capacity GB"
        case dataPrice = "price"
        case dataGeneration = "generation"
        case year
        case cpuModel = "CPU model"
        case hardDiskSize = "Hard disk size"
        case strapColour = "Strap Colour"
        case caseSize = "Case Size"
        case color = "Color"
        case descDetails = "Description"
        case capacity = "Capacity"
        case screenSize = "Screen size"
        case generation = "Generation"
        case price = "Price"
    }
}

typealias listArray = [ListModal]




class ListViewModal {
    
    var id = ""
    var name = ""
    
    
    init() {
    
    }
    
    init(list : ListTable) {
        self.name = list.name!
        self.id = list.listId!
    }
}


class DataClassViewModal {
    
    var dataColor = ""
    var dataCapacity = ""
    var capacityGB = 0
    var dataPrice = 0.0
    var dataGeneration = ""
    var year = 0
    var cpuModel = ""
    var hardDiskSize = ""
    var strapColour = ""
    var caseSize = ""
    var color = ""
    var descDetails = ""
    var capacity = ""
    var screenSize = 0.0
    var generation = ""
    var price = ""
    var foreignID = ""
    
    init() {
        
    }
    
    
    init(dataclass : DataClassTable) {
        self.foreignID = dataclass.foreignID!
        self.dataColor = dataclass.dataColor!
        self.dataCapacity = dataclass.dataCapacity!
        self.capacity = dataclass.capacity!
        self.capacityGB = Int(dataclass.capacityGB)
        self.caseSize = dataclass.caseSize!
        self.cpuModel = dataclass.cpuModel!
        self.dataGeneration = dataclass.dataGeneration!
        self.dataPrice = dataclass.dataPrice
        self.descDetails = dataclass.descDetails!
        self.generation = dataclass.generation!
        self.hardDiskSize = dataclass.hardDiskSize!
        self.price = dataclass.price!
        self.screenSize = dataclass.screenSize
        self.strapColour = dataclass.strapColour!
        self.year = Int(dataclass.year)
    }
    
}
