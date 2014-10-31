//
//  ViewController.m
//  SQPersist
//
//  Created by Christopher Ney on 29/10/2014.
//  Copyright (c) 2014 Christopher Ney. All rights reserved.
//

#import "ViewController.h"

#import "User.h"
#import "Car.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create Database :
    [[SQPDatabase sharedInstance] setupDatabaseWithName:@"SQPersist.db"];
    
    NSLog(@"DB path: %@ ", [[SQPDatabase sharedInstance] getDdPath]);
    
    // If database exists:
    if ([[SQPDatabase sharedInstance] databaseExists]) {
        
        // REMOVE Local Database :
        [[SQPDatabase sharedInstance] removeDatabase];
        
        NSLog(@"DB '%@' removed!", [[SQPDatabase sharedInstance] getDdName]);
    }

    // Create Table at the first init (if tbale ne exists) :
    User *userJohn = [User SQPCreateEntity];
    userJohn.firstName = @"John";
    userJohn.lastName = @"McClane";
    userJohn.birthday = [NSDate date];
    userJohn.photo = [UIImage imageNamed:@"tn_john-mcclane-1.jpg"];
    
    // INSERT Object :
    [userJohn SQPSaveEntity];
    
    // SELECT BY objectID (John McClane) :
    User *userSelected = [User SQPFetchOneByID:userJohn.objectID];
    userSelected.amount = 10.50f;
    
    // UPDATE Object :
    [userSelected SQPSaveEntity];
    
    User *friendJohn = [User SQPCreateEntity];
    friendJohn.firstName = @"Hans";
    friendJohn.lastName = @"Gruber";
    
    userJohn.friends = [[NSMutableArray alloc] initWithObjects:friendJohn, nil];
    
    // UPDATE Object :
    [userJohn SQPSaveEntity];
    
    User *userJohn2 = [User SQPFetchOneWhere:@"lastname = 'McClane'"];
    
    NSLog(@"Name user : %@", userJohn2.firstName);
    
    Car *car1 = [Car SQPCreateEntity];
    car1.name = @"Ferrari";
    car1.color = @"Red";
    car1.owner = userJohn;
    car1.power = 350;
    [car1 SQPSaveEntity]; // INSERT Object
    
    Car *car2 = [Car SQPCreateEntity];
    car2.name = @"BMW";
    car2.color = @"Black";
    car2.power = 220;
    [car2 SQPSaveEntity]; // INSERT Object
    
    Car *car3 = [Car SQPCreateEntity];
    car3.name = @"Ferrari";
    car3.color = @"Yellow";
    car3.power = 150;
    [car3 SQPSaveEntity]; // INSERT Object
    
    // DELETE Object :
    car3.deleteObject = YES;
    [car3 SQPSaveEntity];
    
    Car *car4 = [Car SQPCreateEntity];
    car4.name = @"Ferrari";
    car4.color = @"Green";
    car4.power = 152;
    [car4 SQPSaveEntity]; // INSERT Object
    
    NSLog(@"Total cars : %lld", [Car SQPCountAll]);
    NSLog(@"Total cars 'Ferrari' : %lld", [Car SQPCountAllWhere:@"name = 'Ferrari'"]);
    
    // SELECT ALL 'Ferrari' :
    NSMutableArray *cars = [Car SQPFetchAllWhere:@"name = 'Ferrari'" orderBy:@"power DESC"];
    
    NSLog(@"Number of cars: %lu", (unsigned long)[cars count]);
    
    // Truncate all entities :
    [Car SQPTruncateAll];
    
    NSLog(@"Total cars : %lld", [Car SQPCountAll]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
