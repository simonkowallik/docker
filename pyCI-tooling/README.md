# pyCI-tooling

pyCI-tooling is a container which provides various python based tools I personally use in CI pipelines.

Depending on the CI system you could use the tools right away, but for some CI systems it is a lot easier to provide a container with the actual tooling and just mount the data/code into the container.

So basically this container can be seen as a runtime environment.

[`pyproject.toml`](pyproject.toml) holds the tools included in the container.
