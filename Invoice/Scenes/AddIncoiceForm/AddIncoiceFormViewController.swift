//
//  AddIncoiceFormViewController.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import UIKit
import Combine

final class AddIncoiceFormViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: AddIncoiceFormViewModelProtocol! 

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //setupUI()
        //setupNavigationItem()
        configureViews()
        setupStyles()
        setupLayout()
        bindInput()
        bindOutput()
        viewModel.inputs.viewDidLoad.send()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.inputs.viewDidAppear.send()
    }
}

// MARK: - View Configurations
private extension AddIncoiceFormViewController {

    //func setupUI() { }

    //func setupNavigationItem() { }

    func configureViews() {
        
    }
    
    func setupStyles() {
        view.backgroundColor = .green
    }
    
    func setupLayout() {
        
    }
    
    private func bindInput() {
        navigationItem.leftBarButtonItem?
            .publisher.map({ _ in () })
            .sink(receiveValue: { [viewModel] _ in viewModel?.inputs.tapNavigateBack.send() })
            .store(in: &cancellables)
    }
    
    private func bindOutput() {
        viewModel.outputs.title
            .publisher
            .sink(receiveValue: { [weak self] value in self?.navigationItem.title = value })
            .store(in: &cancellables)
    }
}

// MARK: - 
extension AddIncoiceFormViewController {
    // Remove if not needed
}

// MARK: - ConfigurableViewControllerProtocol
extension AddIncoiceFormViewController: ConfigurableViewControllerProtocol {
    typealias ViewModelType = AddIncoiceFormViewModelProtocol
}


// MARK: - Instantiable
extension AddIncoiceFormViewController: Instantiable { }
