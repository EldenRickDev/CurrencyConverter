//
//  CurrencyConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Ricardo Andrés Gatica Collarte on 21-08-24.
//

import Foundation

// Modelo para decodificar la respuesta de la API
struct CurrencyRate: Decodable {
    let baseCode: String
    let conversionRates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case baseCode = "base_code"
        case conversionRates = "conversion_rates"
    }
}

// ViewModel que maneja la lógica de conversión
class CurrencyConverterViewModel: ObservableObject {
    @Published var convertedValue: String = ""
    @Published var amount: String = ""
    @Published var fromCurrency: String = "USD"
    @Published var toCurrency: String = "EUR"
    
    // Divisas más populares
    let popularCurrencies = [
        "USD", "EUR", "GBP", "JPY", "CAD", "AUD", "CNY", "INR", "BRL", "ZAR"
    ]
    
    // Resto de las divisas
    let otherCurrencies = [
        "AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AWG", "AZN",
        "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB",
        "BSD", "BTN", "BWP", "BYN", "BZD", "CDF", "CHF", "CLP", "COP",
        "CRC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP",
        "ERN", "ETB", "FJD", "FKP", "FOK", "GEL", "GGP", "GHS", "GIP",
        "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF",
        "IDR", "ILS", "IMP", "IQD", "IRR", "ISK", "JEP", "JMD", "JOD",
        "KES", "KGS", "KHR", "KID", "KMF", "KRW", "KWD", "KYD", "KZT",
        "LAK", "LBP", "LKR", "LRD", "LSL", "LYD", "MAD", "MDL", "MGA",
        "MKD", "MMK", "MNT", "MOP", "MRU", "MUR", "MVR", "MWK", "MXN",
        "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR",
        "PAB", "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON",
        "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD",
        "SHP", "SLE", "SLL", "SOS", "SRD", "SSP", "STN", "SYP", "SZL",
        "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TVD", "TWD",
        "TZS", "UAH", "UGX", "UYU", "UZS", "VES", "VND", "VUV", "WST",
        "XAF", "XCD", "XDR", "XOF", "XPF", "YER", "ZMW", "ZWL"
    ]

    var allCurrencies: [String] {
        popularCurrencies + otherCurrencies.sorted()
    }

    let apiKey = "27801faf64a11f73c0a12da6"  // Reemplaza con tu clave de API
    
    func convertCurrency() {
        guard let amount = Double(amount) else {
            self.convertedValue = "Invalid amount"
            return
        }
        
        let urlString = "https://v6.exchangerate-api.com/v6/\(apiKey)/latest/\(fromCurrency)"
        guard let url = URL(string: urlString) else {
            self.convertedValue = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let decodedResponse = try? decoder.decode(CurrencyRate.self, from: data) {
                    if let rate = decodedResponse.conversionRates[self.toCurrency] {
                        let result = amount * rate
                        DispatchQueue.main.async {
                            self.convertedValue = String(format: "%.2f", result)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.convertedValue = "Conversion rate not found"
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.convertedValue = "Failed to decode response"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.convertedValue = "Network error"
                }
            }
        }.resume()
    }
}
