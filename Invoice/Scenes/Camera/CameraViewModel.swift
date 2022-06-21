//
//  CameraViewModel.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Foundation
import UIKit
import Combine

class CameraViewModel: CameraViewModelInputs, CameraViewModelOutputs {
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: CameraViewModelProtocol
    
    @Published private(set) var title: String?
    
    let navigateToDestination = PassthroughSubject< CameraDestination, Never>()
    //MARK: -
    
    //MARK: CameraViewModelProtocol
    
    let viewDidLoad = PassthroughSubject<(), Never>()
    
    let viewDidAppear = PassthroughSubject<(), Never>()
    
    let actionCancel = PassthroughSubject<(), Never>()
    
    let imageDidTake = PassthroughSubject<UIImage?, Never>()
    
    //MARK: -
    
    private var router: CameraRouter
    
    init(router: CameraRouter) {
        self.router = router
        title = "Camera"
        
        outputs.navigateToDestination
            .sink(receiveValue: router.route(to:))
            .store(in: &cancellables)
        
        actionCancel.map({ _ -> CameraDestination in .cancel })
            .merge(with: imageDidTake.map({ image -> CameraDestination in .finisAction(image: image) }))
            .subscribe(navigateToDestination)
            .store(in: &cancellables)
    }
}

extension CameraViewModel {
    
}

extension CameraViewModel: CameraViewModelProtocol {
    
    var inputs: CameraViewModelInputs { self }
    var outputs: CameraViewModelOutputs { self }
}
