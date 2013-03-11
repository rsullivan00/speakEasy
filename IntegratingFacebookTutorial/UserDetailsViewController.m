//
//  Copyright (c) 2013 Parse. All rights reserved.

#import "UserDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface UserDetailsViewController()
@property (nonatomic, strong) NSDictionary *userProfile;
@end

@implementation UserDetailsViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Facebook Profile";
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    // Add logout navigation bar button
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonTouchHandler:)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    // Load table header view from nib
    [[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil];
    self.tableView.tableHeaderView = _headerView;
    
    // Create array for table row titles
    _rowTitleArray = @[@"Location", @"Gender", @"Date of Birth", @"Relationship"];
    
    // Set default values for the table row data
    _rowDataArray = [NSMutableArray arrayWithObjects:@"N/A", @"N/A", @"N/A", @"N/A", nil];
    
    // If the user is already logged in, display any previously cached values before we get the latest from Facebook.
    if ([PFUser currentUser]) {
        self.userProfile = [PFUser currentUser][@"profile"];
        [self updateProfile];
    }
    
    // Send request to Facebook
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;

            NSString *facebookID = userData[@"id"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];

            self.userProfile = @{@"facebookId": facebookID,
                                 @"name": userData[@"name"],
                                 @"location": userData[@"location"][@"name"],
                                 @"gender": userData[@"gender"],
                                 @"birthday": userData[@"birthday"],
                                 @"relationship": userData[@"relationship_status"],
                                 @"pictureURL": [pictureURL absoluteString]};
            
            [[PFUser currentUser] setObject:self.userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];

            [self updateProfile];
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [self logoutButtonTouchHandler:nil];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    
}


#pragma mark - NSURLConnectionDataDelegate

/* Callback delegate methods used for downloading the user's profile picture */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // As chuncks of the image are received, we build our data file
    [_imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // All data has been downloaded, now we can set the image in the header image view
    _headerImageView.image = [UIImage imageWithData:_imageData];

    // Add a nice corner radius to the image
    _headerImageView.layer.cornerRadius = 8.0f;
    _headerImageView.layer.masksToBounds = YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _rowTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // Create the cell and add the labels
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 120.0f, 44.0f)];
        titleLabel.tag = 1; // We use the tag to set it later
        titleLabel.textAlignment = UITextAlignmentRight;
        titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        
        UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake( 130.0f, 0.0f, 165.0f, 44.0f)];
        dataLabel.tag = 2; // We use the tag to set it later
        dataLabel.font = [UIFont systemFontOfSize:15.0f];
        dataLabel.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:dataLabel];
    }
    
    // Cannot select these cells
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Access labels in the cell using the tag #
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *dataLabel = (UILabel *)[cell viewWithTag:2];
    
    // Display the data in the table
    titleLabel.text = [_rowTitleArray objectAtIndex:indexPath.row];
    dataLabel.text = [_rowDataArray objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - ()

- (void)logoutButtonTouchHandler:(id)sender {
    // Logout user, this automatically clears the cache
    [PFUser logOut];

    // Return to login view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// Set received values if they are not nil and reload the table
- (void)updateProfile {
    if (self.userProfile[@"location"]) {
        [_rowDataArray replaceObjectAtIndex:0 withObject:self.userProfile[@"location"]];
    }
    
    if (self.userProfile[@"gender"]) {
        [_rowDataArray replaceObjectAtIndex:1 withObject:self.userProfile[@"gender"]];
    }
    
    if (self.userProfile[@"birthday"]) {
        [_rowDataArray replaceObjectAtIndex:2 withObject:self.userProfile[@"birthday"]];
    }
    
    if (self.userProfile[@"relationship"]) {
        [_rowDataArray replaceObjectAtIndex:3 withObject:self.userProfile[@"relationship"]];
    }

    [self.tableView reloadData];

    // Set the name in the header view label
    _headerNameLabel.text = self.userProfile[@"name"];
    
    // Download the user's facebook profile picture
    _imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
    
    if (self.userProfile[@"pictureURL"]) {
        NSURL *pictureURL = [NSURL URLWithString:self.userProfile[@"pictureURL"]];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:2.0f];
        // Run network request asynchronously
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        if (!urlConnection) {
            NSLog(@"Failed to download picture");
        }
    }
}

@end
