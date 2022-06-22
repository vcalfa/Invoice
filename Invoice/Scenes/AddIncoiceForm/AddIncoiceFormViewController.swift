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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var totalTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
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

    func setupNavigationItem() {
        navigationItem.leftBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
    }

    func configureViews() {
        imageview.contentMode = .scaleAspectFill
    }
    
    func setupStyles() { }
    
    func setupLayout() { }
    
    private func bindInput() {

        imageview.publisher(for: gestureRecognizer)
            .map({ _ in () })
            .subscribe(viewModel.inputs.tapEditPhoto)
            .store(in: &cancellables)
        
        navigationItem.rightBarButtonItem?
            .publisher.map({ _ in () })
            .subscribe(viewModel.inputs.tapSaveAddAction)
            .store(in: &cancellables)
        
        navigationItem.leftBarButtonItem?
            .publisher.map({ _ in () })
            .subscribe(viewModel.inputs.tapCancel)
            .store(in: &cancellables)
    }
    
    private func bindOutput() {
        viewModel.outputs.image
            .publisher.map({ val -> UIImage? in val })
            .assign(to: \.image, on: imageview)
            .store(in: &cancellables)
        
        viewModel.outputs.title
            .publisher.map({ val -> String? in val })
            .assign(to: \.title, on: navigationItem)
            .store(in: &cancellables)
        
        viewModel.outputs.note
            .publisher.map({ val -> String? in val })
            .assign(to: \.text, on: noteTextView)
            .store(in: &cancellables)
        
        viewModel.outputs.total
            .publisher.map({ val -> String? in val })
            .assign(to: \.text, on: totalTextField)
            .store(in: &cancellables)

        viewModel.outputs.date
            .publisher
            .assign(to: \.date, on: datePicker)
            .store(in: &cancellables)
    }
}

// MARK: - adjust scrollView insets
private extension AddIncoiceFormViewController {
    
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

        //let selectedRange = scrollView.selectedRange
        //scrollView.scrollRangeToVisible(selectedRange)
    }
}

// MARK: - ConfigurableViewControllerProtocol
extension AddIncoiceFormViewController: ConfigurableViewControllerProtocol {
    typealias ViewModelType = AddIncoiceFormViewModelProtocol
}


// MARK: - Instantiable
extension AddIncoiceFormViewController: Instantiable { }
