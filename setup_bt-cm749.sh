#!/bin/bash

# see https://www.collabora.com/news-and-blog/blog/2021/05/05/quick-hack-patching-kernel-module-using-dkms/

# make the script stop on error
set -e

BIN_ABSPATH="$(dirname "$(readlink -f "${0}")")"

KERNEL_MODULE_NAME='bt-cm749'
DKMS_MODULE_VERSION='0.1'

if [[ ! $EUID = 0 ]]; then
  echo "Only root can perform this setup. Aborting."
  exit 1
fi

# set up the actual DKMS module -------------------------------------------------------------------

"${BIN_ABSPATH}/dkms-module_create.sh" "${KERNEL_MODULE_NAME}" "${DKMS_MODULE_VERSION}"

# create the patch file to apply to the source of the bt-cm749 kernel module
# taken from https://github.com/Seven0492/kernel-patches/blob/main/cm749.patch under MIT license

tee "/usr/src/${KERNEL_MODULE_NAME}-${DKMS_MODULE_VERSION}/bt-cm749.patch" <<'EOF'
--- net/bluetooth/hci_sync.c.orig
+++ net/bluetooth/hci_sync.c
@@ -3961,7 +3961,7 @@ static const struct hci_init_stage hci_i
 	/* HCI_OP_READ_INQ_RSP_TX_POWER */
 	HCI_INIT(hci_read_inq_rsp_tx_power_sync),
 	/* HCI_OP_READ_LOCAL_EXT_FEATURES */
-	HCI_INIT(hci_read_local_ext_features_1_sync),
+	/* HCI_INIT(hci_read_local_ext_features_1_sync), */
 	/* HCI_OP_WRITE_AUTH_ENABLE */
 	HCI_INIT(hci_write_auth_enable_sync),
 	{}
EOF

"${BIN_ABSPATH}/dkms-module_build.sh" "${KERNEL_MODULE_NAME}" "${DKMS_MODULE_VERSION}"
