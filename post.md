# I built a project manager for AI coding agents

As you might know, over the last couple of months I've been spending all my free time vibe coding — not just vibe coding, but learning how to create applications that are easy to maintain and extend. Coming from a data engineering background, building a full application from scratch was new territory for me, and AI coding agents made it possible.

## The small wins

My initial tries were limited to small applications — a CLI tool here, a utility there — and they were successful. The workflow was simple: describe what you want, let the agent code it, review, done. For small projects this works beautifully.

Then I wanted to work on something much bigger.

## Where things broke down

I started an ambitious project and quickly noticed I wasn't getting the results I wanted. The problem wasn't the AI — it was me. I had no system for organizing what needed to be done.

Initially I tried creating `task.md` files and documentation in markdown, which seems to be the standard approach in the vibe coding community. But what I kept running into was this: I'm either in task creation mode with no way to launch agents, or I'm in a coding session with no way to properly store documentation and track progress. It was always one or the other. Context kept getting lost between sessions.

I'd spend 30 minutes carefully writing requirements for a feature, then start a new Claude Code session and realize the agent had no idea about any of it. Or I'd be deep in implementation and think "I should document this decision" but there was nowhere structured to put it.

## The data engineer in me woke up

So I started thinking — I need some sort of database. I'm a data engineer after all. Markdown files are great for humans, but they're terrible for machines to query, update, and track state across sessions.

I created a simple application called MDP (MD Project), which later got renamed to **crump** — from CRUD minus the D plus Manage Projects. Don't ask, naming is hard.

## How it grew

Initially crump was just a planning tool. A SQLite database where I could create features, break them into tasks, write requirements. Both the AI agent and I could read and update the same structured data. No more lost context between sessions.

It worked. Really well, actually. For the first time I felt like I had a handle on a large project with an AI agent.

Then I thought: if the tasks are structured and the requirements are written, why am I manually launching the agent for each one? I need a way for an agent to just take one task after another and implement them. So I built a worker loop — an automated agent that picks up approved tasks and codes them.

Then I said: you know what, I want to review PRs before code is merged to main. So I added git automation — crump creates branches, commits code, and opens pull requests automatically.

Then I thought: well, actually, sometimes I'll want to auto-approve simple changes, but manually review complex ones. So I added configurable phases — each stage of the pipeline can be automatic or manual.

Then I wanted notifications between sessions — so when the worker finishes a task, my planning session knows about it immediately.

Then a web dashboard to visualize the pipeline...

You see where this is going.

## What crump looks like today

The core idea is simple: **separate planning from execution**.

You run two terminals:

**Terminal 1** — You and a lead agent plan the project together. Create features, break them into tasks, write requirements, discuss the approach. This is your interactive session where you think and make decisions.

**Terminal 2** — A worker agent runs in a loop. It picks up approved tasks, creates git branches, writes code, commits, pushes, and opens PRs. When it's done, it moves to the next task.

Both terminals share the same database. When the worker finishes a task, you get a notification. When you create a new task, the worker picks it up on the next sweep. You're planning task #5 while the agent is coding task #2.

Every task flows through phases:

| Phase | What happens |
|-------|-------------|
| **Refine** | Write requirements and acceptance criteria |
| **Implement** | Create branch, write code, commit and push |
| **Review** | Open PR, wait for review and merge |

Each phase can be auto (the worker loop handles it) or manual (you control it). By default, implementation is automatic — you plan, the agent codes.

## Why I'm releasing it now

The project kept growing and growing. There's still so much more I want to build — better error recovery, multi-agent coordination, smarter task prioritization, support for other AI coding tools beyond Claude Code.

But I decided it's time to release just a glimpse of it. Version 0.0.1. Rough around the edges. Bugs are expected — I'm sure of it.

I'm releasing it because I think the core idea is valuable: if you're working on anything beyond a small project with AI coding agents, you need structure. You need a system. Markdown files won't scale.

## Try it

If you're vibe coding and tired of managing everything through markdown files — give crump a try. It works as a Claude Code plugin with a companion CLI binary.

I've included a demo video showing the full flow: creating tasks in a planning session, watching the worker loop implement them, PRs opening automatically, merging, and seeing the pipeline end to end.

GitHub: https://github.com/etra/crump-claude

I'd love to hear your feedback — what works, what doesn't, what you'd want to see next.
