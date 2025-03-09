//
//  CodesSearchAppApp.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//

import SwiftUI

@main
struct CodesSearchAppApp: App {
    
    @StateObject var viewModel = SalesmenViewModelImpl(repository: SalesmenRepositoryImpl())

    var body: some Scene {
        WindowGroup {
            SalesmenListView(viewModel: viewModel)
        }
    }
}
