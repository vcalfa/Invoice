//
//  InvoiceListViewController.swift
//  Invoice
//
//  Created by Vladimir Calfa on 18/06/2022.
//

import Combine
import CoreData
import UIKit

final class InvoiceListViewController: UIViewController {
    typealias Item = InvoiceItem
    typealias CoreDataItem = Invoice

    private var cancellables = Set<AnyCancellable>()
    private var collectionView: UICollectionView!

    var viewModel: InvoiceListViewModelProtocol!
    private var dataSource: ListDataSource<CoreDataItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        setupNavigationItem()
        bindInput()
        bindOutput()
        viewModel.inputs.viewDidLoad.send()
    }

    private func bindInput() {
        navigationItem.rightBarButtonItem?
            .publisher.map { _ in () }
            .subscribe(viewModel.inputs.tapAddInvoice)
            .store(in: &cancellables)

        navigationItem.leftBarButtonItem?
            .publisher.map { _ in () }
            .subscribe(viewModel.inputs.tapAddRandomInvoices)
            .store(in: &cancellables)
    }

    private func bindOutput() {
        viewModel.outputs.title
            .publisher.map { value -> String? in value }
            .assign(to: \.title, on: navigationItem)
            .store(in: &cancellables)

        viewModel.inputs.viewDidAppear
            .sink { [weak self] _ in
                self?.configureUserActivity()
            }
            .store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.performFetch()
    }
}

extension InvoiceListViewController: ConfigurableViewControllerProtocol {
    typealias ViewModelType = InvoiceListViewModelProtocol
}

// MARK: private UI functions

extension InvoiceListViewController {
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "+\(InvoiceListViewModel.generateRandomInvoices)", style: .plain, target: nil, action: nil)
    }

    private func setupUI() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.headerMode = .none
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }
    }

    private func configureDataSource() {

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, CoreDataItem> { cell, _, item in
            var content = cell.defaultContentConfiguration()
            content.text = item.note
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }

        dataSource = ListDataSource(collectionView: collectionView,
                                    managedObjectContext: viewModel.outputs.managedObjectContext!,
                                    bgManagedObjectContext: viewModel.outputs.bgManagedObjectContext!,
                                    fetchrequest: invoiceFetchRequest(),
                                    cellRegistration: cellRegistration)
    }

    private func invoiceFetchRequest() -> NSFetchRequest<CoreDataItem> {
        let request = NSFetchRequest<CoreDataItem>(entityName: "Invoice")
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateSort]
        request.fetchBatchSize = 50
        return request
    }
}

// MARK: bind functions

extension InvoiceListViewController {}

extension InvoiceListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        dataSource.getObject(for: indexPath).map {
            $0.invoiceId.map { viewModel.inputs.tapDetailInvoice.send($0) }
        }
    }
}

extension InvoiceListViewController: StateRestorable {
    var defaulUserActivity: NSUserActivity? { NSUserActivity(activityType: "") }

    func updateUserActivity(_: NSUserActivity?) -> NSUserActivity? { nil }

    @discardableResult
    func restore(with userActivity: NSUserActivity?) -> Bool {
        switch userActivity?.registredActivityType {
        case InfoPlist.ActivityType.editInvoice?, InfoPlist.ActivityType.takePhoto?:
            let restored = viewModel.inputs.restoreState(with: userActivity)
            return restored
        default:
            return false
        }
    }
}
