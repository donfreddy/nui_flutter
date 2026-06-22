# Roadmap

> Last updated: June 19, 2026

## Current status

- **25 exported widgets** (excluding ThemeExtension and helpers)
- **~18 Nuxt UI components ported** out of 125+
- **`flutter analyze`**: 0 issues
- **Tests**: 15 (fallback, merge, WCAG contrast)

## Completed components

| Category | Component | Status |
|----------|-----------|--------|
| Button | NButton (6 variants, 5 sizes, 7 colors) | ✅ |
| Input | NInput (+phone, +amount, +otp) | ✅ |
| Textarea | NTextarea | ✅ |
| Checkbox | NCheckbox | ✅ |
| RadioGroup | NRadioGroup | ✅ |
| Card | NCard (5 variants) | ✅ |
| Avatar | NAvatar + NAvatarGroup | ✅ |
| Badge | NBadge (4 variants, dot, emoji) | ✅ |
| Chip | NChip + NChipGroup | ✅ |
| Toggle/Switch | NToggle | ✅ |
| Alert | NAlert (4 variants) | ✅ |
| Dropdown/Select | NDropdown (+search, +multiple) | ✅ |
| Icon Button | NIconButton | ✅ |
| Empty State | NEmptyState | ✅ |
| Toast | NToast | ✅ |
| Modal | NModal | ✅ |
| Skeleton | NSkeleton | ✅ |
| Progress | NProgress | ✅ |
| App Bar | NAppBar | ✅ |
| Tab Bar | NTabBar | ✅ |
| Bottom Sheet | NBottomSheet | ✅ |

## Next components to implement

### High priority

- [ ] **Form / FormField** -- Form validation and submission with state management
- [ ] **SelectMenu** -- Advanced select with search and virtualization
- [ ] **Popover** -- Contextual floating menu
- [ ] **Slider** -- Numeric range value selection
- [ ] **Stepper** -- Multi-step progress indicator (useful for fintech onboarding)
- [ ] **Accordion** -- Collapsible content panels (FAQ, settings)

### Medium priority

- [ ] **PinInput** -- PIN/OTP code entry
- [ ] **InputNumber** -- Numeric stepper (+/-)
- [ ] **InputDate** -- Date picker input
- [ ] **InputTime** -- Time picker input
- [ ] **InputTags** -- Interactive tag input
- [ ] **Drawer** -- Side panel (complements NBottomSheet)
- [ ] **Calendar** -- Calendar/date picker component
- [ ] **FileUpload** -- File/image picker
- [ ] **Tooltip** -- Contextual info popup
- [ ] **Pagination** -- Page navigation control
- [ ] **Table** -- Responsive data table
- [ ] **Timeline** -- Chronological event timeline
- [ ] **Separator** -- Horizontal/vertical divider
- [ ] **Collapsible** -- Toggleable content section

### Low priority

- [ ] **CommandPalette** -- Search overlay command palette
- [ ] **ContextMenu** -- Long-press context menu
- [ ] **Banner** -- Top-of-screen information banner
- [ ] **Carousel** -- Swipeable horizontal carousel
- [ ] **Listbox** -- Searchable selectable list
- [ ] **ColorPicker** -- Color selection UI
- [ ] **NavigationMenu** -- Multi-level navigation
- [ ] **ScrollArea** -- Scrollable container with shadow hints
- [ ] **Sidebar** -- Collapsible sidebar navigation
- [ ] **Slideover** -- Slide-in panel (all sides)
- [ ] **Switch** -- Additional NToggle variant
- [ ] **Tree** -- Hierarchical tree view
- [x] **Error** -- Full error state display
- [ ] **User** -- User display (avatar + name + description)
- [ ] **Marquee** -- Infinite scrolling ticker

## Not planned (web-specific or not relevant for mobile)

These Nuxt UI components are not planned for nui_flutter because they are
specific to web, editorial content, or desktop dashboards:

Dashboard*, Editor*, Content*, Page*, BlogPost*, Chat*, Pricing*,
ColorMode*, AuthForm, Breadcrumb, Changelog*, Footer, FooterColumns,
Icon, Kbd, Link, LocaleSelect, Main, Theme, App

## Non-functional improvements

- [ ] Add golden tests
- [ ] Add `example/` demo application
- [ ] Publish to pub.dev
- [ ] Test coverage above 80%
