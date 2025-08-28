name: Vulnerable Pipeline 2

on:
  pull_request_target:
    types: [opened, edited, synchronize, reopened]

jobs:
  vulnerable-pipeline:
    name: Vulnerable Pipeline
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          # For pull_request_target, we need to checkout the base branch
          ref: ${{ github.event.pull_request.base.ref }}

      - name: Vulnerable Injectable Step
        run: |
          echo "Validating PR title: ${{ github.event.pull_request.title }}"
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
