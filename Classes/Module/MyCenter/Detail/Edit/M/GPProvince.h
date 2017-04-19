

#import <Foundation/Foundation.h>

@interface GPProvince : NSObject

@property (nonatomic, strong) NSArray *cities;

@property (nonatomic, strong) NSString *name;


+ (instancetype)provinceWithDict:(NSDictionary *)dict;

@end
