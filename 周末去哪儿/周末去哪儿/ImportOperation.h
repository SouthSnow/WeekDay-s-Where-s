//
// Created by chris on 6/16/13.
//

#import <Foundation/Foundation.h>

@class Store;


@interface ImportOperation : NSOperation
- (id)initWithStore:(Store*)store Storys:(NSArray*)storys;
@property (nonatomic) float progress;
@property (nonatomic, copy) void (^progressCallback) (float);
@end