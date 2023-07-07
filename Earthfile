VERSION 0.7
PROJECT panda-den/colorful-pandas

colorful-pandas:
  PIPELINE
  TRIGGER pr main
  FROM ./colorful-pandas+lint --platform linux/arm64
  FROM ./colorful-pandas+test --platform linux/arm64
