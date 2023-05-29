//
//  ObjectListViewController.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import UIKit

final class ObjectListViewController: UIViewController, ObjectListViewActionListener {
    
    var actionListener: (any ActionListener<ObjectListViewAction>)?
    
    private let imageDownloader: ImageDownloader
    private var collectionView: UICollectionView!
    private var state: PaginatedViewState<[ObjectSummaryCellViewModel]> = .empty
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    init(imageDownloader: ImageDownloader = ImageDownloaderImp { $0.resize(to: CGSize(width: 20, height: 20)) }) {
        self.imageDownloader = imageDownloader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(ArtObjectsHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ArtObjectsHeaderView.defaultReuseIdentifier)
        collectionView.register(ArtObjectSummaryCell.self,
                                forCellWithReuseIdentifier: ArtObjectSummaryCell.defaultReuseIdentifier)
        collectionView.register(LoadingFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: LoadingFooterView.defaultReuseIdentifier)
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        updateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if state == .empty {
            actionListener?.handle(action: .requestObjects)
        }
    }
    
    private func updateView() {
        collectionView.reloadData()
        
        switch state {
        case .empty:
            collectionView.isHidden = true
            activityIndicator.stopAnimating()
        case .loading:
            activityIndicator.startAnimating()
        case .partiallyLoaded, .loaded:
            collectionView.isHidden = false
            activityIndicator.stopAnimating()
        case .error(let message):
            showAlert(with: message)
        }
    }
    
    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            self.actionListener?.handle(action: .requestObjects)
        }
        alert.addAction(retryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ObjectListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return state.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        guard case .partiallyLoaded = state else {
            return .zero
        }
        
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String,
                        at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            actionListener?.handle(action: .requestObjects)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header: ArtObjectsHeaderView = collectionView.dequeueSupplementaryView(withKind: kind, forIndexPath: indexPath)
            header.set(title: "Rembrandt van Rijn")
            
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer: LoadingFooterView = collectionView.dequeueSupplementaryView(withKind: kind, forIndexPath: indexPath)
            footer.startAnimating()
            
            return footer
        default: fatalError("No registered supplementary element of kind \(kind).")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = state.items?[indexPath.row] else {
            fatalError("Trying to get a cell while no items are present.")
        }
        
        let cell: ArtObjectSummaryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.set(viewModel: viewModel, imageDownloader: imageDownloader)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = state.items?[indexPath.row] else {
            fatalError("Trying to get a cell while no items are present.")
        }
        
        actionListener?.handle(action: .openDetails(id: viewModel.id))
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.size.width, height: 50)
    }
}

extension ObjectListViewController: ObjectListViewUpdater {
    
    func update(state: PaginatedViewState<[ObjectSummaryCellViewModel]>) {
        self.state = state
        updateView()
    }
}
