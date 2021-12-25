//
//  DetailView.swift
//  SwiftSearch
//
//  Created by Godwin A on 5/11/21.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var currency: CurrencyModel?

    var body: some View {
        ZStack {
            if let currency = currency {
                DetailView(currency: currency)
            }
        }
    }
    
}

struct DetailView: View {
    
    @StateObject private var vm: DetailViewModel
    @State private var showFullDescription: Bool = false
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing: CGFloat = 30
    
    init(currency: CurrencyModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(currency: currency))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(currency: vm.currency)
                    .padding(.vertical)

                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    descriptionSection
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
//                    websiteSection
                }
                .padding()
            }
        }
        .background(
            Color.theme.background
                .ignoresSafeArea()
        )
        .navigationTitle(vm.currency.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
    }
}

extension DetailView {
    
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.currency.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CurrencyImageView(currency: vm.currency)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let currencyDescription = vm.currencyDescription,
               !currencyDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(currencyDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)

                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(showFullDescription ? "Less" : "Read more..")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    })
                    .accentColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(vm.overviewStatistics) { stat in
                    StatisticView(stat: stat)
                }
        })
    }
    
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
        })
    }
    
//    private var websiteSection: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            if let websiteString = vm.websiteURL,
//               let url = URL(string: websiteString) {
//                Link("Website", destination: url)
//            }
//
//            if let redditString = vm.redditURL,
//               let url = URL(string: redditString) {
//                Link("Reddit", destination: url)
//            }
//
//        }
//        .accentColor(.blue)
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .font(.headline)
//    }
    
}
