//
// Created by chris on 6/16/13.
//

#import "ImportOperation.h"
#import "Store.h"
#import "StoryModel.h"
#import "Story+Import.h"
#import "Story.h"

static const int ImportBatchSize = 10;

@interface ImportOperation ()
@property (nonatomic, copy) NSArray* storys;
@property (nonatomic, strong) Store* store;
@property (nonatomic, strong) NSManagedObjectContext* context;
@end

@implementation ImportOperation
{

}

- (id)initWithStore:(Store*)store Storys:(NSArray *)storys
{
    self = [super init];
    if(self) {
        self.store = store;
        self.storys = storys;
    }
    return self;
}


- (void)main
{
    // TODO: can we use new in the name? I think it's bad style, any ideas for a better name?
    self.context = [self.store newPrivateContext];
    self.context.undoManager = nil;

    [self.context performBlockAndWait:^
    {
        [self import];
    }];
}

- (void)import
{
    NSInteger count = self.storys.count;
    NSInteger progressGranularity = count/1;
    
    
    [self.storys enumerateObjectsUsingBlock:^(StoryModel* story, NSUInteger idx, BOOL * _Nonnull stop) {
        [Story importStory:story intoContext:self.context];
        
//        if (idx % progressGranularity == 0) {
//        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            !self.progressCallback ?: self.progressCallback(idx / (float) count);
        }];
        
        if (idx % ImportBatchSize == 0) {
            [self.context save:NULL];
        }
    }];
    
    !self.progressCallback?:self.progressCallback(1);
    [self.context save:NULL];
}

@end