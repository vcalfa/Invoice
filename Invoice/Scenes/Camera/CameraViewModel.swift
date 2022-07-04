//
//  CameraViewModel.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Combine
import Foundation
import UIKit

class CameraViewModel: NSObject, CameraViewModelInputs, CameraViewModelOutputs {
    private var cancellables = Set<AnyCancellable>()

    // MARK: CameraViewModelProtocol

    @Published private(set) var title: String?

    let navigateToDestination = PassthroughSubject<CameraDestination, Never>()

    // MARK: -

    // MARK: CameraViewModelProtocol

    let viewDidLoad = PassthroughSubject<Void, Never>()

    let viewDidAppear = PassthroughSubject<Void, Never>()

    let actionCancel = PassthroughSubject<Void, Never>()

    let imageDidTake = PassthroughSubject<UIImage?, Never>()

    // MARK: -

    private let router: CameraRouter
    let invoice: InvoiceItem?

    init(router: CameraRouter, invoice: InvoiceItem? = nil) {
        self.router = router
        self.invoice = invoice
        super.init()

        outputs.navigateToDestination
            .sink(receiveValue: router.route(to:))
            .store(in: &cancellables)

        let finishAction = imageDidTake.map { [invoice] image -> CameraDestination in
            .finishAction(invoice: InvoiceItem(invoice: invoice, image: image))
        }

        actionCancel.map { _ -> CameraDestination in .cancel }
            .merge(with: finishAction)
            .subscribe(navigateToDestination)
            .store(in: &cancellables)
    }
}

extension CameraViewModel {}

extension CameraViewModel: CameraViewModelProtocol {
    var inputs: CameraViewModelInputs { self }
    var outputs: CameraViewModelOutputs { self }
    var userActivityDelegate: NSUserActivityDelegate { self }
}
