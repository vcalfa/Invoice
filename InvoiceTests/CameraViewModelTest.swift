//
//  CameraViewModelTest.swift
//  InvoiceTests
//
//  Created by Vladimir Calfa on 22/06/2022.
//

import XCTest
@testable import Invoice

class CameraViewModelTest: XCTestCase {


    func testCameraViewModelCase1() throws {
        
        let invoice = InvoiceItem(invoiceId: UUID(), date: Date.now, total: 0.0, currency: "$", note: "Notee", image: nil)
        let viewModel = CameraViewModel(router: CameraRouter(nil), invoice: invoice)
        
    }
}
