//
//  BoardView.m
//  Messenger
//
//  Created by abhas saroha on 3/30/15.
//  Copyright (c) 2015 abhas saroha. All rights reserved.
//

#import "BoardView.h"
#import "FetchFacebookImage.h"
#import <FBSDKCoreKit/FBSDKAccessToken.h>

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

enum Player {None = 0, You = -1, Me = 1};
enum Played {NoMove, MadeMove};
enum Marker {Cross = -1, Dot = 1};

const float THICKNESS = 5;

@implementation BoardView {
    NSMutableArray *_board;
    NSMutableArray *_images;
    NSMutableArray *_played;
    BOOL _isOver;
    int _currentMove;
    NSString* _challenger;
    enum GameState _gameState;
    enum Marker _marker;
    UIView *_winLine;
}

- (void) initBoardWithRows:(int) r Cols:(int) c Default:(BOOL) firstTurn {
    _rows = [NSNumber numberWithInt:r];
    _cols = [NSNumber numberWithInt:c];
    _board = [NSMutableArray arrayWithCapacity:r*c];
    _images = [NSMutableArray arrayWithCapacity:r*c];
    _currentMove = -1;
    // only for zero state gameboard
    if (firstTurn) {
        for (int i = 0; i < r*c; i++) {
            [_board setObject:[NSNumber numberWithInt:None] atIndexedSubscript:i];
            [_images setObject:[NSNull null] atIndexedSubscript:i];
        }
        _marker = Cross;
    }
    _victoryScreen.hidden = YES;
}

- (enum GameState) getGameState {
    return _gameState;
}

- (int) getMarker {
    return (int)_marker;
}

- (NSArray*) getBoardState {
    return [[NSArray alloc] initWithArray:[BoardView convertStateToReceivers:_board] copyItems:YES];
}

- (void) setBoardState:(NSArray *)data WithMarker:(NSNumber*) marker {
    [_board setArray:data];
    // we got sender's marker
    _marker = -1*[marker intValue];
    for (int i = 0; i < [_rows intValue]; i++) {
        for (int j = 0; j < [_cols intValue]; j++) {
            int index = [self getIndexForRow:i AndCol:j];
            NSNumber *val = [_board objectAtIndex: index];
            [_images setObject:[NSNull null] atIndexedSubscript:index];
            [self makeMoveAtRow:i Column:j Type:[val intValue]];
        }
    }
    // Check if game won on game start.
    _isOver = [self checkIsWon];
}

- (void) setChallenger:(NSString*) challenger {
    _challenger = challenger;
}

- (NSString*) getChallenger {
    return _challenger;
}

+ (NSArray*) convertStateToReceivers:(NSArray *)data {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < [data count]; i++) {
        NSNumber *elem;
        elem = (NSNumber*) [data objectAtIndex:i];
        [result insertObject:[NSNumber numberWithInt:-1*[elem intValue]] atIndex:i];
    }
    return result;
}

- (void) makeMoveAtRow:(int)r Column:(int)c Type:(int) type {
//    int index = [self getIndexForRow:r AndCol:c];
    [ _board setObject:[NSNumber numberWithInt:(int) type] atIndexedSubscript:[self getIndexForRow:r AndCol:c] ];
    [ self addImageToCellWithRow:r Column:c Type:type];
}

- (BOOL) moveComplete {
    return _currentMove != -1;
}

- (void) addImageToCellWithRow:(int) r Column:(int) c Type:(int) type {
    int index = [self getIndexForRow:r AndCol:c];
    UIImageView *view = [_images objectAtIndex:index];
    if ((id)view == (id)[NSNull null] || view == nil) {
        view = [[UIImageView alloc] init];
        [_images setObject:view atIndexedSubscript:index];
    }
    
    switch (type) {
        case Me:
            [BoardView setImageForView:view ForUserId:[[FBSDKAccessToken currentAccessToken] userID]
                            WithMarker:[BoardView getImageNameForMarker:_marker]];
            break;
        case You:
            [BoardView setImageForView:view ForUserId:_challenger
                            WithMarker:[BoardView getImageNameForMarker:-1*_marker]];
        default:
            break;
    }
    if ([view superview] != nil) {
        if (type == None) {
            [view removeFromSuperview];
        }
    } else {
        CGSize unit = [self getUnit];
        view.frame = CGRectMake(c*unit.width + 4,
                                r*unit.height + 4,
                                100,
                                100);
        [self addSubview:view];
    }
}

- (CGSize) getUnit {
    CGSize unit;
    unit.width = self.frame.size.width/[_cols intValue];
    unit.height = self.frame.size.width/[_cols intValue];
    return unit;
}
- (int) getIndexForRow:(int) r AndCol:(int) c {
    return r*[_cols intValue] + c;
}

