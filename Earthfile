VERSION 0.7
PROJECT panda-den/colorful-pandas

test-colorful-pandas:
  BUILD ./colorful-pandas+lint
  BUILD ./colorful-pandas+test

deploy-colorful-pandas:
  ARG --required VERSION
  BUILD ./colorful-pandas+deploy --VERSION=$VERSION

deploy-handbook:
  ARG --required VERSION
  BUILD ./handbook+deploy --VERSION=$VERSION

vendor-cluster-charts:
  BUILD ./clusters+vendor-charts

compile-cluster-manifests:
  ARG --required CLUSTER
  BUILD ./clusters+compile-manifests --CLUSTER=$CLUSTER
