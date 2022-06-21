//
//  CameraViewController.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import UIKit
import Combine

final class CameraViewController: UIImagePickerController {
    
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: CameraViewModelProtocol!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.inputs.viewDidLoad.send()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.inputs.viewDidAppear.send()
    }
}

// MARK: - View Configurations
private extension CameraViewController {

    func configure() {
        delegate = self
        allowsEditing = true
        mediaTypes = ["public.image"]
        sourceType = .camera
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CameraViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.editedImage] as? UIImage
        viewModel.inputs.imageDidTake.send(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewModel.inputs.actionCancel.send()
    }
}

// MARK: - UINavigationControllerDelegate
extension CameraViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        
    }

    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {

    }
}

extension CameraViewController: ConfigurableViewControllerProtocol {
    typealias ViewModelType = CameraViewModelProtocol
}

//// MARK: - CInstantiable
extension CameraViewController: Instantiable { }
