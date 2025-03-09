//
//  SalesManViewModel.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//

import Foundation
import Combine

class SalesmanListViewModel: ObservableObject {
    
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


