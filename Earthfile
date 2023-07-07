VERSION 0.7
PROJECT panda-den/colorful-pandas

test-colorful-pandas:
  BUILD --platform linux/arm64 ./colorful-pandas+lint
  BUILD --platform linux/arm64 ./colorful-pandas+test

deploy-colorful-pandas:
  ARG --required VERSION
  BUILD --platform linux/arm64 ./colorful-pandas+deploy --VERSION=$VERSION
