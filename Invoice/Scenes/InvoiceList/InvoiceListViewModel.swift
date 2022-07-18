//
//  InvoiceListViewModel.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

import Combine
import CoreData
import Foundation

class InvoiceListViewModel: InvoiceListViewModelProtocol, InvoiceListViewModelInputs, InvoiceListViewModelOutputs {
    static let generateRandomInvoices = 50

    var inputs: InvoiceListViewModelInputs { self }
    var outputs: InvoiceListViewModelOutputs { self }

    private var cancellables = Set<AnyCancellable>()

    // MARK: InvoiceListViewModelOutputs

    @Published private(set) var title: String?

    @Published private var itemsWrapper: [InvoiceItem]?

    var items: Published<[InvoiceItem]?>.Publisher { $itemsWrapper }

    let navigateToDestination = PassthroughSubject<InvoiceListDestination, Never>()

    // MARK: -

    // MARK: InvoiceListViewModelInputs

    let viewDidLoad = PassthroughSubject<Void, Never>()

    let viewDidAppear = PassthroughSubject<Void, Never>()

    let tapAddInvoice = PassthroughSubject<Void, Never>()

    let tapAddRandomInvoices = PassthroughSubject<Void, Never>()

    let tapDetailInvoice = PassthroughSubject<UUID, Never>()

    // MARK: -

    private let router: InvoiceListRouter
    private let storage: LocalStoreProtocol
    private let stateRestorationRouter: InvoiceListStateRestorationProtocol
    private let invoiceManager: InvoiceManagerProtocol

    init(router: InvoiceListRouter,
         storage: LocalStoreProtocol,
         stateRestorationRouter: InvoiceListStateRestorationProtocol,
         invoiceManager: InvoiceManagerProtocol)
    {
        self.router = router
        self.storage = storage
        self.stateRestorationRouter = stateRestorationRouter
        self.invoiceManager = invoiceManager

        outputs.navigateToDestination
            .sink(receiveValue: router.route(to:))
            .store(in: &cancellables)

        title = "Invoices"

        tapAddInvoice.map { _ -> InvoiceListDestination in .addingInvoice }
            .merge(with: tapDetailInvoice.map { id -> InvoiceListDestination in .detailInvoice(uuid: id) })
            .subscribe(navigateToDestination)
            .store(in: &cancellables)

        tapAddRandomInvoices
            .sink(receiveValue: { [weak self] _ in
                for i in 1 ... Self.generateRandomInvoices {
                    dump(i, name: "Generate")
                    let invoice = InvoiceItem.random()
                    self?.invoiceManager.save(invoice, completion: { result in
                        DispatchQueue.main.async {
                            dump(result)
                        }
                    })
                }
            })
            .store(in: &cancellables)
    }

    func restoreState(with userActivity: NSUserActivity?) -> Bool {
        stateRestorationRouter.restore(userActivity)
    }

    // MARK: The CoreData

    var managedObjectContext: NSManagedObjectContext? { storage.viewContext }

    var bgManagedObjectContext: NSManagedObjectContext? { storage.bgViewContext }
}
