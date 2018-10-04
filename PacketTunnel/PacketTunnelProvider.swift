//
//  PacketTunnelProvider.swift
//  PacketTunnel
//
//  Created by CYC on 2018/10/3.
//  Copyright © 2018 west2online. All rights reserved.
//

import NetworkExtension
import PacketProcessor

class PacketTunnelProvider: NEPacketTunnelProvider {

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        // Add code here to start the process of connecting the tunnel.
        let networkSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "8.8.8.8")
        setTunnelNetworkSettings(networkSettings) {
            error in
            guard error == nil else {
                completionHandler(error)
                return
            }
            completionHandler(nil)
        }
    }
    
    func setupTun() {
        Netint
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code here to start the process of stopping the tunnel.
        completionHandler()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle the message.
        if let handler = completionHandler {
            handler(messageData)
        }
    }

}
