//
//  ImageStoreProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 22/06/2022.
//

import Foundation
import UIKit

enum ImageStoreError: Error, Equatable {
    case outOfSpace
    case imageNotFound(uuid: UUID)
    case unspecified
}

protocol ImageStoreProtocol {
    func save(image: UIImage, uuid: UUID?) -> Result<UUID, ImageStoreError>
    func fetch(imageId: UUID) -> Result<(UIImage, UUID), ImageStoreError>
}
