//
//  CameraViewController.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Combine
import MobileCoreServices
import UIKit

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.inputs.viewWillDisappear.send()
    }
}

// MARK: - View Configurations

private extension CameraViewController {
    func configure() {
        delegate = self
        allowsEditing = true
        mediaTypes = [kUTTypeImage as String]
        bindInput()
        bindOutput()
    }

    private func bindOutput() {
        viewModel.inputs.viewDidAppear
            .sink { [weak self] _ in
                self?.configureUserActivity()
            }
            .store(in: &cancellables)
    }
    
    private func bindInput() {
        viewModel.inputs.viewWillDisappear
            .sink { [weak self] _ in
                self?.clearRestoreState()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension CameraViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        if let image = info[.editedImage] as? UIImage {
            viewModel.inputs.imageDidTake.send(image)
        } else if let image = info[.originalImage] as? UIImage {
            viewModel.inputs.imageDidTake.send(image)
        }
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        viewModel.inputs.actionCancel.send()
    }
}

// MARK: - UINavigationControllerDelegate

extension CameraViewController: UINavigationControllerDelegate {
    func navigationController(_: UINavigationController,
                              willShow _: UIViewController,
                              animated _: Bool) {}

    func navigationController(_: UINavigationController,
                              didShow _: UIViewController,
                              animated _: Bool) {}
}

extension CameraViewController: ConfigurableViewControllerProtocol {
    typealias ViewModelType = CameraViewModelProtocol
}

//// MARK: - CInstantiable
extension CameraViewController: Instantiable {}

extension CameraViewController: StateRestorable {
    var defaulUserActivity: NSUserActivity? {
        NSUserActivity(activity: .takePhoto)
    }

    func updateUserActivity(_ userActivity: NSUserActivity?) -> NSUserActivity? {
        userActivity?.delegate = viewModel.userActivityDelegate
        return userActivity
    }
}
