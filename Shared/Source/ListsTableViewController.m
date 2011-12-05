//
//  ListsTableViewController.m
//  CyberImaging
//
//  Created by Troy Potts on 10/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ListsTableViewController.h"

enum {
    WSRadioListSection,
    WSCheckboxListSection
};

typedef enum {
	LTVCRecommendation = 1,
	LTVCCollapse = 1 << 1,
	LTVCMultipleSelection = 1 << 2
} LTVCOptions;

@implementation ListsTableViewController

@synthesize font;
@synthesize showHeaders;
@synthesize simpleHeaders;
@synthesize usesChangeButton;
@synthesize changeText;

- (id)init
{
	if (self = [super init])
	{
		self.showHeaders = YES;
		self.simpleHeaders = NO;
		self.usesChangeButton = NO;
		self.changeText = @"(touch to change)";		
	}
	return self;
}

- (void)awakeFromNib {
    self = [super initWithStyle:UITableViewStyleGrouped];
	
	self.tableView.bounces = NO;
    //if (!self) return nil;
	
	_sectionTitles = [[NSMutableArray alloc] initWithObjects:nil];
	_sectionSelections = [[NSMutableArray alloc] initWithObjects:nil];
	_sectionOptions = [[NSMutableArray alloc] initWithObjects:nil];
	
	_choices = [[NSMutableArray alloc] initWithObjects:nil];
	_choiceDetails = [[NSMutableArray alloc] initWithObjects:nil];
	_choiceValues = [[NSMutableArray alloc] initWithObjects:nil];
	_choiceDetailColors = [[NSMutableArray alloc] initWithObjects:nil];
	
	
	self.tableView.autoresizesSubviews = YES;
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
}

- (NSInteger)addSection:(NSString*)section options:(NSInteger)options
{
	NSInteger newIndex = [_sectionTitles count];
	
	[_sectionTitles addObject:section];
	[_sectionOptions addObject:[NSNumber numberWithInteger:options]];
	
	if ((options & LTVCMultipleSelection))
		[_sectionSelections addObject:[NSNumber numberWithInt:0]];
	else
		[_sectionSelections addObject:[NSNumber numberWithInt:-1]];
	
	[_choices addObject:[[NSMutableArray alloc] initWithObjects:nil]];
	[_choiceValues addObject:[[NSMutableArray alloc] initWithObjects:nil]];
	[_choiceDetails addObject:[[NSMutableArray alloc] initWithObjects:nil]];
	[_choiceDetailColors addObject:[[NSMutableArray alloc] initWithObjects:nil]];
	
	return newIndex;
}

- (NSInteger) addOrFindSection:(NSString*)section options:(NSInteger)options
{
	NSInteger sectionIndex = [self getSectionIndexByName:section];
	
	if (sectionIndex == NSNotFound)
		sectionIndex = [self addSection:section options:options];
	
	return sectionIndex;
}

- (void) removeSection:(NSInteger)sectionIndex
{
	if (sectionIndex < [_sectionTitles count])
	{
		[_sectionTitles removeObjectAtIndex:sectionIndex];
		[_sectionOptions removeObjectAtIndex:sectionIndex];
		[_sectionSelections removeObjectAtIndex:sectionIndex];
		
		[_choices removeObjectAtIndex:sectionIndex];
		[_choiceValues removeObjectAtIndex:sectionIndex];
		[_choiceDetails removeObjectAtIndex:sectionIndex];
		[_choiceDetailColors removeObjectAtIndex:sectionIndex];
	}
}

- (NSInteger)addOptionForSection:(NSInteger)sectionIndex option:(NSString*)option optionValue:(NSString*)optionValue
{
	return [self addOptionForSection:sectionIndex option:option optionValue:optionValue optionDetail:@"" detailColor:[UIColor blackColor]];
}

- (NSInteger)addOptionForSection:(NSInteger)sectionIndex option:(NSString*)option optionValue:(NSString*)optionValue optionDetail:(NSString*)optionDetail detailColor:(UIColor *)detailColor
{
	NSMutableArray* optionArray = [_choices objectAtIndex:sectionIndex];
	NSMutableArray* optionValueArray = [_choiceValues objectAtIndex:sectionIndex];
	NSMutableArray* optionDetailArray = [_choiceDetails objectAtIndex:sectionIndex];
	NSMutableArray* optionDetailColorArray = [_choiceDetailColors objectAtIndex:sectionIndex];
	
	NSInteger newIndex = [optionArray count];
	
	[optionArray addObject:option];
	[optionValueArray addObject:optionValue];
	[optionDetailArray addObject:optionDetail];
	[optionDetailColorArray addObject:detailColor];
	
	return newIndex;
}

