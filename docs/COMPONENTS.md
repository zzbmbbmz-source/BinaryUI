# Components

Window: AddTab, RefreshTheme, Destroy
Tab: AddSection, Destroy
Section: AddButton, AddToggle, AddSlider, AddDropdown, AddTextbox, AddLabel, AddKeybind, AddDivider

Controls validate public values and protect callbacks with SafeCall. Every long-lived connection should have an owner and cleanup path.

The library is intentionally client-side and uses standard Roblox APIs only.
