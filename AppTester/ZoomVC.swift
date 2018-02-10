//
//  ZoomVC.swift
//  AppTester
//
//  Created by Miguel Paolo Bravo on 1/30/18.
//  Copyright © 2018 Miguel Paolo Bravo. All rights reserved.
//

import UIKit

class ZoomVC: UIViewController, UIScrollViewDelegate  {

    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var imgView: UIImageView!
    var image2: UIImage?
    
    var urlHolder = ""
    
    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit{
        print("deinit ZoomVC")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.scrolView.minimumZoomScale = 1.0
        self.scrolView.maximumZoomScale = 4.0
        
        scrolView.delegate = self
        
        imgView.downloadedFrom(link: urlHolder)
        
       // print("url = \(urlHolder)")
        
       //  imgView.image = imgView.image
        
        //        scrolView = UIScrollView(frame: view.bounds)
        //        scrolView.backgroundColor = UIColor.blackColor()
        //        scrolView.contentSize = imgView.bounds.size
        
        //scrolView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        // scrolView.contentOffset = CGPoint(x: 1000, y: 450)
        //
        //        scrolView.addSubview(imgView)
        //        view.addSubview(scrolView)
        
        //        scrolView.minimumZoomScale = 0.1
        //        scrolView.maximumZoomScale = 4.0
        //        scrolView.zoomScale = 1.0
        
        //        setZoomScale()
        
        
        setupGestureRecognizer()
    }
    
    func setZoomScale() {
        let imageViewSize = imgView.bounds.size
        let scrollViewSize = scrolView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrolView.minimumZoomScale = min(widthScale, heightScale)
        scrolView.zoomScale = 1.0
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imgView.frame.size
        let scrollViewSize = scrolView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ZoomVC.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrolView.addGestureRecognizer(doubleTap)
    }
    
    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        
        if (scrolView.zoomScale > scrolView.minimumZoomScale) {
            scrolView.setZoomScale(scrolView.minimumZoomScale, animated: true)
        } else {
            scrolView.setZoomScale(scrolView.maximumZoomScale, animated: true)
        }
    }
    
    
    //    override func viewWillLayoutSubviews() {
    //        setZoomScale()
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.imgView
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
