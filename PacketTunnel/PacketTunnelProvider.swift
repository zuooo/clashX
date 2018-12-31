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
    var proxyPort = 0
    var socksPort:Int32 = 0

    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        // Add code here to start the process of connecting the tunnel.
        
        guard let options = options else {exit(0)}
        guard let port = options["proxyPort"] as? Int,
        let socks = options["socksPort"] as? Int
            else {
            exit(0)
        }
        self.proxyPort = port
        self.socksPort = Int32(socks)
        
        
        let error =  TunnelInterface.setup(with: self.packetFlow)
        if ((error) != nil) {completionHandler(error!)
            exit(1)
        }
        let networkSettings = self.generateNetworkSetting()
        setTunnelNetworkSettings(networkSettings) { [unowned self]
            error in
            guard error == nil else {
                completionHandler(error)
                return
            }
            self.setupTun()
            completionHandler(nil)
        }
    }
    
    func generateNetworkSetting() -> NEPacketTunnelNetworkSettings {
        let networkSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "8.8.8.8")
        networkSettings.mtu = 1400
        let ipv4Settings = NEIPv4Settings(addresses: ["192.169.89.1"], subnetMasks: ["255.255.255.0"])
        ipv4Settings.includedRoutes = [
            NEIPv4Route(destinationAddress: "198.18.0.0", subnetMask: "255.255.0.0"),
        ]
        
        ipv4Settings.excludedRoutes = [
            NEIPv4Route(destinationAddress: "10.0.0.0", subnetMask: "255.0.0.0"),
            NEIPv4Route(destinationAddress: "100.64.0.0", subnetMask: "255.192.0.0"),
            NEIPv4Route(destinationAddress: "127.0.0.0", subnetMask: "255.0.0.0"),
            NEIPv4Route(destinationAddress: "169.254.0.0", subnetMask: "255.255.0.0"),
            NEIPv4Route(destinationAddress: "172.16.0.0", subnetMask: "255.240.0.0"),
            NEIPv4Route(destinationAddress: "192.168.0.0", subnetMask: "255.255.0.0"),
        ]
        networkSettings.ipv4Settings = ipv4Settings
        
        let proxySettings = NEProxySettings()
        proxySettings.httpEnabled = true
        proxySettings.httpServer = NEProxyServer(address: "127.0.0.1", port: proxyPort)
        proxySettings.httpsEnabled = true
        proxySettings.httpsServer = NEProxyServer(address: "127.0.0.1", port: proxyPort)
        proxySettings.excludeSimpleHostnames = true
        // This will match all domains
        proxySettings.matchDomains = [""]
        proxySettings.exceptionList = ["api.smoot.apple.com","configuration.apple.com","xp.apple.com","smp-device-content.apple.com","guzzoni.apple.com","captive.apple.com","*.ess.apple.com","*.push.apple.com","*.push-apple.com.akadns.net"]
//        networkSettings.proxySettings = proxySettings
        
        let dnsSetting = NEDNSSettings(servers: ["127.0.0.1"])
        
        networkSettings.dnsSettings = dnsSetting
        
        return networkSettings
    }

    
    func setupTun() {
        TunnelInterface.startTun2Socks(socksPort)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            TunnelInterface.processPackets()
        }

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
