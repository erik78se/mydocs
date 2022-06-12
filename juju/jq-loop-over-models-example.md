### Upgrade the controller and all models
The following upgrades the controller and all models after.

    juju upgrade-model -m controller;

    for m in $(juju models --format json | jq -r '.models[]["model-uuid"]'); do 
      juju upgrade-model -m $m; 
    done

### Show models with their names
    juju models --format json | jq -r '.models[] | .["model-uuid"] + " " + .["name"]'
