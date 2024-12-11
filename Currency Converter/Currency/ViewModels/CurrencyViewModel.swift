//
//  CurrencyViewModel.swift
//  Currency Converter
//
//  Created by Yaroslav Kupyak on 11.12.2024.
//

import Foundation

class CurrencyViewModel {
    
    // Properties
    var amount: Double = 0.0 {
        didSet { fetchConversionRate() }
    }
    var onConversionResult: ((String) -> Void)?
    var onError: ((String) -> Void)?
    
    private var currencies: [String] = []
    private let currencyService: CurrencyService
    
    init(currencyService: CurrencyService) {
        self.currencyService = currencyService
    }
    
    func fetchInitialCurrencies() {
        // Load initial currency data (can be a mock or from API)
        currencies = ["USD", "EUR", "JPY"]
    }
    
    func fetchConversionRate() {
        guard !currencies.isEmpty else { return }
        let fromCurrency = currencies[0]
        let toCurrency = currencies[1]
        
        currencyService.fetchConversion(fromAmount: amount, fromCurrency: fromCurrency, toCurrency: toCurrency) { [weak self] result in
            switch result {
            case .success(let convertedAmount):
                self?.onConversionResult?("\(convertedAmount)")
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
