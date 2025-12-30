# Align ZText and Text Components with Apple Human Interface Guidelines

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.

This document must be maintained in accordance with `.ai/plans/plans.md`.

## Purpose / Big Picture

After this change, the Zuper SwiftUI design system will use Apple's semantic text styles (body, headline, title, caption, etc.) with correct point sizes that match iOS Human Interface Guidelines. Users of this library will be able to create text that scales correctly with Dynamic Type and follows Apple's typography best practices. The change can be verified by building the project successfully, running the Storybook app, and observing that text components use HIG-compliant sizes (e.g., body text at 17pt instead of 14pt).

## Progress

- [ ] Milestone 1: Update TextSize enum in Text.swift with Apple HIG text styles
- [ ] Milestone 2: Update Heading.Style enum with Apple HIG title styles
- [ ] Milestone 3: Update UIFont.Size enum for consistency
- [ ] Milestone 4: Update component files using TextSize (20+ files in zuper-swiftui)
- [ ] Milestone 5: Update support component files (15 files in zuper-swiftui)
- [ ] Milestone 6: Update Storybook files (20+ files in zuper-swiftui)
- [ ] Milestone 7: Build verification for zuper-swiftui
- [ ] Milestone 8: Migrate Zuper-iOS codebase (616 files, 2,164+ TextSize usages)
- [ ] Milestone 9: Full integration testing on Zuper-iOS

## Surprises & Discoveries

(To be updated during implementation)

## Decision Log

- Decision: Use breaking change approach instead of additive
  Rationale: User chose this approach for cleaner API. Deprecated aliases provide migration path.
  Date/Author: 2025-12-30 / Claude

- Decision: Implement full Apple HIG text style set (11 styles)
  Rationale: User confirmed preference for complete HIG alignment rather than minimal changes.
  Date/Author: 2025-12-30 / Claude

- Decision: Update Heading component to align with Apple title styles
  Rationale: User confirmed Heading should also be updated for consistency.
  Date/Author: 2025-12-30 / Claude

- Decision: Strict HIG alignment despite Zuper-iOS impact (2,164+ usages in 616 files)
  Rationale: User explicitly chose strict HIG alignment knowing it will change visual appearance across 616+ files immediately. This ensures the app matches iOS platform conventions.
  Date/Author: 2025-12-30 / Claude

- Decision: Map .normal (14pt) to .subheadline (15pt) instead of .footnote (13pt)
  Rationale: Analysis of Zuper-iOS cards (DetailKeyValueView, FinancingStatusCardView, JobCard, CustomerCard) shows .normal is used for body-like content in cards. Apple's .subheadline (15pt) is the closest HIG match with minimal visual change (+1pt). .footnote (13pt) would shrink text too much (-1pt) and is semantically for auxiliary info, not body text.
  Date/Author: 2025-12-30 / Claude

## Outcomes & Retrospective

(To be completed after implementation)

## Context and Orientation

The Zuper SwiftUI design system has a custom typography system that does not align with Apple's Human Interface Guidelines. The system consists of three main enums and several components.

