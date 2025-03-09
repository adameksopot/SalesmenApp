//
//  SalesmanRepository.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//

import Foundation

protocol SalesmanRepository {
    func get() async throws -> [Salesman]
}

class SalesmanRepositoryImpl: SalesmanRepository {
    func get() async throws -> [Salesman] {
        try await Task.sleep(nanoseconds: 10_000_000)
        
        return [
            Salesman(name: "Artem Titarenko", areas: ["76133"]),
            Salesman(name: "Bernd Schmitt", areas: ["7619*"]),
            Salesman(name: "Chris Krapp", areas: ["762*"]),
            Salesman(name: "Alex Uber", areas: ["86*"])
        ]
    }
}
