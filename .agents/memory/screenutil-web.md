---
name: flutter_screenutil on web
description: Which size extension to use on desktop-width web viewports
---

## Rule
Use `.r` (responsive — takes the minimum of width and height scale factors) for any fixed-size box (icon containers, avatar circles, spinner sizes). Do NOT use `.w` for these — on desktop viewports (1280px wide vs 390px design width) `.w` produces a 3.28× multiplier, making a "100.w" container 328px wide.

**Why:** The design size is `Size(390, 844)` (mobile). On a 1280×720 desktop viewport the width scale is 3.28× but the height scale is only 0.85×. `.w`-sized containers overflow the screen vertically; `.r` uses the smaller factor (0.85×) and stays proportional.

**How to apply:**
- Tap targets, icon boxes, avatars, spinners → `.r`
- Horizontal padding/margin → `.w`  
- Vertical spacing → `.h`
- Font sizes → `.sp` (already uses min internally)
