//
//  JustPostedFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Michał Kozak on 21.06.2014.
//  Copyright (c) 2014 Michal Kozak. All rights reserved.
//

#import "JustPostedFlickrPhotosTVC.h"
#import "Flickr Fetcher/FlickrFetcher.h"

@interface JustPostedFlickrPhotosTVC ()

@end

@implementation JustPostedFlickrPhotosTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
    // Do any additional setup after loading the view.
}

- (IBAction)fetchPhotos
{
    [self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResult = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResult options:0 error:NULL];
        
        //NSLog(@"Flickr results = %@",propertyListResults);
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });
    
  
}

@end
