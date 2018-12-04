//
//  ExampleViewController.swift
//  Example
//
//  Created by ShengHua Wu on 12.05.18.
//  Copyright © 2018 ShengHua Wu. All rights reserved.
//

import UIKit

struct Toggling {
    let title: String
    var enabled: Bool
    
    init(title: String, enabled: Bool = false) {
        self.title = title
        self.enabled = enabled
    }
}

func buildToggleCell(with driver: Driver<Toggling>, from collectionView: UICollectionView, for indexPath: IndexPath) -> ToggleCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToggleCell.cellIdentifier, for: indexPath) as? ToggleCell else {
        fatalError("Unrecognized cell type")
    }
    
    cell.titleLabel.text = driver.getValue(from: \.title)
    cell.switcher.isOn = driver.getValue(from: \.enabled)
    cell.valueChange = { isOn in
        driver.update(\.enabled, with: isOn)
    }
    
    return cell
}

final class Driver<Element> {
    private var element: Element {
        didSet {
            print("\(element)")
        }
    }
    
    init(element: Element) {
        self.element = element
    }
    
    func update<Value>(_ kp: WritableKeyPath<Element, Value>, with value: Value) {
        element[keyPath: kp] = value
    }
    
    func getValue<Value>(from kp: KeyPath<Element, Value>) -> Value {
        return element[keyPath: kp]
    }
}

final class ToggleCell :UICollectionViewCell {
    static let cellIdentifier = "ToggleCell"
    
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
    private let driver = Driver<Toggling>(element: Toggling(title: "Toggle"))

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: collectionView.frame.width, height: 44)
        
        collectionView!.register(ToggleCell.self, forCellWithReuseIdentifier: ToggleCell.cellIdentifier)
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
        let cell = buildToggleCell(with: driver, from: collectionView, for: indexPath)
        return cell
    }
}
