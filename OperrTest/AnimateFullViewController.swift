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
        if(translation.x < 0 || translation.x > 0){
            translation.x = 0
        }
        if(translation.y < 0 && self.imageContainerView.frame.origin.y < 0){
            translation.y = 0
        }else{
            self.imageContainerView.center = CGPoint(x: self.imageContainerView.center.x, y: self.imageContainerView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
            
            if sender.state == UIGestureRecognizerState.changed {
                self.imageContainerView.layer.masksToBounds = true
                if(self.imageContainerView.layer.cornerRadius > 30){
                    self.imageContainerView.layer.cornerRadius = 30
                }else{
                    self.imageContainerView.layer.cornerRadius = (self.imageContainerView.frame.origin.y/3)
                }
                self.imageContainerView.frame.size = CGSize(width: self.imageContainerView.frame.width-1, height: self.imageContainerView.frame.height-3)
                self.imageContainerView.center = self.view.center
                
                if(self.imageContainerView.frame.origin.y >= 50){
                    self.actionClose()
                }
            }
            if sender.state == UIGestureRecognizerState.ended {
                if(self.imageContainerView.frame.origin.y >= 50){
                    self.imageContainerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width,height: self.view.frame.height)
                    self.moveToPreviousVC()
                }else{
                    self.imageContainerView.layer.cornerRadius = 0
                    self.imageContainerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    sender.setTranslation(CGPoint.zero, in: self.view)
                }
            }
        }
        self.view.layoutIfNeeded()
    }

    @IBAction func actionClose() {
        UIView.animate(withDuration: 1.0, animations: {
            self.imageContainerView.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
            self.imageContainerView.layoutIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                self.moveToPreviousVC()
            })
        })
    }
    
    func  moveToPreviousVC(){
        self.dismiss(animated: true, completion: nil)
    }

}
