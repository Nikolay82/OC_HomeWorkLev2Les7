//
//  ViewController.m
//  UseServerVK
//
//  Created by Nikolay on 28.05.15.
//  Copyright (c) 2015 gng. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>


@interface ViewController ()

@property (nonatomic, strong) NSString * idString;

@property (weak, nonatomic) IBOutlet UITextField *textFieldURL;

@property (weak, nonatomic) IBOutlet UITextField *textFieldID;


- (IBAction)btnGetIDbyURL:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textFieldURL.text = @"https://vk.com/kudago";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getIdVKgroupFromURL: (NSString *) urlString {
    
    NSArray * arrayUrl = [urlString componentsSeparatedByString:@"/"];
    
    NSString * shortNameGroup = [arrayUrl objectAtIndex:arrayUrl.count-1];
    
    NSURL * urlRequest = [NSURL URLWithString:@"https://api.vk.com/method/"];
    
    AFHTTPRequestOperationManager * reqManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:urlRequest];
    
    NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys: shortNameGroup, @"group_id", nil];
    
    [reqManager GET:@"groups.getById" parameters:params
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSLog(@"NSDictionary jsonObject %@", responseObject);
            
            NSDictionary * dict = (NSDictionary *) responseObject;

            NSArray * arrayResponse = [dict valueForKey:@"response"];
            
            NSDictionary * dictError = [dict valueForKey:@"error"];
            
            if (arrayResponse != nil) {
                
                NSDictionary * dictResp = [arrayResponse objectAtIndex:0];
                NSNumber * gid = [dictResp valueForKey:@"gid"];
                self.idString = gid.stringValue;
                [self performSelectorOnMainThread:@selector(showID) withObject:nil waitUntilDone:YES];
                
            }
            else if (dictError != nil) {
                
                self.idString = @"Ошибка";
                [self performSelectorOnMainThread:@selector(showID) withObject:nil waitUntilDone:YES];
                
            }
            
        }
        else {
            
            self.idString = @"Ошибка";
            [self performSelectorOnMainThread:@selector(showID) withObject:nil waitUntilDone:YES];

        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.idString = @"Ошибка";
        [self performSelectorOnMainThread:@selector(showID) withObject:nil waitUntilDone:YES];

        NSLog(@"error %@", error);
        
    }];
    
}

- (void) showID {
    
    self.textFieldID.text = self.idString;
    
}


- (IBAction)btnGetIDbyURL:(id)sender {
    
    [self getIdVKgroupFromURL:self.textFieldURL.text];
    
}
@end
