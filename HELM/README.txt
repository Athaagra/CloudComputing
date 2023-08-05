Helm template

create_charts:
The initial template generated Helm.

my_first_chart:
The modified template:
helm install my-chart my_first_chart/ --dry-run (validation fails (Declaring Variables in Values.yaml))
helm lint my_first_chart (the debugging for fixes)

Yaml:
Values.yaml: declare variables
deployment.yaml: if,loop,dictionaries,print

Compile yamls:
helm template my_first_chart
