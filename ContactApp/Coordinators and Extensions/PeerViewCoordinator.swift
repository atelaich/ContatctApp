//
//  PeerViewCoordinator.swift
//  ContactApp
//
//  Created by Anil Telaich on 30/11/18.
//  Copyright © 2018 Anil Telaich. All rights reserved.
//

import UIKit

/// SelectAndScrollDelegate the protocol that need to be Confirmed to by PeerViewCoordinator kind of classes which,
/// handles coordination between children view controllers for selection of an item or scroll event in one PC.
/// Protocol treats all children like symmetric siblings(Peers) rather than Master/Detail
public protocol SelectAndScrollDelegate : class {
    func didSelectItem(collectionViewController:UICollectionViewController, atIndexPath indexPath:IndexPath)
    func beginScrollIfCan(collectionViewController:UICollectionViewController) -> Bool
    func didEndScrolling(collectionViewController:UICollectionViewController)
    func scrollViewDidScroll(scrollView:UIScrollView, inCollectionViewController collectionViewController:UICollectionViewController, indexOfVisibleRow visibleRowIndex:Int)
}

 class PeerViewCoordinator {
    weak var containerViewController : MasterDetailSplitViewController?
    
    init(containerViewController:UIViewController) {
        self.containerViewController = (containerViewController as! MasterDetailSplitViewController)
    }
}

extension PeerViewCoordinator : SelectAndScrollDelegate {

    /// Method determines the child view controller that triggered the select and selects the same item in other view controller(called peer VC).
    ///
    /// - Parameters:
    ///   - collectionViewController: UICollectionViewController instance that delegated the call.
    ///   - indexPath: the indexPath of selected item
    func didSelectItem(collectionViewController:UICollectionViewController, atIndexPath indexPath:IndexPath) {
        if let peerViewController = collectionViewController is MasterViewController ? containerViewController!.detailsViewController : containerViewController!.masterViewController {
            peerViewController.collectionView.selectItem(at: indexPath, animated: true, scrollPosition:peerViewController.collectionView.scrollPositionForCurrentScrollDirection())
            
        }
    }
    
    /// Method is called when one child VC is scrolled to a visible cell at visibleRowIndex.
    /// Method determines the target or Peer VC that should be coordinated with and adjusts its contentOffset to make its cell at the same index be visible.
    /// - Parameters:
    ///   - scrollView: the scroll view of VC that scrolled toa visible cell.
    ///   - collectionViewController: VC that scrolled toa visible cell.
    ///   - visibleRowIndex: the row# of cell that is visible due to scroll.
    func scrollViewDidScroll(scrollView:UIScrollView, inCollectionViewController collectionViewController:UICollectionViewController, indexOfVisibleRow visibleRowIndex:Int) {
        if let containerVC = containerViewController {
            if containerVC.currentlyScrollingPeer == collectionViewController {
                var peerViewController : UICollectionViewController = collectionViewController
                var peerViewControllerCellSize : CGSize = CGSize(width: 0, height: 0)
                var additionalOffset : CGFloat = CGFloat(0)
                if peerViewController is MasterViewController {
                    peerViewController = containerVC.detailsViewController as! DetailViewController
                    peerViewControllerCellSize = peerViewController.collectionView.frame.size
                }
                else if collectionViewController is DetailViewController {
                    peerViewController = containerVC.masterViewController as! MasterViewController
                    peerViewControllerCellSize = peerViewController.collectionView.flowLayout().itemSize
                    additionalOffset = peerViewController.collectionView.screenMidPointXorYForCurrentScrollDirection(forCellSize: peerViewController.collectionView.flowLayout().itemSize) * -1

                    let computedVisibleIndexPath = IndexPath(row: visibleRowIndex, section: 0)
                    (peerViewController as! MasterViewController).currentlySelectedIndexPath = computedVisibleIndexPath
                }
                UIView.animate(withDuration: kCustomAnimationDuration) {
                    peerViewController.collectionView.setContentOffsetForCurrentScrollDirection(forVisibleRow: visibleRowIndex, forCellSize: peerViewControllerCellSize, additionalOffset:additionalOffset)
                }
            }
        }
    }
    
    /// The Scroll of the VC's should be coordinated. One VC follows the other. When one Peer VC is scrolling, other should follow and not scroll on its own.
    /// Method lets the VC know if it can Scroll.
    ///
    /// - Parameter collectionViewController: UICollectionViewController requesting scroll.
    /// - Returns: returns true if collectionViewController can scroll else false.
    func beginScrollIfCan(collectionViewController: UICollectionViewController) -> Bool {
        var canScroll = false
        if let containerVC = containerViewController {
            if containerVC.currentlyScrollingPeer == nil || containerVC.currentlyScrollingPeer == collectionViewController {
                containerVC.currentlyScrollingPeer = collectionViewController
                canScroll = true
            }
        } else {
            canScroll = true
        }
        return canScroll
    }
    
    /// This is complimentary call to beginScrollIfCan(collectionViewController: UICollectionViewController) -> Bool
    /// The VC controller call this when its scrolling is successfully ended so that the Peer VC can scroll if desired.
    ///
    /// - Parameter collectionViewController: collectionViewController
    func didEndScrolling(collectionViewController: UICollectionViewController) {
        if let containerVC = containerViewController {
            if containerVC.currentlyScrollingPeer == collectionViewController {
                containerVC.currentlyScrollingPeer = nil
            }
        }
    }
}
