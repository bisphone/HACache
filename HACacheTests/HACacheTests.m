//
//  HACacheTests.m
//  HACacheTests
//
//  Created by Hossein Asgari on 4/21/16.
//  Copyright © 2016 Hossein Asgari. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HAMemoryCache.h"
#import "HAMemoryCache+ImageCache.h"

///// change this cache size , then you could check lru and mru clearing issues...
const int CacheSize = 20000;//(Bytes)

@interface HACacheTests : XCTestCase

@property (nonatomic , strong) HAMemoryCache *memCache;

@end

@implementation HACacheTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _memCache = [[HAMemoryCache alloc] initWithSize:CacheSize cacheEvictionRule:CacheEviction_LRU];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [_memCache removeAllObjects];
    _memCache = nil;
}

- (void)testFetchData {
    UIImage *image = [self _testImage];
    NSString *key = @"key";
    
    [_memCache setObject:UIImagePNGRepresentation(image) forKey:key];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"read"];
    UIImage *cachedImage = [UIImage imageWithData:[_memCache objectForKey:key]];
    [self _assertImage:image isEqualImage:cachedImage];
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testFetchDataWithScale {
    UIImage *image = [self _testImage];
    NSString *key = @"key";
    
    [_memCache setObject:UIImagePNGRepresentation(image) forKey:key];
    
    for (int i=0; i < 5; i++) {
        
        XCTestExpectation *expectation = [self expectationWithDescription:@"read"];
        UIImage *cachedImage = [_memCache imageForKey:key withSize:CGSizeMake(50, 50)];
        [self _assertImage:cachedImage isEqualSize:CGSizeMake(50, 50)];
        [expectation fulfill];
    }
    
    [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testFetchDataWithLRUCleared {
    
    _memCache = [[HAMemoryCache alloc] initWithSize:CacheSize cacheEvictionRule:CacheEviction_LRU];
    
    UIImage *image = [self _testImage];
    NSString *key = @"key";
    
    for (int i=0; i < 5; i++) {
        
        [_memCache setObject:UIImagePNGRepresentation(image) forKey:[NSString stringWithFormat:@"%@_%d" , key , i]];
    }
    
    
    for (int i=0; i < 5; i++) {
    
        XCTestExpectation *expectation = [self expectationWithDescription:@"read"];
        UIImage *cachedImage = [UIImage imageWithData:[_memCache objectForKey:[NSString stringWithFormat:@"%@_%d" , key , i]]];
        [self _assertImage:image isEqualImage:cachedImage];
        [expectation fulfill];
    }
    
    XCTAssert([_memCache allKeys]);
    [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testFetchDataWithMRUCleared {
    
    _memCache = [[HAMemoryCache alloc] initWithSize:CacheSize cacheEvictionRule:CacheEviction_MRU];
    
    UIImage *image = [self _testImage];
    NSString *key = @"key";
    
    for (int i=0; i < 5; i++) {
        
        [_memCache setObject:UIImagePNGRepresentation(image) forKey:[NSString stringWithFormat:@"%@_%d" , key , i]];
    }
    
    
    for (int i=0; i < 5; i++) {
        
        XCTestExpectation *expectation = [self expectationWithDescription:@"read"];
        UIImage *cachedImage = [UIImage imageWithData:[_memCache objectForKey:[NSString stringWithFormat:@"%@_%d" , key , i]]];
        [self _assertImage:image isEqualImage:cachedImage];
        [expectation fulfill];
    }
    
    XCTAssert([_memCache allKeys]);
    [self waitForExpectationsWithTimeout:3.0 handler:nil];
}



#pragma mark - Helpers

- (UIImage *)_testImage {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"blue" ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

- (void)_assertImage:(UIImage *)img1 isEqualImage:(UIImage *)img2 {
    XCTAssertNotNil(img1);
    XCTAssertNotNil(img2);
    XCTAssertTrue(img1.size.width * img1.scale ==
                  img2.size.width * img2.scale);
    XCTAssertTrue(img1.size.height * img1.scale ==
                  img2.size.height * img2.scale);
}

- (void)_assertImage:(UIImage *)img isEqualSize:(CGSize)size {
    
    XCTAssertNotNil(img);
    XCTAssertTrue(img.size.width == size.width*img.scale);
    XCTAssertTrue(img.size.height == size.height*img.scale);
}


@end
