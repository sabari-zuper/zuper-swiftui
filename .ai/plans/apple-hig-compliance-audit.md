# Apple HIG Compliance Audit for zuper-swiftui Components

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.

This document must be maintained in accordance with `.ai/plans/plans.md`.


## Purpose / Big Picture

After this change, all 35 zuper-swiftui components will comply with Apple Human Interface Guidelines (HIG). Users will experience proper touch targets (minimum 44pt for all interactive elements), consistent accessibility support (VoiceOver, Reduce Motion, Dynamic Type), and standardized component patterns that match native iOS behavior.

To verify success, build the project with `xcodebuild -scheme Zuper -destination 'generic/platform=iOS Simulator' build` and observe no deprecated warnings in implementation code (preview warnings are acceptable). Then run VoiceOver on any screen using Zuper components and confirm all interactive elements are announced correctly and have adequate touch targets.


## Progress

- [x] Phase 1: Touch Target Fixes (CRITICAL) - COMPLETED 2025-12-31
  - [x] Tag component: Increased vertical padding from 7pt to .small (12pt), added minHeight .touchTarget
  - [x] Tab component: Added minHeight .touchTarget, fixed deprecated TextStrut(.normal) to .subheadline
  - [x] Checkbox/Radio: Added .frame(minHeight: .touchTarget) and .contentShape(Rectangle()) to ButtonStyle
  - [x] ButtonLink: Added minWidth/minHeight .touchTarget for icon-only mode via ZuperStyle
- [x] Phase 2: Deprecated API Migration (HIGH) - COMPLETED 2025-12-31
  - [x] Dialog.swift line 24: Replaced .h5 with .headline
  - [x] EmptyState.swift line 28: Replaced .h6 with .headline
  - [x] All deprecated Heading/TextSize/Icon.Size usages fixed in previous session
- [ ] Phase 3: Accessibility Enhancements (MEDIUM)
  - [ ] Add @Environment(\.accessibilityReduceMotion) to animated components
  - [ ] Enhance VoiceOver labels for InputField suffix, Tag removable, Tab selection
  - [ ] Add missing AccessibilityID cases for Tab, Tag, Switch, Badge
- [ ] Phase 4: Component Standardization (MEDIUM)
  - [ ] BadgeList.Size: Rename .small/.normal to .compact/.standard
  - [ ] KeyValue.Size: Rename .normal to .standard
- [x] Phase 5: Build and Verify - COMPLETED 2025-12-31
  - [x] Run full build, confirm no implementation code deprecated warnings
  - [ ] Manual VoiceOver test
  - [ ] Manual touch target verification


## Surprises & Discoveries

- Tag component vertical padding was 7pt, resulting in ~29pt total height (below 44pt minimum). Fixed by increasing to .small (12pt) plus adding minHeight constraint.
- Tab component already used Button wrapper but lacked minimum height constraint. Fixed with .frame(minHeight: .touchTarget).
- Checkbox and Radio components use a ButtonStyle wrapper pattern. Touch target fix applied to the makeBody function to ensure entire component is tappable.
- ButtonLink icon-only mode needed ZuperStyle to accept TypeStyle parameter to conditionally apply 44pt minimum dimensions.
- TimelineIndicator already had @Environment(\.accessibilityReduceMotion) implemented - good reference for other animated components.


## Decision Log

- Decision: Skip preview code updates, only fix implementation code
  Rationale: Preview code deprecation warnings are educational and don't affect end users. Focusing on implementation reduces scope while maintaining backward compatibility.
  Date/Author: 2025-12-31

- Decision: Use deprecation warnings instead of breaking changes
  Rationale: Existing zuper-iOS app has 1000+ usages of deprecated APIs. Deprecation warnings allow gradual migration without breaking existing code.
  Date/Author: 2025-12-31


## Outcomes & Retrospective

(To be populated after completion)


## Context and Orientation

The zuper-swiftui package is a SwiftUI component library located at `/Users/sabari/Documents/Zuper Projects/zuper-swiftui/`. It contains 35 reusable UI components modeled after common iOS patterns.

Recent work has already aligned the foundation layer with Apple HIG:

- Typography (`Sources/Zuper/Foundation/Typography/`): TextSize enum uses Apple HIG sizes from caption (12pt) to largeTitle (34pt). Dynamic Type is supported via sizeCategory environment.

- Spacing (`Sources/Zuper/Foundation/Spacing/Spacing.swift`): Uses 4pt grid with semantic aliases (.compact 4pt, .standard 16pt, .touchTarget 44pt).

- Colors (`Sources/Zuper/Foundation/Colors/`): Semantic aliases like .textPrimary, .textSecondary, .statusSuccess, .statusError.

- Icons (`Sources/Zuper/Components/Icon.swift`): Semantic sizes .compact (16pt), .default (20pt), .comfortable (24pt), .prominent (28pt).

- Elevation (`Sources/Zuper/Foundation/Elevations/Elevation.swift`): Semantic levels .card, .floating, .sheet, .modal.

The remaining work addresses component-level compliance, particularly touch targets and accessibility.

Key files requiring changes:

