//
//  AddNewPersonViewController.m
//  Person
//
//  Created by RYPE on 20/04/2015.
//  Copyright (c) 2015 RYPE. All rights reserved.
//

#import "AddNewPersonViewController.h"
#import "AppDelegate.h"

@interface AddNewPersonViewController ()
@property (strong, nonatomic) LBRESTAdapter *adapter;
@property (weak, nonatomic) IBOutlet UITextField *firstnameField;
@property (weak, nonatomic) IBOutlet UITextField *mailField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@end

@implementation AddNewPersonViewController

- (LBRESTAdapter *) adapter
{
    if( !_adapter)
        _adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://localhost:3000/api"]];
    return _adapter;
}


/*************************************************/
// Main
/*************************************************/


// Base
/**************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation


// Action if done
/**************************************/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    void (^saveNewErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on save %@", error.description);
    };
    
    void (^saveNewSuccessBlock)() = ^(){
        UIAlertView *messageAlert = [[UIAlertView alloc]initWithTitle:@"Successfull!" message:@"You have add a new Person" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [messageAlert show];
    };
    
    if (sender != self.doneButton) return;
    if (self.firstnameField.text.length > 0) {
        //NSLog(@"%@",self.firstnameField.text);
        LBModelRepository *prototype = [ [AppDelegate adapter]  repositoryWithModelName:@"people"];
        LBModel *model = [prototype modelWithDictionary:@{
                                                        @"firstname"        : self.firstnameField.text,
                                                        @"mail"       : self.mailField.text
                                                        }];
        
        [model saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
    }
    else {
        UIAlertView *messageAlert = [[UIAlertView alloc]initWithTitle:@"Missing person FirstName!" message:@"You have to enter a firstname." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [messageAlert show];
    }
}


@end
