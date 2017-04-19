//
//  DownLoadDataSource.m
//
//  Created by 李盼盼 on 15/11/10.
//  Copyright (c) 2015年 lipan. All rights reserved.
//

#import "DownLoadDataSource.h"
#import "AFNetworking.h"
@interface DownLoadDataSource()


@end

@implementation DownLoadDataSource

-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

-(instancetype)init
{
    if (self = [super init])
    {
        
        //先导入证书，找到证书的路径
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"api.golvon.com" ofType:@"cer"];
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        
        //AFSSLPinningModeNone 这个模式表示不做 SSL pinning，只跟浏览器一样在系统的信任机构列表里验证服务端返回的证书。若证书是信任机构签发的就会通过，若是自己服务器生成的证书，这里是不会通过的。
        //AFSSLPinningModeCertificate 这个模式表示用证书绑定方式验证证书，需要客户端保存有服务端的证书拷贝，这里验证分两步，第一步验证证书的域名/有效期等信息，第二步是对比服务端返回的证书跟客户端返回的是否一致。
        //AFSSLPinningModePublicKey 这个模式同样是用证书绑定方式验证，客户端要有服务端的证书拷贝，只是验证时只验证证书里的公钥，不验证证书的有效期等信息。只要公钥是正确的，就能保证通信不会被窃听，因为中间人没有私钥，无法解开通过公钥加密的数据。
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        if (certData) {
            securityPolicy.pinnedCertificates = @[certData];
        }
        AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
        [sessionManager setSecurityPolicy:securityPolicy];
        sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                                  @"text/html",
                                                                  @"image/jpeg",
                                                                  @"image/png",
                                                                  @"application/octet-stream",
                                                                  @"text/json",
                                                                  @"text/plain",
                                                                  @"multipart/form-data",
                                                                  @"text/json", nil];

        
        self.manager = sessionManager;
        
//        //设置成json解析器
//        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        //设置可以接受的contentTypes
//        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
//                                                                  @"text/html",
//                                                                  @"image/jpeg",
//                                                                  @"image/png",
//                                                                  @"application/octet-stream",
//                                                                  @"text/json",
//                                                                  @"text/plain",
//                                                                  @"multipart/form-data",
//                                                                  @"text/json", nil];
//        [self.manager.securityPolicy setAllowInvalidCertificates:YES];
        
    }
    return self;
}


-(void)downloadWithUrl:(MYString)urlStr parameters:(NSDictionary *)dic complicate:(Complicate) complicate
{
    [self.manager POST:urlStr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError * error = nil;
        if (error)
        {
            if (complicate)
            {
                complicate(NO,error);
            }
        }else
        {
            if (complicate)
            {
                complicate(YES,responseObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        if (complicate)
        {
            complicate(NO,error);
            NSLog(@"错区类型%@",error);
        }
        
    }];
    
}



@end
