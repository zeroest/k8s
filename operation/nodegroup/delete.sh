
#!/bin/bash

aws eks delete-nodegroup \
	--cluster-name cluster-name \
	--nodegroup-name nodegroup-name

# https://docs.aws.amazon.com/cli/latest/reference/eks/delete-nodegroup.html

#   delete-nodegroup
# --cluster-name <value>
# --nodegroup-name <value>
# [--cli-input-json <value>]
# [--generate-cli-skeleton <value>]

