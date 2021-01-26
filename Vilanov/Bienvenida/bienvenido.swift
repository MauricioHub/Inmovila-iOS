//
//  ViewController.swift
//  Vilanov
//
//  Created by Daniel on 24/11/18.
//  Copyright © 2018 Inmovila. All rights reserved.
//

import UIKit

class bienvenido: UIViewController {

    @IBOutlet weak var secondview   : UIView!
    @IBOutlet var firstview         : UIView!
    @IBOutlet weak var inmologo     : UIImageView!
    @IBOutlet weak var vilalogo     : UIImageView!
    @IBOutlet weak var textologo    : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        animate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animate(){
        
        let antxvila = self.vilalogo.frame.origin.y
        let yvila = self.secondview.convert(self.vilalogo.frame.origin, to: self.firstview)
        self.vilalogo.frame.origin.y = -yvila.y - self.vilalogo.frame.size.height
        self.inmologo.alpha=0
        self.textologo.alpha=0
        
        UIView.animate(withDuration: 1.2,delay:0.5, animations: {
            self.vilalogo.frame.origin.y = antxvila
        }, completion: {(finished:Bool) in
            UIView.animate(withDuration: 1.2, animations: {
                self.textologo.alpha=1
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 1.2, animations: {
                    self.inmologo.alpha=1
                }, completion: {(finished:Bool) in
                    let storyBoard : UIStoryboard = UIStoryboard(name: "inicial", bundle: nil)
                    let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "view_2")
                    let transition = CATransition()
                    transition.duration = 0.8
                    transition.type = kCATransitionPush
                    transition.subtype = kCATransitionReveal
                    self.view.window!.layer.add(transition, forKey: kCATransition)
                    self.present(ViewControllerDos, animated: false)
                    
                    
                })
            })
        })
                
    }


}

