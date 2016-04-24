# HACache #

HACache is a simple in-memory LRU cache. It evicts objects based on an LRU/MRU algorithm and capacity/size limitation. Like NSCache, HACache is a mutable collection with an API similar to NSDictionary.

HACache objects have the following features:

* Least recently used objects(or most recently used objects) are evicted from the cache when the count/size limit is exceeded. eviction is disabled when **cacheEvictionRule** set as `CacheEviction_DISABLE`.
* LRU(or MRU) algorithm was implemented by using Link List for best performance result.
* The cache is thread-safe, so you can add, remove, and query items in the cache from different threads without having to lock the cache yourself.

### Usage: ###

Just `#import` the `HACache.h` header file, add Cache Classes and use the initializer that supports the eviction features you need.

The following example creates a cache with a limit of 1000 objects, with MRU eviction feature:  
`
[[HAMemoryCache alloc] initWithCapacity:1000 cacheEvictionRule:CacheEviction_MRU]
`  

and The following example creates a cache with 10 Mb limit size, with LRU eviction feature:  
`
[[HAMemoryCache alloc] initWithSize:10*1024*1024 cacheEvictionRule:CacheEviction_LRU]
`  

just set object in memory cache with this script :  
`- (void) setObject:(id)obj forKey:(NSString *)key;`  
 If the key with other object has already being cached, this method will remove the old object from cache and store new one. If the size of the cache is greater than specified capacity/size, cache eviction is performed base on your initialization algorithm.

read from cache memory with this:  
`- (id) objectForKey:(NSString *)key;`  
If no key is found, nil is return.

also remove object from memory cache with `removeObjectForKey` and in state of **didReceiveMemoryWarning** use `removeAllObjects`