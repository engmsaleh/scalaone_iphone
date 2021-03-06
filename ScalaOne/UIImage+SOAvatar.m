//
//  UIImage+SOAvatar.m
//  ScalaOne
//
//  Created by Jean-Pierre Simard on 9/5/12.
//  Copyright (c) 2012 Magnetic Bear Studios. All rights reserved.
//  http://www.magneticbear.com

#import "UIImage+SOAvatar.h"

@implementation UIImage (SOAvatar)

+ (UIImage *)avatarWithSource:(UIImage *)source type:(SOAvatarType)avatarType {
    NSString *bgImgName = nil;
    
    switch (avatarType) {
        case SOAvatarTypeLarge:
            bgImgName = @"profile_avatar";
            break;
            
        case SOAvatarTypeUser:
            bgImgName = @"map_avatar_generic";
            break;
            
        default:
            bgImgName = @"list-avatar-generic-nostar";
            break;
    }
    UIImage *background = [UIImage imageNamed:bgImgName];
    
    CGSize contextSize = background.size;
    if (avatarType == SOAvatarTypeFavoriteOff || avatarType == SOAvatarTypeFavoriteOn) {
        contextSize.width += 2;
    }
    
    if (avatarType == SOAvatarTypeLarge) {
        source = [self imageWithImage:source scaledToSize:CGSizeMake(80, 80)];
    } else {
        source = [self imageWithImage:source scaledToSize:CGSizeMake(44, 44)];
    }
    
    static CGFloat scale = -1.0;
    if (scale < 0.0) {
        UIScreen *screen = [UIScreen mainScreen];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
            scale = [screen scale];
        }
        else {
            scale = 0.0;    // Use the standard API
        }
    }
    if (scale > 0.0) {
        UIGraphicsBeginImageContextWithOptions(contextSize, NO, scale);
    }
    else {
        UIGraphicsBeginImageContext(contextSize);
    }
    
    [background drawInRect:CGRectMake(0, 0, background.size.width, background.size.height)];
    source = [self roundedImage:source withRadius:4.0 scale:scale];
    
    if (avatarType == SOAvatarTypeLarge) {
        [source drawInRect:CGRectMake(1.5,1,source.size.width,source.size.height)];
    } else {
        [source drawInRect:CGRectMake(2.5,1.5,source.size.width,source.size.height)];
    }
    
    if (avatarType == SOAvatarTypeFavoriteOff || avatarType == SOAvatarTypeFavoriteOn) {
        BOOL starState = NO;
        if (avatarType == SOAvatarTypeFavoriteOn) starState = YES;
        
        UIImage *star = [UIImage imageNamed:
                         [NSString stringWithFormat:
                          @"speakers-star-%@",starState ? @"on" : @"off"]];
        [star drawInRect:CGRectMake(contextSize.width-star.size.width,
                                    contextSize.height-star.size.height,
                                    star.size.width,
                                    star.size.height)
               blendMode:kCGBlendModeNormal alpha:1.0];
    }
    
    UIImage *avatar = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return avatar;
}

+ (UIImage *)roundedImage:(UIImage *)image withRadius:(CGFloat)radius scale:(CGFloat)scale {
    CGRect imgRect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
    
    // Clip context
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:imgRect cornerRadius:radius];
    [path addClip];
    
    // Draw image & set to UIImage
    [image drawInRect:imgRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
