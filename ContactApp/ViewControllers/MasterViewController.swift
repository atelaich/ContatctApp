//
//  MasterViewController.swift
//  ContactApp
//
//  Created by Anil Telaich on 29/11/18.
//  Copyright © 2018 Anil Telaich. All rights reserved.
//

import UIKit

fileprivate let kNumberOfSections = 1
fileprivate let kCellReusbaleIdentifier = "MasterViewCellIdentifier"

private let kInterItemSpacing : CGFloat = CGFloat(1)
private let kCellSizeWidth : CGFloat = CGFloat(70)
private let kCellSizeHeight : CGFloat = CGFloat(70)
private let cellSize : CGSize = CGSize(width: kCellSizeWidth, height: kCellSizeHeight)

class MasterViewController: UICollectionViewController {
    private weak var selectAndScrollDelegate:SelectAndScrollDelegate?
    private var contacts:[ContactItem]?

    @objc var currentlySelectedIndexPath : IndexPath {
        didSet {
            print("Called: did Set.The value got updated. The current value is : \(currentlySelectedIndexPath)")
        }
    } // used for configuring the "selection" state in new Cell for given index.
    
    // MARK: initializers
    required init?(coder aDecoder: NSCoder) {
        currentlySelectedIndexPath = IndexPath(row: 0, section: 0)
        super.init(coder: aDecoder)
    }
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - layout: flowlayout object that has the scroll direction as set by the client
    ///   - dataSourceDelegate: dataSourceDelegate set by client's context
    ///   - selectAndScrollDelegate: selectAndScrollDelegate set by client's context
    init(collectionViewLayout layout: UICollectionViewLayout, dataSourceDelegate:DataSourceDelegate?, selectAndScrollDelegate:SelectAndScrollDelegate?) {
        let flowLayout = layout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = kInterItemSpacing
        flowLayout.estimatedItemSize = cellSize
        flowLayout.itemSize = cellSize
        currentlySelectedIndexPath = IndexPath(row: 0, section: 0)
        self.contacts = (dataSourceDelegate!.dataSource(dataSourceInfo: nil) as! [ContactItem])
        self.selectAndScrollDelegate = selectAndScrollDelegate
        
        super.init(collectionViewLayout: layout)
    }
    
    // MARK: Overrides and delegate implementations
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                                     collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     collectionView.leftAnchor.constraint(equalTo: view.leftAnchor)])
        collectionView.setupDefaults(withReusableCellIdentifier: kCellReusbaleIdentifier, clipToBounds: true, enablePaging: false)
        addObserver(self, forKeyPath: #keyPath(currentlySelectedIndexPath), options: .old, context: nil)
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentlySelectedIndexPath" {
            print("The value got updated.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.selectItem(at: currentlySelectedIndexPath, animated: true, scrollPosition: collectionView.scrollPositionForCurrentScrollDirection())
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return kNumberOfSections
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contacts!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReusbaleIdentifier, for: indexPath)
        cell.configureForMasterView(usingContatct: contacts![indexPath.row])
        cell.contentView.backgroundColor = indexPath == currentlySelectedIndexPath ? kCellSelectionBackgroundColor : UIColor.clear
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedCell = collectionView.cellForItem(at: indexPath) {
            selectedCell.contentView.backgroundColor = UIColor.clear
        }
    }    
    
    /// Will set the content offset which is apprppriate to center the selected cell.
    /// also, indicate to the selectAndScrollDelegate so that it can perform any coordination task.
    fileprivate func animateAndAdjustContentOffsetToKeepSelectionInCenter() {
        UIView.animate(withDuration: kCustomAnimationDuration, animations: {
            self.collectionView.setContentOffsetForCurrentScrollDirection(forVisibleRow: self.currentlySelectedIndexPath.row, forCellSize:cellSize, additionalOffset:-self.collectionView.screenMidPointXorYForCurrentScrollDirection(forCellSize:cellSize))
        }, completion: { (finished:Bool) in
            self.selectAndScrollDelegate!.didEndScrolling(collectionViewController: self)
        })
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectAndScrollDelegate!.didSelectItem(collectionViewController:self, atIndexPath: indexPath)        
        self.selectAndScrollDelegate!.didEndScrolling(collectionViewController: self)
    }
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if FeatureManagerFlagScrollFromMaster == true {
            scrollViewDidScroll(scrollView: scrollView, withCellSize:cellSize, selectAndScrollDelegate: selectAndScrollDelegate, computedVisibleIndexPath:&currentlySelectedIndexPath)
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if FeatureManagerFlagScrollFromMaster == true {
            perfomEndScrollingWithDelegate(selectAndScrollDelegate: selectAndScrollDelegate, currentSelectedIndexPath: currentlySelectedIndexPath)
        }
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if FeatureManagerFlagScrollFromMaster == true {
            if !decelerate { // if there is not further momentum perform post requisites
                perfomEndScrollingWithDelegate(selectAndScrollDelegate: selectAndScrollDelegate, currentSelectedIndexPath: currentlySelectedIndexPath)
            }
        }
    }    

    func perfomEndScrollingWithDelegate(selectAndScrollDelegate:SelectAndScrollDelegate?, currentSelectedIndexPath:IndexPath?) {
        if FeatureManagerFlagScrollFromMaster == true {
            // set the right offset for selected cell with animation
            // selectAndScrollDelegate!.didEndScrolling(collectionViewController: self)
        }
    }
}
