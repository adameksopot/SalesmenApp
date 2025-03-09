//
//  SalesmanRow.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//


import SwiftUI

struct SalesmanRow: View {
    let salesman: Salesman
    @State private var isExpanded = false

    var body: some View {
        VStack {
            HStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 40, height: 40)
                    .overlay(Text(String(salesman.name.prefix(1)))
                        .font(.headline)
                    )
                
                VStack(alignment: .leading) {
                    Text(salesman.name)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.black)

                    if isExpanded && !salesman.areas.isEmpty {
                        Text(salesman.areas.joined(separator: ", "))
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color.init(hex: 0x999999))
                            .transition(.opacity)
                    }
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(Color.white)
            .frame(maxWidth: .infinity)
            
            Divider().background(Color.init(hex: 0x00C6C5C9))
        }
    }
}



struct SalesmanRow_Previews: PreviewProvider {
    static var previews: some View {
        SalesmanRow(salesman: Salesman(name: "Adam", areas: ["123"]))
    }
}
