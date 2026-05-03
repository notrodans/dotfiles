---

name: requirements-analyzer
description: "Analyze PRDs, User Stories, and specs to identify 'topological holes'—logical gaps, missing edge cases, and contradictions. Triggers on: analyze requirements, find gaps in PRD, review user stories, check for edge cases, audit this spec."
user-invocable: true

---
# Requirements Topology Analyzer

Audit requirements to find logical inconsistencies, "black holes" in user flows, and undefined system states before development begins.

---

## The Job

1. **Scan** the provided input (PRD, User Stories, or raw idea).
2. **Identify "Topological Holes"** (where the logic breaks or ends abruptly).
3. **Mandatory Iteration:** You **must** ask clarifying questions and **cannot** proceed to the final report until the user provides enough data to close the identified holes.
4. **Final Output:** Generate a "Hardened Requirements Doc" or an "Edge Case Matrix".

---

## Step 1: Deep Analysis (Internal Monologue)

Before responding, analyze the input for:

* **The "Happy Path" Fallacy:** Is only the perfect scenario described?
* **State Deadlocks:** Can a user get stuck in a state with no exit?
* **Data Integrity:** What happens if a process is interrupted (e.g., loss of connection)?
* **Permissions & Roles:** Who can see/do this? Who *cannot*?
* **Empty/Extreme States:** 0 items, 1,000,000 items, null values, expired tokens.

---

## Step 2: The "Hole Hunter" Questions

**Important:** You are forbidden from generating the final document if significant gaps exist. Use the lettered options format to force precision.

### Focus areas for questions:

```
1. The "What If" Scenarios (Edge Cases):
A. User loses internet during the transaction.
B. User attempts to perform an action without required permissions.
C. The external API returns a 500 error.
D. Other: [please specify]

2. State Transitions:
A. What is the 'Pending' state timeout duration?
B. Can a user cancel an action once it has reached the 'Processing' stage?
C. What happens to the data if the user closes the browser mid-flow?

3. Validation & Constraints:
A. What are the character limits for input X?
B. How do we handle duplicate entries?
C. Is there a rate limit for this specific action?
```

---

## Step 3: Closing the Holes (The Loop)

**Instruction to Agent:** If the user's answers create *new* logical gaps, repeat Step 2 with a new set of targeted questions. Do not stop until the "Topology" is solid.

---

## Step 4: Final Report Structure (Gap-Free Spec)

Once the logic is closed, generate the report in `tasks/audit-[feature-name].md`:

### 1. Hardened User Flow

A step-by-step map including error states and branch logic.

### 2. Edge Case Matrix

| Scenario | Expected System Behavior | UI/UX Feedback |
| --- | --- | --- |
| No Data / Empty State | Show "Empty" illustration + CTA | Standard Empty State |
| Concurrent Edit | "Last win" or "Locking" mechanism | Toast notification |
| Network Timeout | Retry 3 times, then show Error | "Retry" button |

### 3. State Machine (Logical States)

List all possible states (e.g., `Draft` -> `Pending` -> `Active` | `Rejected`) and the triggers for each transition.

### 4. Boundary Conditions

* Max/Min values.
* Timeouts.
* File size/type limits.

### 5. Security & Privacy Gaps

* Data masking requirements.
* Authorization checks per endpoint.

---

## Example Interaction

**User:** "Write a spec for a 'Delete Account' button."

**Agent (The Analyzer):**
"I've analyzed the request. We have several topological holes to plug before this is ready for dev:

```
1. What happens to the user's data?
A. Hard delete (immediate wipe)
B. Soft delete (marked as deleted, kept for 30 days)
C. Anonymization (keep data, remove PII)

2. What about active subscriptions?
A. Block deletion until cancelled
B. Auto-cancel and refund pro-rata
C. Auto-cancel without refund

3. Are there any 'Unstoppable' states?
A. Can they delete if a payment is currently 'Processing'?
B. Can they delete if they are the last Admin of a team?
```

Please answer (e.g., 1B, 2A, 3B) so I can complete the spec."
