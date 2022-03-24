### Upgrade the controller
The following upgrades the controller and all models after.

    juju upgrade-model -m controller;

    for m in $(juju models --format json | jq -r '.models[]["model-uuid"]'); do 
      juju upgrade-model -m $m; 
    done
