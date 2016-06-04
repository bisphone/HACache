//
//  HAMemoryCache+ImageCache.m
//  HACache
//
//  Created by Hossein Asgari on 6/4/16.
//  Copyright © 2016 Hossein Asgari. All rights reserved.
//

#import "HAMemoryCache+ImageCache.h"

@implementation HAMemoryCache (ImageCache)

- (UIImage *)setImageData:(NSData *)imageData WithSize:(CGSize)size forKey:(NSString *)key {
    
    UIImage *imageInfo = [self scaleImage:[UIImage imageWithData:imageData] withSize:size];
    NSData *data = UIImagePNGRepresentation(imageInfo);
    
    [self setObject:data forKey:[NSString stringWithFormat:@"%@_%f" , key , size.width]];
    
    return imageInfo;
}

- (UIImage *)imageForKey:(NSString *)key withSize:(CGSize)size {
    
    NSData *imageData = [self objectForKey:[NSString stringWithFormat:@"%@_%f" , key , size.width]];
    if (imageData) {
        
        UIImage *jpegImage = [UIImage imageWithData:imageData];
        UIImage *image = [UIImage imageWithCGImage:jpegImage.CGImage scale:jpegImage.scale orientation:jpegImage.imageOrientation];
        
        return image;
    }
    
    imageData = [self objectForKey:key];
    if (imageData) {
        
        return [self setImageData:imageData WithSize:size forKey:key];
    }
    
    return nil;
}

- (UIImage *)scaleImage:(UIImage *)image withSize:(CGSize)size{

    UIGraphicsBeginImageContextWithOptions(size, NO, image.scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


@end
