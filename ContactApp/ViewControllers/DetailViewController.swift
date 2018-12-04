//
//  DetailViewController.swift
//  ContactApp
//
//  Created by Anil Telaich on 29/11/18.
//  Copyright © 2018 Anil Telaich. All rights reserved.
//

import UIKit

fileprivate let kMasterContentViewTag : Int = 8888
fileprivate let kDetailsContentViewTag : Int = 7777
fileprivate let kMarginDesignationToParagraph : CGFloat = CGFloat(50)

// Fonts
fileprivate let kFontSizeContactName : CGFloat = CGFloat(19)
fileprivate let kFontSizeHeading : CGFloat = CGFloat(17)
fileprivate let kFontSizeParagraph : CGFloat = CGFloat(15)

fileprivate let kNumberOfSections = 1
fileprivate let kCellReusbaleIdentifier = "DetailViewCellIdentifier"

class DetailViewController: UICollectionViewController {
    weak var selectAndScrollDelegate : SelectAndScrollDelegate?
    private var contacts:[ContactItem]?
    
    var currentlySelectedIndexPath : IndexPath // can be used for configuring the "selection" state in new Cell for given index.
    
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
        currentlySelectedIndexPath = IndexPath(row: 0, section: 0)
        let flowLayout = layout as! UICollectionViewFlowLayout
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        self.contacts = (dataSourceDelegate!.dataSource(dataSourceInfo: nil) as! [ContactItem])
        self.selectAndScrollDelegate = selectAndScrollDelegate!
       
        super.init(collectionViewLayout: layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()       
        collectionView.setupDefaults(withReusableCellIdentifier: kCellReusbaleIdentifier, clipToBounds: true, enablePaging: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return kNumberOfSections
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contacts!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReusbaleIdentifier, for: indexPath)
        cell.configureForDetailsView(usingContatct: contacts![indexPath.row])
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScroll(scrollView: scrollView, withCellSize: collectionView.frame.size, selectAndScrollDelegate: selectAndScrollDelegate, computedVisibleIndexPath:&currentlySelectedIndexPath)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        performEndScrollingWithDelegate(selectAndScrollDelegate: selectAndScrollDelegate!, currentSelectedIndexPath: currentlySelectedIndexPath)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            performEndScrollingWithDelegate(selectAndScrollDelegate: selectAndScrollDelegate!, currentSelectedIndexPath: currentlySelectedIndexPath)
        }
    }
    
    func performEndScrollingWithDelegate(selectAndScrollDelegate:SelectAndScrollDelegate?, currentSelectedIndexPath:IndexPath?) {
        collectionView.selectItem(at: currentSelectedIndexPath, animated: true, scrollPosition: [])
        selectAndScrollDelegate!.didEndScrolling(collectionViewController: self)
    }
}

// MARK: UICollectionViewDelegateFlowLayout delegate methods
extension DetailViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
