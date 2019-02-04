//
//  ProxyMenuItemView.swift
//  
//
//  Created by CYC on 2018/10/19.
//

import Cocoa

class ProxyMenuItemView: NSView {
    static func create(proxy:String,delay:Int?)->ProxyMenuItemView {
        var topLevelObjects : NSArray?
        if Bundle.main.loadNibNamed("ProxyMenuItemView", owner: self, topLevelObjects: &topLevelObjects) {
            let view = (topLevelObjects!.first(where: { $0 is NSView }) as? ProxyMenuItemView)!
            view.setupView(proxy:proxy,delay:delay)
            return view;
        }
        return NSView() as! ProxyMenuItemView
    }
    
    var onClick:(()->())? = nil
    
    @IBOutlet weak var proxyNameLabel: NSTextField!

    
    @IBOutlet weak var delayLabel: NSTextField!
    
    
    func setupView(proxy:String,delay:Int?){
        proxyNameLabel.stringValue = proxy
        if let delay = delay {
            switch delay {
            case Int.max:delayLabel.stringValue = "Fail"
            case ..<0:delayLabel.stringValue = "Unknown"
            default:delayLabel.stringValue = "\(delay)ms"
            }
        } else {
            delayLabel.isHidden = true
        }
    }
   
}
