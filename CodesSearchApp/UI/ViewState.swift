//
//  SearchPageState.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//


enum ViewState : Equatable {
    case Loading
    case Error
    case Loaded(salesmen:[Salesman])
    case Empty
}
