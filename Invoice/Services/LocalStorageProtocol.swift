//
//  LocalStorageProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

import Foundation
import CoreData

protocol LocalStoreProtocol {
    
    var getContext: NSManagedObjectContext? { get }

    func fetchAllInvoices() -> [Invoice]?
    func fetch(invoiceId: UUID?) -> Invoice?    
}
