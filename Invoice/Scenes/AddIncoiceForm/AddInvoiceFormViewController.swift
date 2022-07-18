//
//  AddIncoiceFormViewController.swift
//  Invoice
//
//  Created by Vladimir Calfa on 21/06/2022.
//

import Combine
import CombineCocoa
import UIKit

final class AddInvoiceFormViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()

    var viewModel: AddInvoiceFormViewModelProtocol!

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageview: UIImageView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var totalTextField: UITextField!
    @IBOutlet var noteTextView: UITextView!
    @IBOutlet var currencyLabel: UILabel!

    private var gestureRecognizer: UITapGestureRecognizer {
        let doubleTap = UITapGestureRecognizer()
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.numberOfTapsRequired = 2
        return doubleTap
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        registerKeyboardNotifications()
        configureViews()
        setupStyles()
        setupLayout()
        bindOutput()
        bindInput()
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

private extension AddInvoiceFormViewController {
    func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: nil)
        // navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
    }

    func configureViews() {
        imageview.contentMode = .scaleAspectFill
    }

    func setupStyles() {
        noteTextView.clipsToBounds = true
        noteTextView.layer.cornerRadius = 5.0
        noteTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        noteTextView.layer.borderWidth = 0.7
    }

    func setupLayout() {}

    private func bindInput() {
        imageview.publisher(for: gestureRecognizer)
            .map { _ in () }
            .subscribe(viewModel.inputs.tapEditPhoto)
            .store(in: &cancellables)

        navigationItem.leftBarButtonItem?
            .publisher.map {
                dump($0)
                return ()
            }
            .subscribe(viewModel.inputs.tapCancel)
            .store(in: &cancellables)

        navigationItem.rightBarButtonItem?
            .publisher.map {
                dump($0)
                return ()
            }
            .subscribe(viewModel.inputs.tapSaveAddAction)
            .store(in: &cancellables)

        noteTextView.valuePublisher
            .subscribe(viewModel.inputs.noteUpdated)
            .store(in: &cancellables)

        totalTextField.textPublisher
            .subscribe(viewModel.inputs.totalUpdated)
            .store(in: &cancellables)

        datePicker.datePublisher
            .subscribe(viewModel.inputs.dateUpdated)
            .store(in: &cancellables)
    }

    private func bindOutput() {
        viewModel.outputs.image
            .assign(to: \.image, on: imageview)
            .store(in: &cancellables)

        viewModel.outputs.title
            .assign(to: \.title, on: navigationItem)
            .store(in: &cancellables)

        viewModel.outputs.note
            .assign(to: \.text, on: noteTextView)
            .store(in: &cancellables)

        viewModel.outputs.total
            .assign(to: \.text, on: totalTextField)
            .store(in: &cancellables)

        viewModel.outputs.date
            .assign(to: \.date, on: datePicker)
            .store(in: &cancellables)

        viewModel.outputs.currencySymbol
            .assign(to: \.text, on: currencyLabel)
            .store(in: &cancellables)

        viewModel.outputs.action
            .map(updateRightBarButton)
            .assign(to: \.rightBarButtonItem, on: navigationItem)
            .store(in: &cancellables)

        viewModel.inputs.viewDidAppear
            .sink { [weak self] _ in
                self?.configureUserActivity()
            }
            .store(in: &cancellables)
        
        viewModel.inputs.viewWillDisappear
            .sink { [weak self] _ in
                self?.clearRestoreState()
            }
            .store(in: &cancellables)
    }

    private func updateRightBarButton(_ action: ActionType) -> UIBarButtonItem {
        switch action {
        case .edit: return UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        case .add: return UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        }
    }
}

// MARK: - adjust scrollView insets

private extension AddInvoiceFormViewController {
    func registerKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset

        if let firstResponder = scrollView.firstResponder {
            let offsetRect = firstResponder.bounds.offsetBy(dx: 0, dy: 12)
            let adjustedRect = firstResponder.convert(offsetRect, to: scrollView)
            scrollView.scrollRectToVisible(adjustedRect, animated: true)
        }
    }
}

private extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
}

// MARK: - ConfigurableViewControllerProtocol

extension AddInvoiceFormViewController: ConfigurableViewControllerProtocol {
    typealias ViewModelType = AddInvoiceFormViewModelProtocol
}

extension AddInvoiceFormViewController: StateRestorable {
    var defaultUserActivity: NSUserActivity? {
        NSUserActivity(activity: .editInvoice)
    }

    func updateUserActivity(_ userActivity: NSUserActivity?) -> NSUserActivity? {
        userActivity?.delegate = viewModel.userActivityDelegate
        return userActivity
    }
}
