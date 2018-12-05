//
//  UICollectionViewController+Helpers.swift
//  ContactApp
//
//  Created by Anil Telaich on 01/12/18.
//  Copyright © 2018 Anil Telaich. All rights reserved.
//

import UIKit

// MARK: UICollectionViewController helpers
public extension UICollectionViewController {
    
    /// Given an X or Y and cellsize and cell spacing, the method determines the approximate index of the cell
    ///
    func itemRowForOffset(offsetParameter:CGFloat, lineSpacing:CGFloat, cellSize:CGSize, scrollDirection:UICollectionView.ScrollDirection) -> Int {
        let scrollDirection = collectionView.flowLayout().scrollDirection
        let cellDimension : CGFloat = scrollDirection == .horizontal ? cellSize.width : cellSize.height
        let effectiveCellWidth = cellDimension + lineSpacing
        var numberOfItems : Int = 0
        if effectiveCellWidth != 0 {
            numberOfItems = Int(offsetParameter/effectiveCellWidth)
            if numberOfItems > collectionView.numberOfItems(inSection: 0) - 1 {
                numberOfItems = collectionView.numberOfItems(inSection: 0) - 1
            }
            if numberOfItems < 0 {
                numberOfItems = 0
            }
            
        }
        return numberOfItems
    }    
    
    /// Calls itemRowForOffset, however before that determines the index.
    ///
    /// - Parameters:
    ///   - contentOffset: CGPoint specifying the offset.
    ///   - cellSize: cellSize
    /// - Returns: index of visible row as described above.
    func computedVisibleRowIndex(forContentOffset contentOffset:CGPoint, currentCellSize cellSize:CGSize) -> Int {
        let flowLayout = collectionView.flowLayout()
        let scrollDirection = flowLayout.scrollDirection
        let inputOffset = scrollDirection == .horizontal ? contentOffset.x : contentOffset.y
        return itemRowForOffset(offsetParameter:inputOffset, lineSpacing:flowLayout.minimumLineSpacing, cellSize:cellSize, scrollDirection: scrollDirection)
    }
    
    
    /// A reusable method common for all coordinating VCs.
    /// Calls delegate if it can scroll. If true then computes the visble cell index and calls delegate method for further handling.
    ///
    /// - Parameters:
    ///   - scrollView: scrollView of the caller that was scrolled.
    ///   - cellSize: celler's cellSize
    ///   - selectAndScrollDelegate: selectAndScrollDelegate
    ///   - computedVisibleIndexPath: an out parameter that caller passed in to update latest selection index value.
    func scrollViewDidScroll(scrollView:UIScrollView, withCellSize cellSize:CGSize, selectAndScrollDelegate:SelectAndScrollDelegate?, computedVisibleIndexPath:inout IndexPath) {
        if selectAndScrollDelegate!.beginScrollIfCan(collectionViewController:self) {
            let computedVisibleRow : Int = computedVisibleRowIndex(forContentOffset: scrollView.contentOffset, currentCellSize:cellSize)
            computedVisibleIndexPath = IndexPath(row: computedVisibleRow, section: 0)
            selectAndScrollDelegate!.scrollViewDidScroll(scrollView: scrollView, inCollectionViewController:self, indexOfVisibleRow:computedVisibleRow)
        }
    }
}

