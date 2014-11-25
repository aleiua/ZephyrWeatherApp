//
//  TraitOverrideSplitViewController.swift
//  ZephyrWeatherApp
//
//  Created by A. Lynn on 11/25/14.
//  Copyright (c) 2014 Lexie Lynn. All rights reserved.
//

import UIKit
class TraitOverrideSplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performTraitCollectionOverrideForSize(view.bounds.size)
    }
    
    override func viewWillTransitionToSize(size: CGSize,
        withTransitionCoordinator coordinator:
        UIViewControllerTransitionCoordinator) {
            super.viewWillTransitionToSize(size, withTransitionCoordinator:
                coordinator)
            performTraitCollectionOverrideForSize(size)
    }
    
    private func performTraitCollectionOverrideForSize(size: CGSize) {
        var overrideTraitCollection: UITraitCollection? = nil
        if size.width > 320 {
            overrideTraitCollection =
                UITraitCollection(horizontalSizeClass: .Regular)
        }
        for vc in self.childViewControllers as [UIViewController] {
            setOverrideTraitCollection(overrideTraitCollection, 
                forChildViewController: vc)
        }
    }
    
}
