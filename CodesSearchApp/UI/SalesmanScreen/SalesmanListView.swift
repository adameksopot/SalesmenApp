//
//  ContentView.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//

import SwiftUI


struct SalesmenListView<ViewModel: SalesmenViewModel>: View {
    
    @ObservedObject var viewModel: ViewModel
    private let theme: SalesMenTheme = SalesMenTheme()
    
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
                        .font(theme.titleFont)
                        .foregroundColor(.white)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(theme.primaryColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear { viewModel.push(event: .FetchSalesmen) }
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
                .foregroundColor(theme.textColor)
        case .Error:
            Text("Error:")
                .foregroundColor(theme.errorTextColor)
        }
    }
    
    private var searchView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(theme.searchButtonColor)
            TextField("Suche", text: $viewModel.query)
            Button(action: { print("Microphone tapped") }) {
                Image(systemName: "mic.fill")
                    .foregroundColor(theme.searchButtonColor)
            }
        }
        .padding(theme.searchFieldPadding)
        .background(theme.searchBarBackgroundColor)
        .cornerRadius(theme.searchFieldCornerRadius)
        .padding(.horizontal, theme.horizontalPadding)
        .padding(.top, theme.verticalPadding)
        .padding(.bottom, theme.searchFieldBottomPadding)
    }
}

struct SalesMenTheme {
     let primaryColor = Color(hex: 0x00327FF0, alpha: 0.94)
     let secondaryColor = Color(hex: 0x999999)
     let searchBarBackgroundColor = Color(.systemGray6)
     let searchButtonColor = Color.gray
     let errorTextColor = Color.red
     let textColor = Color.black
     let sectionHeaderColor = Color.gray
     let dividerColor = Color.init(hex: 0x00C6C5C9)
     let horizontalPadding: CGFloat = 16
     let verticalPadding: CGFloat = 24
     let searchFieldPadding: CGFloat = 10
     let searchFieldBottomPadding: CGFloat = 31
     let searchFieldCornerRadius: CGFloat = 8
     let titleFont = Font.headline
}


struct SalesmenListView_Previews: PreviewProvider {
    static var previews: some View {
        SalesmenListView(viewModel: FakeSalesmenViewModelImpl())
    }
}
