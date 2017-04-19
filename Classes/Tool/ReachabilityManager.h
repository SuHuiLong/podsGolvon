
#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityManager : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, assign) BOOL reachable;

@end