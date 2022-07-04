//
//  InvoiceListViewModel.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

import Foundation
import Combine
import CoreData

class InvoiceListViewModel: InvoiceListViewModelProtocol, InvoiceListViewModelInputs, InvoiceListViewModelOutputs {
    
    static let generateRandomInvoices = 50
    
    var inputs: InvoiceListViewModelInputs { self }
    var outputs: InvoiceListViewModelOutputs { self }
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: InvoiceListViewModelOutputs
    
    @Published private(set) var title: String?
    
    @Published private var itemsWrapper: [InvoiceItem]?
    
    var items: Published<[InvoiceItem]?>.Publisher { $itemsWrapper }
    
    let navigateToDestination = PassthroughSubject<InvoiceListDestination, Never>()
    //MARK: -
    
    //MARK: InvoiceListViewModelInputs
    
    let viewDidLoad = PassthroughSubject<(), Never>()
    
    let viewDidAppear = PassthroughSubject<(), Never>()
    
    let tapAddInvoice = PassthroughSubject<(), Never>()
    
    let tapAddRandomInvoices = PassthroughSubject<(), Never>()
    
    let tapDetailInvoice = PassthroughSubject<UUID, Never>()
    
    //MARK: -
    
    private let router: InvoiceListRouter
    private let storage: LocalStoreProtocol
    private let stateRostorationRouter: InvoiceListStateRestorationProtocol
    private let invoiceManager: InvoiceManagerProtocol
    
    init(router: InvoiceListRouter,
         storage: LocalStoreProtocol,
         stateRostorationRouter: InvoiceListStateRestorationProtocol,
         invoiceManager: InvoiceManagerProtocol)
    {
        self.router = router
        self.storage = storage
        self.stateRostorationRouter = stateRostorationRouter
        self.invoiceManager = invoiceManager
        
        outputs.navigateToDestination
            .sink(receiveValue: router.route(to:))
            .store(in: &cancellables)
        
        title = "Invoices"
        
        tapAddInvoice.map({ _ -> InvoiceListDestination in .addingInvoice })
            .merge(with: tapDetailInvoice.map({ id -> InvoiceListDestination in .detailInvoice(uuid: id) }))
            .subscribe(navigateToDestination)
            .store(in: &cancellables)
        
        
        tapAddRandomInvoices
            .sink(receiveValue: { [weak self] invoice in
                for i in 1...Self.generateRandomInvoices {
                    dump(i, name: "Generate")
                    let invoice = InvoiceItem.random()
                    self?.invoiceManager.save(invoice, completition: { result in
                        DispatchQueue.main.async {
                            dump(result)
                        }
                    })
                }
            })
            .store(in: &cancellables)
    }
    
    func restoreState(with userActivity: NSUserActivity?) -> Bool {
        stateRostorationRouter.restore(userActivity)
    }
    
    //MARK: The CoreData
    
    var managedObjectContext: NSManagedObjectContext? { storage.viewContext }
    
    var bgManagedObjectContext: NSManagedObjectContext? { storage.bgViewContext }
}
