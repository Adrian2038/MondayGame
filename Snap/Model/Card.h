//
//  Card.h
//  Snap
//
//  Created by Adrian on 15/4/3.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

#import <Foundation/Foundation.h>


// Because the Set card has four features : symbol , shading , color , and number,
// except the number can be represnet by the NSInterger peoperty, the other features can be represent by enum.

typedef enum
{
    SetColorRed,
    SetColorGreen,
    SetColorPurple
}
SetColor;

typedef enum
{
    SetShadingSolid,
    SetShadingStriped,
    SetShadingOpen
}
SetShading;

typedef enum
{
    SetSymbolDiamond,
    SetSymbolSquiggle,
    SetSymbolOval
}
SetSymbol;

@interface Card : NSObject

@property (nonatomic, assign, readonly) SetColor color;
@property (nonatomic, assign, readonly) SetShading shading;
@property (nonatomic, assign, readonly) SetSymbol symbol;
@property (nonatomic, assign, readonly) NSUInteger value;

- (instancetype)initWithColor:(SetColor)color
                      shading:(SetShading)shading
                       symbol:(SetSymbol)symbol
                        value:(NSUInteger)value;

@end
