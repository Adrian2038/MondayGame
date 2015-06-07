//
//  Packet.m
//  Snap
//
//  Created by Adrian on 15/3/27.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

#import "Packet.h"
#import "NSData+SnapAdditions.h"
#import "PacketSignInResponse.h"
#import "PacketServerReady.h"
#import "PacketDealCards.h"
#import "PacketPlayerCallSet.h"
#import "PacketPlayerShouldCallSet.h"
#import "PacketOtherClientQuit.h"
#import "Card.h"

const size_t PACKET_HEADER_SIZE = 10;

@implementation Packet

@synthesize packetType = _packetType;

+ (id)packetWithType:(PacketType)packetType
{
	return [[[self class] alloc] initWithInsideType:packetType];
}

+ (id)packetWithData:(NSData *)data
{
	if ([data length] < PACKET_HEADER_SIZE)
	{
		NSLog(@"Error: Packet too small");
		return nil;
	}
    
	if ([data rw_int32AtOffset:0] != 'SNAP')
	{
		NSLog(@"Error: Packet has invalid header");
		return nil;
	}
    
	int packetNumber = [data rw_int32AtOffset:4];
    
    NSLog(@"puacketNumber is : %d", packetNumber);
    
	PacketType packetType = [data rw_int16AtOffset:8];
    
	Packet *packet;
    
	switch (packetType)
	{
		case PacketTypeSignInRequest:
        case PacketTypeClientReady:
        case PacketTypeClientDealtCards:
        case PacketTypeServerQuit:
		case PacketTypeClientQuit:            
			packet = [Packet packetWithType:packetType];
			break;
            
		case PacketTypeSignInResponse:
			packet = [PacketSignInResponse packetWithData:data];
			break;
            
        case PacketTypeServerReady:
			packet = [PacketServerReady packetWithData:data];
			break;
        
        case PacketTypeDealCards:
            packet = [PacketDealCards packetWithData:data];
            break;
            
        case PacketTypePlayerShouldSnap:
            packet = [PacketPlayerShouldCallSet packetWithData:data];
            break;
                        
        case PacketTypeOtherClientQuit:
			packet = [PacketOtherClientQuit packetWithData:data];
			break;
            
		default:
			NSLog(@"Error: Packet has invalid type");
			return nil;
	}
    
	return packet;
}

+ (NSMutableDictionary *)cardsFromData:(NSData *)data atOffset:(size_t)offset
{
    size_t count;
    
    // Because the only the server can deal the cards
    NSMutableDictionary *cards = [NSMutableDictionary dictionaryWithCapacity:1];
    
    while (offset < [data length])
    {
        NSString *peerID = [data rw_stringAtOffset:offset bytesRead:&count];
        offset += count;
        
        int numeberOfCards = [data rw_int8AtOffset:offset];
        offset += 1;
        
        NSLog(@"with packet with data number of cards = %d", numeberOfCards);
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:numeberOfCards];
        
        for (int t = 0; t < numeberOfCards; t++)
        {
            int color = [data rw_int8AtOffset:offset];
            offset += 1;
            
            int shading = [data rw_int8AtOffset:offset];
            offset += 1;
            
            int symbol = [data rw_int8AtOffset:offset];
            offset += 1;
            
            int value = [data rw_int8AtOffset:offset];
            offset += 1;
            
            Card *card = [[Card alloc] initWithColor:color
                                             shading:shading
                                              symbol:symbol
                                               value:value];
            [array addObject:card];
        }
        
        // let the packet has the cards dictionary
        [cards setObject:array forKey:peerID];
    }
    return cards;
}

- (id)initWithInsideType:(PacketType)packetType
{
	if ((self = [super init]))
	{
		self.packetType = packetType;
	}
	return self;
}

- (NSData *)data
{
	NSMutableData *data = [[NSMutableData alloc] initWithCapacity:100];
    
	[data rw_appendInt32:'SNAP'];   // 0x534E4150
	[data rw_appendInt32:0];
	[data rw_appendInt16:self.packetType];
    
    [self addPayloadToData:data];
    
	return data;
}

- (void)addPayloadToData:(NSMutableData *)data
{
	// base class does nothing
}

- (void)addCards:(NSDictionary *)cards toPayload:(NSMutableData *)data
{
    // key is server's peerID
    [cards enumerateKeysAndObjectsUsingBlock:^(id key, NSArray *array, BOOL *stop)
    {
        [data rw_appendString:key];
        [data rw_appendInt8:[array count]];
        NSLog(@"with payload array count = %d", array.count);
        
        for (int t = 0; t < [array count]; t++)
        {
            Card *card = [array objectAtIndex:t];
            
            [data rw_appendInt8:card.color];
            [data rw_appendInt8:card.shading];
            [data rw_appendInt8:card.symbol];
            [data rw_appendInt8:card.value];
        }
    }];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@, type=%d", [super description], self.packetType];
}

@end
