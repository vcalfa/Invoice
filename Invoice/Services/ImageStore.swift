//
//  ImageStore.swift
//  Invoice
//
//  Created by Vladimir Calfa on 22/06/2022.
//

import Foundation
import UIKit

class ImageStore {
    
    private enum DirectoryType: String {
        
        case invoiceImages = "invoiceImages"
        case temporary = "temporary"
        
        var pathComponent: String { rawValue }
    }
    
    private let documentsDirectories: [URL]
    
    public init() {
        documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    }
    
    public init(homeDirectory: URL) {
        documentsDirectories = [homeDirectory]
    }
    
    private func documentsDirectories(_ location: DirectoryType) -> [URL] {
        documentsDirectories.compactMap {
            $0.appendingPathComponent(location.pathComponent)
        }
    }
    
    private func save(image: UIImage, location: DirectoryType) -> Result<UUID, ImageStoreError> {
        let imageUUID = UUID()
        
        let existingImagePaths = documentsDirectories(location).compactMap {
                $0.appendingPathComponent(imageUUID.uuidString)
            }
            
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return .failure(.unspecified)
        }
        
        for url in existingImagePaths {
            
            do {
                try FileManager.default.createDirectory(atPath: url.deletingLastPathComponent().path, withIntermediateDirectories: true, attributes: nil)
                try imageData.write(to: url, options: .atomic)
            } catch {
                dump(error)
                return .failure(.unspecified)
            }
            
            return .success(imageUUID)
        }
        
        return .failure(.unspecified)
    }
    
    private func fetch(imageId: UUID, location: DirectoryType) -> Result<(UIImage, UUID), ImageStoreError> {
        
        let fileManager = FileManager.default
        
        let existingImagePaths = documentsDirectories(location).compactMap {
                $0.appendingPathComponent(imageId.uuidString).path
            }
            .filter(fileManager.fileExists(atPath:))
        
        for path in existingImagePaths {
            guard let image = UIImage(contentsOfFile: path) else {
                continue
            }

            return .success((image, imageId))
        }
        
        return .failure(.imageNotFound(uuid: imageId))
    }
}

extension ImageStore: ImageStoreProtocol {
    func save(image: UIImage) -> Result<UUID, ImageStoreError> {
        save(image: image, location: .invoiceImages)
    }
    
    func fetch(imageId: UUID) -> Result<(UIImage, UUID), ImageStoreError> {
        fetch(imageId: imageId, location: .invoiceImages)
    }
}
