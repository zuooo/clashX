//
//  LoginViewController.swift
//  
//
//  Created by CYC on 2019/1/11.
//

import Cocoa

class LoginViewController: NSViewController {

    @IBOutlet weak var logoView: NSImageView!
    
    @IBOutlet weak var emailTextField: NSTextField!
    
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    @IBOutlet weak var authCodeTextField: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoView.image = logoView.image?.tint(color: NSColor.black)
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        if emailTextField.stringValue.count == 0 {
            NSAlert.alert(with: "邮箱不能为空")
            return
        }
        
        if passwordTextField.stringValue.count == 0 {
            NSAlert.alert(with: "密码不能为空")
            return
        }
        
        let hud = MBProgressHUD(view: self.view)!
        hud.labelText = "登录中"
        hud.show(true)
        self.view.addSubview(hud)
        hud.removeFromSuperViewOnHide = true

        WebPortalManager.shared.login(mail: emailTextField.stringValue, password: passwordTextField.stringValue, authCode: authCodeTextField.stringValue) {
            errDesp in
            if let errDesp = errDesp {
                NSAlert.alert(with: errDesp)
                hud.hide(true)
                print(errDesp)
                return
            }
            hud.labelText = "获取托管配置文件地址"
            WebPortalManager.shared.refreshConfigUrl() {
                errDesp in
                if let errDesp = errDesp {
                    NSAlert.alert(with: errDesp)
                    hud.hide(true)
                    print(errDesp)
                    return
                }
                
                hud.labelText = "刷新配置文件"
                RemoteConfigManager.updateConfigIfNeed() { err in
                    hud.hide(true)

                    if let err = err {
                        NSAlert.alert(with:err)
                        return
                    }
                    NSAlert.alert(with: "配置获取成功")
                    self.dismiss(nil)
                }
            }
        }
    }
    
  
}
