//
//  ListsTableViewController.h
//  CyberImaging
//
//  Created by Troy Potts on 10/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListsTableViewController : UITableViewController
{
    NSMutableArray *_sectionTitles;
	NSMutableArray *_sectionSelections;
	NSMutableArray *_sectionOptions;
	
	NSMutableArray *_choices;
	NSMutableArray *_choiceDetails;
	NSMutableArray *_choiceDetailColors;
	NSMutableArray *_choiceValues;
}

@property (retain) UIFont *font;

@property (assign) BOOL showHeaders;
@property (assign) BOOL simpleHeaders;
@property (assign) BOOL usesChangeButton;

@property (retain) NSString* changeText;

- (NSInteger)addSection:(NSString*)section options:(NSInteger)options;
- (NSInteger) addOrFindSection:(NSString*)section options:(NSInteger)options;

- (void) removeSection:(NSInteger)sectionIndex;

- (NSInteger)addOptionForSection:(NSInteger)sectionIndex option:(NSString*)option optionValue:(NSString*)optionValue;
- (NSInteger)addOptionForSection:(NSInteger)sectionIndex option:(NSString*)option optionValue:(NSString*)optionValue optionDetail:(NSString*)optionDetail detailColor:(UIColor*)detailColor;

- (void) setOption:(NSString*)value section:(NSInteger)sectionIndex index:(NSInteger)optionIndex;
- (void) setOptionValue:(NSString*)value section:(NSInteger)sectionIndex index:(NSInteger)optionIndex;

- (void) clearSection:(NSInteger)sectionIndex;

- (NSString*) getSectionName:(NSInteger)sectionIndex;
- (NSString*) getOptionForSection:(NSInteger)sectionIndex optionIndex:(NSInteger)optionIndex;
- (NSString*) getOptionValueForSection:(NSInteger)sectionIndex optionIndex:(NSInteger)optionIndex;

- (NSInteger) getSelectionIndexForSection:(NSInteger)sectionIndex;

- (int) getOptionIndexByValue:(NSString*)optionValue inSection:(int)sectionIndex;
- (id) getSelectedForSection:(NSInteger)sectionIndex;

- (void) setSelectedForSection:(int)sectionIndex row:(int)row;
- (void) setSelectedForSection:(int)sectionIndex row:(int)row override:(BOOL)override;
- (void) setSelectedForSection:(int)sectionIndex optionValue:(NSString*)optionValue;
- (void) clearSelectedForSection:(NSInteger)sectionIndex;

- (NSInteger) getSectionIndexByName:(NSString*)sectionName;

- (NSInteger) addOrFindSection:(NSString*)section options:(NSInteger)options;

@end

@interface RadioButtonTableCell : UITableViewCell
{
	
}

@end