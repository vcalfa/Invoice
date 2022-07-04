// ___FILEHEADER___

import Combine

// MARK: ___VARIABLE_productName:identifier___ViewModelInputs

protocol ___VARIABLE_productName: identifier___ViewModelInputs {
    var viewDidLoad: PassthroughSubject<Void, Never> { get }

    var viewDidAppear: PassthroughSubject<Void, Never> { get }

    var tapNavigateBack: PassthroughSubject<Void, Never> { get }

    var tapCancel: PassthroughSubject<Void, Never> { get }
}

// MARK: ___VARIABLE_productName:identifier___ViewModelOutputs

enum ___VARIABLE_productName: identifier___Destination {
    case navigateBack, cancel
}

protocol ___VARIABLE_productName: identifier___ViewModelOutputs {
    var title: String? { get }

    var navigateToDestination: PassthroughSubject<___VARIABLE_productName: identifier___Destination, Never> { get }
}

// MARK: ___VARIABLE_productName:identifier___ViewModelProtocol

protocol ___VARIABLE_productName:identifier___ViewModelProtocol: AnyObject {
    var inputs: ___VARIABLE_productName: identifier___ViewModelInputs { get }
    var outputs: ___VARIABLE_productName: identifier___ViewModelOutputs { get }
}
