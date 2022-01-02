
#!/bin/bash

aws eks create-nodegroup \
	--cluster-name zero-eks \
	--nodegroup-name buffer \
	--subnets subnet-08ae6472495ec4127 subnet-0ddbe4a446288f2ff \
	--node-role arn:aws:iam::225953240914:role/zero-eks-node-group-role

# https://docs.aws.amazon.com/cli/latest/reference/eks/create-nodegroup.html

#   create-nodegroup
# --cluster-name <value>
# --nodegroup-name <value>
# [--scaling-config <value>]
# [--disk-size <value>]
# --subnets <value>
# [--instance-types <value>]
# [--ami-type <value>]
# [--remote-access <value>]
# --node-role <value>
# [--labels <value>]
# [--taints <value>]
# [--tags <value>]
# [--client-request-token <value>]
# [--launch-template <value>]
# [--update-config <value>]
# [--capacity-type <value>]
# [--release-version <value>]
# [--kubernetes-version <value>]
# [--cli-input-json <value>]
# [--generate-cli-skeleton <value>]

