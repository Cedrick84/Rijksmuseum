//
//  ObjectListViewController.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import UIKit

class ObjectListViewController: UIViewController, ObjectListViewActionListener {
    
    var actionListener: (any ActionListener<ObjectListViewAction>)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .yellow
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.actionListener?.handle(action: .requestList)
        }
    }
    
}

extension ObjectListViewController: ObjectListViewUpdater {
    
    func update(state: ViewState<[ObjectSummaryCellViewModel]>) {
        print(state)
    }
}