- (void) clearSection:(NSInteger)sectionIndex
{
	[[_choices objectAtIndex:sectionIndex] removeAllObjects];
	[[_choiceValues objectAtIndex:sectionIndex] removeAllObjects];
	[[_choiceDetails objectAtIndex:sectionIndex] removeAllObjects];
	[[_choiceDetailColors objectAtIndex:sectionIndex] removeAllObjects];
	
	[self clearSelectedForSection:sectionIndex];
}

- (NSString*) getSectionName:(NSInteger)sectionIndex
{
	return [_sectionTitles objectAtIndex:sectionIndex];
}

- (NSString*) getOptionForSection:(NSInteger)sectionIndex optionIndex:(NSInteger)optionIndex
{
	return [[_choices objectAtIndex:sectionIndex] objectAtIndex:optionIndex];
}

- (NSString*) getOptionValueForSection:(NSInteger)sectionIndex optionIndex:(NSInteger)optionIndex
{
	return [[_choiceValues objectAtIndex:sectionIndex] objectAtIndex:optionIndex];
}

- (void) setOption:(NSString*)value section:(NSInteger)sectionIndex index:(NSInteger)optionIndex
{
	[[_choices objectAtIndex:sectionIndex] replaceObjectAtIndex:optionIndex withObject:value];
}

- (void) setOptionValue:(NSString*)value section:(NSInteger)sectionIndex index:(NSInteger)optionIndex
{
	[[_choiceValues objectAtIndex:sectionIndex] replaceObjectAtIndex:optionIndex withObject:value];
}

- (NSInteger) getSelectionIndexForSection:(NSInteger)sectionIndex
{
	NSInteger selectedIdx = [[_sectionSelections objectAtIndex:sectionIndex] integerValue];
	return selectedIdx;
}
- (id) getSelectedForSection:(NSInteger)sectionIndex
{
	int selectedIdx = [[_sectionSelections objectAtIndex:sectionIndex] intValue];
	NSMutableArray* sectionValues = [_choiceValues objectAtIndex:sectionIndex];
	if (selectedIdx >= 0)
	{
		int options = [[_sectionOptions objectAtIndex:sectionIndex] intValue];
		
		if (options & LTVCMultipleSelection)
		{
			NSMutableArray* sel = [[NSMutableArray alloc] init];
			
			for (int i=0; i < [sectionValues count]; i++)
				if (selectedIdx & (1 << i))
					[sel addObject:[sectionValues objectAtIndex:i]];
			
			NSLog(@"Multi-select %@", sel);
			return sel;
		}
		else if (selectedIdx < [sectionValues count])
		{
			
			return [sectionValues objectAtIndex:selectedIdx];
		}
	}
	
	return nil;
}

- (void) clearSelectedForSection:(NSInteger)sectionIndex
{
	int options = [[_sectionOptions objectAtIndex:sectionIndex] intValue];
	
	if (options & LTVCMultipleSelection)
		[_sectionSelections replaceObjectAtIndex:sectionIndex withObject:[NSNumber numberWithInt:0]];
	else
		[_sectionSelections replaceObjectAtIndex:sectionIndex withObject:[NSNumber numberWithInt:-1]];
}

