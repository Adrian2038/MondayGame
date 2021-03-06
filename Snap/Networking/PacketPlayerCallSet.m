//
//  PacketPlayerSet.m
//  Snap
//
//  Created by Adrian on 15/4/10.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

#import "PacketPlayerCallSet.h"


@implementation PacketPlayerCallSet

+ (id)packetWithPeerId:(NSString *)peerId withCards:(NSDictionary *)cards
{
    return [[[self class] alloc] initWithPeerId:peerId withCards:cards];
}

- (id)initWithPeerId:(NSString *)peerId withCards:(NSDictionary *)cards
{
    self = [super initWithInsideType:PacketTypePlayerCalledSnap];
    if (self) {
        self.peerId = peerId;
        self.cards = cards;
    }
    return self;
}


@end
