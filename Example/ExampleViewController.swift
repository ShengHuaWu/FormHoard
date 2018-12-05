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

struct Section {
    let numberOfItems = 2
    
    var toggling: Toggling
    var texting: Texting
}

func buildToggleCell(with driver: Driver<Section>, from collectionView: UICollectionView, for indexPath: IndexPath) -> ToggleCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToggleCell.cellIdentifier, for: indexPath) as? ToggleCell else {
        fatalError("Unrecognized cell type")
    }
    
    cell.titleLabel.text = driver.getValue(from: \.toggling.title)
    cell.switcher.isOn = driver.getValue(from: \.toggling.enabled)
    cell.valueChange = { isOn in
        driver.update(\.toggling.enabled, with: isOn)
    }
    
    return cell
}

func buildTextCell(with driver: Driver<Section>, from collectionView: UICollectionView, for indexPath: IndexPath) -> TextCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCell.cellIdentifier, for: indexPath) as? TextCell else {
        fatalError("Unrecognized cell type")
    }
    
    cell.titleLabel.text = driver.getValue(from: \.texting.title)
    cell.textField.text = driver.getValue(from: \.texting.text)
    cell.valueChange = { text in
        driver.update(\.texting.text, with: text)
    }
    
    return cell
}

func buildCellsInSection(with driver: Driver<Section>, from collectionView: UICollectionView, for indexPath: IndexPath) -> [UICollectionViewCell] {
    return [
        buildToggleCell(with: driver, from: collectionView, for: indexPath),
        buildTextCell(with: driver, from: collectionView, for: indexPath)
    ]
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

final class ExampleViewController: UICollectionViewController {
    // MARK: Properties
    private let driver = Driver<Section>(element: Section(
        toggling: Toggling(title: "Toggle"),
        texting: Texting(title: "Text", text: "Nothing")))

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
        return driver.getValue(from: \.numberOfItems)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return buildCellsInSection(with: driver, from: collectionView, for: indexPath)[indexPath.item]
    }
}
