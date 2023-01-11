data "cloudinit_config" "tor_obfs4_bridge" {
  # https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/cloudinit_config
  # https://github.com/hashicorp/terraform-provider-template/blob/79c2094838bfb2b6bba91dc5b02f5071dd497083/website/docs/d/cloudinit_config.html.markdown
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    filename     = "tor_obfs4_bridge.conf"

    content = yamlencode(
      {
        "write_files" : [
          {
            "path" : "/tor-obfs4-bridge/docker-compose.yml",
            "content" : file("${path.module}/files/docker-compose.yml"),
          },
          {
            "path" : "/tor-obfs4-bridge/.env",
            "content" : templatefile("${path.module}/files/.env.tpl", {
              OR_PORT = var.OR_PORT,
              PT_PORT = var.PT_PORT,
              EMAIL   = var.EMAIL,
            }),
          },
        ],

        "package_update" : "true",

        "packages" : [
          "bat",
          "docker-compose",
          "fzf",
          "git",
          "iftop",
          "iputils-ping",
          "jq",
          "kitty-terminfo",
          "nano",
          "net-tools",
          "python3-pip",
          "tcptrack",
          "unzip",
          "vim",
          "zip",
          "zsh",
        ],

        "runcmd" : [
          templatefile("${path.module}/files/runcmd.tpl.sh", {
          }),
        ]
      }
    )
  }
}
