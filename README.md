csscagradientlayer
==================

CAGradientLayer  from CSS (HEX or RGBA)

Usage:

+(CAGradientLayer *)gradientWithType:(kColourGradients)type
{
    NSString *gradientString = @"";
    ColorFormat format = ColorFormatHEX;
    
    switch (type)
    {
        case kStrongButton:
            gradientString = @"#A4438B 10%,#5E2750 50%";
            break;
        case kPrimaryButton:
            gradientString = @"#282828 10%,#747474 50%";
            break;
        case kSecondaryButton:
            gradientString = @"#FFFFFF 10%,#E0E0E0 50%";
            break;
        case kBackgroundPanel:
            gradientString = @"#FFFFFF 0%,#E7E7E7 9%,#FFFFFF 100%";
            break;
        case kTopNavBar:
            gradientString = @"rgba(0,0,0,0) 0%,rgba(0,0,0,0) 6%,rgba(254,254,254,0.12) 7%,rgba(254,254,254,0.47) 9%,rgba(254,254,254,0.74) 10%,rgba(254,254,254,0.9) 11%,rgba(254,254,254,0.98) 12%,rgba(254,254,254,1) 13%,rgba(231,231,231,1) 100%";
            format = ColorFormatRGBA;
            break;
        default:
            break;
    }
    
    return [BackgroundLayer gradientFromString:gradientString usingFormat:format];
}

+(CAGradientLayer *)gradientWithType:(kColourGradients)type forView:(UIView *)view
{
    CAGradientLayer *bgLayer = [self gradientWithType:type];
    bgLayer.frame = view.bounds;
    return bgLayer;
}
