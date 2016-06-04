//
//  HAMemoryCache.m
//  HACache
//
//  Created by Hossein Asgari on 4/21/16.
//  Copyright © 2016 Hossein Asgari. All rights reserved.
//

#import "HAMemoryCache.h"
#import "HADoublyLinkList.h"


@interface HAMemoryCache ()

/** @property keyToIndexMap
 *  @brief a map that stores the node of the cache.
 **/
@property (nonatomic, strong) NSMutableDictionary *keyToCacheNodeMap;

/** @property orderedEntries
 *  @brief cache data strcuture. The front is the most recently accessed and tail is the least.
 **/
@property (nonatomic, strong) HADoublyLinkList *cacheList;

@end

@implementation HAMemoryCache

- (instancetype) initWithSize:(long long)size cacheEvictionRule:(CacheEviction)cm {
    self = [super init];
    if (self) {
        self.size = size;
        self.capacity = -1;
        self.keyToCacheNodeMap = [[NSMutableDictionary alloc] init];
        self.cacheList = [HADoublyLinkList new];
        self.cacheEvictionRule = cm;
    }
    return self;
}


- (instancetype) initWithCapacity:(NSUInteger)capacity cacheEvictionRule:(CacheEviction)cm {
    self = [super init];
    if (self) {
        self.capacity = capacity;
        self.size = -1;
        self.keyToCacheNodeMap = [[NSMutableDictionary alloc] initWithCapacity:self.capacity];
        self.cacheList = [HADoublyLinkList new];
        self.cacheEvictionRule = cm;
    }
    return self;
}

- (void) setObject:(NSData *)obj forKey:(NSString *)key {
    if (obj != nil && key != nil) {
        @synchronized(self) {
            HALinkListNode *node = [self.keyToCacheNodeMap objectForKey:key];
            if (node != nil) {
                HALinkListNode *oldNode = self.keyToCacheNodeMap[key];
                [self.cacheList removeNode:oldNode];
            }
            HALinkListNode *newNode = [self.cacheList addObjectToFront:obj forKey:key];
            self.keyToCacheNodeMap[key] = newNode;
            [self evictCacheNodes];
        }
    }
}

- (NSData *) objectForKey:(NSString *)key {
    @synchronized(self) {
        HALinkListNode *node = [self.keyToCacheNodeMap objectForKey:key];
        if (node != nil) {
            id obj = node.obj;
            [self.cacheList moveNodeToHead:node];
            return obj;
        }
    }
    return nil;
}

-(void)removeObjectForKey:(NSString *)key{
    
    @synchronized(self) {
        HALinkListNode *node = [self.keyToCacheNodeMap objectForKey:key];
        if (node != nil) {
            HALinkListNode *removeNode = [self.cacheList removeNode:node];
            [self.keyToCacheNodeMap removeObjectForKey:removeNode.key];
        }
    }
}

-(void)removeAllObjects {
    
    @synchronized(self) {
        self.cacheList = [HADoublyLinkList new];
        [self.keyToCacheNodeMap removeAllObjects];
    }
}

-(void)evictNodesBaseOnCacheState {
    
    @synchronized(self) {
        
        if (self.cacheEvictionRule == CacheEviction_LRU) {
            HALinkListNode *removeNode = [self.cacheList removeNode:self.cacheList.tail];
            [self.keyToCacheNodeMap removeObjectForKey:removeNode.key];
        
        }else if (self.cacheEvictionRule == CacheEviction_MRU){
            HALinkListNode *removeNode = [self.cacheList removeNode:self.cacheList.head];
            [self.keyToCacheNodeMap removeObjectForKey:removeNode.key];
        }
        
    }
}

- (NSArray *) allKeys {
    [self.cacheList dumpList];
    return [self.keyToCacheNodeMap allKeys];
}

- (NSArray *) allObjects {
    [self.cacheList dumpList];
    return [self.cacheList allObjects];
}

- (void) evictCacheNodes {
    
    if (self.cacheEvictionRule == CacheEviction_DISABLE) {
        
        //// evict cache is disabled
        return;
    }
    
    if (self.capacity == -1 && self.cacheList.size > self.size) {
        
        while (self.cacheList.size - self.size > 0) {
            [self evictNodesBaseOnCacheState];
        }
        
        return;
    }
    
    if (self.size == -1 && self.cacheList.length > self.capacity) {
        
        while (self.cacheList.length - self.capacity > 0) {
            [self evictNodesBaseOnCacheState];
        }
        
        return;
    }
}

@end
