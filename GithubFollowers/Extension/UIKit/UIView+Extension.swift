//
//  UIView+Ext.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 15/10/2024.
//

import UIKit

//MARK: - CONSTRAINT
extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func pinEdgesToSuperView(useSafeLayoutGuide: Bool = false) {
        guard let superview = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        if useSafeLayoutGuide {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
                self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
                self.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superview.topAnchor),
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            ])
        }
    }
    
    func constraintSize(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: height),
        ])
    }
}

//MARK: - ANIMATION
extension UIView {
        
    func addBlurEffect(with style: UIBlurEffect.Style = .regular) {
        let blurEffect = UIBlurEffect(style: style)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        addSubview(blurredEffectView)
    }
    
    func removeBlurEffect() {
        let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
        blurredEffectViews.forEach{ blurView in
            blurView.removeFromSuperview()
        }
    }
    
    func shake(completion: (() -> Void)? = nil) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if let completion = completion {
                completion()
            }
        }
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }
}
