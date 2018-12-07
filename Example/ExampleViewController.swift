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

final class Driver<Element> {
    // TODO: Implement driver
}

struct Section {
    let cells: [UICollectionViewCell]
}

final class ExampleViewController: UICollectionViewController {
    // MARK: Properties
    private let sections: [Section]
    
    init(sections: [Section]) {
        self.sections = sections
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return sections[indexPath.section].cells[indexPath.item]
    }
}
