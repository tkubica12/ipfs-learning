variable "prefix" {
  type        = string
  default     = "ipfs"
  description = <<EOF
Prefix for resources.
Preferably 2-4 characters long without special characters, lowercase.
EOF
}

variable "location" {
  type        = string
  default     = "swedencentral"
  description = <<EOF
Azure region for resources.

Examples: swedencentral, westeurope, northeurope, germanywestcentral.
EOF
}

variable "ipfs_node_count" {
  type        = number
  default     = 5
  description = <<EOF
Number of IPFS nodes to deploy.
EOF
}
