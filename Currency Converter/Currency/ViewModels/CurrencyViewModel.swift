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
        Currency(code: "UAH", name: NSLocalizedString("Ukrainian Hryvnia", comment: "Currency name")),
        Currency(code: "AED", name: NSLocalizedString("United Arab Emirates Dirham", comment: "Currency name")),
        Currency(code: "ALL", name: NSLocalizedString("Albanian Lek", comment: "Currency name")),
        Currency(code: "ARS", name: NSLocalizedString("Argentine Peso", comment: "Currency name")),
        Currency(code: "AUD", name: NSLocalizedString("Australian Dollar", comment: "Currency name")),
        Currency(code: "AZN", name: NSLocalizedString("Azerbaijani Manat", comment: "Currency name")),
        Currency(code: "BAM", name: NSLocalizedString("Bosnia-Herzegovina Convertible Mark", comment: "Currency name")),
        Currency(code: "BGN", name: NSLocalizedString("Bulgarian Lev", comment: "Currency name")),
        Currency(code: "BRL", name: NSLocalizedString("Brazilian Real", comment: "Currency name")),
        Currency(code: "BYN", name: NSLocalizedString("Belarusian Ruble", comment: "Currency name")),
        Currency(code: "CAD", name: NSLocalizedString("Canadian Dollar", comment: "Currency name")),
        Currency(code: "CHF", name: NSLocalizedString("Swiss Franc", comment: "Currency name")),
        Currency(code: "CLP", name: NSLocalizedString("Chilean Peso", comment: "Currency name")),
        Currency(code: "CNY", name: NSLocalizedString("Chinese Yuan", comment: "Currency name")),
        Currency(code: "COP", name: NSLocalizedString("Colombian Peso", comment: "Currency name")),
        Currency(code: "CVE", name: NSLocalizedString("Cape Verdean Escudo", comment: "Currency name")),
        Currency(code: "CZK", name: NSLocalizedString("Czech Koruna", comment: "Currency name")),
        Currency(code: "DKK", name: NSLocalizedString("Danish Krone", comment: "Currency name")),
        Currency(code: "DZD", name: NSLocalizedString("Algerian Dinar", comment: "Currency name")),
        Currency(code: "EGP", name: NSLocalizedString("Egyptian Pound", comment: "Currency name")),
        Currency(code: "GEL", name: NSLocalizedString("Georgian Lari", comment: "Currency name")),
        Currency(code: "HKD", name: NSLocalizedString("Hong Kong Dollar", comment: "Currency name")),
        Currency(code: "HUF", name: NSLocalizedString("Hungarian Forint", comment: "Currency name")),
        Currency(code: "ILS", name: NSLocalizedString("Israeli New Shekel", comment: "Currency name")),
        Currency(code: "INR", name: NSLocalizedString("Indian Rupee", comment: "Currency name")),
        Currency(code: "IQD", name: NSLocalizedString("Iraqi Dinar", comment: "Currency name")),
        Currency(code: "JOD", name: NSLocalizedString("Jordanian Dinar", comment: "Currency name")),
        Currency(code: "JPY", name: NSLocalizedString("Japanese Yen", comment: "Currency name")),
        Currency(code: "KWD", name: NSLocalizedString("Kuwaiti Dinar", comment: "Currency name")),
        Currency(code: "KZT", name: NSLocalizedString("Kazakhstani Tenge", comment: "Currency name")),
        Currency(code: "MAD", name: NSLocalizedString("Moroccan Dirham", comment: "Currency name")),
        Currency(code: "MDL", name: NSLocalizedString("Moldovan Leu", comment: "Currency name")),
        Currency(code: "MKD", name: NSLocalizedString("Macedonian Denar", comment: "Currency name")),
        Currency(code: "MXN", name: NSLocalizedString("Mexican Peso", comment: "Currency name")),
        Currency(code: "NGN", name: NSLocalizedString("Nigerian Naira", comment: "Currency name")),
        Currency(code: "NOK", name: NSLocalizedString("Norwegian Krone", comment: "Currency name")),
        Currency(code: "NZD", name: NSLocalizedString("New Zealand Dollar", comment: "Currency name")),
        Currency(code: "PHP", name: NSLocalizedString("Philippine Peso", comment: "Currency name")),
        Currency(code: "PLN", name: NSLocalizedString("Polish Złoty", comment: "Currency name")),
        Currency(code: "RON", name: NSLocalizedString("Romanian Leu", comment: "Currency name")),
        Currency(code: "RSD", name: NSLocalizedString("Serbian Dinar", comment: "Currency name")),
        Currency(code: "RUB", name: NSLocalizedString("Russian Ruble", comment: "Currency name")),
        Currency(code: "SAR", name: NSLocalizedString("Saudi Riyal", comment: "Currency name")),
        Currency(code: "SEK", name: NSLocalizedString("Swedish Krona", comment: "Currency name")),
        Currency(code: "SGD", name: NSLocalizedString("Singapore Dollar", comment: "Currency name")),
        Currency(code: "THB", name: NSLocalizedString("Thai Baht", comment: "Currency name")),
        Currency(code: "TRY", name: NSLocalizedString("Turkish Lira", comment: "Currency name")),
        Currency(code: "ZAR", name: NSLocalizedString("South African Rand", comment: "Currency name"))
    ]
}
