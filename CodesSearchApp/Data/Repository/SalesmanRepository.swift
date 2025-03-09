//
//  SalesmanRepository.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//

import Foundation

protocol SalesmenRepository {
    func get() async throws -> [Salesman]
}

class SalesmenRepositoryImpl: SalesmenRepository {
    let uuidGenerator : UUIDGenerator
    
    init(uuidGenerator: UUIDGenerator = DefaultUUIDGenerator()) {
        self.uuidGenerator = uuidGenerator
    }
    
    func get() async throws -> [Salesman] {
        try await Task.sleep(nanoseconds: 1)
        return [
            Salesman(name: "Artem Titarenko", areas: ["76133"]),
            Salesman(name: "Bernd Schmitt", areas: ["7619*"]),
            Salesman(name: "Chris Krapp", areas: ["762*"]),
            Salesman(name: "Alex Uber", areas: ["86*"])
        ]
    }
}


class FakeSalesmenRepository :  SalesmenRepository {
    
    func get() async throws -> [Salesman] {
        try await Task.sleep(nanoseconds: 1)
        return [
            Salesman(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!, name: "Artem Titarenko", areas: ["76133"]),
            Salesman(id: UUID(uuidString: "E621E1F8-C36C-491A-93FC-0C247A3E6E5F")!,name: "Bernd Schmitt", areas: ["7619*"]),
            Salesman(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E7F")!,name: "Chris Krapp", areas: ["762*"]),
            Salesman(id: UUID(uuidString: "E621E1F9-C36C-495A-93FC-0C247A3E6E7F")!,name: "Alex Uber", areas: ["86*"])
        ]
    }
}
