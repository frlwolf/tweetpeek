//
//  UIImage+TPK.m
//  TweetPeek
//
//  Created by Felipe Lobo on 9/23/15.
//  Copyright © 2015 Felipe Lobo. All rights reserved.
//

#import "UIImage+TPK.h"

@implementation UIImage (TPK)

- (UIImage *)tpk_imageByColorizingWithColor:(UIColor *)color
{
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, .0f, self.size.height * scale);
    CGContextScaleCTM(context, 1.f, -1.f);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGRect rect = CGRectMake(0, 0, self.size.width * scale, self.size.height * scale);
    
    CGContextDrawImage(context, rect, self.CGImage);
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathEOFill);
    
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:coloredImage.CGImage scale:scale orientation:UIImageOrientationUp];
}

@end
