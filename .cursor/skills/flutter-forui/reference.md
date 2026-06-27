# ForUI Widget Reference

Quick catalog for `forui ^0.23.0`. All widgets import from `package:forui/forui.dart`.

## Layout

| Widget | Use for |
|--------|---------|
| `FScaffold` | App shell (replaces Material Scaffold) |
| `FDivider` | Horizontal/vertical separator |
| `FResizable` | Resizable split panes |

## Form

| Widget | Use for |
|--------|---------|
| `FButton` | Primary actions (`onPress`, `variant`, `suffix`/`prefix` icons) |
| `FTextField` / `FTextFormField` | Text input |
| `FCheckbox` | Boolean toggle |
| `FRadio` | Single selection in a group |
| `FSwitch` | On/off toggle |
| `FSlider` | Numeric range |
| `FSelect` / `FSelectGroup` | Dropdown selection |
| `FMultiSelect` | Multiple selection |
| `FAutocomplete` | Typeahead search |
| `FDateField` / `FTimeField` | Date/time input |
| `FDateTimePicker` / `FTimePicker` / `FPicker` | Pickers |
| `FOtpField` | OTP / PIN entry |
| `FLabel` | Form field labels |

## Data presentation

| Widget | Use for |
|--------|---------|
| `FCard` | Grouped content |
| `FAvatar` | User images/initials |
| `FBadge` | Status/count badges |
| `FAccordion` | Collapsible sections |
| `FCalendar` / `FLineCalendar` | Calendar views |
| `FItem` / `FItemGroup` | List item rows |

## Tile

| Widget | Use for |
|--------|---------|
| `FTile` / `FTileGroup` | Settings-style rows |
| `FSelectTileGroup` / `FSelectMenuTile` | Selectable tile lists |

## Navigation

| Widget | Use for |
|--------|---------|
| `FHeader` | Top app bar |
| `FBottomNavigationBar` | Bottom tabs |
| `FSidebar` | Side navigation |
| `FTabs` | Tabbed content |
| `FBreadcrumb` | Hierarchy path |
| `FPagination` | Page controls |

## Feedback

| Widget | Use for |
|--------|---------|
| `FAlert` | Inline alerts |
| `FProgress` | Loading/progress bars |
| `FToast` / `showFToast` | Transient notifications (needs `FToaster`) |

## Overlay

| Widget | Use for |
|--------|---------|
| `FDialog` / `showFDialog` | Modal dialogs |
| `FSheet` / `FPersistentSheet` | Bottom/side sheets |
| `FPopover` / `FPopoverMenu` | Anchored menus |
| `FContextMenu` | Right-click / long-press menus |
| `FTooltip` | Hover/focus hints (needs `FTooltipGroup`) |

## Foundation

| Widget | Use for |
|--------|---------|
| `FCollapsible` | Expand/collapse animation |
| `FTappable` | Custom pressable areas |
| `FFocusedOutline` | Focus ring styling |
| Portal widgets | Custom overlay positioning |

## Theme API

```dart
// Access current theme
final data = FTheme.of(context);
final colors = data.colors;
final typography = data.typography;
final style = data.style;

// Available palettes
FThemes.neutral | .zinc | .slate | .blue | .green
// Each: .light | .dark → .touch | .desktop

// Bridge to Material
theme.toApproximateMaterialTheme()
```

## Icons

```dart
Icon(FLucideIcons.chevronsUp)
Icon(FLucideIcons.settings)
// Browse FLucideIcons for full set
```

## Optional: Flutter Hooks

This project does not include `forui_hooks` yet. If adding reactive controllers:

```yaml
dependencies:
  flutter_hooks: ^0.21.0
  forui_hooks: ^0.23.0
```

Then use hook variants (e.g. `useFTextFieldController`) from `package:forui_hooks/forui_hooks.dart`.
