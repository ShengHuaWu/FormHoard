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

struct Texting {
    let title: String
    var text: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
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

func buildTextCell(with driver: Driver<Texting>, from collectionView: UICollectionView, for indexPath: IndexPath) -> TextCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCell.cellIdentifier, for: indexPath) as? TextCell else {
        fatalError("Unrecognized cell type")
    }
    
    cell.titleLabel.text = driver.getValue(from: \.title)
    cell.textField.text = driver.getValue(from: \.text)
    cell.valueChange = { text in
        driver.update(\.text, with: text)
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
        label.font = .systemFont(ofSize: 20, weight: .medium)
        
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

final class TextCell: UICollectionViewCell {
    static let cellIdentifier = "TextCell"
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        
        return label
    }()
    
    private(set) lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 24, weight: .medium)
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        return textField
    }()
    
    var valueChange: ((String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            textField.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        valueChange?(text)
    }
}

final class ExampleViewController: UICollectionViewController {
    // MARK: Properties
    private let togglingDriver = Driver<Toggling>(element: Toggling(title: "Toggle"))
    private let textingDriver = Driver<Texting>(element: Texting(title: "Text", text: "Nothing"))

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: collectionView.frame.width, height: 44)
        
        collectionView.register(ToggleCell.self, forCellWithReuseIdentifier: ToggleCell.cellIdentifier)
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCell.cellIdentifier)
    }
}

// MARK: - UICollectionViewDataSource
extension ExampleViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            return buildToggleCell(with: togglingDriver, from: collectionView, for: indexPath)
        case 1:
            return buildTextCell(with: textingDriver, from: collectionView, for: indexPath)
        default:
            fatalError("Too many cells")
        }
    }
}
