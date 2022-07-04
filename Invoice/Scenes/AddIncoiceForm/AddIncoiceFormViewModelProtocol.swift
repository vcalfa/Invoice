//
//  AddIncoiceFormViewModelProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Combine
import UIKit

//MARK: AddIncoiceFormViewModelInputs

protocol AddIncoiceFormViewModelInputs {

    var viewDidLoad: PassthroughSubject<(), Never>  { get }
    
    var viewDidAppear: PassthroughSubject<(), Never>  { get }

    var tapNavigateBack:  PassthroughSubject<(), Never> { get }

    var tapCancel: PassthroughSubject<(), Never> { get }
    
    var tapEditPhoto: PassthroughSubject<(), Never> { get }
    
    var tapSaveAddAction: PassthroughSubject<(), Never> { get }
    
    var noteUpdated: PassthroughSubject<String?, Never> { get }
    
    var totalUpdated: PassthroughSubject<String?, Never> { get }
    
    var dateUpdated: PassthroughSubject<Date, Never> { get }
}


//MARK: AddIncoiceFormViewModelOutputs

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


//MARK: AddIncoiceFormViewModelProtocol

protocol AddIncoiceFormViewModelProtocol: AnyObject {
    var inputs: AddIncoiceFormViewModelInputs { get }
    var outputs: AddIncoiceFormViewModelOutputs { get }
    var userActivityDelegate: NSUserActivityDelegate { get }
}
