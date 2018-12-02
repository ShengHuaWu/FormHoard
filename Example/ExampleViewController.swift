//
//  ExampleViewController.swift
//  Example
//
//  Created by ShengHua Wu on 12.05.18.
//  Copyright © 2018 ShengHua Wu. All rights reserved.
//

import UIKit

struct Toggling {
    var enabled: Bool
}

final class ToggleCell :UICollectionViewCell {
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        
        return label
    }()
    
    private(set) lazy var switcher: UISwitch = {
        let switcher = UISwitch(frame: .zero)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        
        return switcher
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(switcher)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            switcher.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ExampleViewController: UICollectionViewController {
    // MARK: Properties
    private let reuseIdentifier = "ToggleCell"

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: collectionView.frame.width, height: 44)
        
        collectionView!.register(ToggleCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - UICollectionViewDataSource
extension ExampleViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ToggleCell else {
            fatalError("Unrecognized cell type")
        }
        cell.titleLabel.text = "Toggle"
        return cell
    }
}
