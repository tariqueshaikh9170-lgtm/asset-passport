# Asset Passport — V130

- Fixed PAX mobile keyboard behavior.
- PAX no longer lets the workspace/page jump upward when the input is focused.
- When typing on mobile, PAX switches to a compact keyboard-safe mode so the input stays visible without pushing the sheet off-screen.
- Welcome text and quick-action chips collapse while typing; chat remains available.

V131 — PAX keyboard stability polish
- Keeps PAX as a compact card when the Android keyboard opens instead of allowing the sheet to jump too far upward.
- Detects keyboard state with visualViewport and reduces PAX content to the chat/input essentials while typing.
- Preserves the normal premium bottom-sheet layout when the keyboard is closed.

V132 — PAX premium conversation polish
- Added a lightweight animated thinking indicator when PAX receives a question.
- Improved mobile chat feel without changing the stable keyboard layout from V131.
- Preserved existing PAX workspace-data answers and navigation behavior.
