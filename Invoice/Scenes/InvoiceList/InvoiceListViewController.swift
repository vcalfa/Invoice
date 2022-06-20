//
//  InvoiceListViewController.swift
//  Invoice
//
//  Created by Vladimir Calfa on 18/06/2022.
//

import UIKit
import Combine

final class InvoiceListViewController: UIViewController {

    typealias Item = InvoiceRecord
    
    private var cancellables = Set<AnyCancellable>()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>!
    private var collectionView: UICollectionView!

    private var viewModel: InvoiceListViewModelProtocol = InvoiceListViewModel()
    private var router: InvoiceListRouterProtocol = InvoiceListRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        setupNavigationItem()
        bindViewModel()
        viewModel.inputs.viewDidLoad.send()
    }
    
    private func bindViewModel() {
        viewModel.outputs.items
            .sink(receiveValue: itemData)
            .store(in: &cancellables)
        
        viewModel.outputs.title
            .publisher
            .sink(receiveValue: { [weak self] value in self?.navigationItem.title = value })
//            .assign(to: \.title, on: self.navigationItem)
            .store(in: &cancellables)
        
        navigationItem.rightBarButtonItem?
            .publisher
            .sink(receiveValue: { [router] _ in router.navigateAddInvoice() })
            .store(in: &cancellables)
    }
}

//MARK: private UI functions

extension InvoiceListViewController {
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }
    
    private func setupUI() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
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

