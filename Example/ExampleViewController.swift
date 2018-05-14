//
//  ExampleViewController.swift
//  Example
//
//  Created by ShengHua Wu on 12.05.18.
//  Copyright © 2018 ShengHua Wu. All rights reserved.
//

import UIKit

final class ExampleViewController: UICollectionViewController {
    // MARK: Properties
    private let reuseIdentifier = "Cell"

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - UICollectionViewDataSource
extension ExampleViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: It is just a temporary number
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        // TODO: Configure cell with other details
        cell.contentView.backgroundColor = UIColor.yellow
        return cell
    }
}
