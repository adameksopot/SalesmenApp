//
//  ContentView.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//

import SwiftUI

struct SalesmanListView: View {
    @ObservedObject var viewModel : SalesmanListViewModel
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(viewModel.salesmen) { salesman in
                            SalesmanRow(salesman: salesman)
                        }
                    } header: { searchView }
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
            .task { await viewModel.fetchSalesmen() }
        }
    }
    
    private var searchView: some View {
        
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.gray)
            TextField("Suche", text: $viewModel.query)
            Button(action: { print("Microphone tapped")
            }) { Image(systemName: "mic.fill").foregroundColor(.gray) }}
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
        // SalesmanListView(viewModel: )
        Text("Hello")
    }
}
