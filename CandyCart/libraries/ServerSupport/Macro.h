// make sure non-Clang compilers can still compile
#ifndef __has_feature
#define __has_feature(x) 0
#endif

// no ARC ? -> declare the ARC attributes we use to be a no-op, so the compiler won't whine
#if ! __has_feature( objc_arc )
#define __autoreleasing
#define __bridge
#define IF_ARC(with, without) without
#else
#define IF_ARC(with, without) with
#endif

#undef	AS_STATIC_PROPERTY_INT
#define AS_STATIC_PROPERTY_INT( __name ) \
    @property (nonatomic, readonly) NSInteger __name; \
    + (NSInteger)__name;

#undef	DEF_STATIC_PROPERTY_INT
#define DEF_STATIC_PROPERTY_INT( __name, __value ) \
    @dynamic __name; \
    + (NSInteger)__name \
    { \
        return __value; \
    }

#undef	AS_INT
#define AS_INT	AS_STATIC_PROPERTY_INT

#undef	DEF_INT
#define DEF_INT	DEF_STATIC_PROPERTY_INT


#define $new(Klass) IF_ARC([[Klass alloc] init], [[[Klass alloc] init] autorelease])
#define $array(...) ([NSArray arrayWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)])

// this is key/object order, not object/key order
#define $dict(...) DictionaryWithKeysAndObjects(IDARRAY(__VA_ARGS__), IDCOUNT(__VA_ARGS__) / 2)
#define $safe(obj)  ((NSNull *)(obj) == [NSNull null] ? nil : (obj))

#define $bool(val)      [NSNumber numberWithBool:(val)]
#define $char(val)      [NSNumber numberWithChar:(val)]
#define $double(val)    [NSNumber numberWithDouble:(val)]
#define $float(val)     [NSNumber numberWithFloat:(val)]
#define $int(val)       [NSNumber numberWithInt:(val)]
#define $integer(val)   [NSNumber numberWithInteger:(val)]
#define $long(val)      [NSNumber numberWithLong:(val)]
#define $longlong(val)  [NSNumber numberWithLongLong:(val)]
#define $short(val)     [NSNumber numberWithShort:(val)]
#define $uchar(val)     [NSNumber numberWithUnsignedChar:(val)]
#define $uint(val)      [NSNumber numberWithUnsignedInt:(val)]
#define $uinteger(val)  [NSNumber numberWithUnsignedInteger:(val)]
#define $ulong(val)     [NSNumber numberWithUnsignedLong:(val)]
#define $ulonglong(val) [NSNumber numberWithUnsignedLongLong:(val)]
#define $ushort(val)    [NSNumber numberWithUnsignedShort:(val)]


#define IDARRAY(...) ((__autoreleasing id[]){ __VA_ARGS__ })
#define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))
static inline NSDictionary *DictionaryWithKeysAndObjects(id *keysAndObjs, NSUInteger count)
{
    id keys[count];
    id objs[count];
    for(NSUInteger i = 0; i < count; i++)
    {
        keys[i] = keysAndObjs[i * 2];
        objs[i] = keysAndObjs[i * 2 + 1];
    }
    
    return [NSDictionary dictionaryWithObjects: objs forKeys: keys count: count];
}

#define iOS_Version [[[UIDevice currentDevice] systemVersion] floatValue]


#ifdef UI_USER_INTERFACE_IDIOM
#define isIPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#else
#define isIPAD() (false)
#endif

#if DEBUG
#define kDebugMode 1
#endif

#if kDebugMode

#ifndef LOGAPP
#define LOGAPP(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

#else

#ifndef LOGAPP
#define LOGAPP(fmt, ...)
#endif

#endif
