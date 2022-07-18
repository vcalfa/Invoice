//
//  AddIncoiceFormViewModelProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Combine
import UIKit

// MARK: AddIncoiceFormViewModelInputs

protocol AddInvoiceFormViewModelInputs {
    var viewDidLoad: PassthroughSubject<Void, Never> { get }

    var viewDidAppear: PassthroughSubject<Void, Never> { get }

    var viewWillDisappear: PassthroughSubject<Void, Never> { get }
    
    var tapNavigateBack: PassthroughSubject<Void, Never> { get }

    var tapCancel: PassthroughSubject<Void, Never> { get }

    var tapEditPhoto: PassthroughSubject<Void, Never> { get }

    var tapSaveAddAction: PassthroughSubject<Void, Never> { get }

    var noteUpdated: PassthroughSubject<String?, Never> { get }

    var totalUpdated: PassthroughSubject<String?, Never> { get }

    var dateUpdated: PassthroughSubject<Date, Never> { get }
}

// MARK: AddInvoiceFormViewModelOutputs

enum AddInvoiceFormDestination {
    case navigateBack, cancel, editPhoto(invoice: InvoiceItem?)
}

enum ActionType {
    case edit, add
}

protocol AddInvoiceFormViewModelOutputs {
    var title: Published<String?>.Publisher { get }

    var image: Published<UIImage?>.Publisher { get }

    var note: Published<String?>.Publisher { get }

    var date: Published<Date>.Publisher { get }

    var total: Published<String?>.Publisher { get }

    var currencySymbol: Published<String?>.Publisher { get }

    var action: Published<ActionType>.Publisher { get }

    var navigateToDestination: PassthroughSubject<AddInvoiceFormDestination, Never> { get }
}

// MARK: AddInvoiceFormViewModelProtocol

protocol AddInvoiceFormViewModelProtocol: AnyObject {
    var inputs: AddInvoiceFormViewModelInputs { get }
    var outputs: AddInvoiceFormViewModelOutputs { get }
    var userActivityDelegate: NSUserActivityDelegate { get }
}
