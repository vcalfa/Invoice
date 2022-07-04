//
//  AddIncoiceFormViewModelProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Combine
import UIKit

// MARK: AddIncoiceFormViewModelInputs

protocol AddIncoiceFormViewModelInputs {
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

// MARK: AddIncoiceFormViewModelOutputs

enum AddIncoiceFormDestination {
    case navigateBack, cancel, editPhoto(invoice: InvoiceItem?)
}

enum ActionType {
    case edit, add
}

protocol AddIncoiceFormViewModelOutputs {
    var title: Published<String?>.Publisher { get }

    var image: Published<UIImage?>.Publisher { get }

    var note: Published<String?>.Publisher { get }

    var date: Published<Date>.Publisher { get }

    var total: Published<String?>.Publisher { get }

    var currencySymbol: Published<String?>.Publisher { get }

    var action: Published<ActionType>.Publisher { get }

    var navigateToDestination: PassthroughSubject<AddIncoiceFormDestination, Never> { get }
}

// MARK: AddIncoiceFormViewModelProtocol

protocol AddIncoiceFormViewModelProtocol: AnyObject {
    var inputs: AddIncoiceFormViewModelInputs { get }
    var outputs: AddIncoiceFormViewModelOutputs { get }
    var userActivityDelegate: NSUserActivityDelegate { get }
}
