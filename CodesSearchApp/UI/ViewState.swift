//
//  SearchPageState.swift
//  CodesSearchApp
//
//  Created by Adam Heinrich on 09/03/2025.
//


enum ViewState {
    case Loading
    case Error
    case Loaded(salesmen:[Salesman])
    case Empty
}
