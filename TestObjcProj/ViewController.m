//
//  ViewController.m
//  TestObjcProj
//
//  Created by sreekanth reddy iragam reddy on 4/10/17.
//  Copyright © 2017 com.sree.objc. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController
///static NSString * const BaseURLString = @"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=RADAR&lf=";
static NSString *BaseURLString = @"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=#######&lf=";
NSMutableArray *searchedResults;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    //[self dotheFetc];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

- (IBAction)fetchTheResults:(id)sender {
    
    _textField.resignFirstResponder;
    
    NSString *searchTxt=_textField.text;
    NSLog(@"the searched text is %@",searchTxt);
   // searchTxt=searchTxt
    if(searchedResults==nil)
    {searchedResults=[[NSMutableArray alloc] init];
    }else{
        searchedResults.removeAllObjects;
    }
    
    NSString *finalUrl=[BaseURLString stringByReplacingOccurrencesOfString:@"#######"
                                                             withString:searchTxt];
    
      NSURL *URL = [NSURL URLWithString:finalUrl];

    
    NSLog(@"the base url is %@",finalUrl);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
   // manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[URL absoluteString]
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             
             
             //NSLog(@"JSON: %@", responseObject);
             NSArray *myarra=(NSArray *)responseObject;
             NSLog(@"the count of results is %ld",myarra.count);
            // myarra.
             if(myarra.count>0){
                 
                 
                 NSLog(@"the values are  %@",[myarra objectAtIndex:0]);
                 NSDictionary *myDict=(NSDictionary *) [myarra objectAtIndex:0];
                 // NSLog(@"required dict value is %@",[myDict valueForKey:@"lfs"]);
                 NSArray *allResults=[myDict valueForKey:@"lfs"];
                 
                 
                 
                 for (NSDictionary *item in allResults) {
                     NSLog(@"the new values are %@", [item objectForKey:@"lf"]);
                     [searchedResults addObject:[item objectForKey:@"lf"]];
                 }
                 
                 NSLog(@"the values are %@",searchedResults);
                 [self.tableView reloadData];

                 
                 
                 
             }
             
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"the rror is %@",error);
             // Handle failure
         }];
    
     searchTxt=@"";
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    NSLog(@"the count for rows is %ld",searchedResults.count);
    return searchedResults.count;
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifierName=@"Cell";
    
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellIdentifierName];
    
    if(cell==nil){
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierName];
    }
    
    NSLog(@"the values are  in tableview %@",[searchedResults objectAtIndex:indexPath.row]);
    
    cell.textLabel.text=[searchedResults objectAtIndex:indexPath.row];
    
    return cell;
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}





@end
