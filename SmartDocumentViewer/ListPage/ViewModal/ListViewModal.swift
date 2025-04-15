//
//  ListViewModal.swift
//  SmartDocumentViewer
//
//  Created by Aiysha on 15/04/25.
//

import Foundation


class ListpageViewModal : NSObject {
    
    var listVM = [ListViewModal]()
    var dataClassVM = [DataClassViewModal]()
    
    
    override init() {
        super.init()
        //fetchListFromAPI()
    }
    
    
    func fetchListFromAPI(){
        
        WebServiceManager.shared.postDataToURL(input: ["":""], mode: .FetchList) { jsonString in
            if jsonString is Data {
                
                if let decodedRes = try? JSONDecoder().decode(listArray.self, from: jsonString as! Data)
                {
                    CoreDataManager.shared.saveList(list: decodedRes)
                }
                
            }
        }
        
    }
    
    
    func readAPIListtoVMObj(){
      listVM = CoreDataManager.shared.fetchList().map(ListViewModal.init)
    dataClassVM = CoreDataManager.shared.fetchDataClass(id: nil).map(DataClassViewModal.init)
        print(dataClassVM.count)
    }
    
    
    
    func concatenateFeatures(data : DataClassViewModal) -> String{
        var result = ""
        
        
        if !data.capacity.isEmpty {
            result.append("capacity: \(data.capacity)\n")
        }
        
        if data.capacityGB != 0 {
            result.append("capacityGB: \(data.capacityGB)\n")
        }
                
        if !data.caseSize.isEmpty {
            result.append("caseSize: \(data.caseSize)\n")
        }
        
        if !data.color.isEmpty {
            result.append("color: \(data.color)\n")
        }
        
        if !data.cpuModel.isEmpty {
            result.append("cpuModel: \(data.cpuModel)\n")
        }
        
        if !data.dataCapacity.isEmpty {
            result.append("dataCapacity: \(data.dataCapacity)\n")
        }
        
        if !data.dataColor.isEmpty {
            result.append("dataColor: \(data.dataColor)\n")
        }
        
        if !data.dataGeneration.isEmpty {
            result.append("dataGeneration: \(data.dataGeneration)\n")
        }
        
        if data.dataPrice > 0.0 {
            result.append("dataPrice: \(data.dataPrice)\n")
        }
        
        if !data.descDetails.isEmpty {
            result.append("descDetails: \(data.descDetails)\n")
        }
        
        if !data.generation.isEmpty {
            result.append("generation: \(data.generation)\n")
        }
        
        if !data.hardDiskSize.isEmpty {
            result.append("hardDiskSize: \(data.hardDiskSize)\n")
        }
        
        if !data.price.isEmpty {
            result.append("price: \(data.price)\n")
        }
        
        if data.screenSize > 0.0{
            result.append("screenSize: \(data.screenSize)\n")
        }
        
        if !data.strapColour.isEmpty {
            result.append("strapColour: \(data.strapColour)\n")
        }
        
        if data.year > 0 {
            result.append("year: \(data.year)")
        }
        
        return result
    }
    
}
