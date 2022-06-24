//
//  Currency+symbol.swift
//  Invoice
//
//  https://stackoverflow.com/questions/31999748/get-currency-symbols-from-currency-code-with-swift
//

import Foundation

class Currency {
    static let shared: Currency = Currency()

    private var cache: [String:String] = [:]

    func findSymbol(currencyCode:String) -> String {
        if let hit = cache[currencyCode] { return hit }
        guard currencyCode.count < 4 else { return "" }

        let symbol = findSymbolBy(currencyCode)
        cache[currencyCode] = symbol

        return symbol
    }

    private func findSymbolBy(_ currencyCode: String) -> String {
        var candidates: [String] = []
        let locales = NSLocale.availableLocaleIdentifiers

        for localeId in locales {
            guard let symbol = findSymbolBy(localeId, currencyCode) else { continue }
            if symbol.count == 1 { return symbol }
            candidates.append(symbol)
        }

        return candidates.sorted(by: { $0.count < $1.count }).first ?? ""
    }

    private func findSymbolBy(_ localeId: String, _ currencyCode: String) -> String? {
        let locale = Locale(identifier: localeId)
        return currencyCode.caseInsensitiveCompare(locale.currencyCode ?? "") == .orderedSame
            ? locale.currencySymbol : nil
    }
}

extension String {
    var currencySymbol: String { return Currency.shared.findSymbol(currencyCode: self) }
}
