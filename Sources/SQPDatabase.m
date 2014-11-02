//
//  SQPDatabase.m
//  SQPersist
//
//  Created by Christopher Ney on 29/10/2014.
//  Copyright (c) 2014 Christopher Ney. All rights reserved.
//

#import "SQPDatabase.h"

#define kSQPDefaultDdName @"SQPersist.db"

@interface SQPDatabase ()
- (FMDatabase*)createDatabase;
@end

@implementation SQPDatabase

/**
 *  Get the main instance of the database manager.
 *
 *  @return Instance.
 */
+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

/**
 *  Setup the database.
 *
 *  @param dbName Name of the database.
 */
- (void)setupDatabaseWithName:(NSString*)dbName {
 
    _dbName = dbName;
    _database = [self createDatabase];
}

/**
 *  Return the name of the database.
 *
 *  @return Database name.
 */
- (NSString*)getDdName {
    return _dbName;
}

/**
 *  Return the path of the database.
 *
 *  @return Path of the database.
 */
- (NSString*)getDdPath {
    return _dbPath;
}

/**
 *  Create the local SQLite database file (private method).
 *
 *  @return Database connector.
 */
- (FMDatabase*)createDatabase {
    
    if (_dbName == nil) _dbName = kSQPDefaultDdName;
    
    NSString *documentdir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    _dbPath = [documentdir stringByAppendingPathComponent:_dbName];
    
    //NSLog(@"%@", _dbPath);
    
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    db.logsErrors = YES;
    db.traceExecution = NO;
    
    if (![db open]) {
        return nil;
    } else {
        return db;
    }
}

/**
 *  Database connector.
 *
 *  @return Database connector.
 */
- (FMDatabase*)database {
    
    if (_database == nil) {
        _database = [self createDatabase];
    }
    
    return _database;
}

/**
 *  Check if the database file exists.
 *
 *  @return Return YES if the database exists.
 */
- (BOOL)databaseExists {
 
    if (_dbPath != nil) {
        BOOL isDirectory = NO;
        return [[NSFileManager defaultManager] fileExistsAtPath:_dbPath isDirectory:&isDirectory];
    } else {
        return NO;
    }
}

/**
 *  Remove the database.
 *
 *  @return Remove the database.
 */
- (BOOL)removeDatabase {
    
    if (_dbPath != nil) {
        
        if (_database != nil) {
            [_database close];
        }
        
        NSError *error = nil;
        
        [[NSFileManager defaultManager] removeItemAtPath:_dbPath error:&error];
        
        if (error == nil) {
            _database = nil;
            return YES;
        } else {
            NSLog(@"%@", [error localizedDescription]);
            return NO;
        }
        
    } else {
        return NO;
    }
}

@end
