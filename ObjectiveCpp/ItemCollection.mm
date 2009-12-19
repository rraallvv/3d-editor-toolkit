//
//  ItemCollection.mm
//  OpenGLWidgets
//
//  Created by Filip Kunc on 6/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <GLUT/glut.h>
#import "ItemCollection.h"

@implementation ItemCollection

- (id)init
{
	self = [super init];
	if (self)
	{
		items = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self)
	{
		items = [[aDecoder decodeObjectForKey:@"items"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:items forKey:@"items"];
}

- (void)dealloc
{
	[items release];
	[super dealloc];
}

- (Item *)itemAtIndex:(uint)index
{
	return (Item *)[items objectAtIndex:index];
}

- (void)addItem:(Item *)item
{
	[items addObject:item];
}

- (void)removeItem:(Item *)item
{
	[items removeObject:item];
}

- (uint)count
{
	return [items count];
}

- (Vector3D)positionAtIndex:(uint)index
{
	return [[self itemAtIndex:index] position];
}

- (Quaternion)rotationAtIndex:(uint)index
{
	return [[self itemAtIndex:index] rotation];
}

- (Vector3D)scaleAtIndex:(uint)index
{
	return [[self itemAtIndex:index] scale];
}

- (void)setPosition:(Vector3D)position atIndex:(uint)index
{
	[[self itemAtIndex:index] setPosition:position];
}

- (void)setRotation:(Quaternion)rotation atIndex:(uint)index
{
	[[self itemAtIndex:index] setRotation:rotation];
}

- (void)setScale:(Vector3D)scale atIndex:(uint)index
{
	[[self itemAtIndex:index] setScale:scale];
}

- (void)moveByOffset:(Vector3D)offset atIndex:(uint)index
{
	[[self itemAtIndex:index] moveByOffset:offset];
}

- (void)rotateByOffset:(Quaternion)offset atIndex:(uint)index
{
	[[self itemAtIndex:index] rotateByOffset:offset];
}

- (void)scaleByOffset:(Vector3D)offset atIndex:(uint)index
{
	[[self itemAtIndex:index] scaleByOffset:offset];
}

- (BOOL)isSelectedAtIndex:(uint)index
{
	return [[self itemAtIndex:index] selected];
}

- (void)setSelected:(BOOL)selected atIndex:(uint)index
{
	[[self itemAtIndex:index] setSelected:selected];
}

- (void)drawAtIndex:(uint)index forSelection:(BOOL)forSelection withMode:(enum ViewMode)mode
{
	[[self itemAtIndex:index] drawWithMode:mode];
}

- (void)cloneSelected
{
	int count = [self count];
	for (int i = 0; i < count; i++)
	{
		if ([self isSelectedAtIndex:i])
		{
			Item *newItem = [[self itemAtIndex:i] clone];
			[items addObject:newItem];
		}
	}
}

- (void)removeSelected
{
	for (int i = 0; i < [self count]; i++)
	{
		if ([self isSelectedAtIndex:i])
		{
			[items removeObjectAtIndex:i];
			i--;
		}
	}
}

- (void)mergeSelectedItems
{
	Vector3D center = Vector3D();
	int selectedCount = 0;
	
	for (int i = 0; i < [items count]; i++)
	{
		if ([self isSelectedAtIndex:i])
		{
			selectedCount++;
			center += [[self itemAtIndex:i] position];
		}
	}
	
	if (selectedCount < 2)
		return;
	
	center /= selectedCount;
	
	Item *newItem = [[Item alloc] initWithPosition:center rotation:Quaternion() scale:Vector3D(1, 1, 1)];
	Mesh *mesh = [newItem mesh];
	
	Matrix4x4 firstMatrix, itemMatrix;
	
	firstMatrix.TranslateRotateScale([newItem position],
									 [newItem rotation],
									 [newItem scale]);
	
	firstMatrix = firstMatrix.Inverse();
	
	for (int i = 0; i < [items count]; i++)
	{
		if ([self isSelectedAtIndex:i])
		{
			Item *item = [self itemAtIndex:i];
			Vector3D scale = [item scale];
			
			itemMatrix.TranslateRotateScale([item position],
											[item rotation],
											scale);
			
			Matrix4x4 finalMatrix = firstMatrix * itemMatrix;
			Mesh *itemMesh = [item mesh];
			
			[itemMesh transformWithMatrix:finalMatrix];
			
			// mirror detection, some component of scale is negative
			if (scale.x < 0.0f || scale.y < 0.0f || scale.z < 0.0f)
				[itemMesh flipAllTriangles];
				
			[mesh mergeWithMesh:itemMesh];
			[items removeObjectAtIndex:i];
			i--;
		}
	}
	
	[newItem setSelected:YES];
	[self addItem:newItem];
}

@end