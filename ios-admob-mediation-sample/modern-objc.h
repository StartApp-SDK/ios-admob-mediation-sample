/**
 * Copyright 2021 Start.io Inc
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef MODERN_OBJC_H
#define MODERN_OBJC_H

@import Foundation;

#pragma mark [ Type Inferring ]
#define let __auto_type const
#define var __auto_type

#pragma mark [ Foreach Support ]
@interface NSArray<__covariant ObjectType> (ForeachSupport)
@property (nonatomic, readonly) ObjectType _enumeratedType;
@end

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (ForeachSupport)
@property (nonatomic, readonly) KeyType _enumeratedType;
@end

#define foreach(object_, collection_) \
    for (typeof((collection_)._enumeratedType) object_ in (collection_))

#pragma mark [ Typed Copying ]
@interface NSArray<__covariant ObjectType> (TypedCopying)
- (NSArray<ObjectType>*)copy;
- (NSMutableArray<ObjectType>*)mutableCopy;
@end

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (TypedCopying)
- (NSDictionary<KeyType, ObjectType>*)copy;
- (NSMutableDictionary<KeyType, ObjectType>*)mutableCopy;
@end

#endif /* MODERN_OBJC_H */
