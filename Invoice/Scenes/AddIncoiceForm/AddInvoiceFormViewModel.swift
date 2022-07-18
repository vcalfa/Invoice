//
//  AddIncoiceFormViewModel.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Combine
import CombineExt
import Foundation
import UIKit

class AddInvoiceFormViewModel: NSObject, AddInvoiceFormViewModelInputs, AddInvoiceFormViewModelOutputs {
    private var cancellable = Set<AnyCancellable>()

    private lazy var totalFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.locale = self.locale
        return currencyFormatter
    }()

    // MARK: AddInvoiceFormViewModelOutputProtocol

    @Published private(set) var _title: String?
    var title: Published<String?>.Publisher { $_title }

    @Published private(set) var _image: UIImage?
    var image: Published<UIImage?>.Publisher { $_image }

    @Published private(set) var _note: String?
    var note: Published<String?>.Publisher { $_note }

    @Published private(set) var _date: Date = .init()
    var date: Published<Date>.Publisher { $_date }

    @Published private(set) var _total: String?
    var total: Published<String?>.Publisher { $_total }

    @Published private(set) var _currencySymbol: String?
    var currencySymbol: Published<String?>.Publisher { $_currencySymbol }

    @Published private(set) var _action: ActionType = .add
    var action: Published<ActionType>.Publisher { $_action }

    @Published private(set) var updatedValue: InvoiceItem?

    let navigateToDestination = PassthroughSubject<AddInvoiceFormDestination, Never>()

    // MARK: -

    // MARK: AddInvoiceFormViewModelInputProtocol

    let viewDidLoad = PassthroughSubject<Void, Never>()

    let viewDidAppear = PassthroughSubject<Void, Never>()

    let viewWillDisappear = PassthroughSubject<Void, Never>()

    let tapNavigateBack = PassthroughSubject<Void, Never>()

    let tapCancel = PassthroughSubject<Void, Never>()

    let tapEditPhoto = PassthroughSubject<Void, Never>()

    let tapSaveAddAction = PassthroughSubject<Void, Never>()

    let noteUpdated = PassthroughSubject<String?, Never>()

    let totalUpdated = PassthroughSubject<String?, Never>()

    let dateUpdated = PassthroughSubject<Date, Never>()

    // MARK: -

    private let initialValue = CurrentValueSubject<InvoiceItem?, Never>(nil)
    private let initialUUIDValue = CurrentValueSubject<UUID?, Never>(nil)
    private let router: AddInvoiceFormRouter
    private let invoiceManager: InvoiceManagerProtocol
    private let locale: Locale

    init(router: AddInvoiceFormRouter,
         invoiceManager: InvoiceManagerProtocol,
         invoice: InvoiceItem? = nil,
         invoiceID: UUID? = nil,
         locale: Locale = Locale.current)
    {
        self.router = router
        self.invoiceManager = invoiceManager
        self.locale = locale
        super.init()
        initialValue.send(invoice)
        initialUUIDValue.send(invoiceID)
        bindNavigation()
        bindUpdateInvoice()
    }

    private func bindUpdateInvoice() {
        initialValue
            .sink(receiveValue: setModel)
            .store(in: &cancellable)

        initialUUIDValue
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] invoiceId in
                self?.invoiceManager.getInvoice(invoiceId: invoiceId, completion: { result in
                    dump(result)
                    switch result {
                    case let .success(invoice):
                        self?.setModel(invoice)
                    case .failure:
                        break
                    }
                })
            })
            .store(in: &cancellable)

        noteUpdated.combineLatest($updatedValue)
            .map { InvoiceItem(invoice: $1, note: $0) }
            .assign(to: &$updatedValue)

        totalUpdated.map { [weak self] in
            $0.flatMap { self?.totalFormatter.number(from: $0)?.doubleValue }
        }
        .combineLatest($updatedValue)
        .map { InvoiceItem(invoice: $1, total: $0) }
        .assign(to: &$updatedValue)

        dateUpdated.combineLatest($updatedValue)
            .map { InvoiceItem(invoice: $1, date: $0) }
            .assign(to: &$updatedValue)
    }

    private func bindNavigation() {
        navigateToDestination
            .sink(receiveValue: router.route(to:))
            .store(in: &cancellable)

        tapSaveAddAction.withLatestFrom($updatedValue)
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] invoice in
                dump(invoice)
                self?.invoiceManager.save(invoice, completion: { result in
                    dump(result)
                    DispatchQueue.main.async {
                        self?.tapCancel.send(())
                    }
                })
            })
            .store(in: &cancellable)

        let navigateEditPhoto = tapEditPhoto.combineLatest($updatedValue)
            .map { _, invoice -> AddInvoiceFormDestination in
                .editPhoto(invoice: invoice)
            }

        tapNavigateBack.map { _ -> AddInvoiceFormDestination in .navigateBack }
            .merge(with: tapCancel.map { _ -> AddInvoiceFormDestination in .cancel })
            .merge(with: navigateEditPhoto)
            .subscribe(navigateToDestination)
            .store(in: &cancellable)
    }

    private func setModel(_ invoice: InvoiceItem?) {
        if let image = invoice?.image {
            _image = image
        } else if let invoice = invoice, let _ = invoice.imageId {
            invoiceManager.getImage(for: invoice) { [weak self] result in
                switch result {
                case let .success(image):
                    self?._image = image
                case .failure:
                    self?._image = nil
                }
            }
        }
        _date = invoice?.date ?? Date()
        _currencySymbol = invoice?.currencyCode.map { $0.currencySymbol }
        _total = invoice.flatMap { $0.total }
            .flatMap { totalFormatter.string(from: NSNumber(value: $0)) }
        _note = invoice?.note
        _title = invoice?.invoiceId == nil ? "Add invoice" : "Edit invoice"
        _action = invoice?.invoiceId == nil ? .add : .edit
        updatedValue = InvoiceItem(invoice: invoice)
    }
}

extension AddInvoiceFormViewModel {}

extension AddInvoiceFormViewModel: AddInvoiceFormViewModelProtocol {
    var inputs: AddInvoiceFormViewModelInputs { self }
    var outputs: AddInvoiceFormViewModelOutputs { self }
    var userActivityDelegate: NSUserActivityDelegate { self }
}
