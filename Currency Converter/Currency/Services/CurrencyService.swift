//
//  CurrencyService.swift
//  Currency Converter
//
//  Created by Yaroslav Kupyak on 11.12.2024.
//

import Foundation

class CurrencyService {
    
    func fetchConversion(fromAmount: Double, fromCurrency: String, toCurrency: String, completion: @escaping (Result<Double, Error>) -> Void) {
        let urlString = "http://api.evp.lt/currency/commercial/exchange/\(fromAmount)-\(fromCurrency)/\(toCurrency)/latest"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(CurrencyResponse.self, from: data)
                completion(.success(response.amount))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
