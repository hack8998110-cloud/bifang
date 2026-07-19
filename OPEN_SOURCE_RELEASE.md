# Open Source Release Boundary

This file records what is ready to publish and what should stay out of the first open-source release.

## Publish

- `README.md`
- `LICENSE`
- `CHANGELOG.md`
- `RELEASE_NOTES_V0.1_OPEN_SOURCE.md`
- `RELEASE_NOTES_V0.2_DEV.md`
- `templates/starter_output_template.md`
- `tests/smoke_cases.md`
- `tests/director_thinking_pressure_tests.md`
- `tests/v0.2_pressure_matrix.md`
- `tests/positive_industry_starter_cases.md`
- `tests/positive_industry_instance_runs_2026-07-18.md`
- `tests/failure_regression_cases.md`
- `tests/instance_runs_2026-07-18.md`
- `tests/open_source_acceptance.md`
- `bifang-starter/`
- `bifang-baokuan/`
- `bifang-diagnosis/`
- `bifang-profile/`
- `bifang-assets/`
- `bifang-topic/`
- `bifang-script/`
- `bifang-review/`
- `bifang-rewrite/`
- `bifang-feedback/`
- `bifang-intake/`
- `bifang-report/`

## Do Not Publish In The First Release

- `outputs/`: generated internal validation artifacts.
- `internal/`: private beta notes, scorecards, creator distillation rules, and customer-test records.
- `iterations/`: internal pressure-test history.
- `README_internal_beta.md`: old internal beta narrative.
- `bifang_README_v2.6.md`: historical v2.6 usage note.
- `package-lock.json` and `package.json`: only include if the V4 contest tooling is intentionally released.
- `tools/`: only include after rewriting the old contest audit scripts into open-source audits.
- `sales/`: only include after removing private pricing or sales-process context.
- Complex orchestration layers: hold back from V0.1 open source until internal validation, comparison, pilot, and pricing artifacts are removed.

## Remaining Before Public Release

- Choose and add a `LICENSE`.
- Keep V0.1 open source skills-only; decide later whether a cleaned orchestration layer should be released.
- Replace contest-specific package audit with an open-source audit.
- Run the smoke cases on at least three real industries: local store, high-ticket service, and course/IP.
- Review all non-skill docs for old wording such as "爆款引擎", hardcoded internal paths, and generated artifacts.
