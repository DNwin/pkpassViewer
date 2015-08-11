//
//  ViewController.m
//  pkpassViewer
//
//  Created by Dennis Nguyen on 8/10/15.
//  Copyright (c) 2015 dnwin. All rights reserved.
//

#import "ViewController.h"
@import PassKit;

@interface ViewController ()
<UITableViewDelegate, UITableViewDataSource,
PKAddPassesViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *passes; // Holds pkpasses

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Check to see if passbook is available and exit if not
    if (![PKPassLibrary isPassLibraryAvailable]) {
        // Display error message
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Passkit not available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
        return;
    }
    
    // Init objects
    _passes = [[NSMutableArray alloc] init];
    
    // Load passes from folder
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSArray *passFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcePath error:nil];
    
    // Loop over resource files and add .pkpass files
    for (NSString *passFile in passFiles) {
        if ( [passFile hasPrefix:@".pkpass"]) {
            [self.passes addObject: passFile];
        }
    }
}

#pragma mark - Table View


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.passes.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString *passName = self.passes[indexPath.row];
    cell.textLabel.text = passName;
    
    return cell;
}

@end
