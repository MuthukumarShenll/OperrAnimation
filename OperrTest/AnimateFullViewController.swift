//
//  AnimateFullViewController.swift
//  OperrTest
//
//  Created by Shenll_IMac on 22/02/19.
//  Copyright © 2019 STS. All rights reserved.
//

import UIKit

class AnimateFullViewController: UIViewController {
    
    //MARK: - UIImageView declaration
    @IBOutlet weak var animationImage: UIImageView!
    
    //MARK: - UIView declaration
    @IBOutlet weak var imageContainerView: UIView!

    //MARK: - UIButton declaration
    @IBOutlet weak var closeButton: UIButton!

    //MARK: - NSNumber declaration
    var selectedImage =  NSNumber()

    //MARK: - UIPanGestureRecognizer declaration
    var panGesture  = UIPanGestureRecognizer()

    
    //MARK: - UIView Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        // While swipe down the view UIPanGestureRecognizer action will be initiated..
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(AnimateFullViewController.draggedView(_:)))
        self.imageContainerView.addGestureRecognizer(self.panGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        self.animationImage.image = UIImage(named: self.selectedImage.stringValue)
    }
    
    //MARK: - UIPanGestureRecognizer function

    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        
        var translation = sender.translation(in: self.imageContainerView)
        
        // condition will not allow swipe to top..

        if(translation.y < 0 && self.imageContainerView.frame.origin.y < 0){
            translation.y = 0
        }else{
            
            // condition will enter swipe to down..

            self.imageContainerView.center = CGPoint(x: self.imageContainerView.center.x, y: self.imageContainerView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
            
            // condition will enter when continously swipe down the view..
            if sender.state == UIGestureRecognizerState.changed {
                
                self.imageContainerView.layer.masksToBounds = true
                if(self.imageContainerView.layer.cornerRadius >= 25){
                    self.imageContainerView.layer.cornerRadius = 25
                }else{
                    self.imageContainerView.layer.cornerRadius = (self.imageContainerView.frame.origin.y/3)
                }
                self.imageContainerView.frame.size = CGSize(width: self.imageContainerView.frame.width-1, height: self.imageContainerView.frame.height-3)
                self.imageContainerView.center = self.view.center
                
                if(self.imageContainerView.frame.origin.y >= 50){
                    self.actionClose()
                }
            }
            
            // condition will enter when the swipe is end..

            if sender.state == UIGestureRecognizerState.ended {
                if(self.imageContainerView.frame.origin.y >= 50){
                    self.moveToPreviousVC()
                }else{
                    // condition will enter when the swipe is not reached a certain level to close the view, get back to default position..
                    self.imageContainerView.layer.cornerRadius = 0
                    self.imageContainerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    sender.setTranslation(CGPoint.zero, in: self.view)
                }
            }
        }
        self.view.layoutIfNeeded()
    }

    @IBAction func actionClose() {
        // Before dismissing the view , made animation for previous view animation continuity.
        UIView.animate(withDuration: 0.5, animations: {
            self.imageContainerView.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
            self.imageContainerView.layoutIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.moveToPreviousVC()
            })
        })
    }
    
    // Get back to the previous viewController..
    func  moveToPreviousVC(){
        self.dismiss(animated: true, completion: nil)
    }

}
