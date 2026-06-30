# Contributing

## Local validation

```bash
bash install/doctor.sh --capability docs
python3 scripts/readme-gate.py --readme README.md
python3 scripts/readme-gate.py --readme docs/README_en.md
bash -n install/*.sh shared/scripts/*.sh
```

Run the stage gate affected by a workflow, template, or rule change.

## Pull request checklist

- Add a `governance/updates/` record for package rule changes.
- Keep `workspace/` runtime artifacts and real `.env` files untracked.
- Preserve the `local/dev` boundary and never add `test/uat/prod` access.
- Keep Chinese and English README structures aligned.
- Confirm all README images are registered in `assets/asset-manifest.json`.
- Include executable evidence for script changes.
