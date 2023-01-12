# Provision a GCP instance for a tor obfs4 bridge

This terraform bundle lets you provision a GCP VM instance for a tor obfs4 bridge.

Usage: update the `instances` variable in [main.tf](main.tf) and run
`terraform apply`.

A `tor-obfs4-bridge-2cpu-8gb` VM will be ready to use in a few minutes.

## Setup GCP
1. [Create a new project](https://console.cloud.google.com/cloud-resource-manager)
   and name it e.g. `data-tor-obfs4-gridge`. Note the Project ID (e.g. `stunning-vertex-342218`).
2. Export a JSON credentials file ([Credentials](https://console.cloud.google.com/apis/credentials)
  - Create credentials -> Service account.
  - "Service account name" can be e.g. "tf-tor-obfs4-gridge".
  - "Role" can be Basic -> Editor.
  - Manage keys -> Add key -> Create new key -> JSON -> Save it in e.g.
    `~/secrets/stunning-vertex-342218-e123456abcde`.
  - Enable "[Compute Engine API](https://console.developers.google.com/apis/api/compute.googleapis.com/overview?project=986404459234)"

## Generate SSH keys
SSH keys are handy for avoiding manual passwords.

To generate a public-private key pair,

```shell
ssh-keygen -t rsa -b 4096 -f ~/secrets/gcp-tor-obfs4-bridge-ssh -C ""
```

The public key will later be pushed into the VM and the private key will be
used for provisioning files and ssh-ing into the VM.

## Provisioning

At the very first time, run

```
sudo snap install --classic google-cloud-sdk
terraform init
```

Update [main.tf](main.tf) with your project id and credentials filename and
then run:

```shell
terraform apply
```

Log-in (ssh) into the VM instance:

```shell
ssh -i ~/secrets/gcp-tor-obfs4-bridge-ssh \
  -o "UserKnownHostsFile=/dev/null" \
  -o "StrictHostKeyChecking no" \
  ubuntu@$(terraform output ip_nat_vm_tor_obfs4_bridge | xargs -n1 echo)
```

After logging in, you can check:
- `cat /var/log/cloud-init-output.log`
- `sudo docker ps`

Some changes to the configuration files (namely the cloud-init) are not picked
up by terraform, so you may need to explicitly request a replacement:

```shell
terraform apply -var-file="tor-obfs4-bridge.tfvars" \
  -replace google_compute_instance.vm_tor_obfs4_bridge
```

To remove the VM,

```shell
terraform destroy
```

## Under the hood
- Firewall rules allow access to the onion ports from anywhere
- Tested on:
  - Terraform v1.3.7 on linux_amd64, google-cloud-sdk 413.0.0
