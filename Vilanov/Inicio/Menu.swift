//
//  Menu.swift
//  Vilanov
//
//  Created by Daniel on 25/11/18.
//  Copyright © 2018 Inmovila. All rights reserved.
//

import UIKit
import CoreData

class Menu: UIViewController {

    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var menu_main: UIImageView!
    
    @IBOutlet weak var menu_noti: UIButton!
    @IBOutlet weak var menu_noticias: UIButton!
    @IBOutlet weak var menu_servicios: UIButton!
    @IBOutlet weak var menu_invitaciones: UIButton!
    @IBOutlet weak var menu_club: UIButton!
    @IBOutlet weak var menu_config: UIButton!
    @IBOutlet weak var menu_administracion: UIButton!
    @IBOutlet weak var sm1not: UIButton!
    @IBOutlet weak var sm2not: UIButton!
    @IBOutlet weak var sm3not: UIButton!
    @IBOutlet weak var sm4not: UIButton!
    @IBOutlet weak var sm1usu: UIButton!
    @IBOutlet weak var sm2usu: UIButton!
    @IBOutlet weak var sm3usu: UIButton!
    @IBOutlet weak var sm4usu: UIButton!
    @IBOutlet weak var sm5usu: UIButton!
    @IBOutlet weak var sm1acc: UIButton!
    @IBOutlet weak var sm2acc: UIButton!
    @IBOutlet weak var btn_return_menu: UIButton!
    @IBOutlet weak var view_mpronto: UIView!
    @IBOutlet weak var img_mpronto: UIImageView!
    
    var distance    : CGFloat = 0.0
    var wh2         : CGFloat = 0.0
    var centrarimg  : CGFloat = 0.0
    var centrarlet  : CGFloat = 0.0
    
    var buttons         = [UIButton]()
    var smbuttonsnot    = [UIButton]()
    var smbuttonsusu    = [UIButton]()
    var smbuttonsacc    = [UIButton]()
    var smbuttonsactive    = [UIButton]()
    var smbuttonidactive : Int = 0
    var animar:Bool     = true
    var isopen:Bool     = false
    var isopensm:Bool     = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        var wh:CGFloat
        animar=false
        switch (deviceIdiom) {
        case .pad:
            wh = (self.view.frame.size.width-200)/3
            wh2 = (wh/10)*9
            break
        default:
            wh = (self.view.frame.size.width-10)/3
            wh2 = (wh/10)*8.5
            
            break
        }
        
