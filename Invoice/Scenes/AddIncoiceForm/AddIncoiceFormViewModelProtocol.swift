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
}


//MARK: AddIncoiceFormViewModelOutputs

enum AddIncoiceFormDestination {
    case navigateBack, cancel, editPhoto(invoice: InvoiceItem?)
}

enum ActionType {
    case edit, add
}

protocol AddIncoiceFormViewModelOutputs {
    
    var title: String? { get }
    
    var image: UIImage? { get }
    
    var note: String? { get }

    var date: Date? { get }

    var total: String? { get }
    
    var action: ActionType? { get }
    
    var navigateToDestination: PassthroughSubject<AddIncoiceFormDestination, Never> { get }
}


//MARK: AddIncoiceFormViewModelProtocol

protocol AddIncoiceFormViewModelProtocol: AnyObject {
    var inputs: AddIncoiceFormViewModelInputs { get }
    var outputs: AddIncoiceFormViewModelOutputs { get }
}
