//
//  PlayerPresentationViewController.swift
//  Podcast
//
//  Created by Austin Tooley on 7/21/18.
//  Copyright © 2018 Austin Tooley. All rights reserved.
//

import UIKit

class PlayerPresentationViewController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration: Double = 0.7
    var miniPlayerFrame: CGRect!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let destination = transitionContext.viewController(forKey: .to) as! PlayerViewController
        let containerView = transitionContext.containerView
        containerView.addSubview(destination.view)
        
        // MARK: Transition initial state
        let widthConstraint = destination.view.widthAnchor.constraint(equalToConstant: miniPlayerFrame.width)
        let heightConstraint = destination.view.heightAnchor.constraint(equalToConstant: miniPlayerFrame.height)
        let bottomConstraint = destination.view.bottomAnchor.constraint(equalTo: destination.view.bottomAnchor)
        
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, bottomConstraint])
        
        // Place over the miniplayer
        let translate = CATransform3DMakeTranslation(miniPlayerFrame.origin.x, miniPlayerFrame.origin.y, 0.0)
        destination.view.layer.transform = translate
        containerView.layoutIfNeeded() // force update if needed
        
        // Make it look like the mini player before we start
        
        
        // Extra animations
        
        
        // MARK: Transition final state
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.7) {
            NSLayoutConstraint.deactivate([widthConstraint, heightConstraint, bottomConstraint])
            destination.view.layer.transform = CATransform3DIdentity
            containerView.layoutIfNeeded()
            
            // Reset to normal
            
            
            // Final title state
        }
        // MARK: Transition completion
        animator.addCompletion { (finished) in
            transitionContext.completeTransition(true)
        }
        animator.startAnimation()
    }
}
