//
//  CurrencyImageProvider.swift
//  SwiftSearch
//
//  Created by Godwin A on 5/9/21.
//

import Foundation
import SwiftUI
import Combine

class CurrencyImageProvider {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let currency: CurrencyModel
    private let folderName = "currency_images"
    private let imageName: String
    
    init(currency: CurrencyModel) {
        self.currency = currency
        self.imageName = currency.id
        downloadCurrencyImage()
    }
    
    private func downloadCurrencyImage() {
        guard let url = URL(string: currency.image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
            })
    }
    
}
