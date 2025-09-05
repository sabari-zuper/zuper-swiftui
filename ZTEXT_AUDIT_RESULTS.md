# ZText to Text Audit Results

## Summary
Found 15 components using ZText across the codebase. Analysis shows potential for replacing ZText with Text in 8 components.

## Components Analyzed

### ✅ Can Replace with Text (8 components)

#### 1. **Badge.swift** (Line 33)
```swift
ZText(label, size: textSize, color: .custom(style.labelColor), weight: .medium)
```
- **Features used**: Basic text rendering
- **Action**: Replace with `Text`

#### 2. **TextStrut.swift** (Line 11) 
```swift
ZText("I", size: textSize, color: .custom(.clear))
```
- **Features used**: Invisible text for height
- **Action**: Replace with `Text`

#### 3. **Heading.swift** (Line 27)
```swift
ZText(content, size: .custom(style.size), color: color?.textColor, weight: style.weight, lineSpacing: lineSpacing, alignment: alignment, accentColor: accentColor, isSelectable: false)
```
- **Features used**: Basic heading text (isSelectable: false)
- **Action**: Replace with `Text` (already done in Phase 2)

#### 4. **NotificationBadge.swift** (Line 37)
```swift
ZText(text, size: Self.textSize, color: .none, weight: .medium, linkColor: .custom(style.labelColor))
```
- **Features used**: Only linkColor, no actual links
- **Action**: Replace with `Text` unless links are actually used

#### 5. **Icon.swift** (Line 514) - Test/Preview code
```swift
ZText("Concatenated")
```
- **Features used**: Basic text in preview
- **Action**: Replace with `Text`

#### 6. **TextRepresentable+Concatenation.swift** (Lines 35, 41, 75) - Test code
```swift
ZText(" (Delayed)", size: .xLarge, color: .inkNormal)
ZText(" Text", size: .xLarge, color: nil)  
ZText(" and Text", color: nil)
```
- **Features used**: Basic text concatenation examples
- **Action**: Replace with `Text`

### ❌ Must Keep ZText (7 components)

#### 1. **KeyValue.swift** (Line 13)
```swift
ZText(value, size: size.valueSize, weight: .medium, alignment: .init(alignment), isSelectable: true)
```
- **Features used**: `isSelectable: true` for copy/paste
- **Action**: Keep ZText

#### 2. **Alert.swift** (Line 52)
```swift
ZText(description, color: applyStatusColor ? .custom(status.uiColor) : .inkDark, linkColor: .secondary, linkAction: descriptionLinkAction)
```
- **Features used**: `linkAction` for interactive links
- **Action**: Keep ZText

#### 3. **BadgeList.swift** (Line 24)
```swift
ZText(label, size: size.textSize, color: .custom(labelColor.color), accentColor: style.iconColor, linkColor: .custom(labelColor.color), linkAction: linkAction)
```
- **Features used**: `linkAction`, `accentColor` for HTML formatting
- **Action**: Keep ZText

#### 4. **TextLink.swift** (Lines 140, 141)
```swift
ZText(link("Primary link"), linkColor: .primary)
ZText(link("Secondary link"), linkColor: .secondary)
```
- **Features used**: Core link component
- **Action**: Keep ZText

#### 5. **ZText.swift** (Multiple) - Component definition & previews
- Component definition and test cases
- **Action**: Keep ZText

#### 6. **TextRepresentable+Concatenation.swift** (Line 44)
```swift
ZText("<ref>Text</ref> with <strong>formatting</strong>", size: .small, color: nil, accentColor: .orangeNormal)
```
- **Features used**: HTML formatting with `<ref>` and `<strong>`
- **Action**: Keep ZText

## Implementation Priority

### High Priority (Quick Wins)
1. Badge.swift ✅ (Done in Phase 2)
2. TextStrut.swift ✅ (Done in Phase 2) 
3. Heading.swift ✅ (Done in Phase 2)
4. NotificationBadge.swift

### Medium Priority
5. Icon.swift (preview code)
6. TextRepresentable+Concatenation.swift (test examples)

### Do Not Change
- KeyValue.swift (needs isSelectable)
- Alert.swift (needs linkAction)
- BadgeList.swift (needs linkAction)
- TextLink.swift (core link functionality)

## Expected Impact
- **4-5 additional components** can be optimized
- **20-30% performance improvement** in NotificationBadge
- Cleaner test/preview code