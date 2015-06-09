//
//  PacketSignInResponse.m
//  Snap
//
//  Created by Adrian on 15/5/13.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

#import "PacketSignInResponse.h"
#import "NSData+SnapAdditions.h"

@implementation PacketSignInResponse

@synthesize playerName = _playerName;

+ (id)packetWithData:(NSData *)data
{
	size_t count;
	NSString *playerName = [data rw_stringAtOffset:PACKET_HEADER_SIZE bytesRead:&count];
	return [[self class] packetWithPlayerName:playerName];
}

+ (id)packetWithPlayerName:(NSString *)playerName
{
	return [[[self class] alloc] initWithPlayerName:playerName];
}

- (id)initWithPlayerName:(NSString *)playerName
{
	if ((self = [super initWithInsideType:PacketTypeSignInResponse]))
	{
		self.playerName = playerName;
	}
	return self;
}

- (void)addPayloadToData:(NSMutableData *)data
{
	[data rw_appendString:self.playerName];
}

@end