- (NSInteger) getSectionIndexByName:(NSString*)sectionName
{
	return [_sectionTitles indexOfObject:sectionName];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [_sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	int options = [[_sectionOptions objectAtIndex:section] intValue];
	int selectedIdx = [[_sectionSelections objectAtIndex:section] intValue];
	if ((options & LTVCCollapse) && !(options & LTVCMultipleSelection) && selectedIdx != -1)
		return 1;
	else
		return [[_choices objectAtIndex:section] count];

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_sectionTitles objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger sectionIndex = indexPath.section;
	NSInteger row = indexPath.row;
	
	[self setSelectedForSection:sectionIndex row:row override:NO];
}

- (int) getOptionIndexByValue:(NSString*)optionValue inSection:(int)sectionIndex
{
	NSMutableArray *sectionChoiceValues = [_choiceValues objectAtIndex:sectionIndex];
	NSLog(@"sectionChoiceValues: %@", sectionChoiceValues);
	if ([sectionChoiceValues containsObject:optionValue])
		return [sectionChoiceValues indexOfObject:optionValue];

	return -1;
}
- (void) setSelectedForSection:(int)sectionIndex optionValue:(NSString*)optionValue
{
	int optionIdx = [self getOptionIndexByValue:optionValue inSection:sectionIndex];
	NSLog(@"optionIdx: %d", optionIdx);
	if (optionIdx >= 0)
	{
		[self setSelectedForSection:sectionIndex row:optionIdx override:YES];
	}
}

- (void) setSelectedForSection:(int)sectionIndex row:(int)row
{
	[self setSelectedForSection:sectionIndex row:row override:NO];
}
- (void) setSelectedForSection:(int)sectionIndex row:(int)row override:(BOOL)override
{
	//BOOL sectionIsCheckBox = [[_sectionTypes objectAtIndex:sectionIndex] boolValue];
	
	NSInteger options = [[_sectionOptions objectAtIndex:sectionIndex] intValue];
	BOOL sectionIsCheckBox = (options & LTVCMultipleSelection);
	
	int selectedIdx = [[_sectionSelections objectAtIndex:sectionIndex] intValue];
	
	if (!override && (options & LTVCCollapse) && !(options & LTVCMultipleSelection) && selectedIdx != -1)
	{
		[self clearSelectedForSection:sectionIndex];
		
		NSDictionary* d = [[NSDictionary alloc] initWithObjectsAndKeys:
						   [NSNumber numberWithInteger:sectionIndex], @"sectionIndex",
						   nil];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ListsTableViewSelectionDidClearNotification" object:self userInfo:d];
		
		[self.tableView reloadData];
	}
	else
	{
		if (sectionIsCheckBox)
		{
			NSNumber* nsnum = [_sectionSelections objectAtIndex:sectionIndex];
			int num = [nsnum intValue];
			num |= (1 << row);
			nsnum = [NSNumber numberWithInt:num];
			
			[_sectionSelections replaceObjectAtIndex:sectionIndex withObject:nsnum];
		}
		else
		{
			NSNumber* nsnum = [NSNumber numberWithInt:row];
			[_sectionSelections replaceObjectAtIndex:sectionIndex withObject:nsnum];		
		}
		/*switch (indexPath.section) {
			case WSRadioListSection: {
				_radioSelection = indexPath.row;
				break;
			}
				// ========== updated part ==========
			case WSCheckboxListSection: {
				// toggle the indexPath.row'th bit in accumulative integer
				_checkboxSelections ^= (1 << indexPath.row);
				break;
			}
				// ==================================
		}*/

		NSDictionary* d = [[NSDictionary alloc] initWithObjectsAndKeys:
						   [NSNumber numberWithInteger:sectionIndex], @"sectionIndex", 
						   [NSNumber numberWithInteger:row], @"row",
						   nil];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ListsTableViewSelectionDidChangeNotification" object:self userInfo:d];
		
		[self.tableView reloadData];
	}
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
	if (self.showHeaders)
	{
		if (self.simpleHeaders)
		{
			UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
			l.text = [NSString stringWithFormat:@"  %@:", [_sectionTitles objectAtIndex:section]];
			l.font = self.font;
			[l sizeToFit];
			l.backgroundColor = [UIColor lightGrayColor];
			
			UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
			v.backgroundColor = [UIColor redColor];
			return l;
		}
		else
			return [super tableView:tableView viewForHeaderInSection:section];
	}
	return [[UIView alloc] init];
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	//if (self.showHeaders)
		return [super tableView:tableView heightForHeaderInSection:section];
	//return 50;
}*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
	
	NSInteger sectionIndex = indexPath.section;
	NSInteger rowNumber = indexPath.row;
	
	int options = [[_sectionOptions objectAtIndex:sectionIndex] intValue];
	int selectedIdx = [[_sectionSelections objectAtIndex:sectionIndex] intValue];
	
	BOOL collapsedAndSet = (options & LTVCCollapse) && !(options & LTVCMultipleSelection) && selectedIdx != -1;
	
	if (collapsedAndSet)
	{
		rowNumber = selectedIdx;
		cellStyle = UITableViewCellStyleValue1;
	}
	else if (options & LTVCRecommendation)
		cellStyle = UITableViewCellStyleValue1;
	
    UITableViewCell *cell = nil;
	//UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[RadioButtonTableCell alloc] initWithStyle:cellStyle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSString* detail = [[_choiceDetails objectAtIndex:sectionIndex] objectAtIndex:rowNumber];
	UIColor* detailColor = [[_choiceDetailColors objectAtIndex:sectionIndex] objectAtIndex:rowNumber];
	
	if (collapsedAndSet)
	{
		detail = self.changeText;
		detailColor = [UIColor lightGrayColor];
	}
	
	if (detail)
	{
		cell.detailTextLabel.text = detail;
		if (self.font)
			cell.detailTextLabel.font = self.font;
		cell.detailTextLabel.textColor = detailColor;
	}
		
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSInteger IMAGE_SIZE;
	NSInteger SIDE_PADDING;
	
	UIImage* btnImage;
	UIImageView* indicator;

	BOOL sectionIsCheckBox = (options & LTVCMultipleSelection);
	
	cell.textLabel.text = [[_choices objectAtIndex:sectionIndex] objectAtIndex:rowNumber];
	if (self.font)
		cell.textLabel.font = self.font;
	
	NSNumber* nsnum = [_sectionSelections objectAtIndex:sectionIndex];
	int num = [nsnum intValue];
	
	if (sectionIsCheckBox)
	{

		
            // get the indexPath.row'th bit from accumulative integer
            int flag = (1 << rowNumber);
            // update row's accessory if it's "turned on"
            if (num & flag)
				[cell setSelected:YES];
			
			if (cell.isSelected)
			{
				btnImage = [UIImage imageNamed:@"checkbox-checked.png"];
			}
			else
			{
				btnImage = [UIImage imageNamed:@"checkbox.png"];
			}
			
			IMAGE_SIZE = 16;
			SIDE_PADDING = 5;

    }
	else
	{
		
		if (rowNumber == num)
			[cell setSelected:YES];
		
		if (cell.isSelected)
		{
			btnImage = [UIImage imageNamed:@"radiobutton.png"];
		}
		else
		{
			btnImage = [UIImage imageNamed:@"radio_button_on.png"];
		}
		
		IMAGE_SIZE = 21;
		SIDE_PADDING = 5;
	}
	
	indicator = [[[UIImageView alloc] initWithImage:btnImage] autorelease];
	
	//indicator.tag =;
	indicator.frame =
	CGRectMake(-5 - IMAGE_SIZE + SIDE_PADDING, (0.5 * tableView.rowHeight) - (0.5 * IMAGE_SIZE), IMAGE_SIZE, IMAGE_SIZE);
	[cell.contentView addSubview:indicator];
	
	//CGRect contentFrame = cell.contentView.frame;
	//contentFrame.origin.x = 45;
	//contentFrame.size.width += 45;
	//cell.contentView.frame = contentFrame;
    return cell;
}

- (void)dealloc {
    [_sectionTitles release];
    //[_radioListOptions release];
    //[_checkboxListOptions release];
    [super dealloc];
}

@end

@implementation RadioButtonTableCell 

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    //[UIView beginAnimations:nil context:nil];
    //[UIView setAnimationBeginsFromCurrentState:YES];
	
    [super layoutSubviews];
	
    if (((UITableView *)self.superview).isEditing)
    {
        CGRect contentFrame = self.contentView.frame;
        contentFrame.origin.x = 0; //EDITING_HORIZONTAL_OFFSET;
        self.contentView.frame = contentFrame;
    }
    else
    {
        CGRect contentFrame = self.contentView.frame;
        contentFrame.origin.x = 35;
        self.contentView.frame = contentFrame;
    }
	
	CGRect detailFrame = self.detailTextLabel.frame;
	detailFrame.origin.x -= 35;
	self.detailTextLabel.frame = detailFrame;
	
    //[UIView commitAnimations];
}

@end
