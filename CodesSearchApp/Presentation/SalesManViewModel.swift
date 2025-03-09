//
//  SalesManViewModel.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//

import Foundation
import Combine

protocol SalesManViewModel : ObservableObject {
    var salesmen: [Salesman] { get set }
    var query: String { get set }
    func fetchSalesmen() async
    
}
class SalesManViewModelImpl: SalesManViewModel , ObservableObject {
    
    @Published var query: String = ""
    @Published var salesmen: [Salesman] = []
    
    private let repository: SalesmanRepository
    var cancellables = Set<AnyCancellable>()

    init(repository: SalesmanRepository) {
        self.repository = repository
        textFieldSubscribe()
    }
    
    @MainActor
    func fetchSalesmen() async {
        do {
            self.salesmen = try await repository.get() }
        catch {
            print("Error fetching salesmen: \(error)")
        }
    }

    private func textFieldSubscribe() {
        $query
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.handleQuery(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func handleQuery(query: String) {
        Task { @MainActor in
            do {
                let allSalesmen = try await repository.get()
                if query.isEmpty { salesmen = allSalesmen }
                else { salesmen = filterSalesmen(allSalesmen, matching: query) }
            } catch { print("Error fetching salesmen: \(error)") }
        }
    }

    private func filterSalesmen(_ salesmen: [Salesman], matching query: String) -> [Salesman] {
        salesmen.filter { salesman in
            salesman.areas.contains { area in
                queryMatches(area, query)
            }
        }
    }
    
    private func queryMatches(_ area: String, _ query: String) -> Bool {
        let normalizedArea = area.replacingOccurrences(of: "*", with: "")
        let normalizedQuery = query.replacingOccurrences(of: "*", with: "")
        
        if area.hasSuffix("*") {
            return normalizedQuery.hasPrefix(normalizedArea)
        } else if query.hasSuffix("*") {
            return normalizedArea.hasPrefix(normalizedQuery)
        }
        return area == query
    }
}

class FakeSalesViewModel: SalesManViewModel, ObservableObject {
    @Published var query: String = ""
    @Published var salesmen: [Salesman] = []
    
    func fetchSalesmen() async {
        return self.salesmen = [
            Salesman(name: "Anna Müller", areas: ["73133", "76131"]),
            Salesman(name: "Bern Schmitt", areas: ["762*", "76300"]),
            Salesman(name: "Carlos Ruiz", areas: ["80000", "801*"]),
            Salesman(name: "Diana Prince", areas: ["900*", "90100"]),
        ]
    }
}


