//
//  CurrencyImageViewModel.swift
//  SwiftSearch
//
//  Created by Godwin A on 5/9/21.
//

import Foundation
import SwiftUI
import Combine

class CurrencyImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let currency: CurrencyModel
    private let dataProvider: CurrencyImageProvider
    private var cancellables = Set<AnyCancellable>()
    
    init(currency: CurrencyModel) {
        self.currency = currency
        self.dataProvider = CurrencyImageProvider(currency: currency)
        self.addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        dataProvider.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
        
    }
    
}
