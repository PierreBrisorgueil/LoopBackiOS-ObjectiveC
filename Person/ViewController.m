//
//  ViewController.m
//  Person
//
//  Created by RYPE on 19/04/2015.
//  Copyright (c) 2015 RYPE. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (strong, nonatomic) LBRESTAdapter *adapter;
@property (strong, nonatomic) NSMutableArray *tableData;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@end

@implementation ViewController

- (NSMutableArray *) tableData
{
    if ( !_tableData) _tableData = [[NSMutableArray alloc] init];
    return _tableData;
};


/*************************************************/
// Functions
/*************************************************/

- (void) getPerson {
    
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models) {
        //NSLog( @"selfSuccessBlock %lu", models.count);
        //NSLog(@"Success on Static Method result: %@", models);
        
        [self.tableData removeAllObjects ];
        
        for (int i = 0; i < models.count; i++) {
            LBModel *modelInstance = (LBModel*)[models objectAtIndex:i];
            [self.tableData addObject:modelInstance ];
        }
        
        [self.myTable reloadData];
    };
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
    };
    

    LBModelRepository *prototype = [ [AppDelegate adapter]  repositoryWithModelName:@"people"];
    [prototype allWithSuccess: loadSuccessBlock failure: loadErrorBlock];

};


/*************************************************/
// Design protection for IOS 7 & 8
/*************************************************/

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


/*************************************************/
// Main
/*************************************************/

// Base
/**************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    // put top margin UITableViewController without a UINavigationController consequence ;)
    // self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    // init data
    [self getPerson];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Buttons actions
/**************************************/
- (IBAction)actionGetPerson:(id)sender {
    [self getPerson];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    NSLog(@"Back to list");
    [self getPerson];
}


// Table View
/**************************************/
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    LBModel *model = (LBModel *)[self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - %@", [model objectForKeyedSubscript:@"firstname"] ,[model objectForKeyedSubscript:@"mail"]  ];
    
    return cell;
}



@end
