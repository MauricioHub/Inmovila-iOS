//
//  Login.swift
//  Vilanov
//
//  Created by Daniel on 29/11/18.
//  Copyright © 2018 Inmovila. All rights reserved.
//

import UIKit

class Login: UIViewController {

    @IBOutlet weak var hola     : UILabel!
    @IBOutlet weak var ico      : UIImageView!
    @IBOutlet weak var parrafo  : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hola.alpha     = 0
        self.ico.alpha      = 0
        self.parrafo.alpha  = 0
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animar()
    }
    
    @IBAction func `return`(_ sender: Any) {
        let transition      = CATransition()
        transition.duration = 0.4
        transition.type     = kCATransitionPush
        transition.subtype  = kCATransitionFromTop
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animar() {
        UIView.animate(withDuration: 0.8,delay:1, animations: {
            self.hola.alpha=1
        }, completion: {(finished:Bool) in
            UIView.animate(withDuration: 0.8, animations: {
                 self.ico.alpha=1
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.8, animations: {
                     self.parrafo.alpha=1
                })
            })
        })
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