        self.menu_main.frame.size.height = wh
        self.menu_main.frame.size.width = wh
        self.menu_main.center = self.view.center
        rotateImageMpronto()
        buttons.append(menu_noticias)
        buttons.append(menu_config)
        buttons.append(menu_club)
        buttons.append(menu_invitaciones)
        buttons.append(menu_administracion)
        buttons.append(menu_servicios)
        smbuttonsnot.append(sm1not)
        smbuttonsnot.append(sm2not)
        smbuttonsnot.append(sm3not)
        smbuttonsnot.append(sm4not)
        smbuttonsusu.append(sm1usu)
        smbuttonsusu.append(sm2usu)
        smbuttonsusu.append(sm3usu)
        smbuttonsusu.append(sm4usu)
        smbuttonsusu.append(sm5usu)
        smbuttonsacc.append(sm2acc)
        smbuttonsacc.append(sm1acc)
        distance = self.menu_main.frame.size.height
        
        
        let tapGestureRecognizer_camera = UITapGestureRecognizer(target: self, action: #selector(self.goToPerfilLogin))
        titulo.isUserInteractionEnabled = true
        titulo.addGestureRecognizer(tapGestureRecognizer_camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        titulo.text = (AppSettings.nombre.isEmpty ? "Bienvenido" : "Hola \(AppSettings.nombre)")
        if AppSettings.mostrarMenuPrincipal {
            AbrirMenu()
            AppSettings.mostrarMenuPrincipal = false
            animar = true
            return
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (animar==false) {
            AbrirMenu()
        }
    }
    
    @objc func goToPerfilLogin() {
        if(AppSettings.bearer.isEmpty) {
            self.openLoginModule()
        }else {
            self.openPerfilModule()
        }
    }
    
    func AbrirMenu(){
        animar = true
        UIView.animate(withDuration: 0.5, animations: {
            self.titulo.alpha=0
        },completion: { (finished:Bool) in
            self.titulo.text = (AppSettings.nombre.isEmpty ? "Bienvenido" : "Hola \(AppSettings.nombre)")
            UIView.animate(withDuration: 0.5, animations: {
                self.titulo.alpha=1
            })
        })
        
        self.menu_main.alpha = 1
        for i in 0 ..< self.buttons.count{
            self.buttons[i].frame.size.height = self.wh2
            self.buttons[i].frame.size.width = self.wh2
            self.buttons[i].center.x = self.menu_main.center.x
            self.buttons[i].center.y = self.menu_main.center.y
            self.buttons[i].transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.buttons[i].alpha = 0
        }
        
        for i in 0 ..< self.smbuttonsnot.count{
            self.smbuttonsnot[i].frame.size.height = self.wh2
            self.smbuttonsnot[i].frame.size.width = self.wh2
            self.smbuttonsnot[i].center.x = self.menu_main.center.x
            self.smbuttonsnot[i].center.y = self.menu_main.center.y
            self.smbuttonsnot[i].alpha=0
        }
        for i in 0 ..< self.smbuttonsusu.count{
            self.smbuttonsusu[i].frame.size.height = self.wh2
            self.smbuttonsusu[i].frame.size.width = self.wh2
            self.smbuttonsusu[i].center.x = self.menu_main.center.x
            self.smbuttonsusu[i].center.y = self.menu_main.center.y
            self.smbuttonsusu[i].alpha=0
        }
        for i in 0 ..< self.smbuttonsacc.count{
            self.smbuttonsacc[i].frame.size.height = self.wh2
            self.smbuttonsacc[i].frame.size.width = self.wh2
            self.smbuttonsacc[i].center.x = self.menu_main.center.x
            self.smbuttonsacc[i].center.y = self.menu_main.center.y
            self.smbuttonsacc[i].alpha=0
        }
        
        let angulo = 360 / buttons.count
        UIView.animate(withDuration: 0.6, animations: {
            for i in 0 ..< self.buttons.count{
                let newangulo = (CGFloat(angulo) * CGFloat(i)) - 90
                let newx = self.menu_main.center.x + (cos(newangulo * CGFloat.pi / 180.0) * self.distance)
                let newy = self.menu_main.center.y + (sin(newangulo * CGFloat.pi / 180.0) * self.distance)
                self.buttons[i].center.x = newx
                self.buttons[i].center.y = newy
                self.buttons[i].transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                if (i<=1 || i==3) {
                    self.buttons[i].alpha=1
                } else {
                    self.buttons[i].alpha=0.15
                }
                
            }
        }, completion: {(finished:Bool) in
            UIView.animate(withDuration: 0.4, animations: {
                for i in 0 ..< self.buttons.count{
                    self.buttons[i].transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            })
            
        })
    }

    @IBAction func inicio(_ sender: Any) {
        self.backToInicio()
    }
    
    func backToInicio() {
        btn_return_menu.alpha=0
        view_mpronto.alpha=0
        if (isopensm==true){
            menu_main.alpha=1
            abrir_submenu(buttonid: 0,title: "Noticias",smbutton: self.smbuttonsnot, smactive: [0,1,3])
            isopensm=false
            return()
        }
        if (isopen==true){
            UIView.animate(withDuration: 0.5, animations: {
                self.titulo.alpha=0
            },completion: {(finished:Bool) in
                self.titulo.text = (AppSettings.nombre.isEmpty ? "Bienvenido" : "Hola \(AppSettings.nombre)")
                UIView.animate(withDuration: 0.5, animations: {
                    self.titulo.alpha=1
                })
            })
            
            let angulo = 360 / self.buttons.count
            for i in 0 ..< self.buttons.count{
                if (i != smbuttonidactive){
                    let newangulo = (CGFloat(angulo) * CGFloat(i)) - 90
                    let newx = self.menu_main.center.x + (cos(newangulo * CGFloat.pi / 180.0) * self.distance)
                    let newy = self.menu_main.center.y + (sin(newangulo * CGFloat.pi / 180.0) * self.distance)
                    self.buttons[i].center.x = newx
                    self.buttons[i].center.y = newy
                    self.buttons[i].transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                
            }
            
            UIView.animate(withDuration: 0.4, animations: {
                
                for i in 0 ..< self.smbuttonsactive.count {
                    let newx = self.menu_main.center.x
                    let newy = self.menu_main.center.y
                    self.smbuttonsactive[i].center.x = newx
                    self.smbuttonsactive[i].center.y = newy
                    self.smbuttonsactive[i].alpha=0
                }
                
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.4, animations: {
                    let angulo = 360 / self.buttons.count
                    let newangulo = (CGFloat(angulo) * CGFloat(self.smbuttonidactive)) - 90
                    let newx = self.menu_main.center.x + (cos(newangulo * CGFloat.pi / 180.0) * self.distance)
                    let newy = self.menu_main.center.y + (sin(newangulo * CGFloat.pi / 180.0) * self.distance)
                    self.buttons[self.smbuttonidactive].center.x = newx
                    self.buttons[self.smbuttonidactive].center.y = newy
                    self.menu_main.alpha=1
                    self.buttons[self.smbuttonidactive].alpha=1
                    for i in 0 ..< self.buttons.count{
                        if (i<=1 || i==3){
                            self.buttons[i].alpha=1
                        } else {
                            self.buttons[i].alpha=0.15
                        }
                    }
                    
                })
                
            })
            isopen = false
        }
    }
    
    
    @IBAction func mprontoservicios(_ sender: Any) {
        muy_pronto(buttonid: 5,title: "Servicios")
    }
    @IBAction func mprontoadm(_ sender: Any) {
        muy_pronto(buttonid: 4,title: "Administrador")
    }
    @IBAction func mprontoac() {
        muy_pronto(buttonid: 3,title: "Accesos")
    }
    @IBAction func mpronto(_ sender: Any) {
        muy_pronto(buttonid: 2,title: "Club Social")
    }
    @IBAction func mprontonoturb(_ sender: Any) {
        muy_prontosm(buttonid: 2,title: "Urbanización",smbutton: self.smbuttonsnot)
    }
    func rotateImageMpronto()
    {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {() -> Void in
            self.img_mpronto.transform = self.img_mpronto.transform.rotated(by: .pi / 2)
        }, completion: {(_ finished: Bool) -> Void in
            if finished {
                self.rotateImageMpronto()
            }
        })
    }
    func muy_prontosm(buttonid:Int, title:String, smbutton:[UIButton]){
        btn_return_menu.alpha=1
        //smbuttonsactive = smbutton
        smbuttonidactive = buttonid
        
        isopensm=true
        UIView.animate(withDuration: 0.5, animations: {
            self.titulo.alpha=0
        },completion: {(finished:Bool) in
            self.titulo.text=title
            UIView.animate(withDuration: 0.5, animations: {
                self.titulo.alpha=1
            })
        })
        
        /*let angulo = 360 / smbutton.count
         for i in 0 ..< smbutton.count{
         smbutton[i].transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
         }*/
        
        UIView.animate(withDuration: 0.35, animations: {
            self.menu_main.alpha=0
            for i in 0 ..< smbutton.count{
                if (i==buttonid){
                    smbutton[i].center.x = self.menu_main.center.x
                    smbutton[i].center.y = self.menu_main.center.y
                    smbutton[i].alpha=0
                } else {
                    smbutton[i].alpha=0
                }
            }
            //self.menu_main.alpha=0
        }, completion: {(finished:Bool) in
            UIView.animate(withDuration: 0.6, animations: {
                self.view_mpronto.alpha=1
                /*
                 for i in 0 ..< smbutton.count{
                 let newangulo = (CGFloat(angulo) * CGFloat(i)) - 90
                 let newx = self.menu_main.center.x + (cos(newangulo * CGFloat.pi / 180.0) * self.distance)
                 let newy = self.menu_main.center.y + (sin(newangulo * CGFloat.pi / 180.0) * self.distance)
                 smbutton[i].center.x = newx
                 smbutton[i].center.y = newy
                 smbutton[i].transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                 
                 for iactive in 0 ..< smactive.count{
                 
                 if (smactive[iactive]==i){
                 smbutton[i].alpha=1
                 break
                 } else {
                 smbutton[i].alpha=0.15
                 
                 }
                 }
                 
                 
                 }
                 }, completion: {(finished:Bool) in
                 UIView.animate(withDuration: 0.4, animations: {
                 for i in 0 ..< self.smbuttonsnot.count{
                 smbutton[i].transform = CGAffineTransform(scaleX: 1, y: 1)
                 }
                 })
                 })*/
            })
        })
    }
    
    func muy_pronto(buttonid:Int, title:String){
        btn_return_menu.alpha=1
        //smbuttonsactive = smbutton
        smbuttonidactive = buttonid
        
        isopen=true
        UIView.animate(withDuration: 0.5, animations: {
            self.titulo.alpha=0
        },completion: {(finished:Bool) in
            self.titulo.text=title
            UIView.animate(withDuration: 0.5, animations: {
                self.titulo.alpha=1
            })
        })
        
        /*let angulo = 360 / smbutton.count
        for i in 0 ..< smbutton.count{
            smbutton[i].transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }*/
        
        UIView.animate(withDuration: 0.35, animations: {
            self.menu_main.alpha=0
            for i in 0 ..< self.buttons.count{
                if (i==buttonid){
                    self.buttons[i].center.x = self.menu_main.center.x
                    self.buttons[i].center.y = self.menu_main.center.y
                    self.buttons[i].alpha=0
                } else {
                    self.buttons[i].alpha=0
                }
            }
            //self.menu_main.alpha=0
        }, completion: {(finished:Bool) in
            UIView.animate(withDuration: 0.6, animations: {
                self.view_mpronto.alpha=1
                /*
                for i in 0 ..< smbutton.count{
                    let newangulo = (CGFloat(angulo) * CGFloat(i)) - 90
                    let newx = self.menu_main.center.x + (cos(newangulo * CGFloat.pi / 180.0) * self.distance)
                    let newy = self.menu_main.center.y + (sin(newangulo * CGFloat.pi / 180.0) * self.distance)
                    smbutton[i].center.x = newx
                    smbutton[i].center.y = newy
                    smbutton[i].transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    
                    for iactive in 0 ..< smactive.count{
                        
                        if (smactive[iactive]==i){
                            smbutton[i].alpha=1
                            break
                        } else {
                            smbutton[i].alpha=0.15
                            
                        }
                    }
                    
                    
                }
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.4, animations: {
                    for i in 0 ..< self.smbuttonsnot.count{
                        smbutton[i].transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                })
            })*/
            })
        })
    }
    
    func abrir_submenu(buttonid:Int, title:String, smbutton:[UIButton], smactive:[Int]){
        btn_return_menu.alpha=1
        smbuttonsactive = smbutton
        smbuttonidactive = buttonid
        
        isopen=true
        UIView.animate(withDuration: 0.5, animations: {
            self.titulo.alpha=0
        },completion: {(finished:Bool) in
            self.titulo.text=title
            UIView.animate(withDuration: 0.5, animations: {
                self.titulo.alpha=1
            })
        })
        
        let angulo = 360 / smbutton.count
        for i in 0 ..< smbutton.count{
            smbutton[i].transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        
        UIView.animate(withDuration: 0.35, animations: {
            
            for i in 0 ..< self.buttons.count{
                if (i==buttonid){
                    self.buttons[i].center.x = self.menu_main.center.x
                    self.buttons[i].center.y = self.menu_main.center.y
                    self.buttons[i].alpha=0
                } else {
                    self.buttons[i].alpha=0
                }
            }
            //self.menu_main.alpha=0
        }, completion: {(finished:Bool) in
            UIView.animate(withDuration: 0.6, animations: {
                
                for i in 0 ..< smbutton.count{
                    var anguloi:CGFloat = 90;
                    if (smbutton.count==2){
                        anguloi=0;
                    }
                    let newangulo = (CGFloat(angulo) * CGFloat(i)) - anguloi
                    let newx = self.menu_main.center.x + (cos(newangulo * CGFloat.pi / 180.0) * self.distance)
                    let newy = self.menu_main.center.y + (sin(newangulo * CGFloat.pi / 180.0) * self.distance)
                    smbutton[i].center.x = newx
                    smbutton[i].center.y = newy
                    smbutton[i].transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    
                    for iactive in 0 ..< smactive.count{
                        
                        if (smactive[iactive]==i){
                            smbutton[i].alpha=1
                            break
                        } else {
                            smbutton[i].alpha=0.15
                            
                        }
                    }
                    
                    
                }
            }, completion: {(finished:Bool) in
                UIView.animate(withDuration: 0.4, animations: {
                    for i in 0 ..< smbutton.count{
                        smbutton[i].transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                })
            })
        })
    }
    
    @IBAction func noticias_click(_ sender: Any) {
        abrir_submenu(buttonid: 0,title: "Noticias",smbutton: self.smbuttonsnot, smactive: [0,1,3])
    }
    
    @IBAction func ajustes_click(_ sender: Any) {
        if(AppSettings.bearer.isEmpty) {
            self.openLoginModule()
        }else {
            abrir_submenu(buttonid: 1,title: "Ajustes",smbutton: self.smbuttonsusu, smactive: [0,1])
        }
    }
    @IBAction func accesos_click(_ sender: Any) {
        abrir_submenu(buttonid: 3,title: "Accesos",smbutton: self.smbuttonsacc, smactive: [0,1])
    }
    @IBAction func perfil(_ sender: Any) {
        self.goToPerfilLogin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sm_notclick(_ sender: UIButton) {
//        print("hice clic");
//        print(sender.tag);
        let storyBoard : UIStoryboard = UIStoryboard(name: "noticias", bundle: nil)
        //let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "noticias_view")
        if let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "noticiasViewController") as? noticiasViewController {
            ViewControllerDos.tipo = sender.tag
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = kCATransitionMoveIn
            transition.subtype = kCATransitionFromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.present(ViewControllerDos, animated: false)
        }
        
    }
    
    @IBAction func sm_acc_invi_click(_ sender: UIButton) {
        //        print("hice clic");
        //        print(sender.tag);
        let storyBoard : UIStoryboard = UIStoryboard(name: "invitados", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "invitados")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
        
    }
    @IBAction func sm_acc_eve_click(_ sender: UIButton) {
        //        print("hice clic");
        //        print(sender.tag);
        let storyBoard : UIStoryboard = UIStoryboard(name: "eventos", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "eventos")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
        
    }
    
    @IBAction func sm_userClick(_ sender: UIButton) {
        if(AppSettings.usuario.isEmpty) {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: "Necesitas iniciar sesión para poder ingresar a este módulo.")
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "usuarios_editadd", bundle: nil)
        switch sender.tag {
        case 0:
            self.goToPerfilLogin()
            break
        case 1:
            print("Lista usuarios")
            if( AppSettings.adm != 1) {
                MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.noAdminUserAccess)
                return
            }
            if let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "UsersListViewController") as? UsersListViewController {
                self.animateTransition(viewController: ViewControllerDos)
            }
            break
        case 2:
            print("Datos usuario")
            break
        case 3:
            print("Datos usuario")
            break
        default:
            print("NO ACTIONS FOR TAG #\(sender.tag)")
        }
        
//        UsersListViewController
        
        
    }
    
    @IBAction func goToNotificationsAction(_ sender: ButtonImage) {
        self.openNotificationsModule()
    }
    
    @IBAction func goToSearchNotificationsAction(_ sender: ButtonImage) {
        self.openSearchNotificationsModule()
    }
    
    func animateTransition(viewController : UIViewController) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(viewController, animated: false)
    }
    
    func openLoginModule() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "usuarios", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "login")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
    
    func openPerfilModule() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "usuarios_editadd", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "perfil_usuario_controller")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
    
    func openSearchNotificationsModule() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "notificaciones", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "notificaciones")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
    
    func openNotificationsModule() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "notificaciones", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "NotificationListViewController")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
}
