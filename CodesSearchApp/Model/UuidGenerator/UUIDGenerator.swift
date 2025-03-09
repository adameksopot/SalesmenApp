//
//  UUIDGenerator.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//

import Foundation


protocol UUIDGenerator {
    func generate() -> UUID
}

struct DefaultUUIDGenerator: UUIDGenerator {
    func generate() -> UUID {
        return UUID()
    }
}
