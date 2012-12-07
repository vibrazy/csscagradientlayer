//  Created by Daniel Hollis
//  Copyright (c) 2012 Daniel Hollis. All rights reserved.
//  Email : vibrazy@hotmail.com
//

#import "BackgroundLayer.h"
#import "UIColor+HexString.h"
@implementation BackgroundLayer


+(NSArray *)componentsFromString:(NSString *)string usingFormat:(ColorFormat)format
{
    NSArray *arr = nil;
    
    switch (format) {
        case ColorFormatRGBA:
        {
            string = [string stringByReplacingOccurrencesOfString:@"rgba" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@","];
            string = [string stringByReplacingOccurrencesOfString:@"%" withString:@""];
            
            arr = [string componentsSeparatedByString:@","];
        }
            break;
        case ColorFormatHEX:
        {
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@","];
            
            arr = [string componentsSeparatedByString:@","];
        }
        default:
            break;
    }
    return arr;
    
}

+(UIColor *)colorFromString:(NSString *)string withColorFormat:(ColorFormat)format
{
    UIColor *color = nil;
    
    NSArray *componentsArray = [self componentsFromString:string usingFormat:format];
    
    switch (format)
    {
        case ColorFormatRGBA:
        {
            //254,254,254,1,7
            @try {
                
                float r,g,b,a;
                r = [[componentsArray objectAtIndex:0] floatValue];
                g = [[componentsArray objectAtIndex:1] floatValue];
                b = [[componentsArray objectAtIndex:2] floatValue];
                a = [[componentsArray objectAtIndex:3] floatValue];
                
                color = [UIColor colorWithRed:r/255.f
                                        green:g/255.f
                                         blue:b/255.f
                                        alpha:a];
                
            }
            @catch (NSException *exception)
            {
                color = [UIColor whiteColor];
            }
        }
        break;
        
        case ColorFormatHEX:
        {
            //#000000 7%
            color = [UIColor colorWithHexString:[componentsArray objectAtIndex:0]];
        }
        break;
        
        default:
            break;
    }
    
    
    return color;
    
}

+(CAGradientLayer *)gradientFromString:(NSString *)stringValue usingFormat:(ColorFormat)format
{
    NSString *regexStr = @"";
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    /*
     rgba(0,0,0,0) 0%,rgba(0,0,0,0) 6%,rgba(254,254,254,0.12) 7%,rgba(254,254,254,0.47) 8%,rgba(254,254,254,0.74) 9%,rgba(254,254,254,0.9) 10%,rgba(254,254,254,0.98) 11%,rgba(254,254,254,1) 12%,rgba(231,231,231,1) 96%,rgba(0,0,0,0) 97%,rgba(0,0,0,0) 100%
     */
    switch (format)
    {
        case ColorFormatHEX:
            regexStr = @"#[a-zA-Z0-9]{3,6} [0-9]{1,3}%";
            break;
        case ColorFormatRGBA:
            regexStr = @"rgba\\([0-9]{1,3},[0-9]{1,3},[0-9]{1,3},(([0-9]*\\.?[0-9]*))?\\) [0-9]{1,3}%";
            break;
        default:
            break;
    }
    
    NSError *error = nil;
    
    NSRegularExpression *testRegex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    
    if( testRegex == nil ) NSLog( @"Error making regex: %@", error );
    
    NSInteger matches = [testRegex numberOfMatchesInString:stringValue options:0 range:NSMakeRange(0, [stringValue length])];
    
    if (matches>0)
    {
        //we have a match, now we need to create the colours based on the string
        __block NSMutableArray *arrayOfColors = [NSMutableArray arrayWithCapacity:10];
        __block NSMutableArray *arrayOfPositions = [NSMutableArray arrayWithCapacity:10];
        
        [testRegex enumerateMatchesInString:stringValue options:0 range:NSMakeRange(0, [stringValue length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            NSString *invididualColorString = [stringValue substringWithRange:result.range];
            UIColor *color = [self colorFromString:invididualColorString withColorFormat:format];
            
            NSArray *componentsArray = [self componentsFromString:invididualColorString usingFormat:format];
            
            float percentage = [[componentsArray lastObject] floatValue];
            percentage/= 100.0f;
            NSNumber *positionOfColor = [NSNumber numberWithFloat:percentage];
            
            [arrayOfColors addObject:(id)color.CGColor];
            [arrayOfPositions addObject:positionOfColor];
            
        }];
        
        if (([arrayOfColors count] > 0 && [arrayOfPositions count] > 0) && [arrayOfColors count] == [arrayOfPositions count])
        {
            gradientLayer.colors = [NSArray arrayWithArray:arrayOfColors];
            gradientLayer.locations = [NSArray arrayWithArray:arrayOfPositions];
        }
    }

    return gradientLayer;
}
@end
