/*
 BabyBluetooth
 简单易用的蓝牙ble库，基于CoreBluetooth 作者：刘彦玮
 https://github.com/coolnameismy/BabyBluetooth
 */

//  Created by 刘彦玮 on 15/8/1.
//  Copyright (c) 2015年 刘彦玮. All rights reserved.
//

#import "BabyToy.h"

@implementation BabyToy


//十六进制转换为普通字符串的。
+ (NSString *)ConvertHexStringToString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
//    BabyLog(@"===字符串===%@",unicodeString);
    return unicodeString;
}

//普通字符串转换为十六进制
+ (NSString *)ConvertStringToHexString:(NSString *)string {
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for (int i=0;i<[myD length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if ([newHexStr length]==1) {
           hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else{
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }

    } 
    return hexStr; 
}


//int转data
+ (NSData *)ConvertIntToData:(int)i {

    NSData *data = [NSData dataWithBytes: &i length: sizeof(i)];
    return data;
}

//data转int
+ (int)ConvertDataToInt:(NSData *)data {
    int i;
    [data getBytes:&i length:sizeof(i)];
    return i;
}

//十六进制转换为普通字符串的。
+ (NSData *)ConvertHexStringToData:(NSString *)hexString {
    
    NSData *data = [[BabyToy ConvertHexStringToString:hexString] dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}


//根据UUIDString查找CBCharacteristic
+ (CBCharacteristic *)findCharacteristicFormServices:(NSMutableArray *)services
                                         UUIDString:(NSString *)UUIDString {
    for (CBService *s in services) {
        for (CBCharacteristic *c in s.characteristics) {
            if ([c.UUID.UUIDString isEqualToString:UUIDString]) {
                return c;
            }
        }
    }
    return nil;
}

+ (void)writeValue:(CBPeripheral* )currPeripheral
   characteristic:(CBCharacteristic* )currcharacteristic {
   
    Byte byte[]={0xfe,0x01,0x00,0x13,0x75,0x31,0x00,0x11,0x0a,0x00,0x12,0x04,0x38,0x38,0x39,0x39,0x18,0x91,0x4e};
    
    NSData *data = [[NSData alloc]initWithBytes:byte length:sizeof(byte)];
    NSLog(@"new value %@",data);
   
    [currPeripheral writeValue:data forCharacteristic:currcharacteristic type:CBCharacteristicWriteWithResponse];
}


////订阅一个值
//+(void)setNotifiy:(BabyBluetooth *)baby
//       Peripheral:(CBPeripheral* )currPeripheral
//   characteristic:(CBCharacteristic* )currcharacteristic {
//    
// 
//    if(currPeripheral.state != CBPeripheralStateConnected) {
//        
//        return;
//    }
//    if (currcharacteristic.properties & CBCharacteristicPropertyNotify ||  currcharacteristic.properties & CBCharacteristicPropertyIndicate) {
//        
//        if(currcharacteristic.isNotifying) {
//            [baby cancelNotify:currPeripheral characteristic:currcharacteristic];
//            
//        }else{
//
//        [baby notify:currPeripheral
//          characteristic:currcharacteristic
//                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
//                       NSLog(@"notify block");
//                       NSLog(@"new value %@",currcharacteristic.value);
//                      
//                   }];
//        }
//    }
//    else{
//       
//        return;
//    }
//    
//}

@end


