//
//  PacketPlayerShouldCallSet.m
//  Snap
//
//  Created by Adrian on 15/5/31.
//  Copyright (c) 2015年 Hollance. All rights reserved.
//

#import "PacketPlayerShouldCallSet.h"


@implementation PacketPlayerShouldCallSet

+ (id)packetWithPeerId:(NSString *)peerId withCards:(NSDictionary *)cards
{
    return [[[self class] alloc] initWithPeerId:peerId withCards:cards];
}

+ (id)packetWithData:(NSData *)data
{
    size_t offset = PACKET_HEADER_SIZE;
    
    NSDictionary *cards = [[self class] cardsFromData:data atOffset:offset];
    NSString *key = [[cards allKeys] firstObject];
    
    return [[self class] packetWithPeerId:key withCards:cards];

}

- (id)initWithPeerId:(NSString *)peerId withCards:(NSDictionary *)cards
{
    self = [super initWithInsideType:PacketTypePlayerShouldSnap];
    if (self) {
        self.peerId = peerId;
        self.cards = cards;
    }
    return self;
}

- (void)addPayloadToData:(NSMutableData *)data
{
    [self addCards:self.cards toPayload:data];
}

@end
