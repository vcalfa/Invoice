//
//  AddIncoiceFormViewModelTest.swift
//  InvoiceTests
//
//  Created by Vladimir Calfa on 18/06/2022.
//

import Combine
import XCTest

@testable import Invoice

class AddIncoiceFormViewModelTest: XCTestCase {
    func testAddIncoiceForm1() throws {
        var cancellables = Set<AnyCancellable>()
        let viewModel = AddIncoiceFormViewModel(router: AddIncoiceFormRouter(nil),
                                                invoiceManager: InvoiceManager(localStore: LocalStorage(),
                                                                               imageStore: ImageStore()),
                                                invoice: nil)

        viewModel.outputs.title.sink { result in XCTAssertEqual(result, "Add invoice") }.store(in: &cancellables)
        viewModel.outputs.action.sink { result in XCTAssertEqual(result, .add) }.store(in: &cancellables)
        viewModel.outputs.total.sink { result in XCTAssertNil(result) }.store(in: &cancellables)
        viewModel.outputs.note.sink { result in XCTAssertNil(result) }.store(in: &cancellables)
        viewModel.outputs.image.sink { result in XCTAssertNil(result) }.store(in: &cancellables)
        viewModel.outputs.date.sink { result in XCTAssertEqual(result.stripTime(), Date().stripTime()) }.store(in: &cancellables)
    }

    func testAddIncoiceForm2() throws {
        var cancellables = Set<AnyCancellable>()
        let invoice = InvoiceItem(invoiceId: nil, date: nil, total: nil, currencyCode: nil, note: "Test", image: nil, imageId: nil)
        let viewModel = AddIncoiceFormViewModel(router: AddIncoiceFormRouter(nil),
                                                invoiceManager: InvoiceManager(localStore: LocalStorage(),
                                                                               imageStore: ImageStore()),
                                                invoice: invoice)

        viewModel.outputs.title.sink { result in XCTAssertEqual(result, "Add invoice") }.store(in: &cancellables)
        viewModel.outputs.action.sink { result in XCTAssertEqual(result, .add) }.store(in: &cancellables)
        viewModel.outputs.total.sink { result in XCTAssertNil(result) }.store(in: &cancellables)
        viewModel.outputs.note.sink { result in XCTAssertEqual(result, "Test") }.store(in: &cancellables)
    }

    func testAddIncoiceForm3() throws {
        var cancellables = Set<AnyCancellable>()
        let invoice = InvoiceItem(invoiceId: UUID(), date: Date.now, total: 0.0, currencyCode: "USD", note: "Notee", image: nil, imageId: nil)
        let viewModel = AddIncoiceFormViewModel(router: AddIncoiceFormRouter(nil),
                                                invoiceManager: InvoiceManager(localStore: LocalStorage(),
                                                                               imageStore: ImageStore()),
                                                invoice: invoice)

        viewModel.outputs.title.sink { result in XCTAssertEqual(result, "Edit invoice") }.store(in: &cancellables)
        viewModel.outputs.action.sink { result in XCTAssertEqual(result, .edit) }.store(in: &cancellables)
        viewModel.outputs.total.sink { result in XCTAssertEqual(result, "0.00") }.store(in: &cancellables)
        viewModel.outputs.note.sink { result in XCTAssertEqual(result, "Notee") }.store(in: &cancellables)
    }

    func testAddIncoiceForm4() throws {
        var cancellables = Set<AnyCancellable>()
        let invoice = InvoiceItem(invoiceId: UUID(), date: Date.now, total: 1254.356, currencyCode: "USD", note: "Notee", image: nil, imageId: nil)
        let viewModel = AddIncoiceFormViewModel(router: AddIncoiceFormRouter(nil),
                                                invoiceManager: InvoiceManager(localStore: LocalStorage(),
                                                                               imageStore: ImageStore()),
                                                invoice: invoice)

        viewModel.outputs.title.sink { result in XCTAssertEqual(result, "Edit invoice") }.store(in: &cancellables)
        viewModel.outputs.action.sink { result in XCTAssertEqual(result, .edit) }.store(in: &cancellables)
        viewModel.outputs.total.sink { result in XCTAssertEqual(result, "1,254.36") }.store(in: &cancellables)
        viewModel.outputs.note.sink { result in XCTAssertEqual(result, "Notee") }.store(in: &cancellables)
    }

    func testAddIncoiceForm5() throws {
        var cancellables = Set<AnyCancellable>()
        let invoice = InvoiceItem(invoiceId: UUID(), date: Date.now, total: 1254.356, currencyCode: "USD", note: "Notee", image: nil, imageId: nil)
        let viewModel = AddIncoiceFormViewModel(router: AddIncoiceFormRouter(nil),
                                                invoiceManager: InvoiceManager(localStore: LocalStorage(),
                                                                               imageStore: ImageStore()),
                                                invoice: invoice,
                                                locale: Locale(identifier: "sk"))

        viewModel.outputs.title.sink { result in XCTAssertEqual(result, "Edit invoice") }.store(in: &cancellables)
        viewModel.outputs.action.sink { result in XCTAssertEqual(result, .edit) }.store(in: &cancellables)
        viewModel.outputs.total.sink { result in XCTAssertEqual(result, "1 254,36") }.store(in: &cancellables)
        viewModel.outputs.note.sink { result in XCTAssertEqual(result, "Notee") }.store(in: &cancellables)
    }
}

public extension Date {
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day, .timeZone], from: self)
        guard let date = Calendar.current.date(from: components) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
}
