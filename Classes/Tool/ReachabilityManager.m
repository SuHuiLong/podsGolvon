#import "ReachabilityManager.h"

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject;
@implementation ReachabilityManager

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}

- (id)init {
    self = [super init];
    if (self) {
        [self initBlock];
    }
    return self;
}

- (void)initBlock {
    
    WeakSelfType blockSelf = self;
    self.reachability = [Reachability reachabilityForInternetConnection];
    self.reachability.reachableBlock = ^(Reachability *reach) {
        blockSelf.reachable = YES;
    };
    self.reachability.unreachableBlock = ^(Reachability *reach) {
        blockSelf.reachable = NO;
    };
    [self.reachability startNotifier];
    self.reachable = [self.reachability isReachable];
}

@end
