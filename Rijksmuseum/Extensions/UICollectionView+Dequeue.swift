//
//  UICollectionView+Dequeue.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionReusableView: ReusableView {}

extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier).")
        }
        
        return cell
    }
    
    func dequeueSupplementaryView<T: UICollectionReusableView>(withKind kind: String = UICollectionView.elementKindSectionHeader, forIndexPath indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue view with kind: \(kind) and identifier: \(T.defaultReuseIdentifier).")
        }
        
        return view
    }
}