**Current TextSize enum** at `Sources/Zuper/Components/Text.swift:95-151`:
The enum defines four main cases: `.small` (12pt), `.normal` (14pt), `.large` (16pt), `.xLarge` (18pt), plus `.custom(CGFloat)`. These map to incorrect Apple text styles (e.g., `.normal` maps to `.body` but uses 14pt instead of Apple's 17pt).

**Current Heading.Style enum** at `Sources/Zuper/Components/Heading.swift:100-256`:
Defines `.display` (40pt), `.displaySubtitle` (22pt), `.h1` through `.h6` (36pt down to 16pt), and `.title5`/`.title6`. These use HTML-style naming rather than Apple's semantic names.

**Current UIFont.Size enum** at `Sources/Zuper/Foundation/Typography/UIFont.swift:6-64`:
Similar structure with raw values for point sizes.

**Typography foundation** at `Sources/Zuper/Foundation/Typography/`:
Contains `Font.swift` (font registration), `ZuperFont.swift` (ViewModifier for Dynamic Type), and `UIFont.swift` (UIKit equivalent).

**Text components**:
- `Text.swift` - Lightweight text component, no HTML support
- `ZText.swift` - Full-featured text with HTML formatting support
- `Heading.swift` - Semantic heading component

**Impact**: 82+ files use TextSize, TextColor, or Text/ZText components in zuper-swiftui. Additionally, 616 files in Zuper-iOS use TextSize patterns with 2,164+ occurrences.

## Plan of Work

The work is organized into nine milestones. Each milestone produces a working state that can be verified.

### Milestone 1: Update TextSize Enum

In `Sources/Zuper/Components/Text.swift`, replace the TextSize enum (lines 95-151) with Apple HIG-aligned cases. The new enum will have these cases:

    case largeTitle    // 34pt - Navigation bars, main screen titles
    case title         // 28pt - Section headers
    case title2        // 22pt - Subheadings
    case title3        // 20pt - Tertiary headers
    case headline      // 17pt - Emphasized body (semibold default)
    case body          // 17pt - Primary content
    case callout       // 16pt - Secondary content
    case subheadline   // 15pt - Smaller body text
    case footnote      // 13pt - Auxiliary information
    case caption       // 12pt - Supplementary content
    case caption2      // 11pt - Smallest readable text
    case custom(CGFloat)

Add deprecated static aliases for backward compatibility.

**IMPORTANT: Mapping based on actual Zuper-iOS card usage analysis:**

The analysis of JobCard, CustomerCard, AssetCard, etc. shows that `.normal` (14pt) is used for body text in cards. To maintain semantic correctness while minimizing visual disruption:

    @available(*, deprecated, renamed: "caption")
    public static let small = TextSize.caption        // 12pt → 12pt (no change)

    @available(*, deprecated, renamed: "subheadline")
    public static let normal = TextSize.subheadline   // 14pt → 15pt (minimal change, body-like usage)

    @available(*, deprecated, renamed: "callout")
    public static let large = TextSize.callout        // 16pt → 16pt (no change)

    @available(*, deprecated, renamed: "title3")
    public static let xLarge = TextSize.title3        // 18pt → 20pt (slight increase)

    @available(*, deprecated, renamed: "callout")
    public static let body1 = TextSize.callout        // 16pt → 16pt (no change)

    @available(*, deprecated, renamed: "subheadline")
    public static let body2 = TextSize.subheadline    // 14pt → 15pt (minimal change)

    @available(*, deprecated, renamed: "caption")
    public static let body3 = TextSize.caption        // 12pt → 12pt (no change)

**Rationale:** Analysis of DetailKeyValueView, FinancingStatusCardView, and other cards shows `.normal` is used semantically as "regular body text" in cards. Apple's `.subheadline` (15pt) is the closest HIG match that:
1. Maintains similar visual weight (14pt → 15pt is +1pt)
2. Provides proper Apple text style for Dynamic Type
3. Works well as secondary content in card layouts

For PRIMARY body text (not card labels), developers should explicitly use `.body` (17pt).

Update the computed properties `value`, `textStyle`, `lineHeight`, and `iconSize` to return correct values for each new case.

At the end of this milestone, `swift build` succeeds and deprecated aliases generate compiler warnings.

### Milestone 2: Update Heading.Style Enum

In `Sources/Zuper/Components/Heading.swift`, replace the Style enum (lines 100-256) with Apple HIG-aligned cases:

    case largeTitle    // 34pt, bold
    case title         // 28pt, bold
    case title2        // 22pt, semibold
    case title3        // 20pt, semibold
    case headline      // 17pt, semibold

Add deprecated static aliases:

    @available(*, deprecated, renamed: "largeTitle")
    public static let display = Style.largeTitle

    @available(*, deprecated, renamed: "title2")
    public static let displaySubtitle = Style.title2

    @available(*, deprecated, renamed: "largeTitle")
    public static let h1 = Style.largeTitle

    @available(*, deprecated, renamed: "title")
    public static let h2 = Style.title

    @available(*, deprecated, renamed: "title2")
    public static let h3 = Style.title2

    @available(*, deprecated, renamed: "title3")
    public static let h4 = Style.title3

    @available(*, deprecated, renamed: "headline")
    public static let h5 = Style.headline

    @available(*, deprecated, renamed: "headline")
    public static let h6 = Style.headline

    @available(*, deprecated, renamed: "headline")
    public static let title5 = Style.headline

    @available(*, deprecated, renamed: "headline")
    public static let title6 = Style.headline

Update computed properties `size`, `textStyle`, `lineHeight`, `iconSize`, and `weight`.

At the end of this milestone, Heading uses Apple text styles and `swift build` succeeds.

### Milestone 3: Update UIFont.Size Enum

In `Sources/Zuper/Foundation/Typography/UIFont.swift`, update the Size enum to match the new TextSize cases:

    enum Size: Int, Comparable {
        case caption2 = 11
        case caption = 12
        case footnote = 13
        case subheadline = 15
        case callout = 16
        case body = 17
        case title3 = 20
        case title2 = 22
        case title = 28
        case largeTitle = 34
        case tabBar = 11
        case navigationBar = 17
    }

Add deprecated aliases matching TextSize deprecations.

At the end of this milestone, UIFont.Size aligns with TextSize.

### Milestone 4: Update Component Files

Update 20+ component files to use new TextSize cases. Key files include:

1. `Sources/Zuper/Components/Button.swift` - Update textSize property
2. `Sources/Zuper/Components/InputField.swift` - Update font size references
3. `Sources/Zuper/Components/Badge.swift` - Update default size
4. `Sources/Zuper/Components/Alert.swift` - Update text sizes
5. `Sources/Zuper/Components/Icon.swift` - Update size references
6. `Sources/Zuper/Components/KeyValue.swift` - Update size mapping
7. `Sources/Zuper/Components/Checkbox.swift` - Update label size
8. `Sources/Zuper/Components/Radio.swift` - Update label size
9. `Sources/Zuper/Components/Tag.swift` - Update text size
10. `Sources/Zuper/Components/TextLink.swift` - Update size references

For each file, replace deprecated case usages (`.small`, `.normal`, `.large`, `.xLarge`) with new HIG cases (`.caption`, `.subheadline`, `.callout`, `.title3`).

At the end of this milestone, all component files compile without deprecation warnings.

### Milestone 5: Update Support Component Files

Update 15 support component files:

1. `Sources/Zuper/Support/Components/Label.swift` - Update style references
2. `Sources/Zuper/Support/Forms/FieldLabel.swift` - Update text size
3. `Sources/Zuper/Support/Forms/FieldMessage.swift` - Update text size
4. `Sources/Zuper/Support/Layout/TextStrut.swift` - Update TextSize usage

At the end of this milestone, all support files compile without deprecation warnings.

### Milestone 6: Update Storybook Files

Update 20+ Storybook files in `Sources/ZuperStorybook/` to use new text style names in previews and demonstrations.

At the end of this milestone, Storybook demonstrates correct Apple HIG text styles.

### Milestone 7: Build Verification for zuper-swiftui

Run full build of the design system library and verify it compiles successfully.

At the end of this milestone, `swift build` succeeds in the zuper-swiftui project.

### Milestone 8: Migrate Zuper-iOS Codebase

The Zuper-iOS project at `/Users/sabari/Documents/Zuper Projects/Zuper-iOS` has significant usage:
- 1,689 Text component usages in 558 files
- 2,164+ TextSize pattern usages in 616 files
- 43 ZText usages in 35 files
- 14 Heading usages in 12 files

Migration approach for Zuper-iOS:

1. Update the zuper-swiftui package dependency to the new version
2. Build the project - compiler warnings will show all deprecated usages
3. Use Xcode's fix-it suggestions to migrate deprecated TextSize cases:
   - `.small` -> `.caption` (12pt) - no visual change
   - `.normal` -> `.subheadline` (15pt) - +1pt minimal change
   - `.large` -> `.callout` (16pt) - no visual change
   - `.xLarge` -> `.title3` (20pt) - +2pt
   - `.body1` -> `.callout` (16pt) - no visual change
   - `.body2` -> `.subheadline` (15pt) - +1pt minimal change
   - `.body3` -> `.caption` (12pt) - no visual change
4. For Heading usages, migrate:
   - `.h1` -> `.largeTitle`
   - `.h2` -> `.title`
   - `.h3` -> `.title2`
   - `.h4` -> `.title3`
   - `.h5`, `.h6` -> `.headline`
5. Review visual changes in key screens after migration

High-priority modules to migrate first (based on usage density):
- ZCheckList module - 14 Text occurrences
- ZComponents module - Card views and detail views
- ZAssets module - Detail and creation views
- ZNotes module - List and card views
- ZQuotes module - Detail and layout views
- ZJobs module - Service task views

At the end of this milestone, Zuper-iOS builds without deprecation warnings.

### Milestone 9: Full Integration Testing

Run full build and verify:
1. `swift build` succeeds with no errors
2. All deprecation warnings are resolved (except in test files if intentional)
3. Storybook app launches and displays correct text sizes
4. Dynamic Type scaling works correctly

## Concrete Steps

### Part A: zuper-swiftui Design System

All commands are run from: `/Users/sabari/Documents/Zuper Projects/zuper-swiftui`

**Build the design system:**

    swift build

Expected output: Build succeeds with deprecation warnings (initially) then no warnings after migration.

**Run tests (if available):**

    swift test

Expected output: All tests pass.

**Open Storybook in Xcode Simulator:**

    open Sources/ZuperStorybook/ZuperStorybookApp.swift

Then build and run in Xcode to visually verify text styles.

### Part B: Zuper-iOS Main App

All commands are run from: `/Users/sabari/Documents/Zuper Projects/Zuper-iOS`

**Update package dependency:**

Open Xcode and update the zuper-swiftui package to the new version, or update Package.swift manually.

**Build to see deprecation warnings:**

    xcodebuild -workspace ZuperiOS.xcworkspace -scheme ZuperiOS build 2>&1 | grep -i deprecated

Expected output: List of all deprecated TextSize usages across 616+ files.

**Migrate using Xcode fix-its:**

1. Open the project in Xcode
2. Build (Cmd+B) - yellow warnings appear for deprecated usages
3. Click each warning and apply the fix-it suggestion
4. For bulk migration, use Find & Replace (Cmd+Shift+F):
   - Replace `size: .small` with `size: .caption`
   - Replace `size: .normal` with `size: .subheadline`
   - Replace `size: .large` with `size: .callout`
   - Replace `size: .xLarge` with `size: .title3`

**Final build verification:**

    xcodebuild -workspace ZuperiOS.xcworkspace -scheme ZuperiOS build

Expected output: BUILD SUCCEEDED with no deprecation warnings.

## Validation and Acceptance

### zuper-swiftui Design System

1. Run `swift build` in zuper-swiftui - expect success with zero errors
2. Run `swift build 2>&1 | grep -i deprecated` - expect no deprecation warnings from Zuper source files
3. Launch Storybook app and navigate to Typography section - expect to see:
   - body text at 17pt (not 14pt as before)
   - headline text at 17pt semibold
   - caption text at 12pt
   - title styles matching Apple HIG sizes
4. Test Dynamic Type by changing iOS Settings > Accessibility > Display & Text Size > Larger Text - expect all text to scale appropriately
5. Each TextSize case returns the matching Font.TextStyle (e.g., `.body` returns `.body`, `.caption` returns `.caption`)

### Zuper-iOS Main App

1. Build Zuper-iOS project - expect success with zero errors
2. Run `xcodebuild ... 2>&1 | grep -i deprecated` - expect no deprecation warnings
3. Launch app in Simulator and verify key screens:
   - Job list views - text should appear slightly larger (body 17pt vs old 14pt)
   - Detail views - headings should use consistent HIG sizes
   - Forms and input fields - labels should be readable at new sizes
4. Compare before/after screenshots of:
   - ZCheckList screens (highest usage area)
   - ZComponents card views
   - ZAssets detail views
5. Verify accessibility scaling works correctly across the app

## Idempotence and Recovery

These changes are source code modifications that can be repeated safely. If a step fails:

1. Use `git diff` to see what changed
2. Use `git checkout -- <file>` to revert a specific file
3. Use `git stash` to save partial progress
4. The deprecated aliases ensure existing code continues to work during migration

To rollback entirely: `git checkout -- Sources/`

## Artifacts and Notes

**Migration Mapping Table (Updated based on Zuper-iOS card analysis):**

    Old Name    | Old Size | New HIG Name  | New Size | Visual Change
    ------------|----------|---------------|----------|---------------
    .small      | 12pt     | .caption      | 12pt     | None
    .normal     | 14pt     | .subheadline  | 15pt     | +1pt (minimal)
    .large      | 16pt     | .callout      | 16pt     | None
    .xLarge     | 18pt     | .title3       | 20pt     | +2pt
    .body1      | 16pt     | .callout      | 16pt     | None
    .body2      | 14pt     | .subheadline  | 15pt     | +1pt (minimal)
    .body3      | 12pt     | .caption      | 12pt     | None
    .display    | 40pt     | .largeTitle   | 34pt     | -6pt
    .h1         | 36pt     | .largeTitle   | 34pt     | -2pt
    .h2         | 28pt     | .title        | 28pt     | None
    .h3         | 24pt     | .title2       | 22pt     | -2pt
    .h4         | 20pt     | .title3       | 20pt     | None
    .h5         | 18pt     | .headline     | 17pt     | -1pt
    .h6         | 16pt     | .headline     | 17pt     | +1pt

**Note:** `.normal` → `.subheadline` (not `.footnote`) based on analysis of DetailKeyValueView, FinancingStatusCardView, and other Zuper-iOS card components where `.normal` is used for body-like content.

**Apple HIG Line Heights (approximately 1.2x font size):**

    largeTitle: 41pt, title: 34pt, title2: 28pt, title3: 25pt
    headline/body: 22pt, callout: 21pt, subheadline: 20pt
    footnote: 18pt, caption: 16pt, caption2: 13pt

## Interfaces and Dependencies

**TextSize enum** in `Sources/Zuper/Components/Text.swift`:

    public enum TextSize {
        case largeTitle, title, title2, title3
        case headline, body, callout, subheadline
        case footnote, caption, caption2
        case custom(CGFloat)

        public var value: CGFloat { ... }
        public var textStyle: Font.TextStyle { ... }
        public var lineHeight: CGFloat { ... }
        public var iconSize: CGFloat { ... }
        public var defaultWeight: Font.Weight { ... }
    }

**Heading.Style enum** in `Sources/Zuper/Components/Heading.swift`:

    public enum Style {
        case largeTitle, title, title2, title3, headline

        public var size: CGFloat { ... }
        public var textStyle: Font.TextStyle { ... }
        public var lineHeight: CGFloat { ... }
        public var iconSize: CGFloat { ... }
        public var weight: Font.Weight { ... }
    }

**UIFont.Size enum** in `Sources/Zuper/Foundation/Typography/UIFont.swift`:

    public enum Size: Int, Comparable {
        case caption2 = 11, caption = 12, footnote = 13
        case subheadline = 15, callout = 16, body = 17
        case title3 = 20, title2 = 22, title = 28, largeTitle = 34
        case tabBar = 11, navigationBar = 17
    }

**Critical Files (in order of modification):**

zuper-swiftui Design System:
1. `Sources/Zuper/Components/Text.swift`
2. `Sources/Zuper/Components/Heading.swift`
3. `Sources/Zuper/Foundation/Typography/UIFont.swift`
4. `Sources/Zuper/Components/Button.swift`
5. `Sources/Zuper/Support/Components/Label.swift`

Zuper-iOS Main App (high-usage modules):
6. `ZuperiOS/ZCheckList/` - 14 Text occurrences
7. `ZuperiOS/ZComponents/` - Card views, detail views
8. `ZuperiOS/ZAssets/` - Detail and creation views
9. `ZuperiOS/ZNotes/` - List and card views
10. `ZuperiOS/ZQuotes/` - Detail and layout views
