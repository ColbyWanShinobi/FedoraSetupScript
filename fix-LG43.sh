#! /bin/bash

GRUB_STRING="drm.edid_firmware=HDMI-A-1:edid/lg-43inch.bin
sudo mkdir -p /lib/firmware/edid
sudo cp ../EDID/LG_43UN700-B_43_Inch_HDR_4K.bin /lib/firmware/edid/LG_43UN700-B_43_Inch_HDR_4K.bin
sudo chmod 644 /lib/firmware/edid/LG_43UN700-B_43_Inch_HDR_4K.bin