- (void) handleTouch:(CGPoint)pos {
    CGSize unit = [self getUnit];
    int col = floor(pos.x/unit.width);
    int row = floor(pos.y/unit.height);
    if (!self->_isOver && row < [_rows intValue] && col < [_cols intValue]) {
        int index = [self getIndexForRow:row AndCol:col];
        if (_currentMove != -1) {
            if (_currentMove == index) {
                // undo move
                [self makeMoveAtRow:row Column:col Type:None];
                _currentMove = -1;
            }
            
        } else {
            NSNumber *elem = [_board objectAtIndex:index];
            if ([elem intValue] == None) {
                [self makeMoveAtRow:row Column:col Type:Me];
                _currentMove = [self getIndexForRow:row AndCol:col];
                // Check if game won on game move.
                _isOver = [self checkIsWon];
            }
        }
    }
}

- (BOOL) checkIsWon {
    BOOL result = NO;
    // check rows
    if (!result) {
        for (int i = 0; i < _rows.intValue; i++) {
            int count = 0;
            for (int j = 0; j < _cols.intValue; j++) {
                NSNumber *elem = [_board objectAtIndex:[self getIndexForRow:i AndCol:j]];
                count += (int) [elem intValue];
            }
            if (abs(count) == [_rows intValue]) {
                result = YES;
                CGSize unit = [self getUnit];
                CGRect rect = CGRectMake(4, (i + 0.5)*unit.height + 4,
                                         320, THICKNESS);
                _winLine = [self drawWinLine:rect];
                break;
            }
        }
    }
    // check columns
    if (!result) {
        for (int i = 0; i < _rows.intValue; i++) {
            int count = 0;
            for (int j = 0; j < _cols.intValue; j++) {
                NSNumber *elem = [_board objectAtIndex:[self getIndexForRow:j AndCol:i]];
                count += (int) [elem intValue];
            }
            if (abs(count) == [_rows intValue]) {
                result = YES;
                CGSize unit = [self getUnit];
                CGRect rect = CGRectMake((i + 0.5)*unit.height + 4, 4,
                                         THICKNESS, 320);
                _winLine = [self drawWinLine:rect];
                break;
            }
        }
    }
    // check first diagonal
    if (!result) {
        int count = 0;
        for (int i = 0; i < _rows.intValue; i++) {
            NSNumber *elem = [_board objectAtIndex:[self getIndexForRow:i AndCol:i]];
            count += (int) [elem intValue];
        }
        if (abs(count) == [_rows intValue]) {
            CGSize unit = [self getUnit];
            CGRect rect = CGRectMake(4, ([_rows intValue]/2 + 0.5)*unit.height + 4,
                                     320, THICKNESS);
            _winLine = [self drawWinLine:rect];
            _winLine.transform = CGAffineTransformRotate(_winLine.transform, -45);
            result = YES;
        }
    }
    // check second diagonal
    if (!result) {
        int count = 0;
        for (int i = 0; i < _rows.intValue; i++) {
            NSNumber *elem = [_board objectAtIndex:[self getIndexForRow:i AndCol:[_rows intValue] - i - 1]];
            count += (int) [elem intValue];
        }
        if (abs(count) == [_rows intValue]) {
            CGSize unit = [self getUnit];
            CGRect rect = CGRectMake(4, ([_rows intValue]/2 + 0.5)*unit.height + 4,
                                     320, THICKNESS);
            _winLine = [self drawWinLine:rect];
            _winLine.transform = CGAffineTransformRotate(_winLine.transform, 45);
            result = YES;
        }
    }
    if (result) {
        _victoryScreen.hidden = NO;
        [self bringSubviewToFront:_victoryScreen];
    }
    // check columns
    return result;
}

+(NSString*) getImageNameForMarker:(int) marker {
    if (marker == Cross) {
        return @"cross";
    } else {
        return @"dot";
    }
}

-(UIView*) drawWinLine: (CGRect) rect {
    UIView *winLine = [[UIView alloc] initWithFrame:rect];
    winLine.backgroundColor = [UIColor greenColor];
    [self addSubview:winLine];
    return winLine;
}

-(void) reset {
    for (int i = 0; i < _rows.intValue; i++) {
        for (int j = 0; j < _cols.intValue; j++) {
            UIImageView *view = [_images objectAtIndex:[self getIndexForRow:i AndCol:j]];
            if ((id)view != (id)[NSNull null] && view != nil) {
                if ([view superview]) {
                    [view removeFromSuperview];
                }
            }
        }
    }
    if (_winLine != nil) {
        if ([_winLine superview]) {
            [_winLine removeFromSuperview];
        }
    }
    
}

+ (void) setImageForView: (UIImageView*) view ForUserId:(NSString*) userId WithMarker:(NSString*) marker {
    [FetchFacebookImage downLoadImageForView:view
                                      FromId:[[FBSDKAccessToken currentAccessToken] userID]
                                 PlaceHolder:marker];
}

+ (NSString*) getImageForPlayer:(NSString*) identity {
    return [[NSBundle mainBundle] pathForResource:identity ofType:@"jpg"];
}
//+ (NSArray*) convertFromBoardToNetwork:(NSArray *)data {
//    
//}
//
//+ (NSArray*) convertFromNetworkToBoard:(NSArray *)data {
//    
//}


@end