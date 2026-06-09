---
name: import-notes
description: "Import notes from a SUMMARY.md file into the Obsidian vault. Autonomously routes notes based on tags, updates indexes, and manages navigation links. Triggers on: import notes, process summary, import summary.md."
user-invocable: true
---

# Obsidian Vault Importer

You are responsible for importing a generated `SUMMARY.md` file into the Obsidian knowledge base.

---

## Phase 1: Planning & Interrogation

Before writing ANY files, you must build an execution plan and confirm it with the user.

1. **Read the Source**: Read the `SUMMARY.md` file.
2. **Map the Tags**: Use `glob` and `read`/`grep` to find the correct destination directories in `30 Sources/`. Look for `Index.md` files matching the tags in the note blocks. Ignore generic tags like `index`, `glossary`, `books`, `patterns`.
3. **Present the Plan**: Show the user a structured table of exactly where each note will be saved.
4. **Resolve Conflicts**: If a tag resolves to multiple directories, or no directories (fallback to `00 Inbox/`), explicitly ask the user how to handle it. Interview the user relentlessly until the routing for every single note is 100% unambiguous.

**Do NOT proceed to Phase 2 until the user explicitly approves the routing plan.**

---

## Phase 2: Execution Rules

Once approved, execute the import strictly following these rules:

### 1. Note Creation
- Extract each note from `SUMMARY.md` delimited by `<!-- NOTE BLOCK -->`.
- Ensure frontmatter (`type`, `tags`) and Context lines are preserved.
- Write the note to the agreed target path.
- If `glossary: true`, ALSO write a copy to the nearest `Glossary/` directory in that path's hierarchy.

### 2. Update Indices
- For every directory that received new notes, find its `Index.md`.
- Add a link to the new note in the appropriate section (e.g., `- [[Note Name]]`). Do not duplicate links if they already exist.

### 3. Rebuild Navigation Links
- Notes in a directory must be linked sequentially at the bottom: `[[Previous Note|Previous]] | [[Next Note|Next]]`.
- `Index.md` is always the first note in the sequence.
- Update the footer of ALL notes in the modified directories to ensure the circular/linear reading path is perfectly intact.

---

## Checklist Before Completion

Before finishing the task, verify:
- [ ] All notes written to correct directories.
- [ ] Glossary notes copied to nearest `Glossary/`.
- [ ] Parent `Index.md` files updated with new links.
- [ ] `Previous | Next` footers updated for all notes in the affected folders.
- [ ] No duplicate tags used in routing without user confirmation.
