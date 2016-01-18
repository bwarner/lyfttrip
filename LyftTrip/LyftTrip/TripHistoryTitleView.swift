//
//  TripHistoryTitleView.swift
//  LyftTrip
//
//  Created by Byron Warner on 1/17/16.
//  Copyright © 2016 Byron Warner. All rights reserved.
//

import UIKit

@IBDesignable
class TripHistoryTitleView : UIView {
    
    
    func loadAndLayout(nibName:String, bundle:NSBundle, container:UIView, owner:NSObject! = nil) -> UIView? {
        let nib = UINib(nibName: nibName, bundle:bundle)
        let views = nib.instantiateWithOwner(owner, options: nil)
        if views.count == 0 {
            return nil
        }
        let view = views[0] as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = self.frame
        container.addSubview(view)
        container.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views:["view":view]))
        container.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views:["view":view]))
        return view
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        loadAndLayout("TripHistoryTitleView", bundle: NSBundle(forClass: self.dynamicType), container: self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadAndLayout("TripHistoryTitleView", bundle: NSBundle(forClass: self.dynamicType), container: self)
    }
}