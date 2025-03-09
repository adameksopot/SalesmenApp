//
//  Salesman.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//

import Foundation


struct Salesman: Identifiable, Equatable {
    let id : UUID
    let name: String
    let areas: [String]
    
    init(id: UUID, name: String, areas: [String]) {
         self.id = id
         self.name = name
         self.areas = areas
     }
    
    init(name: String, areas: [String], uuidGenerator: UUIDGenerator = DefaultUUIDGenerator()) {
        self.id = uuidGenerator.generate()
        self.name = name
        self.areas = areas
    }
}
