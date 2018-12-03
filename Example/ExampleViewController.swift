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

final class TogglerDriver {
    private var toggling = Toggling(enabled: false) {
        didSet {
            print("\(toggling.enabled)")
        }
    }
    
    let cellIdentifier = "ToggleCell"
    let cellType = ToggleCell.self
    let title = "Toggle"
    
    func updateToggling(with isOn: Bool) {
        toggling.enabled = isOn
    }
    
    func dequeueCell(from collectionView: UICollectionView, for indexPath: IndexPath) -> ToggleCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ToggleCell else {
            fatalError("Unrecognized cell type")
        }
        
        return cell
    }
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
        switcher.addTarget(self, action: #selector(switcherValueChanged(_:)), for: .valueChanged)
        
        return switcher
    }()
    
    var valueChange: ((Bool) -> ())?
    
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
    
    @objc func switcherValueChanged(_ sender: UISwitch) {
        valueChange?(sender.isOn)
    }
}

final class ExampleViewController: UICollectionViewController {
    // MARK: Properties
    private let driver = TogglerDriver()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: collectionView.frame.width, height: 44)
        
        collectionView!.register(driver.cellType, forCellWithReuseIdentifier: driver.cellIdentifier)
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
        let cell = driver.dequeueCell(from: collectionView, for: indexPath)
        cell.titleLabel.text = driver.title
        cell.valueChange = driver.updateToggling
        
        return cell
    }
}
