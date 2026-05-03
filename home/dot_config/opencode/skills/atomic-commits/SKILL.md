---
name: atomic-commits
description: "Analyzes uncommitted changes (git status/diff) and groups them into logical, atomic commits with meaningful messages based on LeanIX engineering principles. Triggers on: split my commits, make atomic commits, review diff, group changes, git commit plan."
user-invocable: true
---

# Atomic Commit Assistant

Transform messy, bundled code changes into clean, independent, and atomic commits to maintain a readable and manageable Git history.

---

## The Job

1. Receive `git status`, `git diff`, and an optional brief explanation of the work done from the user.
2. Ask 1-3 essential clarifying questions (with lettered options) ONLY if the intent behind certain file changes is ambiguous.
3. Group the changes into logical, independent units (Atomic Commits).
4. Generate an actionable "Commit Plan" with ready-to-use Git commands.

**Important:** Do NOT suggest a single `git commit -am "Update stuff"`. Strict adherence to the single-responsibility principle for commits is required.

---

## Step 1: Clarifying Questions (If Needed)

Ask questions only if the relationship between changed files is unclear. Focus on:

* **Separation of Concerns:** Are these UI changes part of the new feature, or a separate cleanup?
* **Scope:** Is this documentation update related to the bug fix, or a general chore?
* **Test Coverage:** Do these test files belong to the refactoring or the new feature?

### Format Questions Like This:

```
1. I see changes in `src/components/Button.scss`. Are these related to the new calculator feature, or a separate styling update?
   A. Part of the new calculator feature
   B. Separate styling update (UI chore)
   C. Other: [please specify]

2. You updated `docs/changelog.md`. Should this be:
   A. Bundled with the bug fix
   B. A standalone documentation commit
```

This lets users respond with "1B, 2B" for quick iteration. If the diff is perfectly self-explanatory, skip this step.

---

## Step 2: Rules of Atomicity

When grouping files and generating the commit plan, you MUST adhere to these strict rules:

1. **One Purpose:** An atomic commit is the smallest code change that cannot be broken down any further. It serves a single, discrete purpose.
2. **Feature Implementation:** Do not mix adding new logic/utilities with unrelated UI component updates.
3. **Bug Fixes:** The fix and its corresponding test case MUST be in the same commit. Unrelated files (like changelogs or readmes) must be separated.
4. **Refactoring:** Do not mix structural code changes (e.g., migrating to async/await) with unrelated styling or feature additions.
5. **Meaningful Messages:** Commit messages must be clear, concise, and summarize the single change being made (e.g., imperative mood: "Fix divide by zero error", not "fixed bug").

---

## Step 3: Commit Plan Structure

Generate the Commit Plan with these sections:

### 1. Overview

A brief summary of what was found in the diff and how it will be split up.

### 2. The Commit Plan

A numbered list of proposed commits. For each commit, provide:

* **Type:** (Feature | Bug Fix | Refactor | Docs | Chore | Test)
* **Included Files:** List of files to be staged.
* **Reasoning:** One sentence explaining *why* these files are grouped together.
* **Command:** The exact terminal command to execute.

**Format:**

```markdown
### 1. [Commit Type]: [Meaningful Commit Message]
**Files:**
- `path/to/file1`
- `path/to/file2`

**Reasoning:** [Brief explanation of why this is an atomic unit]

**Execute:**
```
```bash
git add path/to/file1 path/to/file2 && git commit -m "Type: Meaningful Commit Message"
```

### 3. Leftover Changes (If Applicable)

List any files or hunks that were excluded from the plan because their purpose was entirely unclear or they seem like accidental modifications (e.g., `console.log` remnants, `.env` files).

---

## Output

* **Format:** Markdown (`.md`)
* **Location:** Direct terminal/chat response
* **Style:** Clear, copy-pasteable bash commands.

---

## Example Execution

**User Input:**
"I built a new addition function, updated the button styles, and fixed a divide-by-zero bug. Here is my git status: `src/utils.js`, `src/components/button.scss`, `src/mathUtils.js`, `tests/mathUtils.test.js`, `docs/changelog.md`."

**Agent Output:**

```markdown
# Atomic Commit Plan

I've analyzed your changes and separated them into 4 atomic commits based on their specific purposes (Feature, Chore, Bug Fix, and Docs).

### 1. Feature: Add addition function to utility module
**Files:**
- `src/utils.js`

**Reasoning:** This is a distinct feature addition and should not be mixed with UI updates or bug fixes.

**Execute:**
```
```bash
git add src/utils.js && git commit -m "feat: Add addition function to utility module"
```

### 2. Chore: Update button component styling

**Files:**

* `src/components/button.scss`

**Reasoning:** UI and styling adjustments are independent of the backend utility logic.

**Execute:**

```bash
git add src/components/button.scss && git commit -m "chore: Update button component styling"

```

### 3. Bug Fix: Fix divide by zero error in 'divide' function

**Files:**

* `src/mathUtils.js`
* `tests/mathUtils.test.js`

**Reasoning:** The bug fix and its accompanying test case form a single, atomic unit of work.

**Execute:**

```bash
git add src/mathUtils.js tests/mathUtils.test.js && git commit -m "fix: Fix divide by zero error in 'divide' function"

```

### 4. Docs: Update changelog for recent fixes and features

**Files:**

* `docs/changelog.md`

**Reasoning:** Documentation updates should be kept separate from functional code changes.

**Execute:**

```bash
git add docs/changelog.md && git commit -m "docs: Update changelog for recent fixes and features"

```
---

## Checklist

Before outputting the commit plan:

- [ ] Reviewed `git diff` and `git status` thoroughly.
- [ ] Asked clarifying questions if the relationship between files was ambiguous.
- [ ] Ensured no single commit mixes Features, Fixes, or Refactoring.
- [ ] Verified that tests are grouped with the code they cover.
- [ ] Wrote clear, imperative commit messages.
- [ ] Provided exact, copy-pasteable `git add ... && git commit -m ...` commands.
