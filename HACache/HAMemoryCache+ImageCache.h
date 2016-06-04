//
//  HAMemoryCache+ImageCache.h
//  HACache
//
//  Created by Hossein Asgari on 6/4/16.
//  Copyright © 2016 Hossein Asgari. All rights reserved.
//

#import "HAMemoryCache.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HAMemoryCache (ImageCache)

- (UIImage *)setImageData:(NSData *)imageData WithSize:(CGSize)size forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key withSize:(CGSize)size;

@end
