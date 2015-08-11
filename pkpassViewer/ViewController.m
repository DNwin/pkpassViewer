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
    
    // Get path of all resources
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    // Get an array of all filenames in resourcepath
    NSArray *passFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcePath error:nil];
    
    // Loop over resource files and add .pkpass files
    for (NSString *passFile in passFiles) {
        if ( [passFile hasSuffix:@".pkpass"]) {
            [self.passes addObject: passFile];
        }
    }
}

#pragma mark - Private

- (void)openPassWithName:(NSString *)name {
    
    // Get path with filename
    // /private/var/mobile/Containers/Bundle/Application/3369688D-8E40-450F-BD9F-86AA8E195B7A/pkpassViewer.app/FreeHug.pkpass
    NSString *passFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: name];
    // Retrieve file data
    NSData *passData = [NSData dataWithContentsOfFile:passFilePath];
    
    NSError *error = nil;
    PKPass *newPass = [[PKPass alloc] initWithData:passData error:&error];
    
    if (error != nil) {
        [[[UIAlertView alloc] initWithTitle:@"Passes error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    
    // Show prompt to add pass to pass library
    PKAddPassesViewController *addController = [[PKAddPassesViewController alloc] initWithPass:newPass];
    addController.delegate = self;
    [self presentViewController:addController animated:YES completion:nil];
    
    
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

// On cell selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    NSString *passName = self.passes[indexPath.row];
    [self openPassWithName:passName];
}
@end
