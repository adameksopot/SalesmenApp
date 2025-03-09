//
//  SalesmanRepository.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//

import Foundation


class SalesmanRepository: ObservableObject {
    @Published var salesmen: [Salesman] = []
    @Published var query: String = ""
    
    init() {
        fetchSalesmen()
    }
    
    func fetchSalesmen() {
        salesmen = [
            Salesman(name: "Artem Titarenko", areas: ["76133"]),
            Salesman(name: "Bernd Schmitt", areas: ["7619*"]),
            Salesman(name: "Chris Krapp", areas: ["762*"]),
            Salesman(name: "Alex Uber", areas: ["86*"]),
            Salesman(name: "Hans Müller", areas: ["8033*"]),
            Salesman(name: "Ivan Petrov", areas: ["6900*"]),
            Salesman(name: "Lukas Bauer", areas: ["4020"]),
            Salesman(name: "Marie Dubois", areas: ["7500*"]),
            Salesman(name: "Paolo Rossi", areas: ["20100"]),
            Salesman(name: "Sophie Neumann", areas: ["5067*"]),
            Salesman(name: "Mikhail Ivanov", areas: ["1010"]),
            Salesman(name: "Elena Kowalski", areas: ["30-059"]),
            Salesman(name: "Felix Huber", areas: ["5023*"]),
            Salesman(name: "Anja Wagner", areas: ["7017*"]),
            Salesman(name: "Giovanni Ferrari", areas: ["00144"]),
            Salesman(name: "Nina Sørensen", areas: ["2100"]),
            Salesman(name: "Oscar Nilsson", areas: ["1144*"]),
            Salesman(name: "Klara Novak", areas: ["10000"]),
            Salesman(name: "Markus Fischer", areas: ["4021*"]),
            Salesman(name: "Laura Meier", areas: ["8004"]),
            Salesman(name: "Andrej Kovač", areas: ["1000*"]),
            Salesman(name: "Emilia Nowak", areas: ["00-999"]),
            Salesman(name: "Pieter de Vries", areas: ["3511"]),
            Salesman(name: "Sofia Costa", areas: ["1999*"]),
            Salesman(name: "Viktor Orban", areas: ["1051"]),
            Salesman(name: "Eva Horváth", areas: ["672*"]),
            Salesman(name: "Anna Müller", areas: ["3011"]),
            Salesman(name: "Thomas Schmidt", areas: ["04109"]),
            Salesman(name: "Julia Weber", areas: ["60306"])
        ]
    }

    var filteredSalesmen: [Salesman] {
        if query.isEmpty { return salesmen }
        else { return salesmen.filter { $0.name.lowercased().contains(query.lowercased()) } }
    }
}
