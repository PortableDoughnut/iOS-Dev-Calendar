---
name: "[ACCESSIBILITY] Font Sizing, Color, and Screen Sizing"
about: Describe this issue template's purpose here.
title: "[ACCESSIBILITY] Font Sizing, Color, and Screen Sizing"
labels: ''
assignees: ''

---

## Overview

An often overlooked part of app development is the process of adding in localization and accessibility features. Apple has several recommendations for how to implement these features in the [Human Interface Guidelines.](https://developer.apple.com/design/human-interface-guidelines/accessibility) Take the time to read through those recommendations so you are more familiar with all of them prior to beginning work on the specific ones you are concerned with here.

## Objectives

- Practice using some of the features of Swift that allow more people to access your app

## Minimum Tasks: 

- [ ] Follow the Human Interface Guidelines steps to making the app accessible to users who have enabled Dynamic Type settings. "Dynamic Type is a systemwide setting available in iOS, iPadOS, watchOS, and visionOS that lets people adjust the size of text displayed onscreen for comfort and legibility. For guidance, see [Supporting Dynamic Type.](https://developer.apple.com/design/human-interface-guidelines/typography#Supporting-Dynamic-Type)"

- [ ] Follow the recommendations on Color in the "Vision" section of the [page linked above.](https://developer.apple.com/design/human-interface-guidelines/accessibility)

- [ ] Verify that your app is adjusting properly when used on iPad and iPhone screens of various sizes. Fix any issues you find.

## Acceptance Criteria
- [ ] DynamicType support added to views wherever possible.
- [ ] Colors follow guidelines laid out in HIG.
- [ ] Views resize properly for a variety of screen sizes.
- [ ] No major bugs or issues when testing.
