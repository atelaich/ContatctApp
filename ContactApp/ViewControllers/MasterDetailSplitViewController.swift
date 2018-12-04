//
//  MasterDetailSplitViewController.swift
//  ContactApp
//
//  Created by Anil Telaich on 28/11/18.
//  Copyright © 2018 Anil Telaich. All rights reserved.
//

import UIKit

/// A container view contrroller class which visually displays its children like master detail view controllers.
/// The class honours orientation changes and currently changes the Scroll direction based on current device orientation.
/// e.g. in Vertical orientation, the split is Top--Bottom and the scrolling direction is horizontal and vertical respectively for Master and Details VC respectively.
/// The view controller owns its children and initializes them with PeerViewCoordinator and DataSourceCoordinator instances.
class MasterDetailSplitViewController: UIViewController {
    
    // class owns its children view controllers and
    var masterViewController : UICollectionViewController?
    var detailsViewController : UICollectionViewController?
    var currentlyScrollingPeer : UICollectionViewController?
    
    private var peerViewCoordinator : PeerViewCoordinator?
    private var dataSourceCoordinator : DataSourceCoordinator?
    
    private var splitType : SplitType = .Vertical
    private var splitWidth : CGFloat = CGFloat(0)
    
    // constraints
    private var horizontalSplitConstraintsMaster : [NSLayoutConstraint] = []
    private var verticalSplitConstraintsMaster : [NSLayoutConstraint] = []
    private var horizontalSplitConstraintsDetail : [NSLayoutConstraint] = []
    private var verticalSplitConstraintsDetail : [NSLayoutConstraint] = []
    
    // MARK: initializers
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init?(splitType:SplitType, splitWidth: CGFloat) {
        
        super.init(nibName: nil, bundle: nil)
        self.splitType = splitType
        self.splitWidth = splitWidth
        
        self.peerViewCoordinator = PeerViewCoordinator(containerViewController: self)
        self.dataSourceCoordinator = DataSourceCoordinator(withDataSourceInfo: nil) 
        
        let masterFlowLayout = UICollectionViewFlowLayout()
        masterFlowLayout.scrollDirection = splitType == .Vertical ? .horizontal : .vertical
        self.masterViewController = MasterViewController(collectionViewLayout: masterFlowLayout, dataSourceDelegate:dataSourceCoordinator, selectAndScrollDelegate:peerViewCoordinator)
        
        let detailsFlowLayout = UICollectionViewFlowLayout()
        detailsFlowLayout.scrollDirection = splitType == .Vertical ? .vertical : .horizontal
        self.detailsViewController = DetailViewController(collectionViewLayout: detailsFlowLayout, dataSourceDelegate:dataSourceCoordinator, selectAndScrollDelegate:peerViewCoordinator)
    }
    
    // MARK: Overridden methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        addSubViewController(viewController: masterViewController!)
        addSubViewController(viewController: detailsViewController!)
        
        createConstraints()
        navigationItem.title = kContactsNavigationTitle
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if splitType == .Vertical {
            NSLayoutConstraint.deactivate(horizontalSplitConstraintsMaster)
            NSLayoutConstraint.deactivate(horizontalSplitConstraintsDetail)
            NSLayoutConstraint.activate(verticalSplitConstraintsMaster)
            NSLayoutConstraint.activate(verticalSplitConstraintsDetail)
        }
        else {
            NSLayoutConstraint.deactivate(verticalSplitConstraintsMaster)
            NSLayoutConstraint.deactivate(verticalSplitConstraintsDetail)
            NSLayoutConstraint.activate(horizontalSplitConstraintsMaster)
            NSLayoutConstraint.activate(horizontalSplitConstraintsDetail)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if size != view.frame.size {
            if size.width > size.height {
                splitType = .Horizontal
                if let masterVC = masterViewController {
                    masterVC.collectionView.flowLayout().scrollDirection = .vertical
                }
                if let detailsVC = detailsViewController {
                    detailsVC.collectionView.flowLayout().scrollDirection = .horizontal
                }
            }
            else {
                splitType = .Vertical
                if let masterVC = masterViewController {
                    masterVC.collectionView.flowLayout().scrollDirection = .horizontal
                }
                if let detailsVC = detailsViewController {
                    detailsVC.collectionView.flowLayout().scrollDirection = .vertical
                }
            }
            detailsViewController?.collectionView.reloadData()
            view.setNeedsUpdateConstraints()
        }
    }
    
    func addSubViewController(viewController:UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
        
    func createConstraints() {
        if let masterVC = masterViewController {
            masterVC.view.translatesAutoresizingMaskIntoConstraints = false
            verticalSplitConstraintsMaster.append(masterVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
            verticalSplitConstraintsMaster.append(masterVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:kSubViewMarginConstant))
            verticalSplitConstraintsMaster.append(masterVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:-kSubViewMarginConstant))
            verticalSplitConstraintsMaster.append(masterVC.view.heightAnchor.constraint(equalToConstant:splitWidth))
            
            horizontalSplitConstraintsMaster.append(masterVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
            horizontalSplitConstraintsMaster.append(masterVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:kSubViewMarginConstant))
            horizontalSplitConstraintsMaster.append(masterVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
            horizontalSplitConstraintsMaster.append(masterVC.view.widthAnchor.constraint(equalToConstant:splitWidth))
        }
        
        if let detailsVC = detailsViewController {
            detailsVC.view.translatesAutoresizingMaskIntoConstraints = false
            verticalSplitConstraintsDetail.append(detailsVC.view.topAnchor.constraint(equalTo: (masterViewController?.view.bottomAnchor)!))
            verticalSplitConstraintsDetail.append(detailsVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:kSubViewMarginConstant))
            verticalSplitConstraintsDetail.append(detailsVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:-kSubViewMarginConstant))
            verticalSplitConstraintsDetail.append(detailsVC.view.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor))
            
            horizontalSplitConstraintsDetail.append(detailsVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
            horizontalSplitConstraintsDetail.append(detailsVC.view.leadingAnchor.constraint(equalTo: (masterViewController!.view.trailingAnchor)))
            horizontalSplitConstraintsDetail.append(detailsVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:-kSubViewMarginConstant))
            horizontalSplitConstraintsDetail.append(detailsVC.view.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor))
        }
    }   
}
