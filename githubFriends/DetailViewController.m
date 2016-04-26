//
//  DetailViewController.m
//  githubFriends
//
//  Created by Oliver Short on 4/25/16.
//  Copyright © 2016 Oliver Short. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <NSURLSessionDelegate>

@property NSMutableData *receivedData;
@property NSMutableArray *repos;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setFriendRepos:(NSString *)newFriendRepos {
    if (_friendRepos != newFriendRepos) {
        _friendRepos = newFriendRepos;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    if (self.friendRepos) {
        // Create a URL object from our string
        NSURL *url = [NSURL URLWithString:self.friendRepos];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
        // Data taskt o retrieve URL data
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url];
        
        // Start the data task to start fetching data from the URL
        [dataTask resume];
    }
}

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view (again).
        [self configureView];
    }
}


- (void)configView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        
        NSString *userName = [self.detailItem description];
        NSString* urlString = [NSString stringWithFormat:@"https://api.github.com/users/%@/repos", userName];
        NSURL *url = [NSURL URLWithString:urlString];
        // vv Creating a local variable that is pointing at the default value for how to create URL sessions vv. Doing this bc sometimes phones have constraints about what domains a user can go to.
        
        NSURLSessionConfiguration*config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]]; //mainQueue is the main thread that allows all of the UI magic to happen. have to do this on the main thread and when we update the UI things will update correctly.
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url]; //create a datatask from the session. dattasks gets data from a URL
        [dataTask resume];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    self.repos = [[NSMutableArray alloc]init];
    self.title = @"Repos!: 0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View Cell Configuration
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepoCell" forIndexPath:indexPath];
    
    // Grab the friend object from the array to populate the cell data with
    NSString *repo = self.repos[indexPath.row];
    
    // Populate the friends name
    cell.textLabel.text = repo;
    
    return cell;
}

#pragma mark NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

//Means that we started receiving data -

//creating something that holds the data we're receiving. going to call this method several times. if we have something already, we want to append what we just received
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    if (!self.receivedData) {
        self.receivedData = [[NSMutableData alloc]initWithData:data];
    }else{
        [self.receivedData appendData:data];
    }
}

//once we get to "did complete with error" it means we've gotten to the end

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    if (!error) {
 //       NSLog(@"Download Successful! %@", [self.receivedData description]);
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", [jsonResponse description]);
    }
}



@end
