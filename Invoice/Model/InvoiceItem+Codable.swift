//
//  InvoiceItem+Codable.swift
//  Invoice
//
//  Created by Vladimir Calfa on 30/06/2022.
//

import Foundation
import UIKit

extension InvoiceItem: Codable {
    private enum CoderKeys: String, CodingKey {
        case invoiceId
        case date
        case total
        case currencyCode
        case note
        case image
        case imageId
    }

    // MARK: - Codable

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoderKeys.self)
        try container.encode(invoiceId, forKey: .invoiceId)
        try container.encode(date, forKey: .date)
        try container.encode(total, forKey: .total)
        try container.encode(currencyCode, forKey: .currencyCode)
        try container.encode(note, forKey: .note)
        let encodedImageString = image.flatMap { $0.jpegData(compressionQuality: 1.0)?.base64EncodedString() }
        try container.encode(encodedImageString, forKey: .image)
        try container.encode(imageId, forKey: .imageId)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CoderKeys.self)

        let decodedInvoiceId = try? values.decode(String.self, forKey: .invoiceId)
        invoiceId = decodedInvoiceId.flatMap { UUID(uuidString: $0) }
        date = try? values.decode(Date.self, forKey: .date)
        total = try? values.decode(Double.self, forKey: .total)
        currencyCode = try? values.decode(String.self, forKey: .currencyCode)
        note = try? values.decode(String.self, forKey: .note)
        let encodedImageString = try? values.decode(String.self, forKey: .image)
        image = encodedImageString.flatMap { Data(base64Encoded: $0) }
            .flatMap { UIImage(data: $0) }
        let decodedImageId = try? values.decode(String.self, forKey: .imageId)
        imageId = decodedImageId.flatMap { UUID(uuidString: $0) }
    }
}
