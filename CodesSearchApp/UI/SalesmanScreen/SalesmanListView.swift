//
//  ContentView.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//

import SwiftUI

struct SalesmanListView<ViewModel: SalesManViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section { contentView }
                    header: { searchView }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Adressen")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(hex: 0x00327FF0, alpha: 0.94), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear { viewModel.process(intent: .FetchSalesmen) }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .Loading:
            ProgressView()
        case .Loaded(let salesmen):
            ForEach(salesmen) { salesman in
                SalesmanRow(salesman: salesman)
            }
        case .Empty:
            Text("No salesmen found")
        case .Error:
            Text("Error:")
        }
    }
    
    private var searchView: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.gray)
            TextField("Suche", text: $viewModel.query)
            Button(action: { print("Microphone tapped") }) {
                Image(systemName: "mic.fill").foregroundColor(.gray)
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 31)
        .background(Color.white)
    }
}

struct SalesmanListView_Previews: PreviewProvider {
    static var previews: some View {
        SalesmanListView(viewModel: FakeSalesViewModel.init())
    }
}
