//
//  Currency.swift
//  Currency Converter
//
//  Created by Yaroslav Kupyak on 11.12.2024.
//

struct CurrencyResponse: Decodable {
    let amount: Double
    let currency: String

    private enum CodingKeys: String, CodingKey {
        case amount
        case currency
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let amountString = try container.decode(String.self, forKey: .amount)
        self.amount = Double(amountString) ?? 0.0
        self.currency = try container.decode(String.self, forKey: .currency)
    }
}
