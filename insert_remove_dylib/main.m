//
//  main.m
//  insert_remove_dylib
//
//  Created by app2 on 2017/9/15.
//  Copyright © 2017年 app2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <getopt.h>
#import "Insert_dylib/Insert_dylib.h"
#import "Remove_dylib/Remove_dylib.h"
#import <mach-o/loader.h>
void print_usage(){
    fprintf(stderr, "insert_remove_dylib \n"
            "Usage: insert_remove_dylib [options] <dylib_path> <mach-o-file>\n"
            "\n"
            "   where options are:\n"
            "       -i          inject a dylib to mach-o file by LC_LOAD_DYLIB\n"
            "       -w          with -i mean by  inject a dylib to mach-o file LC_LOAD_WEAK_DYLIB\n"
            "       -r          remove a dylib in mach-o file\n");
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        if (argc<4) {
            print_usage();
        }
        
        NSString *target_path = nil;
        NSString *insert_dylib_path = nil;
        NSString *remove_dylib_path = nil;
        
        struct option longopts[] = {
            {"insert-dylib",        required_argument,      NULL,   'i'},
            {"insert-dylib",        optional_argument,      NULL,   'w'},
            {"remove-dylib",        required_argument,      NULL,   'r'},
            {NULL,                  0,                      NULL,   0},
            
        };
        int ch;
        BOOL errorFlag = NO;
        int operation;
        while ((ch = getopt_long(argc, (char * const *)argv, "i:w:r:", longopts, NULL)) != -1) {
            switch (ch) {
                case 'i':
                {
                    //获取注入的路径
                    insert_dylib_path = [NSString stringWithUTF8String:optarg];
                    operation = 'i';
                    if (strcmp(optarg, "-w") == 0) {
                        insert_dylib_path = [NSString stringWithUTF8String:argv[optind]];
                        operation = 'w';
                    }
                    
                }
                    break;
                case 'r':
                {
                    remove_dylib_path = [NSString stringWithUTF8String:optarg];
                    operation = 'r';
                }
                    break;
                case 0:
                default:
                    errorFlag = YES;
                    break;
            }
        }
        if (errorFlag) {
            fprintf(stderr, "ERROR!!!\n");
            
            print_usage();
            
            exit(1);
        }
        if (optind < argc) {
            //获取target文件路径
            target_path = [NSString stringWithUTF8String:argv[optind]];
            
            if (insert_dylib_path && operation == 'i') {
                //注入
                fprintf(stderr, "insert:%s\n",[insert_dylib_path UTF8String]);
                
                [Insert_dylib Insert_dylib:insert_dylib_path targetFile:target_path];
            }
            if (insert_dylib_path && operation == 'w') {
                //注入
                fprintf(stderr, "insert:%s\n",[insert_dylib_path UTF8String]);
                target_path = [NSString stringWithUTF8String:argv[optind + 1]];
                [Insert_dylib Insert_dylib:insert_dylib_path targetFile:target_path insertStyle:LC_LOAD_WEAK_DYLIB];
            }
            if (remove_dylib_path && operation == 'r') {
                //移除
                fprintf(stderr, "remove:%s\n",[remove_dylib_path UTF8String]);
                [Remove_dylib Remove_dylib:remove_dylib_path targetFile:target_path];
            }
            if (insert_dylib_path==nil && remove_dylib_path==nil) {
                fprintf(stderr, "ERROR!!!\n");
                print_usage();
                exit(1);
            }
            fprintf(stderr, "completed!!!\n");
        }
        
    }
    return 0;
}





