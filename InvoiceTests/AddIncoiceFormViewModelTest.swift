//
//  AddIncoiceFormViewModelTest.swift
//  InvoiceTests
//
//  Created by Vladimir Calfa on 18/06/2022.
//

import XCTest
@testable import Invoice

class AddIncoiceFormViewModelTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddIncoiceForm1() throws {
        let viewModel = AddIncoiceFormViewModel(router: AddIncoiceFormRouter(nil), invoice: nil)
        XCTAssertEqual(viewModel.outputs.title, "Add invoice")
        XCTAssertEqual(viewModel.outputs.action, .add)
        XCTAssertEqual(viewModel.outputs.total, nil)
    }
    
    func testAddIncoiceForm2() throws {
        let invoice = InvoiceItem(note: "Test")
        let viewModel = AddIncoiceFormViewModel(router: AddIncoiceFormRouter(nil), invoice: invoice)
        XCTAssertEqual(viewModel.outputs.title, "Add invoice")
        XCTAssertEqual(viewModel.outputs.action, .add)
        XCTAssertEqual(viewModel.outputs.total, nil)
    }
    
    func testAddIncoiceForm3() throws {
        let invoice = InvoiceItem(invoiceId: UUID(), date: Date.now, total: 0.0, currency: "$", note: "Notee", image: nil)
        let viewModel = AddIncoiceFormViewModel(router: AddIncoiceFormRouter(nil), invoice: invoice)
        XCTAssertEqual(viewModel.outputs.title, "Edit invoice")
        XCTAssertEqual(viewModel.outputs.action, .edit)
        XCTAssertEqual(viewModel.outputs.total, "0,00")
    }
    
    func testAddIncoiceForm4() throws {
        let invoice = InvoiceItem(invoiceId: UUID(), date: Date.now, total: 1254.356, currency: "$", note: "Notee", image: nil)
        let viewModel = AddIncoiceFormViewModel(router: AddIncoiceFormRouter(nil), invoice: invoice)
        XCTAssertEqual(viewModel.outputs.title, "Edit invoice")
        XCTAssertEqual(viewModel.outputs.action, .edit)
        XCTAssertEqual(viewModel.outputs.total, "1 254,36")
    }
}
