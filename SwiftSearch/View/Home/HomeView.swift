//
//  HomeView.swift
//  SwiftSearch
//
//  Created by Godwin A on 5/8/21.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCurrency: CurrencyModel? = nil
    @State private var showDetailView: Bool = false
    @State private var showPortfolio: Bool = false // animate right

    
    var body: some View {
        ZStack {
            
            // content layer
            VStack {
                SearchBarView(searchText: $vm.searchText)
                columnTitles
                
                if !showPortfolio {
                    allCurrencysList
                        .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    ZStack(alignment: .top) {
                            portfolioCurrencysList
                    }
                    .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(currency: $selectedCurrency),
                isActive: $showDetailView,
                label: { EmptyView() })
        )
    }
}



extension HomeView {
    
    private var portfolioCurrencysList: some View {
        List {
            ForEach(vm.portfolioCurrencys) { currency in
                CurrencyRowView(currency: currency, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(currency: currency)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(PlainListStyle())
    }
    private var allCurrencysList: some View {
        List {
            ForEach(vm.allCurrencys) { currency in
                CurrencyRowView(currency: currency, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(currency: currency)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    
    
    private func segue(currency: CurrencyModel) {
        selectedCurrency = currency
        showDetailView.toggle()
    }
    
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Currency")
            }

            Spacer()
            HStack(spacing: 4) {
                Text("Value")   }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
   }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}

