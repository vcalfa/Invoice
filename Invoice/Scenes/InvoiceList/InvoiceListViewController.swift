//
//  InvoiceListViewController.swift
//  Invoice
//
//  Created by Vladimir Calfa on 18/06/2022.
//

import UIKit
import Combine

final class InvoiceListViewController: UIViewController {

    typealias Item = InvoiceItem
    
    private var cancellables = Set<AnyCancellable>()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>!
    private var collectionView: UICollectionView!

    var viewModel: InvoiceListViewModelProtocol!
    
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
            .publisher.map({ _ in () })
            .subscribe(viewModel.inputs.tapAddInvoice)
            .store(in: &cancellables)
    }
    
    private func bindOutput() {
        viewModel.outputs.items
            .sink(receiveValue: itemData)
            .store(in: &cancellables)
        
        viewModel.outputs.title
            .publisher.map({ value -> String? in value })
            .assign(to: \.title, on: navigationItem)
            .store(in: &cancellables)
    }
}


extension InvoiceListViewController: ConfigurableViewControllerProtocol {
    typealias ViewModelType = InvoiceListViewModelProtocol
}

//MARK: private UI functions

extension InvoiceListViewController {
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }
    
    private func setupUI() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.headerMode = .firstItemInSection
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }
    }
    
    private func configureDataSource() {
        
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.note
            cell.contentConfiguration = content
            cell.accessories = [.outlineDisclosure()]
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.note
            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            if indexPath.item == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        }
    }
}

extension InvoiceListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let menuItem = dataSource.itemIdentifier(for: indexPath) else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.inputs.tapDetailInvoice.send(menuItem.identifier)
    }
}

//MARK: bind functions

extension InvoiceListViewController {
    func itemData(_ items: [Item]) {

        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        let sections = [0]
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)

        for section in sections {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
            let headerItem = Item(note: "Section \(section)")
            sectionSnapshot.append([headerItem])
            sectionSnapshot.append(items, to: headerItem)
            sectionSnapshot.expand([headerItem])
            dataSource.apply(sectionSnapshot, to: section)
        }
    }
}

