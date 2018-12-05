//
//  UICollectionView+Helpers.swift
//  ContactApp
//
//  Created by Anil Telaich on 01/12/18.
//  Copyright © 2018 Anil Telaich. All rights reserved.
//

import UIKit
public extension UICollectionView {
    public func flowLayout() -> UICollectionViewFlowLayout {
        return self.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    /// Given a CGPoint the method returns X or Y based on current scroll direction.
    /// e.g. if its horizontal then returns X.
    public func offsetXorYForCurrentScrollDirection(usingOffset:CGPoint) -> CGFloat {
        return self.flowLayout().scrollDirection == .horizontal ? usingOffset.x : usingOffset.y
    }
    
    /// Convenience method that returns position for finish of scroll.
    ///
    public func scrollPositionForCurrentScrollDirection() -> UICollectionView.ScrollPosition {
        return self.flowLayout().scrollDirection == .horizontal ? .centeredHorizontally : .top
    }
    
    
    /// Returns the Offset X or Y for given row index and cell size. Methods determines the scroll direction and
    ///
    /// - Parameters:
    ///   - row: row index whose offset id required.
    ///   - cellSize: the cell size to compute the offset of.
    /// - Returns: the offset in the scroll direction.
    func computedXOrYForCurrentScrollDirection(forRow row:Int, cellSize:CGSize, flowLayout:UICollectionViewFlowLayout)->CGFloat {
        let cellDimension = flowLayout.scrollDirection == .horizontal ?  cellSize.width : cellSize.height
        let offsetXorY = ((cellDimension + flowLayout.minimumLineSpacing) * CGFloat(row))
        return offsetXorY
    }    
   
    
    /// The method calls computedXOrYForCurrentScrollDirection to get the offset and sets it to receiver.
    /// determines the scroll direction to determine whether to apply X or Y
    ///
    /// - Parameters:
    ///   - row: row index whose offset id required.
    ///   - cellSize: the cell size to compute the offset of.
    ///   - additionalOffset: caller may specify a constant to be added.
    func setContentOffsetForCurrentScrollDirection(forVisibleRow row:Int, forCellSize cellSize:CGSize, additionalOffset:CGFloat) {
        let flowLayout = self.flowLayout()
        var computedXOrY = computedXOrYForCurrentScrollDirection(forRow: row, cellSize: cellSize, flowLayout: flowLayout)
        computedXOrY += additionalOffset
        contentOffset = flowLayout.scrollDirection == .horizontal ? CGPoint(x:computedXOrY, y:contentOffset.y) :  CGPoint(x: contentOffset.x, y:computedXOrY)
    }
    
    
    /// Returns an offset value for current scroll direction which can be used to center the cell of given size.
    ///
    /// - Parameter cellSize: cell size to be centered.
    /// - Returns: the offset as described above.
    func screenMidPointXorYForCurrentScrollDirection(forCellSize cellSize:CGSize) -> CGFloat {
        let scrollDirectionHorizontal = flowLayout().scrollDirection == .horizontal
        let screenXorY = scrollDirectionHorizontal ? frame.size.width :frame.size.height
        let cellXorY = scrollDirectionHorizontal ? cellSize.width : cellSize.height
        return (screenXorY - cellXorY)/2
    }
    
    func updateCellSelection(forNewIndex newIndexPath:IndexPath, oldIndexPath:IndexPath) {
        if let oldCell = cellForItem(at:oldIndexPath) {
            oldCell.contentView.backgroundColor = UIColor.clear
        }
        if let newCell = cellForItem(at:newIndexPath) {
            newCell.contentView.backgroundColor = kCellSelectionBackgroundColor
        }
    }
    
    func setupDefaults(withReusableCellIdentifier cellIdentifier: String, clipToBounds clip: Bool, enablePaging enable: Bool) {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = UIColor.white
        clipsToBounds = clip
        isPagingEnabled = enable
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
}
