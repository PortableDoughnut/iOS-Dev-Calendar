---
name: Add Documentation
about: Template for Documentation Tickets
title: "[DOCUMENTATION] FileName(s)"
labels: ''
assignees: ''

---

Documenting code is important, which is why it's a problem that version 1 of this app has almost no documentation. Take the time to work your way through the assigned file and understand each element of its code. Add comments that explain the functions of the code in plain English. Here are a few guidelines for documentation:

### Types of Comments
- // is for regular, inline comments that explain what’s happening in a specific line or block of code.
- /* */ is for longer, multi-line comments or temporarily disabling code. Avoid nesting them.
- /// is for documentation comments—these appear in Quick Help tooltips when you option-click on a symbol in Xcode. Use /// to describe public functions, properties, and types so other developers (including your future self) can quickly understand what they do.

### Style Tips
- Add comments to explain the purpose of functions, complex conditionals, loops, and any non-obvious Swift syntax. 
- Assume your audience is another student who understands Swift but hasn’t seen this project before. 
- Focus on adding the minimum number of comments necessary to make the code easy to review and maintain. Don't overdo it!
- Use plain English to describe what the code does, especially for people who might not be familiar with the logic or syntax.
- Keep comments concise. Aim for clarity without rambling.
- Comment **why** something is done a certain way, not just _what_ is being done—especially if the reason isn’t obvious.
- Don’t repeat the code in your comments. For example, avoid writing // This sets the variable x to 5 when the line already says let x = 5. Again, explain why x needs to be set to five, or if the reason is obvious, don't bother commenting
  - On the other hand, if what the code does isn't clear (for example, you have a particularly complicated math formula), then it's okay to explain what the code is doing. Everyone knows what `x = 5` is doing, but not everyone knows what `let vector = Point(x: -sin(angle), y: cos(angle))` is doing.
- If a function or property is part of a design pattern (like SOLID or MVVM), you may wish to note that in the comment so future engineers can continue with that pattern.

### ✅ Acceptance Criteria

- [ ] Each function in the assigned file(s) has a clear `///` documentation comment describing its purpose (visible in Xcode Quick Help), other than standard functions such as viewDidLoad.
- [ ] Complex logic, conditionals, or loops are explained using `//` inline comments where appropriate.
- [ ] No redundant or obvious comments (e.g., `// set x to 5`) are present.
- [ ] Comments focus on explaining *why* something is done when it's not immediately obvious from the code.
- [ ] Comments are written concisely in plain English and are easy for another student to understand.
- [ ] The file(s) remains fully functional and compiles with no errors or warnings.
