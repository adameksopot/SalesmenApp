//
//  SalesManViewModel.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//

import Foundation
import Combine

protocol SalesmenViewModel : ObservableObject {
    var state: ViewState { get set }
    var query: String { get set }
    func push(event: Event)
}

class SalesmenViewModelImpl: SalesmenViewModel, ObservableObject {
    
    @Published var state: ViewState = .Loading
    @Published var query: String = ""
    
    private let repository: SalesmenRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: SalesmenRepository) {
        self.repository = repository
        subscribeToQueryEvents()
    }
    
    func push(event: Event) {
        switch event {
        case .FetchSalesmen:
            fetchSalesmen()
        case .Search(let query):
            handleQuery(query: query)
        }
    }
    
    private func fetchSalesmen() {
        Task { @MainActor in
            sleep(2) // display loader briefly
            do {
                let salesmen = try await repository.get()
                state = salesmen.isEmpty ? .Empty : .Loaded(salesmen: salesmen)
            } catch {
                state = .Error
            }
        }
    }
    
    private func handleQuery(query: String) {
        Task { @MainActor in
            do {
                let allSalesmen = try await repository.get()
                if query.isEmpty {
                    state = allSalesmen.isEmpty ? .Empty : .Loaded(salesmen: allSalesmen)
                } else {
                    let filteredSalesmen = filterSalesmen(allSalesmen, matching: query)
                    state = filteredSalesmen.isEmpty ? .Empty : .Loaded(salesmen: filteredSalesmen)
                }
            } catch {
                state = .Error
            }
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

        if area.hasSuffix("*") {
            return query.hasPrefix(normalizedArea) || normalizedArea.hasPrefix(query)
        }

        return area.hasPrefix(query) || query.hasPrefix(area)
    }
    
    private func subscribeToQueryEvents() {
        $query
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.push(event: .Search(query: query))
            }
            .store(in: &cancellables)
    }
}

class FakeSalesmenViewModelImpl: SalesmenViewModel, ObservableObject {
    @Published var query: String = ""
    @Published var state: ViewState = .Loaded(salesmen: [
        Salesman(name: "Anna Müller", areas: ["73133", "76131"]),
        Salesman(name: "Bern Schmitt", areas: ["762*", "76300"]),
        Salesman(name: "Carlos Ruiz", areas: ["80000", "801*"]),
        Salesman(name: "Diana Prince", areas: ["900*", "90100"])
    ])

    
    func push(event: Event) {
        
    }
}
