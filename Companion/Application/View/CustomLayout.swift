//
//  CustomLayout.swift
//  SwiftyCompanion
//
//  Created by Viktor PELIVAN on 12/3/19.
//  Copyright © 2019 Viktor PELIVAN. All rights reserved.
//

import UIKit


class CustomLayout: UICollectionViewLayout {
        
        let CELL_HEIGHT: CGFloat = 60
        let CELL_WIDTH: CGFloat = 60
        
        var cellAttributesDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
        var contentSize = CGSize.zero
        
        override var collectionViewContentSize: CGSize {
            get {
                return contentSize
            }
        }
        var dataSourceDidUpdate = true
        
        override func prepare() {
            
            collectionView?.bounces = false
            dataSourceDidUpdate = false
            
            for section in 0 ..< collectionView!.numberOfSections {
                for item in 0 ..< collectionView!.numberOfItems(inSection: section) {
                    let cellIndexPath = IndexPath(item: item, section: section)
                    let xPos = CGFloat(item) * CELL_WIDTH
                    let yPos = CGFloat(section) * CELL_HEIGHT
                    
                    let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndexPath)
                    cellAttributes.frame = CGRect(x: xPos, y: yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
                    
                    // Determine zIndex based on cell type.
                    if section == 0 && item == 0 {
                        cellAttributes.zIndex = 4
                    } else if section == 0 {
                        cellAttributes.zIndex = 3
                    } else if item == 0 {
                        cellAttributes.zIndex = 2
                    } else {
                        cellAttributes.zIndex = 1
                    }
                    cellAttributesDictionary[cellIndexPath] = cellAttributes
                }
            }
            
            let contentWidth = CGFloat(collectionView!.numberOfItems(inSection: 0)) * CELL_WIDTH
            let contentHeight = CGFloat(collectionView!.numberOfSections) * CELL_HEIGHT
            contentSize = CGSize(width: contentWidth, height: contentHeight)
        }
        
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            var attributesInRect = [UICollectionViewLayoutAttributes]()

            for cellAttrs in cellAttributesDictionary.values {
                if rect.intersects(cellAttrs.frame) {
                    attributesInRect.append(cellAttrs)
                }
            }
            return attributesInRect
        }
        
        override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            return cellAttributesDictionary[indexPath]
        }
        
        override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return true
        }
}
