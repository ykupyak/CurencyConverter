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
    
    var onConversionResult: ((Double, Double) -> Void)?
    var onError: ((String) -> Void)?
        
    private let currencyService: CurrencyService
    private(set) var fromCurrency: Currency = CurrencyViewModel.currencies[0]
    private(set) var toCurrency: Currency = CurrencyViewModel.currencies[1]
    
    init(currencyService: CurrencyService) {
        self.currencyService = currencyService
        startPeriodicUpdates()
    }
    
    private func startPeriodicUpdates() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.fetchConversionRate()
        }
    }
    
    private var timer: Timer?
    
    private func fetchConversionRate() {
        guard amount > 0 else { return }
        currencyService.fetchConversion(fromAmount: amount, fromCurrency: fromCurrency.code, toCurrency: toCurrency.code) { [weak self] result in
            switch result {
            case .success(let convertedAmount):
                let rate = convertedAmount / (self?.amount ?? 1)
                self?.onConversionResult?(convertedAmount, rate)
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func getCurrencies() -> [Currency] {
        return CurrencyViewModel.currencies
    }
    
    func setFromCurrency(_ currency: Currency) {
        fromCurrency = currency
        fetchConversionRate()
    }
    
    func setToCurrency(_ currency: Currency) {
        toCurrency = currency
        fetchConversionRate()
    }
}


extension CurrencyViewModel {
    static let currencies: [Currency] = [
        Currency(code: "USD", name: NSLocalizedString("United States Dollar", comment: "Currency name")),
        Currency(code: "EUR", name: NSLocalizedString("Euro", comment: "Currency name")),
        Currency(code: "LVL", name: NSLocalizedString("Latvian Lats", comment: "Currency name")),
        Currency(code: "UAH", name: NSLocalizedString("Ukrainian Hryvnia", comment: "Currency name"))
    ]
}
