//
//  CodesSearchAppApp.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//

import SwiftUI

@main
struct CodesSearchAppApp: App {
    
    @StateObject var viewModel = SalesManViewModelImpl(repository: SalesmanRepositoryImpl())

    var body: some Scene {
        WindowGroup {
            SalesmanListView(viewModel: viewModel)
        }
    }
}
