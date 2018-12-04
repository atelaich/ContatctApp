//
//  UICollectionViewCell+Helpers.swift
//  ContactApp
//
//  Created by Anil Telaich on 03/12/18.
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

// Colors
fileprivate let kTitleFontColor = UIColor.lightGray
fileprivate let kDisplayNameFontColor = UIColor.black
fileprivate let kIntroductionTitleFontColor = UIColor.black
fileprivate let kIntroductionFontColor = UIColor.lightGray


// MARK: - MasterViewController cell helpers.
extension UICollectionViewCell {
    func configureForMasterView(usingContatct contact:ContactItem) {
        if let oldImageView = contentView.viewWithTag(kMasterContentViewTag) {
            oldImageView.removeFromSuperview()
        }
        
        let imageView : UIImageView = UIImageView(image: UIImage(named: contact.avtarFileName))
        imageView.tag = kMasterContentViewTag
        imageView.center = contentView.center
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                                     imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
    }
}

// MARK: - DetailsViewController cell helpers.
 extension UICollectionViewCell {
    
    func configureForDetailsView(usingContatct contact:ContactItem) {
        configureCellContents(with: contact)
    }
    
    fileprivate func spaceSeparatedAttributedTextForContactDisplayName(for firstName:String, and secondName:String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: firstName, attributes: [NSAttributedString.Key.font: UIFont(name: kFontHelveticaNeueBold, size: kFontSizeContactName) as Any])
        attributedText.append(NSMutableAttributedString(string: " \(secondName) ", attributes: [NSAttributedString.Key.font: UIFont(name: kFontHelveticaNeue, size: kFontSizeContactName) as Any]))
        
        return attributedText
    }
    
    fileprivate func configureCellContents(with contact:ContactItem) {
        if let oldImageView = contentView.viewWithTag(kDetailsContentViewTag) {
            oldImageView.removeFromSuperview()
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        view.tag = kDetailsContentViewTag
        
        let displayNameLabel = UILabel(frame: CGRect(x: 0, y: 2*kSubViewMarginConstant, width: 0, height: 0))
        displayNameLabel.textAlignment = .center
        displayNameLabel.textColor = kDisplayNameFontColor
        displayNameLabel.attributedText = spaceSeparatedAttributedTextForContactDisplayName(for: contact.firstName, and: contact.lastName)
        displayNameLabel.sizeToFit()
        displayNameLabel.center = CGPoint(x: view.center.x, y: displayNameLabel.center.y)
        view.addSubview(displayNameLabel)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: displayNameLabel.frame.maxY, width: 0, height: 0))
        titleLabel.font = UIFont(name: kFontHelveticaNeue, size: kFontSizeHeading)
        titleLabel.textColor = kTitleFontColor
        titleLabel.textAlignment = .center
        titleLabel.text = contact.title
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: view.center.x, y: titleLabel.center.y)
        view.addSubview(titleLabel)
        
        let introductionTitleLabel = UILabel(frame: CGRect(x: kSubViewMarginConstant, y: titleLabel.frame.maxY + kMarginDesignationToParagraph, width: 0, height: 0))
        introductionTitleLabel.font = UIFont(name: kFontHelveticaNeueBold, size: kFontSizeHeading)
        introductionTitleLabel.textColor = kIntroductionTitleFontColor
        introductionTitleLabel.textAlignment = .center
        introductionTitleLabel.text = kAboutMeLabelText
        introductionTitleLabel.sizeToFit()
        view.addSubview(introductionTitleLabel)
        
        let introductionTextView = UITextView(frame: CGRect(x: 0, y: introductionTitleLabel.frame.maxY, width: view.frame.size.width, height:view.frame.size.height - introductionTitleLabel.frame.maxY))
        introductionTextView.font = UIFont(name: kFontHelveticaNeue, size: kFontSizeParagraph)
        introductionTextView.textColor = kIntroductionFontColor
        introductionTextView.text = contact.introduction
        introductionTextView.isEditable = false
        
        view.addSubview(introductionTextView)
        contentView.addSubview(view)
    }
}
