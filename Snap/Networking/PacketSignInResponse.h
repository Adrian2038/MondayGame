//
//  PacketSignInResponse.h
//  Snap
//
//  Created by Adrian on 15/5/13.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

#import "Packet.h"

@interface PacketSignInResponse : Packet

@property (nonatomic, copy) NSString *playerName;

+ (id)packetWithPlayerName:(NSString *)playerName;

@end
