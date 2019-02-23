//
//  ImageViewController.swift
//  OperrTest
//
//  Created by Shenll_IMac on 22/02/19.
//  Copyright © 2019 STS. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate , UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate {
    
    
    //MARK: - UITableView declaration
    @IBOutlet weak var animationImageTable: UITableView!
    
    //MARK: - UIImageView declaration
    @IBOutlet weak var animationImage: UIImageView!
    
    //MARK: - UIView declaration
    @IBOutlet weak var imageContainerView: UIView!
    
    //MARK: - UIButton declaration
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK: - NSNumber declaration
    var selectedImageRow =  NSNumber()
    
    //MARK: - Bool declaration
    var isPresenting: Bool = true
    
    //MARK: - Appdelegate declarations
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - UIView Delegates
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageContainerView.isHidden = true
        self.imageContainerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.animationImageTable.reloadData()
    }

    //MARK: - UITableView Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateTVCell", for: indexPath) as! DateTVCell
            cell.selectionStyle = .none
            cell.dateLabel.text! = getCurrentDate()
            cell.dayLabel.text! = "Today"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewTVCell", for: indexPath) as! ImageViewTVCell
            cell.selectionStyle = .none
            cell.animationImage.image = UIImage(named:(indexPath.row as NSNumber).stringValue)
            cell.imageContainerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognizerHandler(_:)))
            longPressGesture.minimumPressDuration = 1.0
            cell.animationImage.addGestureRecognizer(longPressGesture)

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.isStatusBarHidden = true
        if(indexPath.row > 0){
            self.selectedImageRow = indexPath.row as NSNumber
            appDelegate.selectedImage = indexPath.row as NSNumber
            let cell = tableView.cellForRow(at: indexPath) as! ImageViewTVCell
            
            UIView.animate(withDuration: 0.3, animations: {
                cell.imageContainerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.view.layoutIfNeeded()
            }, completion: { (Success) in
                UIView.animate(withDuration: 0.5, animations: {
                    cell.imageContainerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        self.moveToNextVC()
                    })
                })
            })
        }
        self.view.layoutIfNeeded()
    }
    
    func  moveToNextVC(){
        let animateFullViewController = self.storyboard!.instantiateViewController(withIdentifier: "AnimateFullViewController") as! AnimateFullViewController
        animateFullViewController.selectedImage = self.selectedImageRow
        animateFullViewController.transitioningDelegate = self
        self.present(animateFullViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 75
        }else{
            return 450
        }
    }
    
    // MARK: - Get Current Date

    func getCurrentDate()->String{
        var strDayAndDate = String()
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMMM d"
        let strDay = dateFormatter.string(from: date)
        let splitArray = strDay.components(separatedBy: " ") as NSArray
        strDayAndDate = ((splitArray.object(at: 0) as! String).uppercased()) + " , " + ((splitArray.object(at: 1) as! String).uppercased()) + " " + (splitArray.object(at: 2) as! String)
        return strDayAndDate
    }

    // MARK: - UIViewControllerTransitioning Delegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning Delegate
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 4.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else {
                return
        }
        
        if (isPresenting) {
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                toViewController.view.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                transitionContext.completeTransition(true)
            }, completion: { _ in
                self.selectedImageRow = self.appDelegate.selectedImage
                let cell =  self.animationImageTable.cellForRow(at: NSIndexPath(item: self.selectedImageRow.intValue
                    , section: 0) as IndexPath ) as! ImageViewTVCell
                cell.imageContainerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                UIView.animate(withDuration: 0.5 , animations: {() -> Void in
                    cell.imageContainerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            })
        }
    }
    
    @objc func longPressGestureRecognizerHandler(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.animationImageTable)
        let indexPath = self.animationImageTable.indexPathForRow(at: location)
        
        let cell = self.animationImageTable.cellForRow(at: indexPath!) as! ImageViewTVCell
        
        UIView.animate(withDuration: 0.3, animations: {
            cell.imageContainerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.view.layoutIfNeeded()
        }, completion: { (Success) in
            UIView.animate(withDuration: 0.5, animations: {
                cell.imageContainerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.moveToNextVC()
                })
            })
        })
    }

}
