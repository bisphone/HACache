//
//  HAMemoryCache.h
//  HACache
//
//  Created by Hossein Asgari on 4/21/16.
//  Copyright © 2016 Hossein Asgari. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    
    CacheEviction_DISABLE =    0,
    CacheEviction_LRU =       1,
    CacheEviction_MRU =       2,
    
}CacheEviction;

@interface HAMemoryCache : NSObject

/** @property capacity
 *  @brief describes the number of files in the cache.
 **/
@property (nonatomic, assign) NSUInteger capacity;

/** @property size
 *  @brief describes the size of files the cache.
 **/
@property (nonatomic, assign) long long size;

/** @property size
 *  @brief describes the size of files the cache.
 **/
@property (nonatomic, assign) CacheEviction cacheEvictionRule;

/**
 * init with capacity limitation and eviction rule
 */
- (instancetype) initWithCapacity:(NSUInteger)capacity cacheEvictionRule:(CacheEviction)cm;

/**
 * init with size limitation and eviction rule
 */
- (instancetype) initWithSize:(long long)size cacheEvictionRule:(CacheEviction)cm;

/**
 * Returns the object for key if it exists in the cache.
 * If a object was returned, it is moved to the head of the link List.
 * This returns nil if a object is not cached.
 */
- (NSData *) objectForKey:(NSString *)key;

/**
 * Caches object with key
*/
- (void) setObject:(NSData *)obj forKey:(NSString *)key;

/**
 * remove object with key
 */
- (void) removeObjectForKey:(NSString *)key;

/**
 * remove all object from cache , it could uses in didReceiveMemoryWarning
 */
- (void) removeAllObjects;

/**
 * return all keys , cached in memory , also dump all keys with log
 */
- (NSArray *) allKeys;

/**
 * return all objects , cached in memory , also dump all keys with log
 */
- (NSArray *) allObjects;

@end