- `Sources/Zuper/Components/Tag.swift`: Interactive tag with 7pt vertical padding (below 44pt minimum)
- `Sources/Zuper/Support/Components/Tab.swift`: Tab item with no minimum height and deprecated TextStrut usage
- `Sources/Zuper/Components/Dialog.swift`: Uses deprecated Heading.h5
- `Sources/Zuper/Components/EmptyState.swift`: Uses deprecated Heading.h6
- `Sources/Zuper/Components/Checkbox.swift`: 20pt indicator needs touch area verification
- `Sources/Zuper/Components/Radio.swift`: 20pt indicator needs touch area verification
- `Sources/Zuper/Components/ButtonLink.swift`: Icon-only mode may lack adequate touch target
- `Sources/Zuper/Support/Accessibility/AccessibilityID.swift`: Missing identifiers for several components


## Plan of Work

Phase 1 addresses touch targets, the most critical HIG requirement. Apple mandates 44pt minimum for all interactive elements. The Tag component currently has only 7pt vertical padding resulting in approximately 29pt total height. We will increase this to 12pt padding and add a .frame(minHeight: .touchTarget) constraint. The Tab component lacks any minimum height; we will add the same constraint and also address a FIXME comment suggesting it should use SwiftUI.Button for proper touch feedback.

Phase 2 migrates deprecated API usages in implementation code. Dialog uses Heading.h5 which is deprecated in favor of .headline. EmptyState uses Heading.h6 similarly. We will search for any remaining deprecated usages and fix them.

Phase 3 adds accessibility enhancements. Most components do not respect the accessibilityReduceMotion environment value. We will add this check to all animated components (Button, Switch, Tabs, Tag, Checkbox, Radio, Collapse, Toast). We will also add proper VoiceOver labels to suffix icons in InputField and the remove button in Tag.

Phase 4 standardizes component Size enums. BadgeList and KeyValue use .small/.normal which should be .compact/.standard to match the design system patterns established in Icon.Size.


## Concrete Steps

All commands run from `/Users/sabari/Documents/Zuper Projects/zuper-swiftui/`.

Step 1: Fix Tag touch target

Open `Sources/Zuper/Components/Tag.swift`. Locate lines 6-7:

    public static let horizontalPadding: CGFloat = .xSmall
    public static let verticalPadding: CGFloat = 7

Change verticalPadding to:

    public static let verticalPadding: CGFloat = .small  // 12pt for 44pt+ total height

Then in the body, after the HStack, add:

    .frame(minHeight: .touchTarget)

Step 2: Fix Tab component

Open `Sources/Zuper/Support/Components/Tab.swift`. Replace deprecated TextStrut(.normal) with TextStrut(.subheadline). Add .frame(minHeight: .touchTarget) to ensure adequate touch target. Optionally refactor to use SwiftUI.Button wrapper with HapticsProvider feedback.

Step 3: Fix deprecated Heading usages

Open `Sources/Zuper/Components/Dialog.swift` line 24. Replace `.h5` with `.headline`.

Open `Sources/Zuper/Components/EmptyState.swift` line 28. Replace `.h6` with `.headline`.

Step 4: Add reduce motion support

For each animated component, add:

    @Environment(\.accessibilityReduceMotion) var reduceMotion

Then wrap animations:

    .animation(reduceMotion ? nil : .easeOut(duration: 0.2), value: state)

Step 5: Build and verify

    xcodebuild -scheme Zuper -destination 'generic/platform=iOS Simulator' build 2>&1 | grep -E "(error:|warning:.*deprecated)" | grep -v "PreviewProvider"

Expected: No errors, no deprecated warnings from implementation code (preview warnings are acceptable).


## Validation and Acceptance

Build succeeds with command:

    xcodebuild -scheme Zuper -destination 'generic/platform=iOS Simulator' build

Expected output ends with:

    ** BUILD SUCCEEDED **

Deprecated warning check:

    xcodebuild ... 2>&1 | grep "deprecated" | grep -v "Preview" | wc -l

Expected: 0 (no deprecated warnings in implementation code)

Manual verification: Open any app using zuper-swiftui, enable VoiceOver in Settings > Accessibility, navigate to a Tag component. VoiceOver should announce the tag label. The touch target should be easily tappable with a fingertip (not requiring precise aim).


## Idempotence and Recovery

All changes are additive modifications to Swift source files. Running the implementation multiple times produces the same result. If any step fails, simply revert the specific file changes using git:

    git checkout -- Sources/Zuper/Components/Tag.swift

The project can be rebuilt at any point to verify current state.


## Artifacts and Notes

Current Tag component vertical padding (before fix):

    public static let verticalPadding: CGFloat = 7  // Results in ~29pt height

After fix:

    public static let verticalPadding: CGFloat = .small  // 12pt, results in 44pt+ height

Current Dialog heading usage (before fix):

    Heading(title, style: .h5, alignment: .init(alignment))

After fix:

    Heading(title, style: .headline, alignment: .init(alignment))


## Interfaces and Dependencies

No new interfaces are required. Existing types are modified:

In `Sources/Zuper/Components/Tag.swift`, the public static constant changes:

    public static let verticalPadding: CGFloat = .small

In `Sources/Zuper/Support/Accessibility/AccessibilityID.swift`, add new cases:

    case tabItem = "zuper.tab.item"
    case tagLabel = "zuper.tag.label"
    case tagRemoveButton = "zuper.tag.remove"
    case switchToggle = "zuper.switch.toggle"
    case badgeLabel = "zuper.badge.label"

Dependencies: No new external dependencies. Uses existing SwiftUI framework and Zuper design tokens.
