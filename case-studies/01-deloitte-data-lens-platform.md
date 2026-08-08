# Case Study: Modernizing Deloitte's Enterprise Healthcare Analytics Platform

**Role:** Product Manager / Technical Product Owner
**Timeframe:** 2019 – Present
**Team:** Engineering, Architecture, Business stakeholders (cross-functional)

## Context

Deloitte's Data Lens platform is an enterprise healthcare analytics product used to turn large volumes of healthcare data into actionable insight for clients. By the time I took ownership of the roadmap, the platform's ETL pipelines were running on legacy infrastructure — slow, expensive to maintain, and increasingly a blocker to shipping new analytics capability.

## Problem

- Legacy ETL pipelines were driving up infrastructure spend and limiting how fast we could iterate on new data products.
- Engineering, Architecture, and Business stakeholders had different views on what "modernization" should prioritize first.
- Any migration had to happen without disrupting a live healthcare analytics product already in client hands.

## My Approach

- Owned the product roadmap and backlog, translating a broad "modernize the platform" mandate into a sequenced, de-risked set of releases.
- Led the migration of legacy ETL pipelines to **Azure Databricks**, working closely with engineering to define the cutover plan and rollback safeguards.
- Partnered directly with Architecture to make sure the new pipeline design didn't just move the problem — it addressed the underlying cost and scalability issues.
- Set up delivery KPIs and lightweight governance so stakeholders had visibility into migration progress without needing a meeting to get it.
- Ran sprint planning, release management, and dependency resolution across the workstream to keep migration work from colliding with regular feature delivery.

## Outcome

- **45% reduction in cloud infrastructure costs** post-migration.
- Improved delivery predictability and stakeholder transparency through the governance model introduced alongside the migration.
- Received **2 Customer Success Awards** for delivery excellence on this engagement.

## What this taught me about product work

Modernization projects live or die on sequencing, not ambition. The hard part wasn't convincing anyone that Databricks was the right target — it was building a roadmap that let us get there in production-safe increments while a live client product kept running underneath us.
