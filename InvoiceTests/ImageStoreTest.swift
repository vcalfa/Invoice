//
//  ImageStoreTest.swift
//  InvoiceTests
//
//  Created by Vladimir Calfa on 22/06/2022.
//

import XCTest
@testable import Invoice

class ImageStoreTest: XCTestCase {

    
    func testGetImageCase1() throws {
        let store = ImageStore()
        let randomId = UUID()
        let result = store.fetch(imageId: randomId)
        
        switch result {
        case .success:
            XCTFail("Notpossible to reach the success state")
        case .failure(let error):
            XCTAssertEqual(error, ImageStoreError.imageNotFound(uuid: randomId))
        }

    }
    
    func testSaveAndGetImageCase1() throws {
        let store = ImageStore()
        let image = UIColor.green.image(CGSize(width: 64, height: 64))
        
        let result = store.save(image: image)
        
        switch result {
        case .success(let saveuuid):
            XCTAssertNotNil(saveuuid)
            
            let result = store.fetch(imageId: saveuuid)
            
            switch result {
            case .success(let (image, getuuid)):
                XCTAssertNotNil(getuuid)
                XCTAssertEqual(saveuuid, getuuid)
                XCTAssertNotNil(image)
            case .failure(let error):
                XCTFail("Image not saved: \(error)")
            }
            
        case .failure(let error):
            XCTFail("Image not saved: \(error)")
        }
    }
}

private extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
