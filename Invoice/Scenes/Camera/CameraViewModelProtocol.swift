//
//  CameraViewModelProtocol.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Combine
import UIKit

// MARK: CameraViewModelInputs

protocol CameraViewModelInputs {
    var viewDidLoad: PassthroughSubject<Void, Never> { get }

    var viewDidAppear: PassthroughSubject<Void, Never> { get }

    var viewWillDisappear: PassthroughSubject<Void, Never> { get }
    
    var actionCancel: PassthroughSubject<Void, Never> { get }

    var imageDidTake: PassthroughSubject<UIImage?, Never> { get }
}

// MARK: CameraViewModelOutputs

enum CameraDestination {
    case cancel
    case finishAction(invoice: InvoiceItem?)
}

protocol CameraViewModelOutputs {
    var navigateToDestination: PassthroughSubject<CameraDestination, Never> { get }
}

// MARK: CameraViewModelProtocol

protocol CameraViewModelProtocol: AnyObject {
    var inputs: CameraViewModelInputs { get }
    var outputs: CameraViewModelOutputs { get }
    var userActivityDelegate: NSUserActivityDelegate { get }
}
