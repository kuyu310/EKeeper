//
//  WXBlutoochComponent.swift
//  Ehousekeeper
//  微信的蓝牙组件
//  Created by limeng on 2017/3/9.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD


class WXBlutoochComponent: WXComponent{
    
    let baby = BabyBluetooth.share();
    let testPeripleralName = "JDY-08";
    let characteristicName = "FEE7"
    let DescriptorNameForWrite = "FEC7"
    let DescriptorNameForNodify = "FEC8"
    let channelOnPeropheral = "channelOnPeropheral"
    let channelOnCharacteristic = "channelOnCharacteristic"
    
   
    
    var currPeripheral :CBPeripheral?
    var currcharacteristic : CBCharacteristic?
    var services = [NSMutableArray]()
    
    //这是爆漏给js的标签选项
    override init(ref: String, type: String, styles: [AnyHashable : Any]?, attributes: [AnyHashable : Any]? = nil, events: [Any]?, weexInstance: WXSDKInstance) {
        super.init(ref: ref, type: type, styles: styles, attributes: attributes, events: events, weexInstance: weexInstance);
       
    }
    
//    复位蓝牙
    func restartBle(){
        //停止之前的连接
        baby?.cancelAllPeripheralsConnection()
        //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
        baby?.scanForPeripherals().begin()
        
        
    }
// 停止扫描服务
    func CancelScan(){
       
        baby?.cancelScan()
    }
 
    //  发现蓝牙设备
    func DiscoverToPeripherals(){
        
        let rhythm = BabyRhythm()
        
        //设置查找Peripherals的规则
        baby?.setFilterOnDiscoverPeripherals { (name, adv, RSSi) -> Bool in
            if let name = adv?["kCBAdvDataLocalName"] as? String {
                if name == self.testPeripleralName as String {
                    return true;
                }
                
            }
            return false
        }
        //        设置连接Peripherals的规则
        //        kCBAdvDataLocalName是广播包中的固定名称，是蓝牙模块的规则名称
        baby?.setFilterOnConnectToPeripherals { (name, adv, RSSI) -> Bool in
            if let name = adv?["kCBAdvDataLocalName"] as? String {
                if (name == self.testPeripleralName){
                    // 停止扫描
                    self.CancelScan()
                    return true;
                }
                
            }
            return false;
        }
        
        
        //        找到Peripherals的block
        baby?.setBlockOnDiscoverToPeripherals { (centralManager, peripheral, adv, RSSI) in
            
        };
        
        //        连接Peripherals成功的block
        baby?.setBlockOnConnected { (centralManager, peripheral) in
            print("connect on :\(peripheral?.name)");
            //            把外设传出来
            self.currPeripheral = peripheral
            
            SVProgressHUD.showInfo(withStatus: "设备连接成功：\(peripheral?.name)!")
            
            
        };
        
        baby?.setBlockOnFailToConnect({ (centralManager, peripheral, error) in
            SVProgressHUD.showInfo(withStatus: "设备连接失败：\(peripheral?.name)")
        })
        
        baby?.setBlockOnDisconnect({ (centralManager, peripheral, error) in
            SVProgressHUD.showInfo(withStatus: "设备断开连接：\(peripheral?.name)")
            self.baby?.autoReconnect(peripheral)
            SVProgressHUD.showInfo(withStatus: "设备自动重连：\(peripheral?.name)")
        })
        
        //        设置查找服务的block
        baby?.setBlockOnDiscoverServices { (p, error) in
            print("discover services:\(p?.services)");
            
            
            rhythm.beats()
            
            
        }
        //        设置查找到Characteristics的block
        baby?.setBlockOnDiscoverCharacteristics { (p, s, err) in
            print("discover characteristics:\(s?.characteristics) on uuid \(s?.uuid.uuidString)");
            
            for c in (s?.characteristics!)! {
                
                if c.uuid.uuidString == self.DescriptorNameForNodify{
                    
                    p?.setNotifyValue(true, for: c)
                    
                }
                
                
                
                if c.uuid.uuidString == self.DescriptorNameForWrite{
                    
                    self.currcharacteristic = c
                    self.writeValue()
                }
            }
            
            
            
        }
        //设置beats break委托
        rhythm.setBlockOnBeatsBreak { (bry) in
            print("setBlockOnBeatsBreak call")
        }
        
        //设置beats over委托
        rhythm.setBlockOnBeatsOver { (bry) in
            print("setBlockOnBeatsOver call")
        }
        
        
        
        baby?.scanForPeripherals().enjoy()
        
    }
    
    func writeValue(){
       BabyToy.writeValue(self.currPeripheral, characteristic: self.currcharacteristic)
        
    }

    

}
