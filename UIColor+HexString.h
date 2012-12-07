//
//  UIColor+HexString.h
//  Pegasus
//
//  Created by Micah Hainline
//  http://stackoverflow.com/users/590840/micah-hainline
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *) randomColor;
@end
