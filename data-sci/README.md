# Provision a GCP instance for charm development, using terraform

This terraform bundle lets you provision a GCP VM instance for charm
development. The result is very similar to `multipass launch data-science`, but
has some key differences:

- deploy on google cloud instead of locally
- "unlimited" resources (use variables: `ncpus`, `gbmem`)
- selectable snap channels (use variables: `lxd`, `juju`, `microk8s`,
  `charmcraft`)

For example:

```shell
terraform apply -var-file="data-science.tfvars" \
  -var="ncpus=4" -var="gbmem=16"
```

An `ssd-2cpu-8gb` VM is ready to use in ~10 min, which includes a bootstrapped
microk8s model.

## Setup GCP
1. [Create a new project](https://console.cloud.google.com/cloud-resource-manager)
   and name it e.g. `data-science`. Note the Project ID (e.g. `stunning-vertex-342218`).
2. Export a JSON credentials file ([Credentials](https://console.cloud.google.com/apis/credentials)
  - Create credentials -> Service account.
  - "Service account name" can be e.g. "tf-data-science".
  - "Role" can be Basic -> Editor.
  - Manage keys -> Add key -> Create new key -> JSON -> Save it in e.g.
    `~/secrets/stunning-vertex-342218-e123456abcde`.
  - Enable "[Compute Engine API](https://console.developers.google.com/apis/api/compute.googleapis.com/overview?project=986404459234)"

## Generate SSH keys
SSH keys are handy for avoiding manual passwords.

To generate a public-private key pair,

```shell
ssh-keygen -t rsa -b 4096 -f ~/secrets/gcp-data-science-ssh -C ""
```

The public key will later be pushed into the VM and the private key will be
used for provisioning files and ssh-ing into the VM.

## Provisioning

At the very first time, run

```
sudo snap install --classic google-cloud-sdk
terraform init
```

Update `variables.tf` with your project id and credentials filename.

Modify `data-science.tfvars` to your needs and then run terraform:

```shell
terraform apply -var-file="data-science.tfvars"
```

Or, alternatively, override variables via cli:

```shell
terraform apply -var-file="data-science.tfvars" \
  -var="ncpus=4" -var="gbmem=16"
```

Log-in (ssh) into the VM instance:

```shell
ssh -i ~/secrets/gcp-data-science-ssh \
  -o "UserKnownHostsFile=/dev/null" \
  -o "StrictHostKeyChecking no" \
  ubuntu@$(terraform output ip_nat_vm_data_science | xargs -n1 echo)
```

If you'd like to access web UIs using a local browser, you can use forwarding, e.g.:

```shell
ssh -i ~/secrets/gcp-data-science-ssh \
  -o "UserKnownHostsFile=/dev/null" \
  -o "StrictHostKeyChecking no" \
  -L 8080:localhost:80 \
  ubuntu@$(terraform output ip_nat_vm_data_science | xargs -n1 echo)
```

After logging in, you can check:
- `cat /var/log/cloud-init-output.log`
- `juju status`

Some changes to the configuration files (namely the cloud-init) are not picked
up by terraform, so you may need to explicitly request a replacement:

```shell
terraform apply -var-file="data-science.tfvars" -var="lxd=4.0/stable" \
  -replace google_compute_instance.vm_data_science
```

To remove the VM,

```shell
terraform destroy -var-file="data-science.tfvars"
```

## Under the hood
- Firewall rules allow access to the VM only from the provisioning machine
  (e.g. your laptop)
- node-exporter is installed for your convenience :)
- ohmyzsh juju plugin is installed for your convenience :)
- Tested on:
  - Terraform v1.1.4 on linux_amd64, google-cloud-sdk 374.0.0

## References
- [COS Lite load test](https://github.com/canonical/cos-lite-bundle/tree/main/tests/load/gcp)
- Multipass [data-science](https://github.com/canonical/multipass-workflows/blob/main/v1/data-science.yaml) workflow
- charmed k8s [actions operator](https://github.com/charmed-kubernetes/actions-operator/blob/main/src/bootstrap/index.ts)
