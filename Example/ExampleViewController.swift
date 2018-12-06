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

struct FormSection {
    enum Item: Int, CaseIterable {
        case toggling
        case texting
    }
    
    let numberOfItems = Item.allCases.count
    
    var toggling: Toggling
    var texting: Texting
}

struct FormInfo {
    enum Section: Int, CaseIterable {
        case first
        case second
    }
    
    let numberOfSections = Section.allCases.count
    
    var first: FormSection
    var second: FormSection
}

func buildToggleCell(with driver: Driver<FormInfo>, from collectionView: UICollectionView, for indexPath: IndexPath) -> ToggleCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToggleCell.cellIdentifier, for: indexPath) as? ToggleCell else {
        fatalError("Unrecognized cell type")
    }
    
    cell.titleLabel.text = driver.getValue(from: \.first.toggling.title)
    cell.switcher.isOn = driver.getValue(from: \.first.toggling.enabled)
    cell.valueChange = { isOn in
        driver.update(\.first.toggling.enabled, with: isOn)
    }
    
    return cell
}

func buildTextCell(with driver: Driver<FormInfo>, from collectionView: UICollectionView, for indexPath: IndexPath) -> TextCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCell.cellIdentifier, for: indexPath) as? TextCell else {
        fatalError("Unrecognized cell type")
    }
    
    cell.titleLabel.text = driver.getValue(from: \.second.texting.text)
    cell.textField.text = driver.getValue(from: \.second.texting.text)
    cell.valueChange = { text in
        driver.update(\.second.texting.text, with: text)
    }
    
    return cell
}

func buildCellInSection(with driver: Driver<FormInfo>, from collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
    guard let item = FormSection.Item(rawValue: indexPath.item) else {
        fatalError("Item doesn't exist.")
    }
    
    switch item {
    case .toggling:
        return buildToggleCell(with: driver, from: collectionView, for: indexPath)
    case .texting:
        return buildTextCell(with: driver, from: collectionView, for: indexPath)
    }
}

func numberOfItems(in section: Int, with driver: Driver<FormInfo>) -> Int {
    guard let section = FormInfo.Section(rawValue: section) else {
        fatalError("Section doesn't exist.")
    }
    
    switch section {
    case .first:
        return driver.getValue(from: \.first.numberOfItems)
    case .second:
        return driver.getValue(from: \.second.numberOfItems)
    }
}

func buildCellInForm(with driver: Driver<FormInfo>, from collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
    guard let section = FormInfo.Section(rawValue: indexPath.section) else {
        fatalError("Section doesn't exist.")
    }
    
    switch section {
    case .first:
        return buildCellInSection(with: driver, from: collectionView, for: indexPath)
    case .second:
        return buildCellInSection(with: driver, from: collectionView, for: indexPath)
    }
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
    private let driver = Driver<FormInfo>(element:
        FormInfo(
            first:
                FormSection(
                    toggling: Toggling(title: "Toggle"),
                    texting: Texting(title: "Text", text: "Nothing")
                ),
            second:
                FormSection(
                    toggling: Toggling(title: "Toggle"),
                    texting: Texting(title: "Text", text: "Nothing")
                )
        )
    )

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
        return driver.getValue(from: \.numberOfSections)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(in: section, with: driver)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return buildCellInSection(with: driver, from: collectionView, for: indexPath)
    }
}
