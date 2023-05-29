//
//  ObjectDetailsViewController.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import UIKit

final class ObjectDetailsViewController: UIViewController, ObjectDetailsViewActionListener {
    
    var actionListener: (any ActionListener<ObjectDetailsViewAction>)?
    
    private var state: ViewState<ObjectDetailViewModel> = .empty

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(label)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if state == .empty {
            actionListener?.handle(action: .requestDetails)
        }
    }
}

extension ObjectDetailsViewController: ObjectDetailsViewUpdater {
    
    func update(state: ViewState<ObjectDetailViewModel>) {
        self.state = state
        
        switch state {
        case .empty:
            label.text = "Empty"
        case .loading:
            label.text = "Loading"
        case .loaded(let viewModel):
            label.text = viewModel.title
            textView.text = viewModel.description
        case .error(let errorMessage):
            label.text = errorMessage
            // TODO: retry button
        }
    }
}
