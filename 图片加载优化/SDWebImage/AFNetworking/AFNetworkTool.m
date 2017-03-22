//
//  AFNetworkTool.m
//  TextA
//
//  Created by 张超 on 15/11/6.
//  Copyright © 2015年 张超. All rights reserved.
//

#import "AFNetworkTool.h"
#import "AFNetworking.h"

@implementation AFNetworkTool

+ (void)getUrl:(NSString *)url
          body:(id)body
      response:(ResposeStyle)style
requestHeadFile:(NSDictionary *)headFile
       success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    // 1.获取单例的网络管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.根据style的类型，去选择返回值的类型
    switch (style) {
        case ZCJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
            case ZCXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
            case ZCData:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
            
        default:
            break;
    }
    // 3.设置响应数据支持类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript", nil]];
    // 4.给网络请求添加请求头，(加http协议文件)
    if (headFile) {
        for (NSString *key in headFile.allKeys) {
            [manager.requestSerializer  setValue:headFile[key] forHTTPHeaderField:key];
            
        }
    }
//    [manager.requestSerializer setValue:@"49ef05bf26b30c806642450a08b111e76" forHTTPHeaderField:@"Authorization"];
    // 5.UTF8转码
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    // 6.发送get请求
//    [manager GET:url parameters:body success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        // 回调
//        if (success) {
//            
//            success(task, responseObject);
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        if (failure) {
//            
//            failure (task, error);
//        }
//    }];
    
    /* 6.发送get请求 */
    [manager GET:url parameters:body success:^(NSURLSessionDataTask *task, id responseObject) {
        
        /* ************************************************** */
        //如果请求成功 , 回调请求到的数据 , 同时 在这里 做本地缓存
        NSString *path = [NSString stringWithFormat:@"%ld.plist", [url hash]];
        // 存储的沙盒路径
        NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        // 归档
        [NSKeyedArchiver archiveRootObject:responseObject toFile:[path_doc stringByAppendingPathComponent:path]];
        
        
        /* if判断， 防止success 为空 */
        if (success) {
            
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {


        
        if (error) {
            
            /* *************************************************** */
            // 在这里读取本地缓存
            NSString *path = [NSString stringWithFormat:@"%ld.plist", [url hash]];
            
            NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            
            id result = [NSKeyedUnarchiver unarchiveObjectWithFile:[path_doc stringByAppendingPathComponent:path]];
            
            if (result) {
                success(task, result);
            }else{
                failure(task,error);
            }
            
            //            failure(task, error);
        }
        
    }];
    
}


+ (void)postUrlString:(NSString *)url
                 body:(id)body
             response:(ResposeStyle)style
            bodyStyle:(QCRequestStyle)bodyStyle
      requestHeadFile:(NSDictionary *)headFile
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    // 1.获取Session管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.设置网络请求返回时, responseObject的数据类型
    switch (style) {
        case ZCJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case ZCXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case ZCData:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    // 3.判断body体的类型
    switch (bodyStyle) {
        case RequestJSON:
            // 以JSON格式发送
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        case RequestString:
            // 保持字符串样式
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
                return parameters;
            }];
        case RequestDefault:
            // 默认情况会把JSON拼接成字符串, 但是没有顺序
            break;
            
        default:
            break;
    }
    // 4.给网络请求加请求头
    if (headFile) {
        for (NSString *key in headFile.allKeys) {
            [manager.requestSerializer setValue:headFile[key] forHTTPHeaderField:key];
        }
    }
    // 5.设置支持的响应头格式
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript", nil]];
    // 6.发送网络请求
    [manager POST:url parameters:body success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
    
}









@end
