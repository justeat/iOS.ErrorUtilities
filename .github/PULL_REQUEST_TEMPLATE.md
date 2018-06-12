## Pre-checks
- [ ] JIRA ticket: [CPD-0000](https://jira.just-eat.net/browse/CPD-0000)
- [ ] PR reports JIRA in title with format e.g. "CPD-1234: Basic description"
- [ ] Posted link to PR on JIRA

## Summary
Give context and demonstrate change if not obvious
* A sentence or paragraph to describe the issue if appropriate.
* Image(s) and/or gif(s) (before and after media will likely speed up PR and may alleviate the need for the reviewer to build the project)

## Versioning
- [ ] I've updated the version in the podspec

Pick one of the following:
- [ ] Major: Breaking change to API (module interface)
- [ ] Minor: Non-breaking change to add functionality (backward compatible), dependencies (pod versions) or tooling (Xcode, Swift…)
- [ ] Patch: Non-breaking bug fix (backward compatible)

## Testing strategy
Provide necessary details
- [ ] Manual testing
- [ ] Unit tests
- [ ] Integration
- [ ] UI Tests

## Additional communication
Should this change be broadcast?
- [ ] iOS Chapter – affects process or major change (CI, linting, feature rollout…)
- [ ] Vertical team or other chapter – affects process or changes to non-owned or crossing cutting component (moving repository, changes to CI, experiment rollout…)
- [ ] SOC – callout fix or high impact change (auth, payment, basket etc)
- [ ] Marketing - messaging, campaign (valentines, X Factor)
- [ ] Country market(s) – feature rollout/rollback
