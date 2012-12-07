//  Created by Daniel Hollis
//  Copyright (c) 2012 Daniel Hollis. All rights reserved.
//  Email : vibrazy@hotmail.com
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef enum
{
  ColorFormatRGBA,
    ColorFormatHEX
} ColorFormat;

@interface BackgroundLayer : NSObject

+(CAGradientLayer *)gradientFromString:(NSString *)stringValue usingFormat:(ColorFormat)format;

@end
