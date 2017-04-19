

#import "GPProvince.h"

@implementation GPProvince
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

+ (instancetype)provinceWithDict:(NSDictionary *)dict
{
    GPProvince *p = [[self alloc] init];
    
    [p setValuesForKeysWithDictionary:dict];
    
    return p;
}

@end
