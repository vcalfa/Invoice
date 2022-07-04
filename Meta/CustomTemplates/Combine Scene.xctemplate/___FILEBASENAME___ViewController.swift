// ___FILEHEADER___

import Combine
import UIKit

final class ___VARIABLE_productName:identifier___ViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()

    var viewModel: ___VARIABLE_productName: identifier___ViewModelProtocol!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // setupUI()
        // setupNavigationItem()
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

private extension ___VARIABLE_productName: identifier___ViewController {
    // func setupUI() { }

    // func setupNavigationItem() { }

    func configureViews() {}

    func setupStyles() {
        // view.backgroundColor = .green
    }

    func setupLayout() {}

    private func bindInput() {
        navigationItem.leftBarButtonItem?
            .publisher.map { _ in () }
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

extension ___VARIABLE_productName: identifier___ViewController {
    // Remove if not needed
}

// MARK: - ConfigurableViewControllerProtocol

extension ___VARIABLE_productName:identifier___ViewController: ConfigurableViewControllerProtocol {
    typealias ViewModelType = ___VARIABLE_productName: identifier___ViewModelProtocol
}

// MARK: - Instantiable

extension ___VARIABLE_productName:identifier___ViewController: Instantiable {}
